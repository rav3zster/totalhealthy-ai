# Design Specifications - Modern UI Update

## Component Specifications

### 1. Modern Header Component

```dart
Container(
  padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2A2A2A), Color(0xFF1F1F1F)],
    ),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(32),
      bottomRight: Radius.circular(32),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  ),
)
```

**Dimensions:**
- Padding: 20px horizontal, 16px top, 24px bottom
- Border radius: 32px (bottom corners only)
- Shadow: 20px blur, 10px offset

**Content:**
- Back button: 40x40px rounded container
- Title: 28px, Bold, -0.5 letter spacing
- Subtitle: 13-14px with accent color
- Info card: 12px padding, rounded corners

---

### 2. Enhanced Card Component

```dart
Container(
  margin: EdgeInsets.only(bottom: 16),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2A2A2A), Color(0xFF1F1F1F)],
    ),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: Color(0xFFC2D86A).withValues(alpha: 0.3),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0xFFC2D86A).withValues(alpha: 0.1),
        blurRadius: 20,
        offset: Offset(0, 8),
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.all(20),
    // Card content
  ),
)
```

**Dimensions:**
- Padding: 20px all sides
- Margin: 16px bottom
- Border radius: 24px
- Border: 1.5px width
- Shadow: 20px blur, 8px offset

**Icon Container:**
- Size: 68x68px
- Border radius: 18px
- Gradient background with glow
- Icon size: 36px

---

### 3. Staggered Animation

```dart
TweenAnimationBuilder<double>(
  duration: Duration(milliseconds: 300 + (index * 50)),
  tween: Tween(begin: 0.0, end: 1.0),
  builder: (context, value, child) {
    return Transform.translate(
      offset: Offset(0, 20 * (1 - value)),
      child: Opacity(
        opacity: value,
        child: child,
      ),
    );
  },
  child: // Your widget
)
```

**Timing:**
- Base duration: 300ms
- Stagger delay: 50ms per item
- Translation: 20px upward
- Opacity: 0 to 1

---

### 4. Empty State Component

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFC2D86A).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.category_outlined,
        size: 64,
        color: Color(0xFFC2D86A),
      ),
    ),
    SizedBox(height: 24),
    Text(
      'No Categories Yet',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(height: 8),
    Text(
      'Create your first category\nto get started',
      style: TextStyle(
        color: Colors.white54,
        fontSize: 15,
      ),
      textAlign: TextAlign.center,
    ),
    SizedBox(height: 32),
    ElevatedButton.icon(
      // CTA button
    ),
  ],
)
```

**Dimensions:**
- Icon container: 112x112px (64px icon + 24px padding)
- Spacing: 24px, 8px, 32px
- Button padding: 32px horizontal, 16px vertical

---

### 5. Info Card Component

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  decoration: BoxDecoration(
    color: Color(0xFFC2D86A).withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Color(0xFFC2D86A).withValues(alpha: 0.2),
    ),
  ),
  child: Row(
    children: [
      Icon(
        Icons.info_outline,
        color: Color(0xFFC2D86A).withValues(alpha: 0.8),
        size: 18,
      ),
      SizedBox(width: 12),
      Expanded(
        child: Text(
          'Helpful information text',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ),
    ],
  ),
)
```

**Dimensions:**
- Padding: 16px horizontal, 12px vertical
- Border radius: 12px
- Icon size: 18px
- Gap: 12px

---

### 6. Badge Component

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFFC2D86A).withValues(alpha: 0.3),
        Color(0xFFC2D86A).withValues(alpha: 0.2),
      ],
    ),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: Color(0xFFC2D86A).withValues(alpha: 0.5),
    ),
  ),
  child: Text(
    'Default',
    style: TextStyle(
      color: Color(0xFFC2D86A),
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  ),
)
```

**Dimensions:**
- Padding: 10px horizontal, 5px vertical
- Border radius: 8px
- Font size: 11px
- Letter spacing: 0.5px

---

### 7. Action Button Component

```dart
Container(
  padding: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Color(0xFFC2D86A).withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Icon(
    Icons.arrow_forward_ios_rounded,
    color: Color(0xFFC2D86A),
    size: 16,
  ),
)
```

**Dimensions:**
- Padding: 8px all sides
- Border radius: 10px
- Icon size: 16px
- Total size: ~32x32px

---

### 8. Floating Action Button

```dart
FloatingActionButton.extended(
  onPressed: () {},
  backgroundColor: Color(0xFFC2D86A),
  elevation: 8,
  icon: Icon(Icons.add_rounded, color: Colors.black, size: 24),
  label: Text(
    'Add Category',
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    ),
  ),
)
```

**Dimensions:**
- Elevation: 8px
- Icon size: 24px
- Font size: 15px
- Padding: Default extended FAB padding

---

## Color System

### Primary Palette:
```dart
// Accent
const accentGreen = Color(0xFFC2D86A);

// Backgrounds
const backgroundBlack = Color(0xFF000000);
const cardDark1 = Color(0xFF2A2A2A);
const cardDark2 = Color(0xFF1F1F1F);
const headerDark = Color(0xFF1A1A1A);

// Text
const textWhite = Color(0xFFFFFFFF);
const textSecondary = Color(0xFFFFFFFF); // @ 54-70% opacity
const textTertiary = Color(0xFFFFFFFF); // @ 38% opacity

// States
const errorRed = Colors.red;
const successGreen = accentGreen;
```

### Opacity Scale:
- **10%:** Subtle backgrounds
- **15%:** Light backgrounds
- **20%:** Borders, light accents
- **30%:** Medium accents, glows
- **38%:** Tertiary text, disabled states
- **54%:** Secondary text
- **70%:** Body text
- **80%:** Accent text
- **100%:** Primary text, icons

---

## Spacing Scale

```dart
// Spacing constants
const space4 = 4.0;
const space8 = 8.0;
const space12 = 12.0;
const space16 = 16.0;
const space20 = 20.0;
const space24 = 24.0;
const space32 = 32.0;

// Usage
const smallGap = space8;
const mediumGap = space16;
const largeGap = space24;
const xlargeGap = space32;
```

---

## Border Radius Scale

```dart
// Radius constants
const radius8 = 8.0;
const radius10 = 10.0;
const radius12 = 12.0;
const radius16 = 16.0;
const radius18 = 18.0;
const radius20 = 20.0;
const radius24 = 24.0;
const radius32 = 32.0;

// Usage
const smallRadius = radius8;   // Badges
const mediumRadius = radius12;  // Inputs
const largeRadius = radius20;   // Cards
const xlargeRadius = radius32;  // Headers
```

---

## Typography Scale

```dart
// Font sizes
const fontSize11 = 11.0;  // Badge text
const fontSize12 = 12.0;  // Small labels
const fontSize13 = 13.0;  // Info text
const fontSize14 = 14.0;  // Body text
const fontSize15 = 15.0;  // Buttons
const fontSize16 = 16.0;  // Standard text
const fontSize18 = 18.0;  // Subheadings
const fontSize20 = 20.0;  // Card titles
const fontSize24 = 24.0;  // Section titles
const fontSize28 = 28.0;  // Screen titles

// Font weights
const fontRegular = FontWeight.w400;
const fontMedium = FontWeight.w500;
const fontSemiBold = FontWeight.w600;
const fontBold = FontWeight.w700;

// Letter spacing
const letterSpacingTight = -0.5;
const letterSpacingNormal = 0.0;
const letterSpacingWide = 0.5;
```

---

## Animation Timing

```dart
// Duration constants
const duration100 = Duration(milliseconds: 100);
const duration200 = Duration(milliseconds: 200);
const duration300 = Duration(milliseconds: 300);
const duration400 = Duration(milliseconds: 400);

// Curves
const curveStandard = Curves.easeInOut;
const curveEmphasized = Curves.easeOutCubic;
const curveDecelerate = Curves.decelerate;

// Stagger delay
const staggerDelay = Duration(milliseconds: 50);
```

---

## Shadow Presets

```dart
// Subtle shadow
BoxShadow(
  color: Colors.black.withValues(alpha: 0.1),
  blurRadius: 10,
  offset: Offset(0, 4),
)

// Medium shadow
BoxShadow(
  color: Colors.black.withValues(alpha: 0.3),
  blurRadius: 20,
  offset: Offset(0, 10),
)

// Glow effect
BoxShadow(
  color: Color(0xFFC2D86A).withValues(alpha: 0.3),
  blurRadius: 12,
  spreadRadius: 0,
)

// Card shadow
BoxShadow(
  color: Color(0xFFC2D86A).withValues(alpha: 0.1),
  blurRadius: 20,
  offset: Offset(0, 8),
)
```

---

## Gradient Presets

```dart
// Card gradient
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF2A2A2A), Color(0xFF1F1F1F)],
)

// Background gradient
LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF1A1A1A), Colors.black, Colors.black],
  stops: [0.0, 0.3, 1.0],
)

// Icon container gradient
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFC2D86A).withValues(alpha: 0.3),
    Color(0xFFC2D86A).withValues(alpha: 0.15),
  ],
)

// Badge gradient
LinearGradient(
  colors: [
    Color(0xFFC2D86A).withValues(alpha: 0.3),
    Color(0xFFC2D86A).withValues(alpha: 0.2),
  ],
)
```

---

## Implementation Checklist

### For New Screens:
- [ ] Use modern header component
- [ ] Apply staggered animations to lists
- [ ] Implement enhanced card design
- [ ] Add empty state with CTA
- [ ] Use consistent spacing scale
- [ ] Apply shadow system
- [ ] Use gradient presets
- [ ] Add info cards where helpful
- [ ] Implement conditional FAB
- [ ] Test on multiple screen sizes

### Quality Checks:
- [ ] All animations run at 60fps
- [ ] Touch targets are 44x44px minimum
- [ ] Contrast ratios meet AA standards
- [ ] Typography is consistent
- [ ] Spacing follows scale
- [ ] Colors match palette
- [ ] Shadows are subtle
- [ ] Gradients are smooth

---

## Design Tokens (For Future Theme System)

```dart
class AppDesignTokens {
  // Colors
  static const accentPrimary = Color(0xFFC2D86A);
  static const backgroundPrimary = Color(0xFF000000);
  static const surfacePrimary = Color(0xFF2A2A2A);
  
  // Spacing
  static const spacingXs = 4.0;
  static const spacingSm = 8.0;
  static const spacingMd = 16.0;
  static const spacingLg = 24.0;
  static const spacingXl = 32.0;
  
  // Radius
  static const radiusSm = 8.0;
  static const radiusMd = 12.0;
  static const radiusLg = 20.0;
  static const radiusXl = 32.0;
  
  // Typography
  static const fontSizeXs = 11.0;
  static const fontSizeSm = 13.0;
  static const fontSizeMd = 15.0;
  static const fontSizeLg = 20.0;
  static const fontSizeXl = 28.0;
}
```

This design system ensures consistency across all screens and makes future updates easier.
