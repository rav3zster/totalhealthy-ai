# Render Deployment Guide — TotalHealthy AI Backend

## Files required in flask_backend/
  app.py            ← Flask app
  requirements.txt  ← Python dependencies
  render.yaml       ← Render config
  Procfile          ← Gunicorn start command (fallback)
  .gitignore        ← Ignore cache/venv

---

## Step 1: Get Gemini API Key
  https://aistudio.google.com/app/apikey
  Free tier is sufficient.

---

## Step 2: Push to GitHub
  Option A — push entire project (flask_backend is a subfolder):
    git push mygithub main

  Option B — push only flask_backend as its own repo:
    cd flask_backend
    git init
    git add .
    git commit -m "init flask backend"
    git remote add origin https://github.com/YOUR_USERNAME/totalhealthy-ai.git
    git push -u origin main

---

## Step 3: Create Web Service on Render
  1. Go to https://render.com → New → Web Service
  2. Connect your GitHub repo
  3. If flask_backend is a subfolder, set:
       Root Directory: flask_backend
  4. Settings:
       Name:          totalhealthy-ai
       Runtime:       Python 3
       Build Command: pip install -r requirements.txt
       Start Command: gunicorn app:app --bind 0.0.0.0:$PORT --timeout 120 --workers 1
       Instance Type: Free

---

## Step 4: Add Environment Variable
  Render Dashboard → Your Service → Environment → Add:
    Key:   GEMINI_API_KEY
    Value: AIza... (your actual key)

  Click Save → service will redeploy automatically.

---

## Step 5: Verify Deployment
  Wait for "Deploy succeeded" in Render logs, then:

  # Health check
  curl https://YOUR-APP.onrender.com/

  Expected: {"service":"TotalHealthy AI Backend","status":"ok"}

  # Static test (no Gemini call)
  curl https://YOUR-APP.onrender.com/test

  Expected: {"meals":[...],"note":"This is a static test response","status":"ok"}

---

## Step 6: Test /generate_meal

  curl -X POST https://YOUR-APP.onrender.com/generate_meal \
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
      "exerciseType": "Strength Training",
      "prePostWorkoutNutrition": "yes"
    }'

  Expected response:
  {
    "status": "ok",
    "meals": [
      {
        "name": "Masala Oats",
        "category": "Breakfast",
        "ingredients": ["1 cup oats", "vegetables", "spices"],
        "calories": 320,
        "protein": 14,
        "carbs": 52,
        "fat": 6,
        "description": "..."
      },
      ...
    ]
  }

---

## Step 7: Update Flutter
  In lib/app/services/ai_service.dart, replace:
    const String _renderUrl = 'https://YOUR-APP-NAME.onrender.com';
  with:
    const String _renderUrl = 'https://totalhealthy-ai.onrender.com';

---

## ⚠️ Cold Start Warning
  Render free tier sleeps after 15 min of inactivity.
  First request after sleep: ~15–30 seconds.
  Flutter handles this with 60s timeout + 1 auto-retry.
  Users see shimmer loading during this time — this is expected.

---

## 🐛 Debug Checklist

  PROBLEM: Deploy fails on Render
  FIX:
    - Check Build Logs in Render dashboard
    - Ensure Root Directory is set to flask_backend (if subfolder)
    - Ensure requirements.txt is in the root of the deployed folder

  PROBLEM: 500 error on /generate_meal
  FIX:
    - Check Render Logs tab
    - Verify GEMINI_API_KEY is set in Environment tab
    - Hit GET /test first — if that works, issue is Gemini API key

  PROBLEM: "GEMINI_API_KEY not set" in logs
  FIX:
    - Go to Render → Environment → add GEMINI_API_KEY
    - Trigger manual redeploy

  PROBLEM: Response contains markdown (```json)
  FIX:
    - Already handled in _parse_response() with regex strip
    - Check Render logs for "Gemini raw response" line

  PROBLEM: Flutter gets timeout
  FIX:
    - Render free tier cold start — first request is slow
    - Flutter already retries once automatically
    - Upgrade to Render paid tier ($7/mo) to eliminate cold starts

  PROBLEM: Flutter CORS error (web only)
  FIX:
    - CORS headers are added via @app.after_request in app.py
    - Already handled

  PROBLEM: meals array is empty
  FIX:
    - Check Render logs for "No JSON object found" or "meals key missing"
    - Gemini may have returned plain text — check "Gemini raw response" log
    - Fallback meal will be returned automatically
