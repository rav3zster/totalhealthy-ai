"""
TotalHealthy AI Backend — Flask + OpenRouter (Mistral)
Deployed on Render | Endpoint: POST /generate_meal
"""

import os
import json
import re
import time
import logging
import requests
from flask import Flask, request, jsonify

# ── Logging ───────────────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logger = logging.getLogger(__name__)

# ── Flask app ─────────────────────────────────────────────────────────────────
app = Flask(__name__)

# ── OpenRouter setup ──────────────────────────────────────────────────────────
OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY", "")
if not OPENROUTER_API_KEY:
    logger.warning("⚠️  OPENROUTER_API_KEY not set — AI calls will fail")
else:
    logger.info(f"✅ OPENROUTER_API_KEY loaded (ends ...{OPENROUTER_API_KEY[-4:]})")

OPENROUTER_MODEL = "mistralai/mistral-7b-instruct"
OPENROUTER_URL   = "https://openrouter.ai/api/v1/chat/completions"
logger.info(f"✅ AI model: {OPENROUTER_MODEL}")

# ── Fallback meal — returned when Gemini fails ────────────────────────────────
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


# ── CORS helper ───────────────────────────────────────────────────────────────
def _cors(response):
    response.headers["Access-Control-Allow-Origin"]  = "*"
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    return response


@app.after_request
def after_request(response):
    return _cors(response)


# ── Route 1: Health check ─────────────────────────────────────────────────────
@app.route("/", methods=["GET"])
def health():
    logger.info("GET / — health check")
    return jsonify({"status": "ok", "service": "TotalHealthy AI Backend"}), 200


# ── Route 2: Quick test — returns sample meal without calling AI ──────────────
@app.route("/test", methods=["GET"])
def test():
    logger.info("GET /test — returning sample meal")
    return jsonify({
        "status": "ok",
        "meals": [FALLBACK_MEAL],
        "note": "This is a static test response — Gemini not called",
    }), 200


# ── Route 3: Main AI endpoint ─────────────────────────────────────────────────
@app.route("/generate_meal", methods=["POST", "OPTIONS"])
def generate_meal():
    # Handle CORS preflight
    if request.method == "OPTIONS":
        return jsonify({}), 204

    logger.info("=" * 50)
    logger.info("POST /generate_meal — request received")

    body = request.get_json(silent=True)
    if not body:
        logger.warning("Empty or invalid JSON body — using empty dict")
        body = {}

    logger.info(f"Request keys: {list(body.keys())}")

    try:
        prompt = _build_prompt(body)
        logger.info(f"Prompt built — {len(prompt)} chars")

        raw = _call_ai(prompt)
        logger.info(f"AI responded — first 400 chars:\n{raw[:400]}")

        meals = _parse_response(raw)
        logger.info(f"✅ Parsed {len(meals)} meals — sending response")

        return jsonify({"status": "ok", "meals": meals}), 200

    except Exception as e:
        logger.exception(f"❌ Unhandled error: {e}")
        # Return error status so Flutter shows the error state, not fake data
        return jsonify({
            "status": "error",
            "error": str(e),
            "meals": [],
        }), 500


# ── Prompt builder ────────────────────────────────────────────────────────────

def _build_prompt(data: dict) -> str:
    goal          = data.get("goal", "maintenance")
    curr_weight   = data.get("currentWeight", "not specified")
    target_weight = data.get("targetWeight", "not specified")
    calories      = data.get("calories", "")
    protein       = data.get("protein", "")
    carbs         = data.get("carbs", "")
    fats          = data.get("fats", "")
    diet_type     = data.get("dietType", "not specific")
    allergies_raw = data.get("allergies", [])
    allergies     = ", ".join(allergies_raw) if allergies_raw else "none"
    cuisine       = data.get("cuisine", "any")
    meals_per_day = max(1, int(data.get("mealsPerDay", 3)))
    meal_types    = data.get("mealTypes", ["Breakfast", "Lunch", "Dinner"])
    if not meal_types:
        meal_types = ["Breakfast", "Lunch", "Dinner"]

    # Use the number of selected meal types as the target count.
    # This ensures one distinct meal is generated per type selected.
    total_meals   = max(meals_per_day, len(meal_types))
    meal_types_str = ", ".join(meal_types)

    include_foods = data.get("includeFoods", "")
    avoid_foods   = data.get("avoidFoods", "")
    exercise_freq = data.get("exerciseFrequency", "")
    exercise_type = data.get("exerciseType", "")
    pre_post      = data.get("prePostWorkoutNutrition", "no")
    medical       = data.get("medicalConditions", "none")
    instructions  = data.get("specialInstructions", "")
    group_cats    = data.get("groupCategories", [])
    categories    = ", ".join(group_cats) if group_cats else meal_types_str

    # Build optional blocks
    nutrition_lines = []
    if calories: nutrition_lines.append(f"Target Calories: {calories} kcal")
    if protein:  nutrition_lines.append(f"Target Protein: {protein}g")
    if carbs:    nutrition_lines.append(f"Target Carbs: {carbs}g")
    if fats:     nutrition_lines.append(f"Target Fats: {fats}g")
    nutrition_block = ("\n" + "\n".join(f"  - {l}" for l in nutrition_lines)) if nutrition_lines else " not specified"

    activity_lines = []
    if exercise_freq:             activity_lines.append(f"Frequency: {exercise_freq}")
    if exercise_type:             activity_lines.append(f"Type: {exercise_type}")
    if pre_post.lower() == "yes": activity_lines.append("Include pre/post workout meals")
    activity_block = ("\n" + "\n".join(f"  - {l}" for l in activity_lines)) if activity_lines else " not specified"

    extras = []
    if include_foods:                         extras.append(f"Foods to include: {include_foods}")
    if avoid_foods:                           extras.append(f"Foods to avoid: {avoid_foods}")
    if medical and medical.lower() != "none": extras.append(f"Medical conditions: {medical}")
    if instructions:                          extras.append(f"Special instructions: {instructions}")
    extras_block = ("\n" + "\n".join(f"  - {e}" for e in extras)) if extras else ""

    # Build the JSON schema example for Gemini to follow
    example_meal = '{"name":"string","category":"string","ingredients":["string"],"calories":0,"protein":0,"carbs":0,"fat":0,"description":"string"}'

    # List each required meal type explicitly so Gemini maps one meal per type
    meal_type_list = "\n".join(f"  {i+1}. {t}" for i, t in enumerate(meal_types))

    prompt = f"""You are a professional nutritionist and meal planner.
Generate a complete personalised meal plan with exactly {total_meals} meals — one for each meal type listed below.

USER PROFILE:
  - Goal: {goal}
  - Current Weight: {curr_weight} kg
  - Target Weight: {target_weight} kg
  - Nutrition targets:{nutrition_block}

DIET REQUIREMENTS:
  - Diet Type: {diet_type}
  - Allergies — NEVER include these ingredients: {allergies}
  - Cuisine Preference: {cuisine}

REQUIRED MEAL TYPES (generate exactly one meal per type, in this order):
{meal_type_list}

PHYSICAL ACTIVITY:{activity_block}
{extras_block}

ABSOLUTE RULES — FOLLOW EXACTLY:
  1. Generate exactly {total_meals} meals — one per meal type above, no duplicates
  2. Each meal's "category" field MUST match its meal type exactly
  3. NEVER include any allergen: {allergies}
  4. Match cuisine style: {cuisine}
  5. Support the goal: {goal}
  6. Every meal must be nutritionally distinct — no repeated dishes or ingredients
  7. Use realistic, accurate calorie and macro values appropriate for each meal type
  8. Output ONLY raw JSON — zero markdown, zero explanation, zero code fences
  9. Do NOT wrap output in ```json or ``` blocks

OUTPUT FORMAT — return ONLY this JSON with exactly {total_meals} items in the meals array:
{{"meals":[{example_meal}]}}"""

    return prompt


# ── OpenRouter / Mistral call with one retry ─────────────────────────────────

def _call_ai(prompt: str, attempt: int = 0) -> str:
    try:
        response = requests.post(
            OPENROUTER_URL,
            headers={
                "Authorization": f"Bearer {OPENROUTER_API_KEY}",
                "Content-Type": "application/json",
            },
            json={
                "model": OPENROUTER_MODEL,
                "messages": [{"role": "user", "content": prompt}],
                "temperature": 0.9,
                "max_tokens": 4096,
            },
            timeout=60,
        )
        response.raise_for_status()
        data = response.json()
        text = data["choices"][0]["message"]["content"].strip()
        if not text:
            raise ValueError("AI returned empty response")
        return text
    except Exception as e:
        if attempt == 0:
            logger.warning(f"AI attempt 1 failed: {e} — retrying in 2s")
            time.sleep(2)
            return _call_ai(prompt, attempt=1)
        logger.error(f"AI attempt 2 also failed: {e}")
        raise


# ── JSON parser + field validator ─────────────────────────────────────────────

def _parse_response(raw: str) -> list:
    # Step 1: strip markdown fences
    cleaned = re.sub(r"```(?:json)?", "", raw, flags=re.IGNORECASE)
    cleaned = cleaned.strip().strip("`").strip()

    # Step 2: extract first complete JSON object
    match = re.search(r"\{.*\}", cleaned, re.DOTALL)
    if not match:
        logger.error(f"No JSON object found. Raw response:\n{raw[:500]}")
        return [FALLBACK_MEAL]

    json_str = match.group()

    # Step 3: parse
    try:
        data = json.loads(json_str)
    except json.JSONDecodeError as e:
        logger.error(f"JSON decode error: {e}\nAttempted to parse:\n{json_str[:500]}")
        return [FALLBACK_MEAL]

    # Step 4: extract meals array
    meals = data.get("meals")
    if not isinstance(meals, list) or len(meals) == 0:
        logger.warning(f"'meals' key missing or empty. Keys found: {list(data.keys())}")
        return [FALLBACK_MEAL]

    # Step 5: validate and sanitise each meal
    validated = []
    for i, meal in enumerate(meals):
        if not isinstance(meal, dict):
            logger.warning(f"Meal {i} is not a dict — skipping")
            continue
        validated.append({
            "name":        str(meal.get("name") or "Meal"),
            "category":    str(meal.get("category") or "Lunch"),
            "ingredients": [str(x) for x in (meal.get("ingredients") or [])],
            "calories":    _safe_num(meal.get("calories"), 400),
            "protein":     _safe_num(meal.get("protein"),  20),
            "carbs":       _safe_num(meal.get("carbs"),    40),
            "fat":         _safe_num(meal.get("fat"),      10),
            "description": str(meal.get("description") or ""),
        })

    if not validated:
        logger.warning("All meals failed validation — using fallback")
        return [FALLBACK_MEAL]

    return validated


def _safe_num(val, default):
    try:
        result = round(float(val), 1)
        return result if result >= 0 else default
    except (TypeError, ValueError):
        return default


# ── Entry point ───────────────────────────────────────────────────────────────
if __name__ == "__main__":
    port = int(os.getenv("PORT", 10000))
    logger.info(f"🚀 Starting Flask on 0.0.0.0:{port}")
    app.run(host="0.0.0.0", port=port, debug=False)
