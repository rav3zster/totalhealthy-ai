"""
Nutrition Model Training Script
Run this in Google Colab or locally.
Trains XGBoost multi-output regressor on USDA-style food data.
Output: ai_functions/models/nutrition_model.pkl
"""

import numpy as np
import pandas as pd
import joblib, os, re
from xgboost import XGBRegressor
from sklearn.multioutput import MultiOutputRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error

# ── Sample dataset (replace with USDA FoodData CSV for production) ───────────
# Columns: description, calories, protein, carbs, fat
SAMPLE_DATA = [
    ("2 boiled eggs",                    155, 13.0, 1.1,  11.0),
    ("2 boiled eggs and toast",          280, 16.0, 22.0, 12.0),
    ("grilled chicken breast 150g",      248, 46.0, 0.0,  5.4),
    ("chicken rice bowl",                520, 38.0, 55.0, 12.0),
    ("bowl of oatmeal with banana",      350, 10.0, 65.0, 5.0),
    ("vegetable salad with olive oil",   180, 3.0,  12.0, 14.0),
    ("2 chapati with dal",               380, 14.0, 62.0, 7.0),
    ("paneer butter masala with rice",   650, 22.0, 72.0, 28.0),
    ("fruit salad 1 bowl",               120, 1.5,  30.0, 0.5),
    ("whole wheat bread 2 slices",       160, 6.0,  30.0, 2.0),
    ("milk 1 glass 250ml",               150, 8.0,  12.0, 8.0),
    ("banana smoothie",                  280, 5.0,  55.0, 4.0),
    ("fried rice 1 plate",               450, 10.0, 70.0, 14.0),
    ("salmon fillet 200g",               412, 40.0, 0.0,  26.0),
    ("lentil soup 1 bowl",               230, 18.0, 32.0, 3.0),
    ("cheese sandwich",                  350, 14.0, 38.0, 16.0),
    ("3 idli with sambar",               280, 9.0,  52.0, 3.0),
    ("dosa with coconut chutney",        320, 7.0,  48.0, 11.0),
    ("1 cup yogurt with berries",        180, 10.0, 25.0, 4.0),
    ("beef burger",                      550, 28.0, 42.0, 28.0),
]

df = pd.DataFrame(SAMPLE_DATA, columns=["description", "calories", "protein", "carbs", "fat"])


# ── Feature extraction (must match nutrition.py _extract_features) ────────────
def extract_features(text):
    t = text.lower()
    numbers   = [float(n) for n in re.findall(r"\d+\.?\d*", t)]
    qty_count = len(numbers)
    qty_sum   = sum(numbers) if numbers else 1.0
    word_count = len(t.split())

    def has(*keywords):
        return int(any(k in t for k in keywords))

    return [
        qty_count, word_count,
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

X = np.array([extract_features(d) for d in df["description"]])
y = df[["calories", "protein", "carbs", "fat"]].values

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# ── Train ─────────────────────────────────────────────────────────────────────
base  = XGBRegressor(n_estimators=200, max_depth=4, learning_rate=0.1,
                     random_state=42, verbosity=0)
model = MultiOutputRegressor(base)
model.fit(X_train, y_train)

# ── Evaluate ──────────────────────────────────────────────────────────────────
preds  = model.predict(X_test)
labels = ["calories", "protein", "carbs", "fat"]
for i, label in enumerate(labels):
    mae = mean_absolute_error(y_test[:, i], preds[:, i])
    print(f"MAE {label}: {mae:.2f}")

# ── Save ──────────────────────────────────────────────────────────────────────
os.makedirs("../ai_functions/models", exist_ok=True)
joblib.dump(model, "../ai_functions/models/nutrition_model.pkl")
print("✓ Saved: ai_functions/models/nutrition_model.pkl")
