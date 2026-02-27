# Light Theme Color Reference

## Analysis from Reference Image

This document details the professional color palette extracted from the reference image and applied throughout the app's light theme.

## Color Palette

### Background Colors
- **Main Background**: `#FAFBFC` - Very light gray, almost white
- **Card Background**: `#FFFFFF` - Pure white for cards
- **Secondary Card**: `#F5F6F7` - Light gray for secondary elements
- **Search Bar**: `#F1F3F5` - Subtle gray for input fields

### Text Colors
- **Primary Text**: `#1A1D1F` - Very dark gray/black for headings and important text
- **Secondary Text**: `#6C757D` - Medium gray for labels and descriptions
- **Tertiary Text**: `#ADB5BD` - Light gray for hints and serving sizes

### Accent & Action Colors
- **Primary Accent**: `#C2FF00` - Bright lime/chartreuse green (buttons, active states)
- **Success Green**: `#10B981` - For positive indicators (weight gain, goals achieved)
- **Error Red**: `#EF4444` - For negative indicators (weight loss warnings)

### UI Element Colors
- **Border**: `#E9ECEF` - Very subtle borders for cards
- **Divider**: `#DEE2E6` - Slightly darker for dividers
- **Shadow**: `rgba(0, 0, 0, 0.04)` - Very subtle shadow with 4% opacity

## Design Principles

### 1. Contrast & Readability
- Light theme uses very dark text (#1A1D1F) on light backgrounds for maximum readability
- Secondary text (#6C757D) provides hierarchy without being too light
- Tertiary text (#ADB5BD) for non-essential information

### 2. Card Differentiation
- **User Cards**: Pure white (#FFFFFF) with subtle shadows
- **Background**: Slightly off-white (#FAFBFC) to create depth
- **Secondary Cards**: Light gray (#F5F6F7) for nested or less important content

### 3. Accent Usage
- **Bright Lime Green (#C2FF00)**: Used sparingly for:
  - Primary action buttons
  - Active navigation items
  - Selected category tabs
  - Progress indicators
  - Important highlights

### 4. Shadows & Depth
- **Card Shadow**: `0px 2px 8px rgba(0, 0, 0, 0.04)`
  - Very subtle, only 4% opacity
  - Small blur radius (8px)
  - Minimal offset (2px)
  - Creates gentle elevation without being heavy

### 5. Borders
- **Light borders (#E9ECEF)**: Used to define card boundaries
- **Invisible in dark theme**: Replaced with accent color glow
- **1px width**: Keeps lines crisp and clean

## Component-Specific Colors

### Dashboard
- **Background**: Gradient from #FAFBFC → #F8F9FA → #FAFBFC
- **Header**: White (#FFFFFF) with subtle shadow
- **Meal Cards**: White with #E9ECEF border
- **Stats Cards**: White background, colored text for metrics
- **Weekly Planner Button**: Bright lime green (#C2FF00) with black text

### Navigation Bar
- **Background**: White (#FFFFFF)
- **Border Top**: #E9ECEF
- **Active Icon**: Bright lime green (#C2FF00)
- **Inactive Icon**: Medium gray (#6C757D)

### Search Bar
- **Background**: #F1F3F5 (light gray)
- **Placeholder Text**: #ADB5BD (tertiary text)
- **Input Text**: #1A1D1F (primary text)
- **Icon**: #6C757D (secondary text)

### Category Tabs
- **Unselected**: 
  - Background: Transparent
  - Border: #E9ECEF
  - Text: #6C757D
- **Selected**:
  - Background: Gradient from #C2FF00 (30% opacity) to #C2FF00 (10% opacity)
  - Border: #C2FF00
  - Text: #1A1D1F
  - Shadow: #C2FF00 (30% opacity)

### Meal Cards
- **Background**: White (#FFFFFF)
- **Border**: #E9ECEF
- **Shadow**: rgba(0, 0, 0, 0.04)
- **Meal Name**: #1A1D1F (primary text, 24px, bold)
- **Tags (ORGANIC • FRESH)**: #ADB5BD (tertiary text, 11px, uppercase)
- **Macros Labels**: Colored backgrounds with matching text
  - Protein: Green background (#1A3A2A) with green text (#4CAF50)
  - Fat: Blue background (#1A2A3A) with blue text (#2196F3)
  - Carbs: Red background (#3A1A1A) with red text (#E53935)
- **Calories Badge**: Orange background (#3A2F1A) with orange text (#FFB800)
- **Weight Badge**: Light gray background (#F5F6F7) with dark text (#1A1D1F)

### Settings Screens
- **Background**: Gradient #FAFBFC → #F8F9FA
- **Header**: White with subtle shadow
- **Setting Cards**: White with #E9ECEF border
- **Card Text**: #1A1D1F
- **Arrow Icons**: #6C757D

### Buttons
- **Primary Button**:
  - Background: #C2FF00 (bright lime green)
  - Text: #000000 (black for contrast)
  - No shadow in light theme
  
- **Secondary Button**:
  - Background: White
  - Border: #E9ECEF
  - Text: #1A1D1F

### Dialogs & Modals
- **Background**: White (#FFFFFF)
- **Title**: #1A1D1F (primary text)
- **Body Text**: #6C757D (secondary text)
- **Buttons**: Follow button styles above

## Dark Theme Comparison

### Key Differences
| Element | Light Theme | Dark Theme |
|---------|-------------|------------|
| Background | #FAFBFC | #000000 |
| Cards | #FFFFFF | #1C1C1E |
| Primary Text | #1A1D1F | #FFFFFF |
| Secondary Text | #6C757D | #B0B0B0 |
| Borders | #E9ECEF | Accent glow |
| Shadow Opacity | 4% | 30% |
| Accent | #C2FF00 | #C2FF00 (same) |

### Consistent Elements
- **Accent Color**: Bright lime green (#C2FF00) in both themes
- **Success/Error Colors**: Same in both themes
- **Macro Colors**: Same colored backgrounds in both themes

## Implementation Notes

### Gradients
```dart
// Light theme background gradient
LinearGradient(
  colors: [Color(0xFFFAFBFC), Color(0xFFF8F9FA), Color(0xFFFAFBFC)],
  stops: [0.0, 0.5, 1.0],
)

// Light theme card gradient
LinearGradient(
  colors: [Color(0xFFFFFFFF), Color(0xFFFAFBFC)],
)
```

### Shadows
```dart
// Light theme card shadow
BoxShadow(
  color: Colors.black.withValues(alpha: 0.04),
  blurRadius: 8,
  offset: Offset(0, 2),
  spreadRadius: 0,
)
```

### Context Extensions
```dart
// Usage in widgets
context.backgroundColor  // #FAFBFC
context.cardColor        // #FFFFFF
context.textPrimary      // #1A1D1F
context.textSecondary    // #6C757D
context.textTertiary     // #ADB5BD
context.accentColor      // #C2FF00
context.borderColor      // #E9ECEF
context.searchBarColor   // #F1F3F5
```

## Accessibility

### Contrast Ratios
- **Primary Text on White**: 16.1:1 (AAA)
- **Secondary Text on White**: 4.7:1 (AA)
- **Tertiary Text on White**: 3.2:1 (AA Large)
- **Accent on White**: 1.4:1 (Use with dark text overlay)

### Best Practices
- Always use black text (#000000) on accent color (#C2FF00)
- Use primary text (#1A1D1F) for all important content
- Reserve tertiary text (#ADB5BD) for non-essential information only
- Maintain minimum 3:1 contrast for all interactive elements

## Testing Checklist

- [ ] All screens render correctly in light theme
- [ ] Text is readable on all backgrounds
- [ ] Cards have visible but subtle borders
- [ ] Shadows are present but not overwhelming
- [ ] Accent color stands out appropriately
- [ ] Navigation states are clear
- [ ] Search bar is distinguishable from background
- [ ] Meal cards have proper hierarchy
- [ ] Stats are easy to read
- [ ] Buttons have sufficient contrast
- [ ] Theme switching is instant and smooth
- [ ] No flickering during theme change
- [ ] All screens maintain consistent color usage
