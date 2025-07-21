# Utility Migration Plan - Mix 2.0

## Overview

This plan details the migration from `DtoUtility` pattern to `MixPropUtility` pattern, based on successful migrations and real-world patterns.

## Core Migration Pattern

### 1. Type Constraint and Base Class Updates

```dart
// Before
class YourUtility<T extends Attribute>
    extends DtoUtility<T, YourDto, YourType> {

// After
class YourUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, YourType> {
```

### 2. Constructor Pattern

```dart
// Always use .value constructor for valueToDto
YourUtility(super.builder) : super(valueToDto: YourDto.value);
```

### 3. Override call() Method

```dart
// This is the key transformation method
@override
T call(YourDto value) => builder(MixProp(value));
```

### 4. Nested Utilities Pattern

**✅ CORRECT PATTERN:**
```dart
class BorderRadiusUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, BorderRadius> {
  
  // Nested utilities receive Prop<Radius> and use main constructor
  late final topLeft = RadiusUtility<T>(
    (radius) => call(BorderRadiusDto(topLeft: radius)),
  );
  
  late final all = RadiusUtility<T>(
    (radius) => call(BorderRadiusDto(
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    )),
  );
  
  @override
  T call(BorderRadiusDto value) => builder(MixProp(value));
}
```

**❌ WRONG PATTERNS:**
```dart
// DON'T use .only() constructor with Prop values
(radius) => call(BorderRadiusDto.only(topLeft: radius)) // ERROR!

// DON'T call builder directly
(radius) => builder(BorderRadiusDto(topLeft: radius)) // ERROR!

// DON'T omit <T> type parameter
late final topLeft = RadiusUtility((radius) => ...) // ERROR!
```

## Complete Migration Steps

### Step 1: Update Class Declaration
```dart
final class YourUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, YourType> {
```

### Step 2: Update Constructor
```dart
YourUtility(super.builder) : super(valueToDto: YourDto.value);
```

### Step 3: Add Override call() Method
```dart
@override
T call(YourDto value) => builder(MixProp(value));
```

### Step 4: Update Nested Utilities
```dart
// Pattern: NestedUtility<T>((prop) => call(YourDto(property: prop)))
late final property1 = Property1Utility<T>(
  (prop) => call(YourDto(property1: prop)),
);

late final property2 = Property2Utility<T>(
  (prop) => call(YourDto(property2: prop)),
);
```

### Step 5: Remove only() Methods
```dart
// REMOVE any only() methods from utility classes
// These should not exist in the new pattern
```

### Step 6: Update Complex Nested Utilities
```dart
// For utilities that set multiple properties
late final all = PropertyUtility<T>(
  (prop) => call(YourDto(
    property1: prop,
    property2: prop,
    property3: prop,
    property4: prop,
  )),
);
```

## DTO Constructor Usage Guide

### When to Use Each Constructor

1. **Main Constructor** - Use with `Prop<T>?` values:
   ```dart
   // From nested utilities (receives Prop<T>)
   (prop) => call(YourDto(property: prop))
   ```

2. **`.only()` Constructor** - Use with raw `T?` values:
   ```dart
   // From public API methods (receives raw values)
   YourDto.only(property: rawValue)
   ```

3. **`.value()` Constructor** - Use in `valueToDto`:
   ```dart
   super(valueToDto: YourDto.value)
   ```

## Utility Base Classes

### Choose the Right Base Class

- **`MixPropUtility<T, Type>`**: For DTOs that implement `Mix<Type>`
- **`PropUtility<T, Type>`**: For simple value types (Color, double, etc.)
- **`MixUtility<T, Type>`**: For collections or simple transformations

### Examples by Type

```dart
// For DTO-based utilities
class ShadowUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, Shadow> {

// For simple value utilities  
class ColorUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, Color> {

// For collection utilities
class ShadowListUtility<T extends SpecUtility<Object?>>
    extends MixUtility<T, List<ShadowDto>> {
```

## Common Migration Issues and Solutions

### Issue 1: Type Mismatch with DTO Constructor
```dart
// Problem: Using .only() with Prop values
(prop) => call(YourDto.only(property: prop)) // Prop<T> → T? mismatch

// Solution: Use main constructor
(prop) => call(YourDto(property: prop)) // Prop<T> → Prop<T>?
```

### Issue 2: Missing Type Parameters
```dart
// Problem: Missing <T>
late final nested = NestedUtility((prop) => ...)

// Solution: Add <T>
late final nested = NestedUtility<T>((prop) => ...)
```

### Issue 3: Direct Builder Calls
```dart
// Problem: Calling builder directly
(prop) => builder(YourDto(property: prop))

// Solution: Use call() method
(prop) => call(YourDto(property: prop))
```

### Issue 4: Leftover only() Methods
```dart
// Problem: Utility still has only() methods
T only({Type? property}) { ... }

// Solution: Remove all only() methods from utilities
// Only keep call() method
```

## Migration Verification Checklist

For each utility file:
- [ ] Type constraint updated to `SpecUtility<Object?>`
- [ ] Base class changed to appropriate utility type
- [ ] Constructor uses `super(valueToDto: Dto.value)`
- [ ] Override `call(Dto value)` method exists
- [ ] All nested utilities have `<T>` type parameter
- [ ] All nested utilities use `call()` method
- [ ] All nested utilities use main DTO constructor (not `.only()`)
- [ ] No `only()` methods exist in utility classes
- [ ] Imports updated (remove attribute.dart if not needed)
- [ ] File passes `dart analyze` without errors

## Benefits of New Pattern

1. **Consistency**: All utilities follow the same pattern
2. **Simplicity**: Single `call()` method handles all transformations
3. **Type Safety**: Better type checking and inference
4. **Performance**: Reduced method calls and indirection
5. **Maintainability**: Cleaner, more predictable code structure

## Migration Order Recommendation

1. **Core utilities first**: `scalar_util.dart`, `color_util.dart`, `enum_util.dart`
2. **Simple utilities next**: Single-property utilities
3. **Complex utilities last**: Multi-property utilities with many dependencies

## Testing Strategy

After each migration:
1. Run `dart analyze` to check for errors
2. Run unit tests for the utility
3. Test integration with other utilities
4. Verify token resolution works correctly