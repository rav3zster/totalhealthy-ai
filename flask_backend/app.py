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
from flask_cors import CORS

# ── Logging ───────────────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logger = logging.getLogger(__name__)

# ── Flask app ─────────────────────────────────────────────────────────────────
app = Flask(__name__)
CORS(app, origins="*", supports_credentials=False)

# ── OpenRouter setup ──────────────────────────────────────────────────────────
OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY", "")
if not OPENROUTER_API_KEY:
    logger.warning("⚠️  OPENROUTER_API_KEY not set — AI calls will fail")
else:
    logger.info(f"✅ OPENROUTER_API_KEY loaded (ends ...{OPENROUTER_API_KEY[-4:]})")

OPENROUTER_MODEL         = "stepfun/step-3.5-flash:free"
OPENROUTER_MODEL_FALLBACK = "arcee-ai/trinity-mini:free"
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


# ── Global error handlers ─────────────────────────────────────────────────────
@app.errorhandler(Exception)
def handle_exception(e):
    logger.exception(f"❌ Unhandled exception: {e}")
    return jsonify({"status": "error", "error": str(e), "meals": []}), 500


@app.errorhandler(500)
def handle_500(e):
    return jsonify({"status": "error", "error": str(e), "meals": []}), 500
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
@app.route("/generate_meal", methods=["POST"])
def generate_meal():
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


# ── Route 4: Diet classifier ──────────────────────────────────────────────────
@app.route("/classify_diet", methods=["POST"])
def classify_diet():
    body = request.get_json(silent=True) or {}
    try:
        age            = int(body.get("age", 25))
        weight         = float(body.get("weight", 70))
        height         = float(body.get("height", 170))
        activity_level = int(body.get("activityLevel", 2))   # 1–5
        goal           = body.get("goal", "maintenance")

        # ── BMI ───────────────────────────────────────────────────────────
        height_m = height / 100
        bmi = round(weight / (height_m ** 2), 1)

        # ── BMR (Mifflin-St Jeor, gender-neutral) ─────────────────────────
        bmr = 10 * weight + 6.25 * height - 5 * age

        # ── TDEE activity multipliers ─────────────────────────────────────
        multipliers = {1: 1.2, 2: 1.375, 3: 1.55, 4: 1.725, 5: 1.9}
        tdee = round(bmr * multipliers.get(activity_level, 1.375), 0)

        # ── Recommended calories based on goal ────────────────────────────
        goal_lower = goal.lower().replace(" ", "_")
        if "loss" in goal_lower:
            recommended = int(tdee - 500)
        elif "gain" in goal_lower or "muscle" in goal_lower or "build" in goal_lower:
            recommended = int(tdee + 300)
        else:
            recommended = int(tdee)

        # ── Diet type via AI ──────────────────────────────────────────────
        diet_prompt = (
            f"A person aged {age}, weighing {weight}kg, height {height}cm, "
            f"BMI {bmi}, activity level {activity_level}/5, goal: {goal}. "
            f"Recommend ONE diet type from: keto, mediterranean, high_protein, "
            f"balanced, low_carb, vegetarian. Reply with ONLY the diet type word, nothing else."
        )
        try:
            diet_type = _call_ai(diet_prompt).strip().lower().split()[0]
            # sanitise — only allow known values
            allowed = {"keto","mediterranean","high_protein","balanced","low_carb","vegetarian"}
            if diet_type not in allowed:
                diet_type = "balanced"
        except Exception:
            diet_type = "balanced"

        return jsonify({
            "status":               "ok",
            "dietType":             diet_type,
            "bmi":                  bmi,
            "tdee":                 tdee,
            "recommendedCalories":  recommended,
        }), 200

    except Exception as e:
        logger.exception(f"❌ classify_diet error: {e}")
        return jsonify({"status": "error", "error": str(e)}), 500


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

    total_meals    = max(meals_per_day, len(meal_types))
    include_foods  = data.get("includeFoods", "")
    avoid_foods    = data.get("avoidFoods", "")
    exercise_freq  = data.get("exerciseFrequency", "")
    exercise_type  = data.get("exerciseType", "")
    pre_post       = data.get("prePostWorkoutNutrition", "no")
    medical        = data.get("medicalConditions", "none")
    instructions   = data.get("specialInstructions", "")

    # ── Build constraint blocks ───────────────────────────────────────────────

    # Macro targets — shown as hard limits, not suggestions
    macro_lines = []
    if calories: macro_lines.append(f"Total daily calories ≈ {calories} kcal (split across all meals)")
    if protein:  macro_lines.append(f"Total daily protein ≈ {protein}g")
    if carbs:    macro_lines.append(f"Total daily carbs ≈ {carbs}g")
    if fats:     macro_lines.append(f"Total daily fats ≈ {fats}g")
    macro_block = "\n".join(f"  ⚡ {l}" for l in macro_lines) if macro_lines else "  Not specified — use sensible defaults for the goal"

    # Activity context
    activity_parts = []
    if exercise_freq:              activity_parts.append(exercise_freq)
    if exercise_type:              activity_parts.append(exercise_type)
    if pre_post.lower() == "yes":  activity_parts.append("needs pre/post workout nutrition")
    activity_str = ", ".join(activity_parts) if activity_parts else "not specified"

    # Hard exclusions
    exclusions = []
    if allergies != "none": exclusions.append(f"allergens ({allergies})")
    if avoid_foods:         exclusions.append(f"user-avoided foods ({avoid_foods})")
    exclusion_str = " and ".join(exclusions) if exclusions else "none"

    # Preferred inclusions
    inclusion_str = include_foods if include_foods else "none specified"

    # Medical / special
    medical_str      = medical if medical and medical.lower() != "none" else "none"
    instructions_str = instructions if instructions else "none"

    # Numbered meal type list
    meal_type_list = "\n".join(f"  {i+1}. {t}" for i, t in enumerate(meal_types))

    example_meal = '{"name":"string","category":"string","ingredients":["string"],"calories":0,"protein":0,"carbs":0,"fat":0,"description":"string"}'

    prompt = f"""You are a certified nutritionist and personal meal planner. Your job is to create a highly personalised meal plan that strictly follows every constraint below. Ignoring any constraint is not acceptable.

═══════════════════════════════════════
CRITICAL USER CONSTRAINTS — FOLLOW ALL
═══════════════════════════════════════

🎯 GOAL: {goal}
   Current weight: {curr_weight} kg → Target: {target_weight} kg
   Every meal MUST actively support this goal.

🍽️ CUISINE: {cuisine}
   ALL meals must be authentic {cuisine} cuisine dishes.
   Do NOT use generic or non-{cuisine} meals.

🥗 DIET TYPE: {diet_type}
   Strictly follow this diet. No exceptions.

🚫 NEVER USE (hard exclusions): {exclusion_str}
   If any excluded ingredient appears, the response is invalid.

✅ PREFERRED INGREDIENTS TO INCLUDE: {inclusion_str}

📊 DAILY MACRO TARGETS (distribute across all {total_meals} meals):
{macro_block}

🏋️ ACTIVITY LEVEL: {activity_str}
   Adjust meal timing and macros to support this activity.

🏥 MEDICAL CONDITIONS: {medical_str}
🗒️ SPECIAL INSTRUCTIONS: {instructions_str}

═══════════════════════════════════════
MEAL TYPES REQUIRED
═══════════════════════════════════════
Generate exactly {total_meals} meals, one per type:
{meal_type_list}

Each meal's "category" field must exactly match the meal type name above.

═══════════════════════════════════════
OUTPUT RULES
═══════════════════════════════════════
1. Output ONLY raw JSON — no markdown, no explanation, no code fences
2. Do NOT wrap in ```json or ``` blocks
3. Every meal must be a real, named dish (not "Healthy Lunch")
4. Ingredients must be specific with quantities (e.g. "150g chicken breast")
5. Calories and macros must be realistic and match the targets
6. No two meals can share the same main ingredient

Return ONLY this JSON structure with exactly {total_meals} items:
{{"meals":[{example_meal}]}}"""

    return prompt


# ── OpenRouter / Mistral call with one retry ─────────────────────────────────

def _call_ai(prompt: str, attempt: int = 0) -> str:
    model = OPENROUTER_MODEL if attempt == 0 else OPENROUTER_MODEL_FALLBACK
    try:
        response = requests.post(
            OPENROUTER_URL,
            headers={
                "Authorization": f"Bearer {OPENROUTER_API_KEY}",
                "Content-Type": "application/json",
            },
            json={
                "model": model,
                "messages": [{"role": "user", "content": prompt}],
                "temperature": 0.9,
                "max_tokens": 4096,
            },
            timeout=60,
        )
        if not response.ok:
            logger.error(f"OpenRouter {response.status_code} [{model}]: {response.text[:400]}")
        response.raise_for_status()
        data = response.json()
        text = data["choices"][0]["message"]["content"].strip()
        if not text:
            raise ValueError("AI returned empty response")
        return text
    except Exception as e:
        if attempt == 0:
            logger.warning(f"Model {model} failed: {e} — trying fallback")
            time.sleep(1)
            return _call_ai(prompt, attempt=1)
        logger.error(f"Fallback model {model} also failed: {e}")
        raise


# ── JSON parser + field validator ─────────────────────────────────────────────

def _parse_response(raw: str) -> list:
    # Step 1: strip markdown fences
    cleaned = re.sub(r"```(?:json)?", "", raw, flags=re.IGNORECASE)
    cleaned = cleaned.strip().strip("`").strip()

    # Step 2: try to parse — handle both {"meals":[...]} and [{...}] formats
    data = None

    # Try object format first: {"meals": [...]}
    obj_match = re.search(r"\{.*\}", cleaned, re.DOTALL)
    if obj_match:
        try:
            parsed = json.loads(obj_match.group())
            if isinstance(parsed, dict) and "meals" in parsed:
                data = parsed
            elif isinstance(parsed, dict):
                # Single meal object — wrap it
                data = {"meals": [parsed]}
        except json.JSONDecodeError:
            pass

    # Try array format: [{...}, {...}]
    if data is None:
        arr_match = re.search(r"\[.*\]", cleaned, re.DOTALL)
        if arr_match:
            try:
                parsed = json.loads(arr_match.group())
                if isinstance(parsed, list):
                    data = {"meals": parsed}
            except json.JSONDecodeError:
                pass

    if data is None:
        logger.error(f"Could not parse any JSON. Raw:\n{raw[:500]}")
        return [FALLBACK_MEAL]

    # Step 3: extract meals array
    meals = data.get("meals")
    if not isinstance(meals, list) or len(meals) == 0:
        logger.warning(f"'meals' key missing or empty. Keys: {list(data.keys())}")
        return [FALLBACK_MEAL]

    # Step 4: validate and sanitise each meal
    validated = []
    for i, meal in enumerate(meals):
        if not isinstance(meal, dict):
            continue
        # Clean ingredients — strip any embedded nutrition text after " - "
        raw_ings = meal.get("ingredients") or []
        ingredients = [str(x).split(" - ")[0].strip() for x in raw_ings]
        validated.append({
            "name":        str(meal.get("name") or "Meal"),
            "category":    str(meal.get("category") or "Lunch"),
            "ingredients": ingredients,
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
