# Mix Brightness-Aware Tokens

This feature allows you to create tokens that automatically switch between light and dark values based on the current theme brightness.

## Key Features

✅ **Automatic Switching**: Tokens automatically resolve to different values based on `Theme.of(context).brightness`  
✅ **Simple API**: Easy-to-use extension methods for creating adaptive tokens  
✅ **Material Integration**: Material Design tokens automatically adapt through Flutter's theming  
✅ **Backward Compatible**: Existing token usage continues to work unchanged  

## Usage Examples

### 1. Basic Adaptive Tokens

```dart
// Define tokens
final primaryColor = MixToken<Color>('colors.primary');
final backgroundColor = MixToken<Color>('colors.background');

// Create adaptive tokens using extension methods
MixScope(
  tokens: {
    primaryColor.defineAdaptive(
      light: Colors.blue,
      dark: Colors.lightBlue,
    ),
    backgroundColor.defineAdaptive(
      light: Colors.white,
      dark: Colors.grey[900]!,
    ),
  },
  child: MyApp(),
)
```

### 2. Advanced Builder Functions

```dart
final brandColor = MixToken<Color>('colors.brand');

// Use builder functions for complex logic
MixScope(
  tokens: {
    brandColor.defineAdaptiveBuilder(
      light: (context) => Theme.of(context).primaryColor,
      dark: (context) => Theme.of(context).primaryColorDark,
    ),
  },
  child: MyApp(),
)
```

### 3. Material Design Integration

```dart
// Material tokens automatically adapt to light/dark themes
MixScope.withMaterial(
  tokens: {
    // Add custom adaptive tokens alongside Material ones
    brandColor.defineAdaptive(
      light: Colors.purple,
      dark: Colors.deepPurple,
    ),
  },
  child: MyApp(),
)
```

## How It Works

The brightness-aware token system uses a new `BrightnessTokenDefinition` class that:

1. **Stores both resolvers**: Keeps separate `lightResolver` and `darkResolver` functions
2. **Checks theme brightness**: Uses `Theme.of(context).brightness` to determine current mode
3. **Resolves automatically**: Returns the appropriate value based on brightness

```dart
// Internal implementation (simplified)
class BrightnessTokenDefinition<T> extends TokenDefinition<T> {
  final ValueBuilder<T> lightResolver;
  final ValueBuilder<T> darkResolver;
  
  BrightnessTokenDefinition(token, {required this.lightResolver, required this.darkResolver})
    : super(token, (context) {
        final brightness = Theme.of(context).brightness;
        return brightness == Brightness.light 
          ? lightResolver(context) 
          : darkResolver(context);
      });
}
```

## Token Resolution Flow

1. **Style Definition**: Create styles using adaptive tokens
2. **Context Resolution**: During widget build, tokens are resolved through BuildContext
3. **Brightness Check**: System checks `Theme.of(context).brightness`
4. **Value Selection**: Returns appropriate light or dark value
5. **Widget Application**: Resolved values are applied to widgets

## Benefits

- 🎨 **Consistent theming** across your app
- 🔄 **Automatic updates** when system theme changes
- 🛠️ **Developer friendly** with multiple usage patterns
- 📱 **System integration** respects user's system preferences
- ⚡ **Performance optimized** with efficient resolution
- 🧪 **Well tested** with comprehensive test suite

## Migration from Regular Tokens

Existing token usage continues to work without changes:

```dart
// This still works exactly the same
final regularToken = MixToken<Color>('regular');
MixScope(
  tokens: {
    regularToken.defineValue(Colors.blue),
  },
  child: MyApp(),
)

// Add adaptive tokens alongside regular ones
MixScope(
  tokens: {
    regularToken.defineValue(Colors.blue), // Regular token
    adaptiveToken.defineAdaptive(          // Adaptive token
      light: Colors.red,
      dark: Colors.pink,
    ),
  },
  child: MyApp(),
)
```

## Benefits

- 🎨 **Consistent theming** across your app
- 🔄 **Automatic updates** when system theme changes  
- 🛠️ **Simple API** with intuitive extension methods
- 📱 **System integration** respects user's system preferences
- ⚡ **Performance optimized** with efficient resolution
- 🧪 **Well tested** with comprehensive test suite

This feature provides a simple, powerful way to handle light and dark themes in Mix while maintaining full backward compatibility.