"""
AI Cloud Functions Entry Point
Handles: meal recommendations, nutrition prediction, diet classification
"""

import functions_framework
import firebase_admin
from firebase_admin import credentials, firestore
import json
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Init Firebase Admin once
if not firebase_admin._apps:
    firebase_admin.initialize_app()

db = firestore.client()

# ── import handlers ──────────────────────────────────────────────────────────
from recommendation import get_recommendations
from nutrition   import predict_nutrition
from classifier  import classify_diet


# ── PHASE 1: Meal Recommendation ─────────────────────────────────────────────
@functions_framework.http
def recommend_meals(request):
    """
    POST { "userId": "abc123" }
    Returns top-5 meal recommendations based on user history (TF-IDF + cosine similarity)
    """
    try:
        body   = request.get_json(silent=True) or {}
        user_id = body.get("userId")

        if not user_id:
            return _error("userId is required", 400)

        logger.info(f"[recommend_meals] userId={user_id}")
        result = get_recommendations(db, user_id)
        return _ok(result)

    except Exception as e:
        logger.exception("[recommend_meals] error")
        return _error(str(e), 500)


# ── PHASE 2: Nutrition Prediction ────────────────────────────────────────────
@functions_framework.http
def predict_meal_nutrition(request):
    """
    POST { "description": "2 boiled eggs and toast" }
    Returns estimated calories, protein, carbs, fat
    """
    try:
        body        = request.get_json(silent=True) or {}
        description = body.get("description", "").strip()

        if not description:
            return _error("description is required", 400)

        logger.info(f"[predict_meal_nutrition] description={description}")
        result = predict_nutrition(description)
        return _ok(result)

    except Exception as e:
        logger.exception("[predict_meal_nutrition] error")
        return _error(str(e), 500)


# ── PHASE 3: Diet Type Classifier ────────────────────────────────────────────
@functions_framework.http
def classify_user_diet(request):
    """
    POST { "age": 25, "weight": 70, "height": 175, "activityLevel": 2, "goal": "weight_loss" }
    Returns diet type: weight_loss | muscle_gain | maintenance
    """
    try:
        body = request.get_json(silent=True) or {}
        required = ["age", "weight", "height", "activityLevel", "goal"]

        for field in required:
            if field not in body:
                return _error(f"{field} is required", 400)

        logger.info(f"[classify_user_diet] input={body}")
        result = classify_diet(body)
        return _ok(result)

    except Exception as e:
        logger.exception("[classify_user_diet] error")
        return _error(str(e), 500)


# ── helpers ───────────────────────────────────────────────────────────────────
def _ok(data: dict):
    return (json.dumps({"status": "ok", **data}), 200,
            {"Content-Type": "application/json",
             "Access-Control-Allow-Origin": "*"})

def _error(msg: str, code: int):
    return (json.dumps({"status": "error", "message": msg}), code,
            {"Content-Type": "application/json",
             "Access-Control-Allow-Origin": "*"})
