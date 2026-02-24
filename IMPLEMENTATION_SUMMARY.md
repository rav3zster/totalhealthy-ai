# Group Categories System - Implementation Summary

## Overview

This document provides a high-level summary of the Group Categories system design that replaces the Meal Timing feature.

## Key Changes at a Glance

### What's Being Replaced
- **Old:** User-level "Meal Timing" screen with hardcoded time slots
- **New:** Group-level "Meal Categories" with dynamic, admin-managed categories

### Core Concept Shift
```
BEFORE: User → Meal Timing (personal) → Fixed categories
AFTER:  Group → Meal Categories (shared) → Dynamic categories
```

## Architecture Summary

### 1. Data Model (3 Key Changes)

**New Model: MealCategoryModel**
- Stored at: `groups/{groupId}/categories/{categoryId}`
- Fields: name, order, isDefault, createdAt, createdBy
- Default categories: Breakfast, Lunch, Dinner, Snacks (cannot be deleted)

**Updated: MealModel**
- Add: `categoryIds` (List<String>) - references category IDs
- Keep: `categories` (List<String>) - deprecated, for backward compatibility

**Updated: GroupMealPlanModel**
- Change: `mealSlots` keys from category names to category IDs
- Example: `{"category_abc123": "meal_xyz789"}` instead of `{"Breakfast": "meal_xyz789"}`

### 2. Service Layer (1 New + 3 Updates)

**New: MealCategoriesFirestoreService**
- CRUD operations for categories
- Validation (unique names, deletion constraints)
- Default category initialization

**Updated Services:**
- `GroupsFirestoreService`: Initialize categories when creating group
- `MealsFirestoreService`: Filter by categoryId instead of name
- `GroupMealPlansFirestoreService`: Validate categoryId exists

### 3. Controller Layer (1 New + 2 Updates)

**New: MealCategoriesController**
- Load categories for group
- Handle CRUD with admin permission checks
- Real-time category updates

**Updated Controllers:**
- `ClientDashboardController`: Subscribe to categories, filter by categoryId
- `PlannerController`: Use dynamic categories instead of hardcoded

### 4. UI Layer (1 New + 3 Updates + 1 Removal)

**New: MealCategoriesView**
- Admin mode: Create, rename, reorder, delete categories
- Member mode: Read-only view
- Accessed via: Profile → Meal Categories

**Updated Views:**
- `ProfileSettingsView`: Add "Meal Categories" navigation item
- `ClientDashboardView`: Dynamic category tabs (not hardcoded)
- `MemberProfileView`: Remove "Meal Timing" button

**Removed:**
- Entire `meal_timing` module directory

## Migration Strategy

### Approach: Lazy Migration (No Downtime)

**Phase 1: Initialize Categories**
- Run once per group on first access
- Create default categories if none exist
- Non-blocking background process

**Phase 2: Migrate Meal Data**
- On read: Convert category names to IDs
- Lookup category by name in group's categories
- Update document with categoryIds

**Phase 3: Migrate Planner Data**
- On read: Convert mealSlots keys from names to IDs
- Lookup category IDs by name
- Update document with new keys

**Backward Compatibility:**
- Old data still readable
- New code handles both formats
- Gradual migration as data is accessed

## Validation & Edge Cases

### Category Deletion Constraints
1. ✗ Cannot delete default categories
2. ✗ Cannot delete if meals reference it
3. ✗ Cannot delete if planner references it
4. ✗ Cannot delete last category (must keep ≥1)

### Conflict Resolution
- **Multiple admins editing:** Last write wins, optimistic UI updates
- **Race conditions:** Firestore transactions for critical operations
- **Category renaming:** No planner impact (uses IDs, not names)

### Multi-Group Support
- Categories scoped to groupId
- User in multiple groups sees different categories per group
- Cache categories per group in controller

## Future-Proofing

### Multiple Meals Per Category
**Current:** `Map<String, String?>` - one meal per category
**Future:** `Map<String, List<String>>` - multiple meals per category

**Migration Path:**
```dart
// Backward compatible
if (value is String) {
  slots[categoryId] = [value];  // Old format
} else if (value is List) {
  slots[categoryId] = value;    // New format
}
```

No breaking changes - existing data works as list with 1 item.

## Implementation Checklist

### Critical Path (Must Complete)
1. ✅ Create MealCategoryModel
2. ✅ Create MealCategoriesFirestoreService
3. ✅ Update MealModel (add categoryIds)
4. ✅ Update GroupMealPlanModel (support categoryId keys)
5. ✅ Create MealCategoriesController
6. ✅ Create MealCategoriesView
7. ✅ Update ClientDashboardController
8. ✅ Update ClientDashboardView (dynamic tabs)
9. ✅ Add navigation to ProfileSettingsView
10. ✅ Remove meal_timing module
11. ✅ Create MigrationService
12. ✅ Deploy Firestore indexes

### Testing Checklist
- [ ] Admin can create/rename/reorder/delete categories
- [ ] Member can only view categories
- [ ] Cannot delete category with meals
- [ ] Cannot delete default categories
- [ ] Dashboard filters by categoryId correctly
- [ ] Planner uses dynamic categories
- [ ] Migration handles old data correctly
- [ ] Multiple groups work independently

## Rollback Plan

### If Issues Arise
1. **Code Rollback:** Restore meal_timing module, revert model changes
2. **Data Safety:** Categories remain in Firestore (no harm), old code still works
3. **Feature Flag:** `FeatureFlags.enableDynamicCategories` to toggle systems

### Gradual Rollout
```dart
if (FeatureFlags.useMealCategories) {
  // New system
} else {
  // Old system
}
```

## Benefits

### For Admins
- ✅ Customize categories per group
- ✅ Add unlimited categories (Pre-Workout, Post-Workout, etc.)
- ✅ Reorder categories for better UX
- ✅ Rename categories without breaking planner

### For Members
- ✅ See group-specific categories
- ✅ Clearer meal organization
- ✅ Consistent experience across group

### For Developers
- ✅ Clean architecture (group-level vs user-level)
- ✅ Scalable design (supports future enhancements)
- ✅ Maintainable code (IDs prevent rename issues)
- ✅ Backward compatible (no data loss)

## Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Data migration fails | High | Lazy migration, backward compatibility |
| Race conditions on delete | Medium | Firestore transactions |
| Multiple admins conflict | Low | Optimistic updates, last write wins |
| Category name collisions | Low | Unique name validation |
| Planner breaks after rename | High | Use IDs instead of names |

## Timeline Estimate

- **Phase 1 (Data Layer):** 2-3 days
- **Phase 2 (Controllers):** 2-3 days
- **Phase 3 (UI):** 3-4 days
- **Phase 4 (Testing):** 2-3 days
- **Phase 5 (Migration):** 1-2 days
- **Total:** 10-15 days

## Success Criteria

1. ✅ Admins can manage categories without code changes
2. ✅ Members see dynamic categories in dashboard
3. ✅ Planner works with custom categories
4. ✅ Old data migrates without errors
5. ✅ No downtime during deployment
6. ✅ Performance remains acceptable (<2s load time)

## Next Steps

1. Review design with team
2. Get approval on data model changes
3. Create Firestore indexes
4. Start implementation (Phase 1: Data Layer)
5. Incremental testing after each phase
6. Deploy to staging for QA
7. Run migration script on production
8. Monitor for errors
9. Full production deployment

## Questions to Resolve

1. Should we allow members to suggest categories (pending admin approval)?
2. Should categories have icons/colors for better visual distinction?
3. Should we support category templates (e.g., "Bodybuilding", "Keto")?
4. Should we track category usage analytics?
5. Should we support category-level permissions (some members can't see certain categories)?

## Contact

For questions or clarifications on this design, please refer to:
- **Design Document:** `GROUP_CATEGORIES_DESIGN.md`
- **Architecture Diagram:** `ARCHITECTURE_DIAGRAM.md`
- **This Summary:** `IMPLEMENTATION_SUMMARY.md`
