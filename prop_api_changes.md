# Prop API Migration Guide

## Overview

The Prop system has been redesigned with a cleaner separation of concerns. The key change is splitting the previous unified system into two distinct classes:
- `Prop<T>` for regular values
- `MixProp<V>` for Mix types (where V is the resolved type)

## Core Changes

### 1. Separated Type System

**Before:**
```dart
// Two different classes with complex type parameters
Prop<Color> colorProp = Prop(Colors.red);
MixProp<BorderSide, BorderSideDto> borderProp = MixProp(borderDto);
```

**After:**
```dart
// Two distinct classes with clear purposes
Prop<Color> colorProp = Prop(Colors.red);
MixProp<BorderSide> borderProp = MixProp(borderDto);  // Note: V is the resolved type
```

### 2. Constructor Changes

#### Regular Values (Prop)

**Before:**
```dart
// Named constructors
Prop(value)
Prop(value, animation: animConfig)
Prop.maybe(nullableValue)
Prop.fromToken(token)
```

**After:**
```dart
// Factory constructors
Prop(value)
Prop.maybe(nullableValue)
Prop.token(token)
// Animation now uses separate factory
Prop.animation(animConfig)
```

#### Mix Types (MixProp)

**Before:**
```dart
MixProp<BorderSide, BorderSideDto> prop;
MixProp(borderDto)
MixProp.fromToken(token, (value) => BorderSideDto.from(value))
MixProp.maybe(nullableBorderDto)
```

**After:**
```dart
MixProp<BorderSide> prop;  // Only the resolved type V
MixProp(borderDto)
MixProp.token(token, (value) => BorderSideDto.from(value))
MixProp.maybe(nullableBorderDto)
```

### 3. Type Parameter Simplification

The most important change for MixProp is the reduction from two type parameters to one:

**Before:**
```dart
MixProp<V, T>  // V = resolved type, T = DTO type
MixProp<BorderSide, BorderSideDto>
```

**After:**
```dart
MixProp<V>  // V = resolved type only
MixProp<BorderSide>
```

### 4. Property Access Changes

**Before:**
```dart
// Direct access to internal fields
prop.value        // T?
prop.token        // MixToken<T>?
prop.hasValue     // bool
prop.hasToken     // bool

// MixProp specific
mixProp.mixValue  // T?
mixProp.mixToken  // MixToken<V>?
```

**After:**
```dart
// Prop<T>
prop.hasValue       // bool
prop.hasToken       // bool
prop.getValue()     // T - throws if not a value source
prop.getToken()     // MixToken<T> - throws if not a token source

// MixProp<V>
mixProp.hasSource      // bool
mixProp.getMixSource() // MixPropSource<V> - throws if no source
```

### 5. Directives and Animation

**Before:**
```dart
// Directives and animation passed in constructors
Prop(value, animation: animConfig)
MixProp(dto, animation: animConfig)
```

**After:**
```dart
// Separate factory constructors
Prop.animation(animConfig)
Prop.directives(directives)

MixProp.animation(animConfig)
MixProp.directives(directives)

// Combine using merge
Prop(value).merge(Prop.animation(animConfig))
MixProp(dto).merge(MixProp.animation(animConfig))
```

## Migration Patterns

### Pattern 1: Simple Value Properties

**Before:**
```dart
class MyDto {
  final Prop<Color>? color;
  final Prop<double>? width;
  
  MyDto({Color? color, double? width})
    : color = Prop.maybe(color),
      width = Prop.maybe(width);
}
```

**After:**
```dart
class MyDto {
  final Prop<Color>? color;
  final Prop<double>? width;
  
  MyDto({Color? color, double? width})
    : color = Prop.maybe(color),
      width = Prop.maybe(width);
}
```

### Pattern 2: Mix Properties (DTO Properties)

**Before:**
```dart
class BorderDto {
  final MixProp<BorderSide, BorderSideDto>? top;
  final MixProp<BorderSide, BorderSideDto>? bottom;
  
  factory BorderDto({
    BorderSideDto? top,
    BorderSideDto? bottom,
  }) {
    return BorderDto.props(
      top: MixProp.maybe(top),
      bottom: MixProp.maybe(bottom),
    );
  }
}
```

**After:**
```dart
class BorderDto {
  final MixProp<BorderSide>? top;      // Only resolved type
  final MixProp<BorderSide>? bottom;   // Only resolved type
  
  factory BorderDto({
    BorderSideDto? top,
    BorderSideDto? bottom,
  }) {
    return BorderDto.props(
      top: MixProp.maybe(top),
      bottom: MixProp.maybe(bottom),
    );
  }
}
```

### Pattern 3: Token Properties

**Before:**
```dart
// Regular token
final prop = Prop.token($token.color);

// Mix token with converter
final mixProp = MixProp.fromToken(
  $token.borderSide,
  (value) => BorderSideDto.from(value),
);
```

**After:**
```dart
// Regular token
final prop = Prop.token($token.color);

// Mix token with converter
final mixProp = MixProp.token(
  $token.borderSide,
  (value) => BorderSideDto.from(value),
);
```

### Pattern 4: Properties with Animation

**Before:**
```dart
Prop(Colors.red, animation: AnimationConfig(
  duration: Duration(seconds: 1),
  curve: Curves.easeIn,
))
```

**After:**
```dart
// Use merge to combine
Prop(Colors.red).merge(
  Prop.animation(AnimationConfig(
    duration: Duration(seconds: 1),
    curve: Curves.easeIn,
  ))
)

// Or create a helper method
static Prop<Color> animatedColor(Color color, AnimationConfig animation) {
  return Prop(color).merge(Prop.animation(animation));
}
```

### Pattern 5: Conditional Properties

**Before:**
```dart
// Using maybeValue static method
color: Prop.maybe(isEnabled ? Colors.blue : null),
border: MixProp.maybe(isEnabled ? borderDto : null),
```

**After:**
```dart
// Using maybe static method
color: Prop.maybe(isEnabled ? Colors.blue : null),
border: MixProp.maybe(isEnabled ? borderDto : null),
```

## Common Migration Issues

### Issue 1: MixProp Type Parameters

**Error:**
```
Expected 1 type argument(s) for 'MixProp' but found 2
```

**Solution:**
Remove the DTO type parameter, keep only the resolved type:
```dart
// Before
final MixProp<BorderSide, BorderSideDto>? top;

// After
final MixProp<BorderSide>? top;
```

### Issue 2: maybeValue Method Not Found

**Error:**
```
The method 'maybeValue' isn't defined for the type 'Prop'
The method 'maybeValue' isn't defined for the type 'MixProp'
```

**Solution:**
```dart
// Before
Prop.maybe(value)
MixProp.maybe(dto)

// After
Prop.maybe(value)
MixProp.maybe(dto)
```

### Issue 3: fromValue Constructor Not Found

**Error:**
```
Method not found: 'Prop.fromValue'
Method not found: 'MixProp.fromValue'
```

**Solution:**
```dart
// Before
Prop(value)
MixProp(dto)

// After
Prop(value)
MixProp(dto)
```

### Issue 4: fromToken Constructor Not Found

**Error:**
```
Method not found: 'Prop.fromToken'
Method not found: 'MixProp.fromToken'
```

**Solution:**
```dart
// Before
Prop.fromToken(token)
MixProp.fromToken(token, converter)

// After
Prop.token(token)
MixProp.token(token, converter)
```

### Issue 5: Direct Property Access

**Error:**
```
The getter 'value' isn't defined for the type 'Prop'
The getter 'mixValue' isn't defined for the type 'MixProp'
```

**Solution:**
```dart
// Before (Prop)
if (prop.value != null) {
  useValue(prop.value!);
}

// After (Prop)
if (prop.hasValue) {
  useValue(prop.getValue());
}

// Before (MixProp)
if (mixProp.mixValue != null) {
  useValue(mixProp.mixValue!);
}

// After (MixProp)
if (mixProp.hasSource) {
  // MixProp doesn't expose the raw value directly
  // Resolution happens through the resolve method
}
```

## Migration Checklist

1. **Update type declarations:**
   - [ ] Change `MixProp<V, T>` to `MixProp<V>` (remove DTO type parameter)
   - [ ] Keep `Prop<T>` as is

2. **Update constructor calls:**
   - [ ] `Prop()` → `Prop()`
   - [ ] `Prop.maybe()` → `Prop.maybe()`
   - [ ] `Prop.fromToken()` → `Prop.token()`
   - [ ] `MixProp()` → `MixProp()`
   - [ ] `MixProp.maybe()` → `MixProp.maybe()`
   - [ ] `MixProp.fromToken()` → `MixProp.token()`

3. **Update property access:**
   - [ ] Replace direct `.value` access with `.hasValue` checks and `.getValue()` calls
   - [ ] Replace direct `.token` access with `.hasToken` checks and `.getToken()` calls
   - [ ] For MixProp, use `.hasSource` and `.getMixSource()` if needed

4. **Update animation usage:**
   - [ ] Move animation from constructor parameters to `.merge()` pattern
   - [ ] Create helper methods for commonly animated properties

## Best Practices

1. **Use the correct class for your use case:**
   - `Prop<T>` for regular values (colors, numbers, enums, etc.)
   - `MixProp<V>` for Mix types that support merging (DTOs)

2. **Type parameters:**
   - For `Prop<T>`: T is the actual type (Color, double, etc.)
   - For `MixProp<V>`: V is the resolved type (BorderSide, not BorderSideDto)

3. **Use type checking before accessing:**
   ```dart
   // For Prop
   if (prop.hasValue) {
     final value = prop.getValue();
   } else if (prop.hasToken) {
     final token = prop.getToken();
   }
   
   // For MixProp
   if (mixProp.hasSource) {
     final source = mixProp.getMixSource();
   }
   ```

4. **Leverage the null-safe factory methods:**
   ```dart
   Prop.maybe(nullableValue)     // Returns null if value is null
   MixProp.maybe(nullableDto)    // Returns null if dto is null
   ```

## Summary

The new API provides better type safety and clearer separation of concerns:
1. `Prop<T>` handles regular values with simple types
2. `MixProp<V>` handles Mix types with mergeable DTOs
3. Type parameters are simplified (MixProp now only needs the resolved type)
4. Constructor names are cleaner and more intuitive
5. Property access is more explicit with dedicated methods

While migration requires updating constructors and type declarations, the new API is more maintainable and easier to understand.