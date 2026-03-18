"""
PHASE 1 – Content-Based Meal Recommendation
Uses TF-IDF + cosine similarity on user's Firestore meal history.
Caches result in Firestore for 24h to avoid recomputing on every request.
"""

import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from datetime import datetime, timedelta, timezone
import logging

logger = logging.getLogger(__name__)

CACHE_HOURS = 24


def get_recommendations(db, user_id: str) -> dict:
    """
    Main entry. Returns cached result if fresh, else recomputes.
    """
    # ── 1. Check cache ────────────────────────────────────────────────────────
    cached = _get_cache(db, user_id)
    if cached:
        logger.info(f"[recommendation] cache hit for {user_id}")
        return cached

    # ── 2. Fetch meal history from Firestore ──────────────────────────────────
    meals = _fetch_meals(db, user_id)

    if len(meals) < 3:
        logger.info(f"[recommendation] not enough history for {user_id}")
        return {"recommendations": [], "message": "Log at least 3 meals to get recommendations"}

    # ── 3. Build TF-IDF matrix ────────────────────────────────────────────────
    descriptions = [m["description"] for m in meals]
    vectorizer   = TfidfVectorizer(stop_words="english", ngram_range=(1, 2))
    tfidf_matrix = vectorizer.fit_transform(descriptions)

    # ── 4. Compute cosine similarity ──────────────────────────────────────────
    # Use the last 3 meals as the "query" to find similar past meals
    query_indices = list(range(max(0, len(meals) - 3), len(meals)))
    query_vector  = np.asarray(tfidf_matrix[query_indices].mean(axis=0))
    similarities  = cosine_similarity(query_vector, tfidf_matrix)[0]

    # ── 5. Rank and pick top 5 (exclude the query meals themselves) ───────────
    ranked = sorted(
        [(i, float(similarities[i])) for i in range(len(meals)) if i not in query_indices],
        key=lambda x: x[1],
        reverse=True
    )

    top5 = []
    seen = set()
    for idx, score in ranked:
        meal = meals[idx]
        key  = meal["description"].lower().strip()
        if key not in seen:
            seen.add(key)
            top5.append({
                "mealType":    meal.get("mealType", ""),
                "description": meal["description"],
                "score":       round(score, 4),
            })
        if len(top5) == 5:
            break

    result = {"recommendations": top5}

    # ── 6. Cache result ───────────────────────────────────────────────────────
    _set_cache(db, user_id, result)
    logger.info(f"[recommendation] computed {len(top5)} recs for {user_id}")
    return result


# ── Firestore helpers ─────────────────────────────────────────────────────────

def _fetch_meals(db, user_id: str) -> list:
    """Fetch all meal documents for a user, ordered by timestamp desc."""
    try:
        docs = (
            db.collection("users").document(user_id)
              .collection("meals")
              .order_by("timestamp", direction="DESCENDING")
              .limit(100)
              .stream()
        )
        meals = []
        for doc in docs:
            data = doc.to_dict()
            desc = data.get("description") or data.get("mealName") or ""
            if desc.strip():
                meals.append({
                    "id":          doc.id,
                    "description": desc.strip(),
                    "mealType":    data.get("mealType", ""),
                    "timestamp":   data.get("timestamp"),
                })
        logger.info(f"[recommendation] fetched {len(meals)} meals for {user_id}")
        return meals
    except Exception as e:
        logger.error(f"[recommendation] _fetch_meals error: {e}")
        return []


def _get_cache(db, user_id: str):
    """Return cached recommendations if they exist and are < 24h old."""
    try:
        doc = db.collection("users").document(user_id)\
                .collection("stats").document("recommendation_cache").get()
        if not doc.exists:
            return None
        data      = doc.to_dict()
        cached_at = data.get("cachedAt")
        if not cached_at:
            return None
        age = datetime.now(timezone.utc) - cached_at.replace(tzinfo=timezone.utc)
        if age < timedelta(hours=CACHE_HOURS):
            return {"recommendations": data.get("recommendations", [])}
        return None
    except Exception as e:
        logger.warning(f"[recommendation] cache read error: {e}")
        return None


def _set_cache(db, user_id: str, result: dict):
    """Write recommendations to Firestore cache."""
    try:
        db.collection("users").document(user_id)\
          .collection("stats").document("recommendation_cache")\
          .set({
              "recommendations": result["recommendations"],
              "cachedAt":        datetime.now(timezone.utc),
          })
    except Exception as e:
        logger.warning(f"[recommendation] cache write error: {e}")
