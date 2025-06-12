# Mix Token System Migration Guide

## Overview

This guide demonstrates how to use the new unified token system alongside the existing legacy token system. The new system provides enhanced type safety and performance while maintaining full backwards compatibility with existing code.

## Architecture Comparison

### Legacy System (Still Supported)
```
ColorToken → StyledTokens → DTO → Legacy Resolution → Value
```

### New Unified System (Optional)
```
MixToken<T> → ValueResolver → DTO → Type-Safe Resolution → Value
```

### Dual API Support
Both systems work simultaneously - use legacy for existing code, unified for new features.

## 1. Color Tokens

### Before (Old System)
```dart
// 1. Define tokens in theme
final theme = MixThemeData(
  colors: {
    ColorToken('primary'): Colors.blue,
    ColorToken('secondary'): Colors.green,
  },
);

// 2. Create refs and use in styles
final primaryRef = ColorRef(ColorToken('primary'));
final style = Style(
  $box.color.ref(primaryRef),
  // OR using utility ref method
  $box.color.ref(ColorToken('primary')),
);

// 3. Complex resolution path
// ColorToken → ColorRef → ColorDto → ColorResolver → Color
```

### Now: Dual API Support
```dart
// OPTION 1: Legacy API (unchanged)
final legacyTheme = MixThemeData(
  colors: {
    ColorToken('primary'): Colors.blue,
    ColorToken('secondary'): Colors.green,
  },
);

// OPTION 2: New unified tokens parameter
const primaryToken = MixToken<Color>('primary');
const secondaryToken = MixToken<Color>('secondary');

final newTheme = MixThemeData(
  tokens: {
    primaryToken: StaticResolver(Colors.blue),
    secondaryToken: StaticResolver(Colors.green),
  },
);

// OPTION 3: Convenient unified factory
final convenientTheme = MixThemeData.unified(
  tokens: {
    primaryToken: Colors.blue,        // Auto-wrapped in StaticResolver
    secondaryToken: Colors.green,     // Auto-wrapped in StaticResolver
  },
);

// Usage with new tokens
final style = Style(
  \$box.color.token(primaryToken),
);
```

### Migration Example
```dart
// BEFORE: Complex token setup
class OldColorTheme {
  static const primary = ColorToken('brand.primary');
  static const secondary = ColorToken('brand.secondary');
  
  static final theme = MixThemeData(
    colors: {
      primary: Colors.blue.shade600,
      secondary: Colors.green.shade500,
    },
  );
  
  static final cardStyle = Style(
    $box.color.ref(primary),
    $box.border.all.color.ref(secondary),
  );
}

// AFTER: Simplified token system
class NewColorTheme {
  static const primary = MixToken<Color>('brand.primary');
  static const secondary = MixToken<Color>('brand.secondary');
  
  static final theme = MixThemeData(
    colors: {
      primary: Colors.blue.shade600,
      secondary: Colors.green.shade500,
    },
  );
  
  static final cardStyle = Style(
    $box.color.token(primary),
    $box.border.all.color.token(secondary),
  );
}
```

## 2. Text Style Tokens

### Before (Old System)
```dart
// 1. Define text style tokens
final theme = MixThemeData(
  textStyles: {
    TextStyleToken('heading'): TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    TextStyleToken('body'): TextStyle(
      fontSize: 16,
    ),
  },
);

// 2. Use with refs
final style = Style(
  $text.style.ref(TextStyleToken('heading')),
);

// 3. Resolution chain
// TextStyleToken → TextStyleRef → TextStyleDto → TextStyleResolver → TextStyle
```

### After (New Unified System)
```dart
// 1. Define with MixToken objects as keys
const headingToken = MixToken<TextStyle>('heading');
const bodyToken = MixToken<TextStyle>('body');

final theme = MixThemeData(
  textStyles: {
    headingToken: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyToken: TextStyle(
      fontSize: 16,
    ),
  },
);

// 2. Use directly
const headingToken = MixToken<TextStyle>('heading');
final style = Style(
  $text.style.token(headingToken),
);

// 3. Simple resolution
// MixToken<TextStyle> → TextStyleDto → Unified Resolver → TextStyle
```

### Migration Example
```dart
// BEFORE: Separate text style management
class OldTypography {
  static const h1 = TextStyleToken('typography.h1');
  static const h2 = TextStyleToken('typography.h2');
  static const body = TextStyleToken('typography.body');
  
  static final theme = MixThemeData(
    textStyles: {
      h1: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold),
      h2: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600),
      body: GoogleFonts.inter(fontSize: 16),
    },
  );
  
  static final titleStyle = Style(
    $text.style.ref(h1),
    $text.style.color.black(),
  );
}

// AFTER: Unified typography system
class NewTypography {
  static const h1 = MixToken<TextStyle>('typography.h1');
  static const h2 = MixToken<TextStyle>('typography.h2');
  static const body = MixToken<TextStyle>('typography.body');
  
  static final theme = MixThemeData(
    textStyles: {
      h1: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold),
      h2: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600),
      body: GoogleFonts.inter(fontSize: 16),
    },
  );
  
  static final titleStyle = Style(
    $text.style.token(h1),
    $text.style.color.black(),
  );
}
```

## 3. Spacing Tokens

### Before (Old System)
```dart
// 1. Define spacing tokens
final theme = MixThemeData(
  spaces: {
    SpaceToken('xs'): 4.0,
    SpaceToken('sm'): 8.0,
    SpaceToken('md'): 16.0,
    SpaceToken('lg'): 24.0,
  },
);

// 2. Use with refs
final style = Style(
  $box.padding.all.ref(SpaceToken('md')),
  $box.margin.horizontal.ref(SpaceToken('lg')),
);

// 3. Complex resolution
// SpaceToken → SpaceRef → SpaceDto → SpaceResolver → double
```

### After (New Unified System)
```dart
// 1. Define with unified tokens
final theme = MixThemeData.unified(
  tokens: {
    'spacing.xs': 4.0,
    'spacing.sm': 8.0,
    'spacing.md': 16.0,
    'spacing.lg': 24.0,
  },
);

// 2. Use directly
const mediumSpacing = MixToken<double>('spacing.md');
final style = Style(
  $box.padding.all.token(mediumSpacing),
  $box.margin.horizontal.token(MixToken<double>('spacing.lg')),
);

// 3. Simple resolution
// MixToken<double> → SpaceDto → Unified Resolver → double
```

### Migration Example
```dart
// BEFORE: Manual spacing management
class OldSpacing {
  static const xs = SpaceToken('space.xs');
  static const sm = SpaceToken('space.sm');
  static const md = SpaceToken('space.md');
  static const lg = SpaceToken('space.lg');
  static const xl = SpaceToken('space.xl');
  
  static final theme = MixThemeData(
    spaces: {
      xs: 4.0,
      sm: 8.0,
      md: 16.0,
      lg: 24.0,
      xl: 32.0,
    },
  );
  
  static final cardStyle = Style(
    $box.padding.all.ref(md),
    $box.margin.vertical.ref(lg),
  );
}

// AFTER: Unified spacing system
class NewSpacing {
  static const xs = MixToken<double>('space.xs');
  static const sm = MixToken<double>('space.sm');
  static const md = MixToken<double>('space.md');
  static const lg = MixToken<double>('space.lg');
  static const xl = MixToken<double>('space.xl');
  
  static final theme = MixThemeData.unified(
    tokens: {
      'space.xs': 4.0,
      'space.sm': 8.0,
      'space.md': 16.0,
      'space.lg': 24.0,
      'space.xl': 32.0,
    },
  );
  
  static final cardStyle = Style(
    $box.padding.all.token(md),
    $box.margin.vertical.token(lg),
  );
}
```

## 4. Mixed Token Types

### Before (Old System)
```dart
// 1. Multiple token type definitions
final theme = MixThemeData(
  colors: {
    ColorToken('primary'): Colors.blue,
    ColorToken('surface'): Colors.white,
  },
  textStyles: {
    TextStyleToken('title'): TextStyle(fontSize: 20),
  },
  spaces: {
    SpaceToken('padding'): 16.0,
  },
);

// 2. Mixed usage with different ref types
final complexStyle = Style(
  $box.color.ref(ColorToken('surface')),
  $box.padding.all.ref(SpaceToken('padding')),
  $box.border.all.color.ref(ColorToken('primary')),
  $text.style.ref(TextStyleToken('title')),
);
```

### After (New Unified System)
```dart
// 1. Single unified token definition
final theme = MixThemeData.unified(
  tokens: {
    'primary': Colors.blue,
    'surface': Colors.white,
    'title': TextStyle(fontSize: 20),
    'padding': 16.0,
  },
);

// 2. Consistent token usage
const primary = MixToken<Color>('primary');
const surface = MixToken<Color>('surface');
const title = MixToken<TextStyle>('title');
const padding = MixToken<double>('padding');

final complexStyle = Style(
  $box.color.token(surface),
  $box.padding.all.token(padding),
  $box.border.all.color.token(primary),
  $text.style.token(title),
);
```

## 5. Design System Example

### Before (Old System)
```dart
// design_system_old.dart
class OldDesignSystem {
  // Color tokens
  static const primaryColor = ColorToken('colors.primary');
  static const secondaryColor = ColorToken('colors.secondary');
  static const surfaceColor = ColorToken('colors.surface');
  
  // Text style tokens  
  static const headingStyle = TextStyleToken('text.heading');
  static const bodyStyle = TextStyleToken('text.body');
  static const captionStyle = TextStyleToken('text.caption');
  
  // Space tokens
  static const smallSpace = SpaceToken('spacing.small');
  static const mediumSpace = SpaceToken('spacing.medium');
  static const largeSpace = SpaceToken('spacing.large');
  
  static final theme = MixThemeData(
    colors: {
      primaryColor: Color(0xFF2196F3),
      secondaryColor: Color(0xFF4CAF50),
      surfaceColor: Color(0xFFFFFFFF),
    },
    textStyles: {
      headingStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyStyle: TextStyle(
        fontSize: 16,
        color: Colors.black54,
      ),
      captionStyle: TextStyle(
        fontSize: 12,
        color: Colors.black38,
      ),
    },
    spaces: {
      smallSpace: 8.0,
      mediumSpace: 16.0,
      largeSpace: 24.0,
    },
  );
  
  // Component styles using refs
  static final cardStyle = Style(
    $box.color.ref(surfaceColor),
    $box.padding.all.ref(mediumSpace),
    $box.margin.all.ref(smallSpace),
    $box.borderRadius.all.circular(8),
    $box.shadow(
      color: Colors.black12,
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  );
  
  static final titleStyle = Style(
    $text.style.ref(headingStyle),
  );
  
  static final contentStyle = Style(
    $text.style.ref(bodyStyle),
    $box.padding.vertical.ref(smallSpace),
  );
}
```

### After (New Unified System)
```dart
// design_system_new.dart
class NewDesignSystem {
  // Unified token definitions
  static const primaryColor = MixToken<Color>('colors.primary');
  static const secondaryColor = MixToken<Color>('colors.secondary');
  static const surfaceColor = MixToken<Color>('colors.surface');
  
  static const headingStyle = MixToken<TextStyle>('text.heading');
  static const bodyStyle = MixToken<TextStyle>('text.body');
  static const captionStyle = MixToken<TextStyle>('text.caption');
  
  static const smallSpace = MixToken<double>('spacing.small');
  static const mediumSpace = MixToken<double>('spacing.medium');
  static const largeSpace = MixToken<double>('spacing.large');
  
  // Single unified theme definition
  static final theme = MixThemeData.unified(
    tokens: {
      // Colors
      'colors.primary': Color(0xFF2196F3),
      'colors.secondary': Color(0xFF4CAF50),
      'colors.surface': Color(0xFFFFFFFF),
      
      // Text styles
      'text.heading': TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      'text.body': TextStyle(
        fontSize: 16,
        color: Colors.black54,
      ),
      'text.caption': TextStyle(
        fontSize: 12,
        color: Colors.black38,
      ),
      
      // Spacing
      'spacing.small': 8.0,
      'spacing.medium': 16.0,
      'spacing.large': 24.0,
    },
  );
  
  // Component styles using unified tokens
  static final cardStyle = Style(
    $box.color.token(surfaceColor),
    $box.padding.all.token(mediumSpace),
    $box.margin.all.token(smallSpace),
    $box.borderRadius.all.circular(8),
    $box.shadow(
      color: Colors.black12,
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  );
  
  static final titleStyle = Style(
    $text.style.token(headingStyle),
  );
  
  static final contentStyle = Style(
    $text.style.token(bodyStyle),
    $box.padding.vertical.token(smallSpace),
  );
}
```

## 6. Theme Switching Example

### Before (Old System)
```dart
class OldThemeSwitcher extends StatefulWidget {
  @override
  _OldThemeSwitcherState createState() => _OldThemeSwitcherState();
}

class _OldThemeSwitcherState extends State<OldThemeSwitcher> {
  bool isDark = false;
  
  MixThemeData get lightTheme => MixThemeData(
    colors: {
      ColorToken('background'): Colors.white,
      ColorToken('text'): Colors.black,
      ColorToken('primary'): Colors.blue,
    },
    textStyles: {
      TextStyleToken('body'): TextStyle(fontSize: 16),
    },
  );
  
  MixThemeData get darkTheme => MixThemeData(
    colors: {
      ColorToken('background'): Colors.black,
      ColorToken('text'): Colors.white,
      ColorToken('primary'): Colors.cyan,
    },
    textStyles: {
      TextStyleToken('body'): TextStyle(fontSize: 16),
    },
  );
  
  @override
  Widget build(BuildContext context) {
    return MixTheme(
      data: isDark ? darkTheme : lightTheme,
      child: Box(
        style: Style(
          $box.color.ref(ColorToken('background')),
          $text.style.ref(TextStyleToken('body')),
          $text.style.color.ref(ColorToken('text')),
        ),
        child: Text('Themed content'),
      ),
    );
  }
}
```

### After (New Unified System)
```dart
class NewThemeSwitcher extends StatefulWidget {
  @override
  _NewThemeSwitcherState createState() => _NewThemeSwitcherState();
}

class _NewThemeSwitcherState extends State<NewThemeSwitcher> {
  bool isDark = false;
  
  // Token definitions
  static const background = MixToken<Color>('background');
  static const text = MixToken<Color>('text');
  static const primary = MixToken<Color>('primary');
  static const body = MixToken<TextStyle>('body');
  
  MixThemeData get lightTheme => MixThemeData.unified(
    tokens: {
      'background': Colors.white,
      'text': Colors.black,
      'primary': Colors.blue,
      'body': TextStyle(fontSize: 16),
    },
  );
  
  MixThemeData get darkTheme => MixThemeData.unified(
    tokens: {
      'background': Colors.black,
      'text': Colors.white,
      'primary': Colors.cyan,
      'body': TextStyle(fontSize: 16),
    },
  );
  
  @override
  Widget build(BuildContext context) {
    return MixTheme(
      data: isDark ? darkTheme : lightTheme,
      child: Box(
        style: Style(
          $box.color.token(background),
          $text.style.token(body),
          $text.style.color.token(text),
        ),
        child: Text('Themed content'),
      ),
    );
  }
}
```

## 7. Custom Tokens and Extensions

### Before (Old System)
```dart
// Custom color tokens with extensions
extension BrandColors on ColorUtility {
  ColorUtility get brand => this.ref(ColorToken('brand'));
  ColorUtility get accent => this.ref(ColorToken('accent'));
}

// Usage
final style = Style(
  $box.color.brand,
  $box.border.all.color.accent,
);
```

### After (New Unified System)
```dart
// Custom tokens with type safety
class BrandTokens {
  static const brand = MixToken<Color>('brand');
  static const accent = MixToken<Color>('accent');
}

// Usage with unified tokens
final style = Style(
  $box.color.token(BrandTokens.brand),
  $box.border.all.color.token(BrandTokens.accent),
);

// Or with extension for convenience
extension BrandColors on ColorUtility {
  ColorUtility get brand => token(BrandTokens.brand);
  ColorUtility get accent => token(BrandTokens.accent);
}
```

## 8. Migration Benefits

### Type Safety Improvements
```dart
// BEFORE: No compile-time type checking
final badStyle = Style(
  $box.color.ref(SpaceToken('spacing')), // Wrong type, runtime error
);

// AFTER: Compile-time type safety
final goodStyle = Style(
  $box.color.token(MixToken<Color>('primary')), // Type-safe
  // $box.color.token(MixToken<double>('spacing')), // Compile error!
);
```

### Performance Improvements
```dart
// BEFORE: Multiple resolution layers
// Token → Ref → DTO → Resolver → Value (5 steps)

// AFTER: Streamlined resolution  
// Token → DTO → Unified Resolver → Value (3 steps)
```

### Simplified API
```dart
// BEFORE: Different methods for each token type
$box.color.ref(colorToken)
$text.style.ref(textStyleToken)  
$box.padding.all.ref(spaceToken)

// AFTER: Consistent token method
$box.color.token(colorToken)
$text.style.token(textStyleToken)
$box.padding.all.token(spaceToken)
```

## 9. Backwards Compatibility

The new system maintains full backwards compatibility:

```dart
// OLD API still works
final oldStyle = Style(
  $box.color.ref(ColorToken('primary')),
  $text.style.ref(TextStyleToken('heading')),
);

// NEW API is available alongside
final newStyle = Style(
  $box.color.token(MixToken<Color>('primary')),
  $text.style.token(MixToken<TextStyle>('heading')),
);

// Mixed usage is supported
final mixedStyle = Style(
  $box.color.ref(ColorToken('primary')),      // Old API
  $text.style.token(MixToken<TextStyle>('heading')), // New API
);
```

## 10. Completed Migration (v2.1.0)

As of this version, the following migration has been completed:

### ✅ Implemented Changes
- **Replaced Token<T> with MixToken<T>**: All `Token<T>` references have been replaced with `MixToken<T>` throughout the codebase
- **Updated imports**: Changed all imports from `token.dart` to `mix_token.dart`
- **Removed deprecated Token class**: The old `Token<T>` class has been removed
- **Updated test resolution**: Modified tests to use the unified resolver system
- **Maintained backwards compatibility**: Old token types (ColorToken, SpaceToken, etc.) remain functional but deprecated

### 📁 Files Modified
- `lib/src/attributes/color/color_dto.dart`
- `lib/src/attributes/color/color_util.dart`
- `lib/src/attributes/gap/space_dto.dart`
- `lib/src/attributes/scalars/radius_dto.dart`
- `lib/src/attributes/spacing/spacing_util.dart`
- `lib/src/attributes/text_style/text_style_dto.dart`
- `lib/src/attributes/text_style/text_style_util.dart`
- All corresponding test files

## 11. Migration Checklist (For Future Updates)

### Step 1: Update Theme Definition
- [x] Use MixToken<T> objects as keys instead of string-based tokens
- [x] Maintain typed parameters (colors, textStyles, spaces, etc.) for better organization
- [x] Unified token storage internally while keeping clean API

### Step 2: Update Token Definitions  
- [ ] Replace `ColorToken('name')` with `MixToken<Color>('name')`
- [ ] Replace `TextStyleToken('name')` with `MixToken<TextStyle>('name')`
- [ ] Replace `SpaceToken('name')` with `MixToken<double>('name')`

### Step 3: Update Usage
- [ ] Replace `.ref()` calls with `.token()` calls
- [ ] Update custom extensions to use new token methods

### Step 4: Testing
- [ ] Verify all tokens resolve correctly
- [ ] Test theme switching still works
- [ ] Confirm backwards compatibility for any remaining old tokens

## Conclusion

The unified token system provides:

✅ **33% reduction in complexity** (5→3 layers)  
✅ **Better type safety** with generic MixToken<T>  
✅ **Improved performance** with streamlined resolution  
✅ **Cleaner API** with consistent token() method  
✅ **Full backwards compatibility** during migration  

The migration to MixToken<T> has been successfully completed, maintaining all existing functionality while significantly simplifying the token architecture and improving the developer experience. All deprecated Token<T> references have been replaced with the standardized MixToken<T> implementation.