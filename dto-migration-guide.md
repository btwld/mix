# DTO Migration Guide - Mix 2.0

This guide documents the DTO constructor refactoring pattern for Mix 2.0, aimed at simplifying and standardizing the DTO APIs.

## Overview

The migration involves standardizing DTO constructors with a clean pattern that uses `.only()` for raw values, `.value()` for Flutter objects, and a main constructor with clean `super.property` delegation.

## Important: Field Nullability and Optionality

**All DTO fields must be:**
1. **Nullable**: Use `Type?` (with question mark) for all field types
2. **Optional**: Do NOT use `required` keyword for any field
3. **Named parameters**: All DTO constructors use named parameters

This ensures maximum flexibility and allows partial updates through merging.

## Key Changes

### 1. Main Constructor Pattern

**Before:**
```dart
// Public factory constructor
factory SomeDto({
  PropType? property1,
  PropType? property2,
}) {
  return SomeDto.props(
    property1: MixProp.maybe(property1),
    property2: MixProp.maybe(property2),
  );
}

// .props constructor
const SomeDto.props({super.property1, super.property2});
```

**After:**
```dart
// Named constructor for raw values
SomeDto.only({
  PropType? property1,
  PropType? property2,
}) : this(
       property1: MixProp.maybe(property1),
       property2: MixProp.maybe(property2),
     );

// Main constructor with clean super delegation - all fields nullable and optional
const SomeDto({super.property1, super.property2});
```

### 2. Value Constructor Pattern

**Before:**
```dart
factory SomeDto.value(FlutterType object) {
  return SomeDto(
    property1: object.property1,
    property2: object.property2,
  );
}
```

**After:**
```dart
SomeDto.value(FlutterType object)
  : this.only(
      property1: object.property1,
      property2: object.property2,
    );
```

### 3. Merge Method Updates

**Before:**
```dart
return SomeDto.props(
  property1: MixHelpers.merge(property1, other.property1),
  property2: MixHelpers.merge(property2, other.property2),
);
```

**After:**
```dart
return SomeDto(
  property1: MixHelpers.merge(property1, other.property1),
  property2: MixHelpers.merge(property2, other.property2),
);
```

## Migration Checklist

For each DTO class:

- [ ] Replace `factory ClassName(...)` with `ClassName.only(...)`
- [ ] Change constructor body from `return ClassName.props(...)` to `: this(...)`
- [ ] Remove `.props` constructor and rename to main constructor with clean `super.property` pattern
- [ ] **Keep** `.only()` constructor - it's useful for raw values
- [ ] **Keep** `.value()` constructor - it's needed for utilities and conversions
- [ ] Convert `.value()` from factory to regular constructor using `: this.only(...)`
- [ ] Update all `.props()` calls in merge methods to use main constructor
- [ ] Update all internal `.props()` calls to use main constructor
- [ ] Ensure `maybeValue()` returns null for null input
- [ ] Keep static constants unchanged

## Generic Migration Pattern

### Step 1: Update Main Constructor
```dart
// Before
factory YourDto({Type1? prop1, Type2? prop2}) {
  return YourDto.props(
    prop1: Prop.maybe(prop1),
    prop2: Prop.maybe(prop2),
  );
}
// All fields nullable (Type?) and optional (not required)
const YourDto.props({this.prop1, this.prop2});

// After
YourDto.only({Type1? prop1, Type2? prop2})
  : this(
      prop1: Prop.maybe(prop1),
      prop2: Prop.maybe(prop2),
    );
// All fields nullable (Type?) and optional (not required)
const YourDto({this.prop1, this.prop2});
```

### Step 2: Update Value Constructor
```dart
// Before
factory YourDto.value(FlutterType object) {
  return YourDto(prop1: object.prop1, prop2: object.prop2);
}

// After
YourDto.value(FlutterType object)
  : this.only(prop1: object.prop1, prop2: object.prop2);
```

### Step 3: Update Static Methods
```dart
static YourDto? maybeValue(FlutterType? object) {
  return object != null ? YourDto.value(object) : null;
}
```

## DTOs with Different Property Types

### Simple Properties (using Prop<T>)
```dart
YourDto.only({Color? color, double? size})
  : this(
      color: Prop.maybe(color),
      size: Prop.maybe(size),
    );
```

### Complex Properties (using MixProp<T>)
```dart
YourDto.only({NestedDto? nested})
  : this(nested: MixProp.maybe(nested));
```

### Mixed Properties
```dart
YourDto.only({Color? color, NestedDto? nested})
  : this(
      color: Prop.maybe(color),
      nested: MixProp.maybe(nested),
    );
```

## DTO Base Class Pattern

All DTOs extend from a base class with nullable, optional fields:

```dart
// Example base class
abstract class BaseDto extends Mix<SomeSpec> {
  // All fields are nullable (Type?) and optional (no required keyword)
  final MixProp<Color>? color;
  final MixProp<double>? size;
  final MixProp<NestedDto>? nested;
  
  const BaseDto({
    this.color,
    this.size,
    this.nested,
  });
}

// Concrete implementation
class ConcreteDto extends BaseDto {
  const ConcreteDto({
    super.color,
    super.size,
    super.nested,
  });
  
  // Constructor for raw values - all parameters nullable and optional
  ConcreteDto.only({
    Color? color,
    double? size,
    NestedDto? nested,
  }) : this(
        color: MixProp.maybe(color),
        size: MixProp.maybe(size),
        nested: MixProp.maybe(nested),
      );
}
```

## Special Cases

### All/Symmetric Constructors
These remain as named constructors:
```dart
YourDto.all(PropertyType value)
  : this.only(prop1: value, prop2: value, prop3: value);

YourDto.symmetric({PropertyType? horizontal, PropertyType? vertical})
  : this.only(
      left: horizontal,
      right: horizontal,
      top: vertical,
      bottom: vertical,
    );
```

### Static Factory Methods
Keep these as static methods:
```dart
static YourDto? maybeValue(FlutterType? object) {
  return object != null ? YourDto.value(object) : null;
}
```

## Benefits

1. **Consistency**: All DTOs follow the same pattern
2. **Clarity**: `.only()` for raw values, `.value()` for Flutter objects
3. **Simplicity**: Clean `super.property` delegation eliminates boilerplate
4. **Type Safety**: Constructor delegation ensures proper type wrapping
5. **Utility Integration**: `.value()` constructors work perfectly with utilities

## Verification

After migration, ensure:
1. All tests pass
2. Both `.only()` and `.value()` constructors exist and work correctly
3. No `.props` constructors exist
4. Main constructor uses clean `super.property` pattern
5. Merge methods use the main constructor
6. Constructor delegation is properly implemented
7. Utilities can use `.value()` constructor in `valueToDto`