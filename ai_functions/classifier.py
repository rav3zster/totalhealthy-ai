"""
PHASE 3 – Diet Type Classifier
Loads a pre-trained Random Forest model (.pkl) and classifies
user's diet goal: weight_loss | muscle_gain | maintenance

Training script: ai_training/train_diet_classifier.py
"""

import os
import joblib
import numpy as np
import logging

logger = logging.getLogger(__name__)

MODEL_DIR  = os.path.join(os.path.dirname(__file__), "models")
MODEL_PATH = os.path.join(MODEL_DIR, "diet_classifier.pkl")

# Activity level mapping (string → int if needed)
ACTIVITY_MAP = {
    "sedentary":   1,
    "light":       2,
    "moderate":    3,
    "active":      4,
    "very_active": 5,
}

GOAL_MAP = {
    "weight_loss":  0,
    "maintenance":  1,
    "muscle_gain":  2,
}

LABEL_MAP = {v: k for k, v in GOAL_MAP.items()}

_model = None


def classify_diet(data: dict) -> dict:
    """
    Input : { age, weight (kg), height (cm), activityLevel (1-5 or string), goal (string) }
    Output: { dietType, bmi, tdee, recommendedCalories }
    """
    model = _load_model()

    age      = float(data["age"])
    weight   = float(data["weight"])
    height   = float(data["height"])
    activity = data["activityLevel"]
    goal     = data.get("goal", "maintenance")

    # Normalize activity level
    if isinstance(activity, str):
        activity = ACTIVITY_MAP.get(activity.lower(), 2)
    activity = float(activity)

    # Normalize goal to numeric
    goal_num = GOAL_MAP.get(goal.lower(), 1)

    # ── Derived features ──────────────────────────────────────────────────────
    bmi  = round(weight / ((height / 100) ** 2), 2)
    bmr  = 10 * weight + 6.25 * height - 5 * age + 5   # Mifflin-St Jeor (male base)
    tdee = round(bmr * _activity_multiplier(activity), 1)

    features = np.array([[age, weight, height, bmi, activity, goal_num, tdee]])
    pred     = model.predict(features)[0]
    diet_type = LABEL_MAP.get(int(pred), "maintenance")

    # Recommended calories based on diet type
    cal_map = {
        "weight_loss": round(tdee - 500),
        "maintenance": round(tdee),
        "muscle_gain": round(tdee + 300),
    }

    result = {
        "dietType":             diet_type,
        "bmi":                  bmi,
        "tdee":                 tdee,
        "recommendedCalories":  cal_map[diet_type],
    }
    logger.info(f"[classifier] input={data} → {result}")
    return result


def _load_model():
    global _model
    if _model is None:
        if not os.path.exists(MODEL_PATH):
            raise FileNotFoundError(
                f"Diet classifier not found at {MODEL_PATH}. "
                "Run ai_training/train_diet_classifier.py first."
            )
        _model = joblib.load(MODEL_PATH)
        logger.info("[classifier] model loaded")
    return _model


def _activity_multiplier(level: float) -> float:
    mapping = {1: 1.2, 2: 1.375, 3: 1.55, 4: 1.725, 5: 1.9}
    return mapping.get(int(level), 1.55)
