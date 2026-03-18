# AI Cloud Functions – Deployment Guide

## Step 1: Train the models (run locally or in Google Colab)

```bash
cd ai_training
pip install scikit-learn xgboost pandas joblib numpy
python train_nutrition_model.py
python train_diet_classifier.py
# Output: ai_functions/models/nutrition_model.pkl
#         ai_functions/models/diet_classifier.pkl
```

## Step 2: Deploy to Google Cloud Functions (Python 3.11)

```bash
cd ai_functions

# Deploy recommendation function
gcloud functions deploy recommend_meals \
  --runtime python311 \
  --trigger-http \
  --allow-unauthenticated \
  --entry-point recommend_meals \
  --source .

# Deploy nutrition prediction function
gcloud functions deploy predict_meal_nutrition \
  --runtime python311 \
  --trigger-http \
  --allow-unauthenticated \
  --entry-point predict_meal_nutrition \
  --source .

# Deploy diet classifier function
gcloud functions deploy classify_user_diet \
  --runtime python311 \
  --trigger-http \
  --allow-unauthenticated \
  --entry-point classify_user_diet \
  --source .
```

## Step 3: Update Flutter

In `lib/app/services/ai_service.dart`, replace:
```
const String _baseUrl = 'https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net';
```
with your actual Cloud Functions base URL from the GCP console.

## Firestore Collections Required

```
users/
  {userId}/
    meals/          ← meal logs (mealType, description, timestamp)
    preferences/    ← dietary preferences
    stats/
      recommendation_cache   ← auto-created by recommendation function
groups/
  {groupId}/
    meals/
    members/
```

## Phase 4: Smart Reminders (FCM)
- Cloud Scheduler triggers a Cloud Function every hour
- Function queries users whose last meal log timestamp is overdue
- Sends FCM push notification via firebase-admin

## Testing locally

```bash
cd ai_functions
pip install functions-framework
functions-framework --target recommend_meals --debug
# POST http://localhost:8080 with {"userId": "test123"}
```
