"""
Flask AI Backend — deployed on Render
Endpoint: POST /generate_meal
"""

import os
import json
import re
import time
import logging
from flask import Flask, request, jsonify
import google.generativeai as genai

# ── Logging ───────────────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logger = logging.getLogger(__name__)

# ── Flask app ─────────────────────────────────────────────────────────────────
app = Flask(__name__)

# ── Gemini setup ──────────────────────────────────────────────────────────────
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if not GEMINI_API_KEY:
    logger.warning("GEMINI_API_KEY not set — AI calls will fail")

genai.configure(api_key=GEMINI_API_KEY or "")
gemini_model = genai.GenerativeModel("gemini-1.5-flash")

# ── Fallback meal returned when Gemini fails ──────────────────────────────────
FALLBACK_MEAL = {
    "name":        "Balanced Oats Bowl",
    "category":    "Breakfast",
    "ingredients": ["1 cup oats", "1 banana", "1 tbsp honey", "200 ml milk"],
    "calories":    380,
    "protein":     12,
    "carbs":       65,
    "fat":         7,
    "description": "A nutritious and filling breakfast bowl to start your day.",
}


# ── Health check ──────────────────────────────────────────────────────────────
@app.route("/", methods=["GET"])
def health():
    return jsonify({"status": "ok", "service": "TotalHealthy AI Backend"}), 200


# ── Main endpoint ─────────────────────────────────────────────────────────────
@app.route("/generate_meal", methods=["POST"])
def generate_meal():
    logger.info("=== /generate_meal called ===")

    body = request.get_json(silent=True) or {}
    logger.info(f"Incoming request keys: {list(body.keys())}")

    try:
        prompt = _build_prompt(body)
        logger.info(f"Prompt built ({len(prompt)} chars)")

        raw    = _call_gemini(prompt)
        logger.info(f"Gemini raw response (first 300 chars): {raw[:300]}")

        meals  = _parse_response(raw)
        logger.info(f"Parsed {len(meals)} meals successfully")

        return jsonify({"status": "ok", "meals": meals}), 200

    except Exception as e:
        logger.exception(f"Unhandled error in /generate_meal: {e}")
        return jsonify({"status": "ok", "meals": [FALLBACK_MEAL],
                        "warning": str(e)}), 200


# ── Prompt builder ────────────────────────────────────────────────────────────

def _build_prompt(data: dict) -> str:
    goal           = data.get("goal", "maintenance")
    curr_weight    = data.get("currentWeight", "not specified")
    target_weight  = data.get("targetWeight", "not specified")
    calories       = data.get("calories", "")
    protein        = data.get("protein", "")
    carbs          = data.get("carbs", "")
    fats           = data.get("fats", "")
    diet_type      = data.get("dietType", "not specific")
    allergies      = ", ".join(data.get("allergies", [])) or "none"
    cuisine        = data.get("cuisine", "any")
    meals_per_day  = int(data.get("mealsPerDay", 3))
    meal_types     = data.get("mealTypes", ["Breakfast", "Lunch", "Dinner"])
    meal_types_str = ", ".join(meal_types) if meal_types else "Breakfast, Lunch, Dinner"
    include_foods  = data.get("includeFoods", "")
    avoid_foods    = data.get("avoidFoods", "")
    exercise_freq  = data.get("exerciseFrequency", "")
    exercise_type  = data.get("exerciseType", "")
    pre_post       = data.get("prePostWorkoutNutrition", "no")
    medical        = data.get("medicalConditions", "none")
    instructions   = data.get("specialInstructions", "")
    categories     = ", ".join(data.get("groupCategories", meal_types))

    # Optional nutrition targets block
    nutrition_lines = []
    if calories:    nutrition_lines.append(f"Target Calories: {calories} kcal")
    if protein:     nutrition_lines.append(f"Target Protein: {protein}g")
    if carbs:       nutrition_lines.append(f"Target Carbs: {carbs}g")
    if fats:        nutrition_lines.append(f"Target Fats: {fats}g")
    nutrition_block = ("\n" + "\n".join(f"- {l}" for l in nutrition_lines)) if nutrition_lines else ""

    # Optional activity block
    activity_lines = []
    if exercise_freq:              activity_lines.append(f"Frequency: {exercise_freq}")
    if exercise_type:              activity_lines.append(f"Type: {exercise_type}")
    if pre_post.lower() == "yes":  activity_lines.append("Include pre/post workout meals")
    activity_block = ("\n" + "\n".join(f"- {l}" for l in activity_lines)) if activity_lines else " not specified"

    extras = []
    if include_foods:                          extras.append(f"Foods to include: {include_foods}")
    if avoid_foods:                            extras.append(f"Foods to avoid: {avoid_foods}")
    if medical and medical.lower() != "none":  extras.append(f"Medical conditions: {medical}")
    if instructions:                           extras.append(f"Special instructions: {instructions}")
    extras_block = ("\n" + "\n".join(f"- {e}" for e in extras)) if extras else ""

    prompt = f"""You are a professional nutritionist and meal planner.
Generate a personalised meal plan for exactly {meals_per_day} meals.

USER PROFILE:
- Goal: {goal}
- Current Weight: {curr_weight} kg
- Target Weight: {target_weight} kg{nutrition_block}

DIET REQUIREMENTS:
- Diet Type: {diet_type}
- Allergies (NEVER include these): {allergies}
- Cuisine Preference: {cuisine}

MEAL TYPES REQUIRED: {meal_types_str}
CATEGORIES TO USE (map each meal to one): {categories}

PHYSICAL ACTIVITY:{activity_block}
{extras_block}

STRICT RULES:
1. NEVER include any allergen from: {allergies}
2. All meals must match cuisine style: {cuisine}
3. All meals must support goal: {goal}
4. Each meal must be mapped to one category from: {categories}
5. Provide accurate calorie and macro values
6. Return ONLY a JSON object — no markdown, no explanation, no code fences

Return this EXACT JSON structure with {meals_per_day} meals:
{{"meals": [{{"name": "string","category": "string","ingredients": ["string"],"calories": number,"protein": number,"carbs": number,"fat": number,"description": "string"}}]}}"""

    return prompt


# ── Gemini call with one retry ────────────────────────────────────────────────

def _call_gemini(prompt: str, attempt: int = 0) -> str:
    try:
        response = gemini_model.generate_content(
            prompt,
            generation_config=genai.types.GenerationConfig(
                temperature=0.4,
                max_output_tokens=2048,
            ),
        )
        return response.text.strip()
    except Exception as e:
        if attempt == 0:
            logger.warning(f"Gemini attempt 1 failed: {e} — retrying in 2s")
            time.sleep(2)
            return _call_gemini(prompt, attempt=1)
        logger.error(f"Gemini attempt 2 also failed: {e}")
        raise


# ── JSON parser + field validator ─────────────────────────────────────────────

def _parse_response(raw: str) -> list:
    # Strip markdown code fences if Gemini wraps output
    cleaned = re.sub(r"```(?:json)?", "", raw).strip().rstrip("`").strip()

    # Extract first JSON object found (handles extra text)
    match = re.search(r"\{.*\}", cleaned, re.DOTALL)
    if not match:
        logger.error("No JSON object found in Gemini response")
        return [FALLBACK_MEAL]

    try:
        data  = json.loads(match.group())
        meals = data.get("meals", [])
        if not isinstance(meals, list) or len(meals) == 0:
            logger.warning("meals key missing or empty — using fallback")
            return [FALLBACK_MEAL]
    except json.JSONDecodeError as e:
        logger.error(f"JSON decode error: {e}")
        return [FALLBACK_MEAL]

    validated = []
    for meal in meals:
        validated.append({
            "name":        str(meal.get("name", "Meal")),
            "category":    str(meal.get("category", "Lunch")),
            "ingredients": [str(i) for i in (meal.get("ingredients") or [])],
            "calories":    _safe_float(meal.get("calories"), 400),
            "protein":     _safe_float(meal.get("protein"),  20),
            "carbs":       _safe_float(meal.get("carbs"),    40),
            "fat":         _safe_float(meal.get("fat"),      10),
            "description": str(meal.get("description", "")),
        })

    return validated if validated else [FALLBACK_MEAL]


def _safe_float(val, default):
    try:
        return round(float(val), 1)
    except (TypeError, ValueError):
        return default


# ── Entry point ───────────────────────────────────────────────────────────────
if __name__ == "__main__":
    port = int(os.getenv("PORT", 10000))
    logger.info(f"Starting Flask on 0.0.0.0:{port}")
    app.run(host="0.0.0.0", port=port, debug=False)
