"""
PHASE 2 – Nutrition Prediction
Loads a pre-trained XGBoost model (.pkl) and predicts
calories, protein, carbs, fat from a meal text description.

Training script: ai_training/train_nutrition_model.py
"""

import os
import re
import joblib
import numpy as np
import logging

logger = logging.getLogger(__name__)

# ── Model path (bundled alongside this file when deployed) ───────────────────
MODEL_DIR  = os.path.join(os.path.dirname(__file__), "models")
MODEL_PATH = os.path.join(MODEL_DIR, "nutrition_model.pkl")

_model = None  # lazy-loaded singleton


def predict_nutrition(description: str) -> dict:
    """
    Input : free-text meal description e.g. "2 boiled eggs and toast"
    Output: { calories, protein, carbs, fat }
    """
    model = _load_model()

    # ── Feature engineering from text ────────────────────────────────────────
    features = _extract_features(description)
    X        = np.array([features])

    preds = model.predict(X)[0]  # [calories, protein, carbs, fat]

    result = {
        "calories": max(0, round(float(preds[0]), 1)),
        "protein":  max(0, round(float(preds[1]), 1)),
        "carbs":    max(0, round(float(preds[2]), 1)),
        "fat":      max(0, round(float(preds[3]), 1)),
    }
    logger.info(f"[nutrition] '{description}' → {result}")
    return result


def _load_model():
    """Lazy-load model once and cache in memory."""
    global _model
    if _model is None:
        if not os.path.exists(MODEL_PATH):
            raise FileNotFoundError(
                f"Nutrition model not found at {MODEL_PATH}. "
                "Run ai_training/train_nutrition_model.py first."
            )
        _model = joblib.load(MODEL_PATH)
        logger.info("[nutrition] model loaded")
    return _model


def _extract_features(text: str) -> list:
    """
    Rule-assisted feature extraction from meal description text.
    Returns a fixed-length numeric feature vector.

    Features (12 total):
      0  – total quantity tokens (numbers found in text)
      1  – word count
      2  – has_egg
      3  – has_rice
      4  – has_bread / toast
      5  – has_chicken / meat
      6  – has_vegetable (salad, spinach, broccoli, etc.)
      7  – has_dairy (milk, cheese, yogurt)
      8  – has_fruit
      9  – has_oil / fried
      10 – has_legume (beans, lentils, dal)
      11 – quantity_sum (sum of all numeric values found)
    """
    t = text.lower()

    numbers    = [float(n) for n in re.findall(r"\d+\.?\d*", t)]
    qty_count  = len(numbers)
    qty_sum    = sum(numbers) if numbers else 1.0
    word_count = len(t.split())

    def has(*keywords):
        return int(any(k in t for k in keywords))

    return [
        qty_count,
        word_count,
        has("egg", "eggs"),
        has("rice", "biryani", "fried rice"),
        has("bread", "toast", "roti", "chapati", "wrap"),
        has("chicken", "meat", "beef", "pork", "fish", "salmon", "tuna"),
        has("salad", "spinach", "broccoli", "vegetable", "veggie", "carrot", "cucumber"),
        has("milk", "cheese", "yogurt", "curd", "paneer", "butter"),
        has("fruit", "apple", "banana", "mango", "orange", "berry"),
        has("oil", "fried", "deep fry", "butter"),
        has("beans", "lentils", "dal", "chickpea", "legume"),
        qty_sum,
    ]
