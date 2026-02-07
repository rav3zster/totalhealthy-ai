# Profile Settings - Quick Reference Guide

## 🎯 What Changed?

**Before:** Two separate screens for editing profile
**After:** One unified screen with all fields

## 📍 How to Access

```dart
// From anywhere in the app
Get.toNamed('/profile-settings');

// From profile main view
// Click the Edit button (pencil icon)
```

## 📋 Available Fields

### Personal Information
- Profile Picture (tap camera icon to edit)
- First Name
- Last Name
- Email (read-only)
- Phone Number

### Physical Information
- Age
- Weight (kg)
- Height (cm)
- Gender (Male/Female/Other)

### Activity Level
- Sedentary
- Light
- Moderate
- Active
- Very Active

### Fitness Goals (Multi-select)
- Weight Loss
- Muscle Gain
- Maintenance
- Endurance
- Strength
- Flexibility

### Diet Preferences (Collapsible)
- Diet Type: Vegetarian, Vegan, Keto, Paleo, Mediterranean, Not Specific
- Food Allergies: Gluten, Dairy, Nuts, Shellfish, Meat, Not Specific

## 💾 How to Save

1. Edit any fields you want to change
2. Click "Save" button in the top right
3. Wait for success message
4. Changes are automatically synced to Firebase

## ✅ Validation Rules

| Field | Rule |
|-------|------|
| First Name | Required, min 2 characters |
| Last Name | Required, min 2 characters |
| Email | Valid email format (read-only) |
| Phone | Valid phone format |
| Age | 1-150 years |
| Weight | 1-1000 kg |
| Height | 1-300 cm |
| Goals | At least one must be selected |

## 🔧 For Developers

### Import
```dart
// No import needed, use route
Get.toNamed('/profile-settings');
```

### Access User Data
```dart
final userController = Get.find<UserController>();
final user = userController.currentUser;
```

### Update Profile
```dart
await userController.updateUserProfile(
  firstName: 'John',
  lastName: 'Doe',
  phone: '+1234567890',
  age: 25,
  weight: 70.0,
  height: 175,
  activityLevel: 'Moderate',
  goals: ['Weight Loss', 'Muscle Gain'],
);
```

### Listen to Changes
```dart
Obx(() {
  final user = userController.currentUser;
  return Text(user?.fullName ?? 'Loading...');
});
```

## 🐛 Troubleshooting

### Issue: Fields not loading
**Solution:** Check if UserController is initialized
```dart
final userController = Get.find<UserController>();
if (!userController.isInitialized) {
  await userController.refreshUserData();
}
```

### Issue: Save button not working
**Solution:** Check form validation
```dart
if (!_formKey.currentState!.validate()) {
  // Fix validation errors
  return;
}
```

### Issue: Changes not persisting
**Solution:** Check Firebase connection
```dart
try {
  await userController.updateUserProfile(...);
} catch (e) {
  print('Error: $e');
  // Check Firebase rules and connection
}
```

## 📱 User Guide

### Editing Your Profile

1. **Open Profile Settings**
   - Tap your profile picture or name
   - Tap the Edit button (pencil icon)
   - OR go to Settings → Profile

2. **Edit Personal Information**
   - Tap any field to edit
   - Email cannot be changed (linked to your account)

3. **Update Physical Information**
   - Enter your current age, weight, and height
   - Select your gender

4. **Set Activity Level**
   - Tap the dropdown
   - Choose your typical activity level

5. **Choose Fitness Goals**
   - Tap goals to select/deselect
   - You can select multiple goals
   - At least one goal is required

6. **Set Diet Preferences** (Optional)
   - Tap to expand the section
   - Select your diet type
   - Check any food allergies

7. **Save Changes**
   - Tap "Save" in the top right
   - Wait for confirmation message
   - Your changes are saved!

## 🎨 UI Components

### Text Fields
```dart
_buildTextFormField(
  controller: _firstNameController,
  label: 'First Name',
  validator: AppValidator.validateName,
)
```

### Dropdowns
```dart
_buildActivityLevelSelector()
_buildGenderSelector()
```

### Multi-Select Chips
```dart
_buildGoalsSelector()
```

### Collapsible Section
```dart
_buildDietPreferenceSection()
```

## 🔐 Security Notes

- Email field is read-only (linked to authentication)
- All data is validated before saving
- Changes are synced to Firebase securely
- User data is cached locally for offline access

## 📊 Data Flow

```
User Opens Screen
    ↓
Load from UserController
    ↓
Display in Form
    ↓
User Edits
    ↓
Validate on Save
    ↓
Update UserController
    ↓
Sync to Firebase
    ↓
Update Cache
    ↓
Show Success
```

## 🚀 Performance Tips

1. **Use Cached Data**
   - UserController caches data for 5 minutes
   - Reduces Firebase reads
   - Faster load times

2. **Batch Updates**
   - Edit multiple fields before saving
   - Single Firebase write
   - Better performance

3. **Validate Early**
   - Form validates on save
   - Prevents unnecessary Firebase calls
   - Better user experience

## 📝 Code Examples

### Complete Save Example
```dart
Future<void> _saveProfile() async {
  // Validate
  if (!_formKey.currentState!.validate()) {
    return;
  }
  
  if (_selectedGoals.isEmpty) {
    Get.snackbar('Error', 'Select at least one goal');
    return;
  }
  
  // Save
  try {
    await userController.updateUserProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      weight: double.parse(_weightController.text.trim()),
      height: int.parse(_heightController.text.trim()),
      activityLevel: _selectedActivityLevel!,
      goals: _selectedGoals,
    );
    
    Get.back();
    Get.snackbar('Success', 'Profile updated');
  } catch (e) {
    Get.snackbar('Error', 'Failed to update: $e');
  }
}
```

### Custom Field Example
```dart
Widget _buildCustomField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Field Label',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: TextFormField(
          // ... field configuration
        ),
      ),
    ],
  );
}
```

## 🎯 Best Practices

### For Users
1. Keep your profile up to date
2. Select accurate fitness goals
3. Update weight regularly for progress tracking
4. Set realistic activity levels

### For Developers
1. Always validate before saving
2. Handle errors gracefully
3. Provide clear feedback
4. Use loading states
5. Cache data appropriately
6. Test on multiple devices

## 📞 Support

### Common Questions

**Q: Can I change my email?**
A: No, email is linked to your account and cannot be changed.

**Q: How often should I update my weight?**
A: Weekly updates are recommended for accurate progress tracking.

**Q: Can I select multiple fitness goals?**
A: Yes! Select as many as apply to you.

**Q: What if I don't have diet restrictions?**
A: Select "Not Specific" for both diet type and allergies.

**Q: Will my changes sync across devices?**
A: Yes, all changes are saved to Firebase and sync automatically.

## 🔄 Version History

### v2.0 (Current)
- ✅ Consolidated all profile fields into one screen
- ✅ Added form validation
- ✅ Improved UI/UX
- ✅ Better error handling
- ✅ Loading states
- ✅ Success feedback

### v1.0 (Deprecated)
- ❌ Two separate screens
- ❌ Incomplete validation
- ❌ Inconsistent UI
- ❌ No error handling

## 📚 Related Documentation

- [User Model](lib/app/data/models/user_model.dart)
- [User Controller](lib/app/controllers/user_controller.dart)
- [App Validator](lib/app/core/utitlity/appvalidator.dart)
- [Profile Main View](lib/app/modules/profile/views/profile_main_view.dart)

## ✨ Tips & Tricks

1. **Quick Edit**: Double-tap any field to start editing
2. **Keyboard Navigation**: Use Tab to move between fields
3. **Undo Changes**: Press back button to discard changes
4. **Batch Edit**: Edit multiple fields before saving to reduce Firebase writes
5. **Offline Mode**: Changes are cached and synced when online

## 🎓 Learning Resources

- [Flutter Forms](https://flutter.dev/docs/cookbook/forms)
- [GetX State Management](https://pub.dev/packages/get)
- [Firebase Firestore](https://firebase.google.com/docs/firestore)
- [Form Validation](https://flutter.dev/docs/cookbook/forms/validation)
