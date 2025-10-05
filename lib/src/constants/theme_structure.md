# Theme Structure

This document explains the theme structure for the Wasla Academy app.

## Files

1. [app_theme.dart](file:///F:/New%20folder/waslaacademy/lib/src/constants/app_theme.dart) - Contains the complete theme definition
2. [app_colors.dart](file:///F:/New%20folder/waslaacademy/lib/src/constants/app_colors.dart) - Contains color constants that complement the theme

## Theme Features

### Light Theme ([AppTheme.lightTheme](file:///F:/New%20folder/waslaacademy/lib/src/constants/app_theme.dart#L59-L135))
- Primary color: Dark blue (#0D1B3D)
- Background: Light gray (#F9FAFB)
- Surface: White (#FFFFFF)
- Cards: Light gray (#F3F4F6)
- Gold accent for buttons (#F5C542)

### Dark Theme ([AppTheme.darkTheme](file:///F:/New%20folder/waslaacademy/lib/src/constants/app_theme.dart#L137-L196))
- Background: Dark blue (#0D1B3D)
- Surface: Dark gray (#1F2937)
- Cards: Slightly lighter dark gray (#2D3748)
- Text: Light colors for readability

### Component Styles
- Custom AppBar themes for both light and dark modes
- ElevatedButton, OutlinedButton, and TextButton themes
- Custom input decoration theme with rounded borders
- Consistent border radius (12px) across components

## Integration

The theme is integrated in [main.dart](file:///F:/New%20folder/waslaacademy/lib/main.dart) through:
```dart
theme: AppTheme.lightTheme,
darkTheme: AppTheme.darkTheme,
```

## Usage in Components

To use the theme in your widgets:
```dart
// Access theme colors
final theme = Theme.of(context);
final primaryColor = theme.colorScheme.primary;

// Use predefined text styles
Text('Hello', style: AppTheme.headlineStyle);

// Use theme-aware components
ElevatedButton(
  onPressed: () {},
  child: Text('Click Me'),
)
```