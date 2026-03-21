# Render Deployment Guide — TotalHealthy AI Backend

## Step 1: Push flask_backend to GitHub

The flask_backend folder must be in a GitHub repo (can be your own repo).
Either push the whole project or just the flask_backend folder as its own repo.

## Step 2: Create a Web Service on Render

1. Go to https://render.com → New → Web Service
2. Connect your GitHub repo
3. Set Root Directory to: flask_backend
4. Configure:
   - Name:          totalhealthy-ai
   - Runtime:       Python 3
   - Build Command: pip install -r requirements.txt
   - Start Command: gunicorn app:app --bind 0.0.0.0:10000 --timeout 60 --workers 1
   - Instance Type: Free

## Step 3: Set Environment Variable

In Render dashboard → Environment → Add:
  Key:   GEMINI_API_KEY
  Value: your_actual_gemini_api_key_here

Get your Gemini API key from: https://aistudio.google.com/app/apikey

## Step 4: Deploy

Click "Create Web Service". Render will:
1. Install requirements
2. Start gunicorn
3. Give you a URL like: https://totalhealthy-ai.onrender.com

## Step 5: Update Flutter

In lib/app/services/ai_service.dart, replace:
  const String _renderUrl = 'https://YOUR-APP-NAME.onrender.com';
with your actual Render URL:
  const String _renderUrl = 'https://totalhealthy-ai.onrender.com';

## Step 6: Test the endpoint

curl -X POST https://totalhealthy-ai.onrender.com/generate_meal \
  -H "Content-Type: application/json" \
  -d '{
    "goal": "muscle_build",
    "currentWeight": "70",
    "targetWeight": "75",
    "dietType": "Vegetarian",
    "allergies": ["Dairy"],
    "cuisine": "Indian",
    "mealsPerDay": 3,
    "mealTypes": ["Breakfast", "Lunch", "Dinner"],
    "exerciseFrequency": "5 Days/Week",
    "exerciseType": "Strength Training"
  }'

Expected response:
{
  "status": "ok",
  "meals": [
    {
      "name": "...",
      "category": "Breakfast",
      "ingredients": ["..."],
      "calories": 450,
      "protein": 28,
      "carbs": 55,
      "fat": 12,
      "description": "..."
    }
  ]
}

## ⚠️ Cold Start Warning

Render free tier sleeps after 15 minutes of inactivity.
First request after sleep takes ~30 seconds.
Flutter handles this with a 60s timeout + 1 automatic retry.
Users will see the shimmer loading screen during this time.

## Health Check

GET https://totalhealthy-ai.onrender.com/
Response: {"status": "ok", "service": "TotalHealthy AI Backend"}
