"""
Diet Classifier Training Script
Trains a Random Forest to classify: weight_loss | maintenance | muscle_gain
Output: ai_functions/models/diet_classifier.pkl
"""

import numpy as np
import joblib, os
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.metrics import classification_report

# ── Synthetic training data ───────────────────────────────────────────────────
# Features: age, weight(kg), height(cm), bmi, activityLevel(1-5), goal(0/1/2), tdee
# Label   : 0=weight_loss, 1=maintenance, 2=muscle_gain

np.random.seed(42)
n = 500

age      = np.random.randint(18, 60, n).astype(float)
weight   = np.random.uniform(45, 120, n)
height   = np.random.uniform(150, 195, n)
bmi      = weight / ((height / 100) ** 2)
activity = np.random.randint(1, 6, n).astype(float)
goal_raw = np.random.randint(0, 3, n)   # 0=lose, 1=maintain, 2=gain

multipliers = {1: 1.2, 2: 1.375, 3: 1.55, 4: 1.725, 5: 1.9}
bmr  = 10 * weight + 6.25 * height - 5 * age + 5
tdee = np.array([bmr[i] * multipliers[int(activity[i])] for i in range(n)])

X = np.column_stack([age, weight, height, bmi, activity, goal_raw, tdee])

# Label = goal_raw (the user's stated goal drives the classification)
# In production, you'd derive this from actual behavior patterns
y = goal_raw

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# ── Train ─────────────────────────────────────────────────────────────────────
model = RandomForestClassifier(n_estimators=100, max_depth=8, random_state=42)
model.fit(X_train, y_train)

# ── Evaluate ──────────────────────────────────────────────────────────────────
preds = model.predict(X_test)
print(classification_report(y_test, preds,
      target_names=["weight_loss", "maintenance", "muscle_gain"]))

cv_scores = cross_val_score(model, X, y, cv=5)
print(f"CV Accuracy: {cv_scores.mean():.3f} ± {cv_scores.std():.3f}")

# ── Save ──────────────────────────────────────────────────────────────────────
os.makedirs("../ai_functions/models", exist_ok=True)
joblib.dump(model, "../ai_functions/models/diet_classifier.pkl")
print("✓ Saved: ai_functions/models/diet_classifier.pkl")
