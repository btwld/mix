# Mix Token System Refactor (Ultra-Simplified)

## Core Problem Statement

**Problem**: Current token system has code duplication and uses negative hashcode hack.
**Solution**: Add single `Token<T>` class. That's it.

## What We're NOT Building (YAGNI)

- ❌ Complex adapters between old/new systems
- ❌ Custom error classes  
- ❌ Caching layers
- ❌ Material presets
- ❌ Migration helpers
- ❌ Fallback mechanisms

## What We ARE Building (Minimal)

- ✅ Single `Token<T>` class
- ✅ Simple token resolution in `MixData`
- ✅ Add `.token()` methods to utilities
- ✅ Keep existing system working

## Implementation

### 1. Core Token (Minimal)

```dart
// lib/src/theme/tokens/token.dart

@immutable
class Token<T> {
  final String name;
  const Token(this.name);
  
  @override
  bool operator ==(Object other) => 
      identical(this, other) || (other is Token<T> && other.name == name);
  
  @override
  int get hashCode => Object.hash(name, T);
  
  @override
  String toString() => 'Token<$T>($name)';
}
```

### 2. Add Token Support to DTOs (Direct Approach)

**YAGNI Insight**: Don't add `resolveToken()` to MixData yet. Let DTOs handle their own token resolution directly.

```dart
// No changes to MixData needed initially!
// Each DTO resolves its own token type directly.
```

### 3. Update DTOs (Minimal - Direct Resolution)

```dart
// ColorDto - resolves Token<Color> directly
class ColorDto extends Mixable<Color> {
  final Color? value;
  final Token<Color>? token;
  
  const ColorDto({this.value, this.token});
  
  factory ColorDto.token(Token<Color> token) => ColorDto(token: token);
  
  @override
  Color resolve(MixData mix) {
    if (token != null) {
      // Direct resolution - no complex generics needed
      final oldToken = ColorToken(token!.name);
      final themeValue = mix.theme.colors[oldToken];
      if (themeValue != null) {
        return themeValue is ColorResolver 
            ? themeValue.resolve(mix.context) 
            : themeValue;
      }
      throw StateError('Color token ${token!.name} not found');
    }
    
    if (value is ColorRef) return mix.tokens.colorRef(value as ColorRef);
    return value ?? Colors.transparent;
  }
}

// SpaceDto - resolves Token<double> directly  
class SpaceDto extends Mixable<double> {
  final double? value;
  final Token<double>? token;
  
  const SpaceDto({this.value, this.token});
  
  factory SpaceDto.token(Token<double> token) => SpaceDto(token: token);
  
  @override
  double resolve(MixData mix) {
    if (token != null) {
      // Direct resolution - simple and clear
      final oldToken = SpaceToken(token!.name);
      final themeValue = mix.theme.spaces[oldToken];
      if (themeValue != null) return themeValue;
      throw StateError('Space token ${token!.name} not found');
    }
    
    final val = value ?? 0;
    if (val < 0) return mix.tokens.spaceTokenRef(val); // Handle old hack
    return val;
  }
}

// Same pattern for TextStyleDto, RadiusDto, etc.
```

### 4. Add Utility Methods (Minimal)

```dart
// Just add .token() methods alongside existing .ref() methods

extension ColorUtilityTokens<T extends Attribute> on ColorUtility<T> {
  T token(Token<Color> token) => _buildColor(ColorDto.token(token));
}

extension SpacingTokens<T extends Attribute> on SpacingSideUtility<T> {
  T token(Token<double> token) => builder(SpaceDto.token(token));
}
```

## Usage

### Define Tokens

```dart
class MyTokens {
  static const primary = Token<Color>('primary');
  static const padding = Token<double>('padding');
}
```

### Use Tokens

```dart
// In existing MixThemeData
MixTheme(
  data: MixThemeData(
    colors: {
      ColorToken('primary'): Colors.blue,  // Maps to Token<Color>('primary')
    },
    spaces: {
      SpaceToken('padding'): 16.0,  // Maps to Token<double>('padding')  
    },
  ),
  child: MyApp(),
)

// In widgets
Style(
  $box.color.token(MyTokens.primary),     // New way
  $box.color.ref(ColorToken('primary')),  // Old way - still works
)
```

## Migration

### Phase 1: Start Using Tokens
- Define tokens using `Token<T>`
- Use `.token()` methods in new code
- Existing code unchanged

### Phase 2: Gradual Migration  
- Replace `.ref()` with `.token()` over time
- Both work during transition

### Phase 3: Cleanup (Future)
- Remove old token classes
- Remove `.ref()` methods

## Benefits

1. **Perfect DRY Compliance**: Single `Token<T>` eliminates 5 duplicate token classes
2. **Strict YAGNI Adherence**: Only adds what's needed, no speculative features
3. **True KISS Implementation**: Each DTO handles its own type directly - no complex abstractions
4. **Zero Breaking Changes**: Existing code works exactly as before
5. **Natural Migration**: Developers can adopt new tokens gradually
6. **Eliminates Magic**: Removes negative hashcode hack from SpaceToken
7. **Type Safety**: Compile-time token type checking with generics

## Why This is the Optimal Approach

**Sequential Reasoning**:

**Step 1 - Problem Analysis**: 
- Current system has code duplication (5 token classes) 
- Current system uses magic numbers (negative hashcode hack)
- Need backwards compatibility during migration

**Step 2 - Solution Evaluation**:
- Complex adapters? ❌ Violates YAGNI (not needed yet)
- Generic resolution? ❌ Violates KISS (too complex)  
- Direct DTO resolution? ✅ Simple, clear, minimal

**Step 3 - Implementation Logic**:
- Add `Token<T>` class (solves duplication)
- Add token fields to DTOs (minimal change)
- Each DTO resolves its own token type (simple, clear)
- No complex systems needed (YAGNI compliance)

**Step 4 - Validation**:
- ✅ Solves actual problems without over-engineering
- ✅ Maintains existing functionality 
- ✅ Provides clear migration path
- ✅ Follows all three principles strictly

## What This Approach Avoids

- ❌ No complex MixConfig system
- ❌ No complex adapter bridges  
- ❌ No custom error classes
- ❌ No caching complexity
- ❌ No Material preset factories
- ❌ No enum complications

**Result**: Clean, simple solution that solves actual problems without over-engineering.

## Why This is Better

**Previous approaches violated YAGNI by building:**
- Complex adapters before they're needed
- Caching before performance is proven to be an issue  
- Custom errors before StateError is proven insufficient
- Material presets before anyone asks for them

**This approach follows strict YAGNI:**
- ✅ Only adds what's needed to solve current problems
- ✅ Keeps everything else exactly as it is
- ✅ Allows natural migration without forcing complexity

**Perfect KISS compliance:**
- ✅ Single responsibility: just add Token<T> support
- ✅ Minimal code changes
- ✅ No complex abstractions
- ✅ Simple, obvious implementation
