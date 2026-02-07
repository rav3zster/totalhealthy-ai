# Create Meal Screen - Visual Design Guide

## 🎨 Color Palette

### Primary Colors
```
Lime Green:     #C2D86A
Light Lime:     #B8CC5A
```

### Background Colors
```
Pure Black:     #000000
Dark Gray:      #1A1A1A
Medium Gray:    #2A2A2A
```

### Text Colors
```
White:          #FFFFFF (100%)
Light Gray:     #FFFFFF (70%)
Medium Gray:    #FFFFFF (50%)
Dim Gray:       #FFFFFF (40%)
```

### State Colors
```
Error:          #FF0000 (Red)
Success:        #00FF00 (Green)
Warning:        #FFA500 (Orange)
```

## 📐 Layout Structure

```
┌─────────────────────────────────────────────────────┐
│  ┌───────────────────────────────────────────────┐ │
│  │  HEADER (Gradient Background)                 │ │
│  │  [←] ▌Create Meal                             │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  ┌───────────────────────────────────────────────┐ │
│  │  IMAGE UPLOAD SECTION (180px)                 │ │
│  │                                                │ │
│  │              📷 Add Meal Photo                 │ │
│  │                                                │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  Meal Name                                          │
│  ┌───────────────────────────────────────────────┐ │
│  │ 🍽️ Enter meal name                            │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  Category *                                         │
│  ┌───────────────────────────────────────────────┐ │
│  │ 📁 Select Categories                      ▼   │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  Description                                        │
│  ┌───────────────────────────────────────────────┐ │
│  │ 📝 Describe your meal                         │ │
│  │                                                │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  Ingredients                                        │
│  ┌───────────────────────────────────────────────┐ │
│  │ [Ingredient 1]                            ❌  │ │
│  └───────────────────────────────────────────────┘ │
│  ┌───────────────────────────────────────────────┐ │
│  │ ➕ Add Ingredient                              │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  ┌───────────────────────────────────────────────┐ │
│  │  Nutritional Information                      │ │
│  │  Auto Calculate ──────────────────── ⚪       │ │
│  │                                                │ │
│  │  ┌──────────────┐  ┌──────────────┐          │ │
│  │  │ 🔥 Calories  │  │ 🌾 Carbs (g) │          │ │
│  │  └──────────────┘  └──────────────┘          │ │
│  │  ┌──────────────┐  ┌──────────────┐          │ │
│  │  │ 💪 Protein   │  │ 💧 Fats (g)  │          │ │
│  │  └──────────────┘  └──────────────┘          │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  ┌───────────────────────────────────────────────┐ │
│  │         ✓ Create Meal                         │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## 🎭 Component Styles

### Header
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [#2A2A2A, #1A1A1A],
    ),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(25),
      bottomRight: Radius.circular(25),
    ),
    boxShadow: [
      BoxShadow(
        color: Black (30% opacity),
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  ),
)
```

### Image Upload
```dart
Container(
  height: 180,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [#2A2A2A (80%), #1A1A1A (80%)],
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: #C2D86A (30% opacity),
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: #C2D86A (10% opacity),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  ),
)
```

### Text Field
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [#2A2A2A, #1A1A1A],
    ),
    borderRadius: BorderRadius.circular(15),
    border: Border.all(
      color: #C2D86A (20% opacity),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Black (30% opacity),
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  ),
)
```

### Category Selector
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [#2A2A2A, #1A1A1A],
    ),
    borderRadius: BorderRadius.circular(15),
    border: Border.all(
      color: #C2D86A (20% opacity) or Red (error),
      width: 1 or 2 (error),
    ),
  ),
)
```

### Add Ingredient Button
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [#C2D86A (20%), #C2D86A (10%)],
    ),
    borderRadius: BorderRadius.circular(15),
    border: Border.all(
      color: #C2D86A (30% opacity),
      width: 2,
    ),
  ),
)
```

### Nutritional Info Card
```dart
Container(
  padding: EdgeInsets.all(20),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [#2A2A2A (80%), #1A1A1A (80%)],
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: #C2D86A (20% opacity),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Black (30% opacity),
        blurRadius: 15,
        offset: Offset(0, 8),
      ),
    ],
  ),
)
```

### Create Button
```dart
Container(
  width: double.infinity,
  height: 56,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [#C2D86A, #B8CC5A],
    ),
    borderRadius: BorderRadius.circular(28),
    boxShadow: [
      BoxShadow(
        color: #C2D86A (40% opacity),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  ),
)
```

## ✨ Animation Timeline

### Page Load (0-800ms)
```
0ms    → Start fade-in (opacity: 0)
0ms    → Start slide-up (offset: 0, 0.1)
800ms  → End animations (opacity: 1, offset: 0, 0)
```

### Image Upload (0-600ms)
```
0ms    → Start scale (scale: 0)
600ms  → End scale (scale: 1)
```

### Ingredients (Staggered)
```
Item 0: 0ms    → 300ms
Item 1: 100ms  → 400ms
Item 2: 200ms  → 500ms
Item 3: 300ms  → 600ms
...
```

### Category Selection (200ms)
```
0ms    → Start background transition
0ms    → Start border color transition
200ms  → End transitions
```

### Nutritional Info (300ms)
```
0ms    → Start height animation
300ms  → End height animation
```

## 🎯 Interactive States

### Text Field States
```
Normal:   Border: #C2D86A (20%)
Focused:  Border: #C2D86A (40%)
Error:    Border: Red (100%)
Disabled: Border: Gray (20%)
```

### Button States
```
Normal:   Gradient: #C2D86A → #B8CC5A
Pressed:  Ripple effect
Loading:  Show spinner
Disabled: Opacity: 50%
```

### Category States
```
Unselected: Background: Transparent
Selected:   Background: #C2D86A (20%)
            Text: #C2D86A
            Font Weight: 600
```

## 📏 Spacing System

### Vertical Spacing
```
Extra Small:  8px   (between related items)
Small:        12px  (between field label and input)
Medium:       16px  (between form sections)
Large:        20px  (between major sections)
Extra Large:  24px  (between section groups)
Huge:         30px  (before/after major elements)
```

### Horizontal Spacing
```
Tight:    8px   (icon to text)
Normal:   12px  (between grid items)
Loose:    16px  (between major elements)
Wide:     20px  (page margins)
```

### Padding
```
Compact:  12px  (small buttons)
Normal:   16px  (text fields)
Spacious: 20px  (cards, containers)
```

## 🔤 Typography

### Headers
```
Page Title:     24px, Bold, White, Letter Spacing: 0.5
Section Title:  16px, Semi-Bold, White, Letter Spacing: 0.3
```

### Body Text
```
Input Text:     16px, Normal, White
Placeholder:    14px, Normal, White (40%)
Label:          14px, Medium, White (70%)
Helper:         12px, Normal, White (50%)
```

### Buttons
```
Primary:        18px, Bold, Black, Letter Spacing: 0.5
Secondary:      16px, Semi-Bold, #C2D86A
```

## 🎨 Gradient Recipes

### Background Gradient
```dart
LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Colors.black,
    Color(0xFF1A1A1A),
    Colors.black,
  ],
  stops: [0.0, 0.3, 1.0],
)
```

### Card Gradient
```dart
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF2A2A2A),
    Color(0xFF1A1A1A),
  ],
)
```

### Button Gradient
```dart
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFC2D86A),
    Color(0xFFB8CC5A),
  ],
)
```

### Accent Gradient
```dart
LinearGradient(
  colors: [
    Color(0xFFC2D86A).withValues(alpha: 0.2),
    Color(0xFFC2D86A).withValues(alpha: 0.1),
  ],
)
```

## 🌟 Shadow Recipes

### Subtle Shadow
```dart
BoxShadow(
  color: Colors.black.withValues(alpha: 0.1),
  blurRadius: 10,
  offset: Offset(0, 5),
)
```

### Medium Shadow
```dart
BoxShadow(
  color: Colors.black.withValues(alpha: 0.3),
  blurRadius: 15,
  offset: Offset(0, 8),
)
```

### Strong Shadow
```dart
BoxShadow(
  color: Color(0xFFC2D86A).withValues(alpha: 0.4),
  blurRadius: 20,
  offset: Offset(0, 10),
)
```

## 🎬 Animation Curves

### Entrance Animations
```
Fade In:     Curves.easeInOut
Slide Up:    Curves.easeOutCubic
Scale In:    Curves.easeOut
```

### Exit Animations
```
Fade Out:    Curves.easeIn
Slide Down:  Curves.easeInCubic
Scale Out:   Curves.easeIn
```

### State Changes
```
Expand:      Curves.easeInOut
Collapse:    Curves.easeInOut
Color:       Curves.easeInOut
```

## 📱 Responsive Breakpoints

### Phone (Portrait)
```
Width:  < 600px
Layout: Single column
Spacing: Normal
```

### Phone (Landscape)
```
Width:  600px - 900px
Layout: Single column
Spacing: Compact
```

### Tablet
```
Width:  > 900px
Layout: Single column (centered)
Spacing: Spacious
Max Width: 600px
```

## ♿ Accessibility

### Touch Targets
```
Minimum:  44x44 px
Optimal:  48x48 px
Buttons:  56px height
```

### Contrast Ratios
```
Normal Text:  4.5:1 (WCAG AA)
Large Text:   3:1 (WCAG AA)
Icons:        3:1 (WCAG AA)
```

### Focus Indicators
```
Border:  2px solid #C2D86A
Offset:  2px
```

## 🎯 Best Practices

### Do's ✅
- Use gradient backgrounds
- Add subtle shadows
- Animate state changes
- Provide visual feedback
- Use consistent spacing
- Follow color palette
- Add loading states
- Handle errors gracefully

### Don'ts ❌
- Don't use flat colors
- Don't skip animations
- Don't ignore errors
- Don't use inconsistent spacing
- Don't forget loading states
- Don't use harsh shadows
- Don't overcomplicate layouts
- Don't ignore accessibility
