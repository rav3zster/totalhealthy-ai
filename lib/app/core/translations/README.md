# Translation System Usage Guide

## How to Use Translations in Your App

### Basic Usage

Replace hardcoded text with translation keys using `.tr`:

```dart
// Before
Text('Welcome')

// After
Text('welcome'.tr)
```

### Available Translation Keys

Check `app_translations.dart` for all available keys. Current keys include:

#### Common
- `welcome`, `settings`, `language`, `region`, `theme`
- `save`, `cancel`, `ok`, `yes`, `no`
- `search`, `back`

#### Settings
- `general`, `account`, `notifications`, `profile`
- `preferences`, `about`

#### Theme
- `light`, `dark`, `system`

#### Dashboard
- `dashboard`, `meals`, `workouts`, `progress`

#### Messages
- `theme_updated`, `language_updated`, `region_updated`
- `settings_saved`

### Supported Languages

- English (en) - Default
- Hindi (hi)
- Spanish (es)
- French (fr)

### Adding New Translations

1. Open `lib/app/core/translations/app_translations.dart`
2. Add your key to all language maps:

```dart
'en': {
  'my_new_key': 'My New Text',
  // ... other keys
},
'hi': {
  'my_new_key': 'मेरा नया पाठ',
  // ... other keys
},
// ... other languages
```

3. Use it in your code:

```dart
Text('my_new_key'.tr)
```

### Dynamic Translations with Parameters

```dart
// In translations
'hello_user': 'Hello @name',

// In code
Text('hello_user'.trParams({'name': 'John'}))
```

### Plural Translations

```dart
// In translations
'items': 'You have @count items',

// In code
Text('items'.trParams({'count': '5'}))
```

### How Language Changes Work

When user selects a language in General Settings:

1. `GlobalSettingsController.changeLanguage()` is called
2. Language code is mapped (English → 'en', Hindi → 'hi', etc.)
3. `Get.updateLocale()` updates the app locale
4. All `.tr` texts automatically update across the entire app
5. Settings are saved to SharedPreferences and Firestore

### Testing Translations

1. Go to Settings → General
2. Change Language dropdown
3. All translated text should update instantly
4. Restart app - language should persist

### Best Practices

1. Always use lowercase keys with underscores: `my_key` not `MyKey`
2. Keep keys descriptive: `login_button` not `btn1`
3. Group related keys: `error_network`, `error_timeout`, etc.
4. Add translations for all supported languages when adding new keys
5. Use fallback text for missing translations:

```dart
Text('my_key'.tr ?? 'Fallback Text')
```
