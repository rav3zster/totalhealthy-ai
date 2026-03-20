"""
GENERATE MEAL WITH AI
Cloud Function – calls Gemini API, returns strict JSON meal plan.
API key is stored in Google Cloud Secret Manager (never in Flutter).
"""

import os
import json
import re
import time
import logging
import functions_framework
import google.generativeai as genai

logger = logging.getLogger(__name__)

# ── Gemini setup ──────────────────────────────────────────────────────────────
# Set GEMINI_API_KEY in Cloud Function environment variables (not in code)
genai.configure(api_key=os.environ.get("GEMINI_API_KEY", ""))
_model = genai.GenerativeModel("gemini-1.5-flash")

TIMEOUT_SECONDS = 8
MAX_RETRIES     = 1

# ── Fallback meal used when AI fails ─────────────────────────────────────────
FALLBACK_MEAL = {
    "name":        "Balanced Oats Bowl",
    "category":    "Breakfast",
    "ingredients": ["1 cup oats", "1 banana", "1 tbsp honey", "200ml milk"],
    "calories":    380,
    "protein":     12,
    "carbs":       65,
    "fat":         7,
    "bestTime":    "Morning",
    "description": "A nutritious and filling breakfast bowl.",
}


@functions_framework.http
def generate_meal_with_ai(request):
    """
    POST body: all user inputs from the GenerateAI screen
    Returns: { "meals": [ ...meal objects... ] }
    """
    # CORS preflight
    if request.method == "OPTIONS":
        return ("", 204, {
            "Access-Control-Allow-Origin":  "*",
            "Access-Control-Allow-Methods": "POST",
            "Access-Control-Allow-Headers": "Content-Type",
        })

    try:
        body = request.get_json(silent=True) or {}
        logger.info(f"[generate_meal] request body keys: {list(body.keys())}")

        prompt  = _build_prompt(body)
        result  = _call_gemini_with_retry(prompt)
        meals   = _parse_and_validate(result)

        return _ok({"meals": meals})

    except Exception as e:
        logger.exception("[generate_meal] unhandled error")
        return _ok({"meals": [FALLBACK_MEAL], "warning": str(e)})


# ── Prompt builder ────────────────────────────────────────────────────────────

def _build_prompt(data: dict) -> str:
    goal            = data.get("goal", "maintenance")
    current_weight  = data.get("currentWeight", "not specified")
    target_weight   = data.get("targetWeight", "not specified")
    calories        = data.get("calories", "")
    protein         = data.get("protein", "")
    carbs           = data.get("carbs", "")
    fats            = data.get("fats", "")
    diet_type       = data.get("dietType", "not specific")
    allergies       = ", ".join(data.get("allergies", [])) or "none"
    cuisine         = data.get("cuisine", "any")
    meals_per_day   = data.get("mealsPerDay", 3)
    meal_types      = ", ".join(data.get("mealTypes", ["Breakfast", "Lunch", "Dinner"]))
    include_foods   = data.get("includeFoods", "")
    avoid_foods     = data.get("avoidFoods", "")
    exercise_freq   = data.get("exerciseFrequency", "")
    exercise_type   = data.get("exerciseType", "")
    pre_post        = data.get("prePostWorkoutNutrition", "no")
    medical         = data.get("medicalConditions", "none")
    instructions    = data.get("specialInstructions", "")
    categories      = ", ".join(data.get("groupCategories", [])) or meal_types

    nutrition_block = ""
    if calories:
        nutrition_block += f"\n- Target Calories: {calories} kcal"
    if protein:
        nutrition_block += f"\n- Target Protein: {protein}g"
    if carbs:
        nutrition_block += f"\n- Target Carbs: {carbs}g"
    if fats:
        nutrition_block += f"\n- Target Fats: {fats}g"

    workout_block = ""
    if exercise_freq:
        workout_block += f"\n- Exercise Frequency: {exercise_freq}"
    if exercise_type:
        workout_block += f"\n- Exercise Type: {exercise_type}"
    if pre_post.lower() == "yes":
        workout_block += "\n- Include pre/post workout meals"

    include_block = f"\n- Foods to include: {include_foods}" if include_foods else ""
    avoid_block   = f"\n- Foods to avoid: {avoid_foods}" if avoid_foods else ""
    medical_block = f"\n- Medical conditions: {medical}" if medical and medical.lower() != "none" else ""
    instr_block   = f"\n- Special instructions: {instructions}" if instructions else ""

    prompt = f"""Generate a personalized meal plan for {meals_per_day} meals per day.

USER PROFILE:
- Goal: {goal}
- Current Weight: {current_weight}kg
- Target Weight: {target_weight}kg{nutrition_block}

DIET:
- Diet Type: {diet_type}
- Allergies: {allergies}
- Cuisine Preference: {cuisine}

MEAL TYPES REQUIRED: {meal_types}
CATEGORIES TO USE: {categories}

PHYSICAL ACTIVITY:{workout_block if workout_block else " not specified"}
{include_block}{avoid_block}{medical_block}{instr_block}

STRICT RULES:
- NEVER include allergens: {allergies}
- Match cuisine style: {cuisine}
- Align all meals with goal: {goal}
- Each meal must map to one of these categories: {categories}
- High accuracy nutrition values required

Return ONLY a valid JSON object. No explanation. No markdown. No code blocks.
The JSON must follow this EXACT structure:

{{"meals": [{{"name": "string","category": "string","ingredients": ["string"],"calories": number,"protein": number,"carbs": number,"fat": number,"bestTime": "string","description": "string"}}]}}

Generate exactly {meals_per_day} meals, one per meal type."""

    return prompt


# ── Gemini call with retry ────────────────────────────────────────────────────

def _call_gemini_with_retry(prompt: str) -> str:
    for attempt in range(MAX_RETRIES + 1):
        try:
            response = _model.generate_content(
                prompt,
                generation_config=genai.types.GenerationConfig(
                    temperature=0.4,
                    max_output_tokens=2048,
                ),
                request_options={"timeout": TIMEOUT_SECONDS},
            )
            text = response.text.strip()
            logger.info(f"[generate_meal] Gemini response length: {len(text)}")
            return text
        except Exception as e:
            logger.warning(f"[generate_meal] attempt {attempt + 1} failed: {e}")
            if attempt < MAX_RETRIES:
                time.sleep(1)
            else:
                raise


# ── JSON parser + validator ───────────────────────────────────────────────────

def _parse_and_validate(raw: str) -> list:
    # Strip markdown code fences if Gemini wraps in ```json ... ```
    cleaned = re.sub(r"```(?:json)?", "", raw).strip().rstrip("`").strip()

    try:
        data  = json.loads(cleaned)
        meals = data.get("meals", [])
    except json.JSONDecodeError as e:
        logger.error(f"[generate_meal] JSON parse error: {e}\nRaw: {cleaned[:300]}")
        return [FALLBACK_MEAL]

    validated = []
    for meal in meals:
        validated.append({
            "name":        str(meal.get("name", "Meal")),
            "category":    str(meal.get("category", "Lunch")),
            "ingredients": [str(i) for i in meal.get("ingredients", [])],
            "calories":    _safe_num(meal.get("calories"), 400),
            "protein":     _safe_num(meal.get("protein"),  20),
            "carbs":       _safe_num(meal.get("carbs"),    40),
            "fat":         _safe_num(meal.get("fat"),      10),
            "bestTime":    str(meal.get("bestTime", "")),
            "description": str(meal.get("description", "")),
        })

    return validated if validated else [FALLBACK_MEAL]


def _safe_num(val, default):
    try:
        return round(float(val), 1)
    except (TypeError, ValueError):
        return default


# ── Response helpers ──────────────────────────────────────────────────────────

def _ok(data: dict):
    return (json.dumps({"status": "ok", **data}), 200,
            {"Content-Type": "application/json",
             "Access-Control-Allow-Origin": "*"})
