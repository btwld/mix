# Mix Utility Call Methods Documentation - VERIFIED

This document provides **verified** documentation of all utility classes and their actual `call()` method signatures in the Mix framework, along with deprecation guidance and alternative approaches.

## Overview

Mix utilities provide a convenient API for creating attributes through their `call()` methods. However, there are alternative patterns that may be more explicit and maintainable in certain contexts.

## ⚠️ IMPORTANT FINDINGS

**Key Inconsistencies Discovered:**
1. **DecorationUtility** - Does NOT have a call method that accepts Decoration objects
2. **BorderUtility** - Does NOT accept Border objects, uses named parameters instead
3. **EdgeInsetsGeometryUtility** - Uses positional parameters, not EdgeInsetsGeometry objects
4. **OffsetUtility** - Uses `as()` method instead of `call()`
5. **PaddingModifierSpecUtility** - Does NOT have a call method, only `only()` method

## Core Base Utilities

### GenericUtility<Attr, Value>
- **Call Method**: `Attr call(Value value)`
- **Purpose**: Basic value conversion utility that wraps any value into an attribute
- **Usage**: Direct value-to-attribute conversion
- **Review**: ✅ **Keep** - Essential base utility for generic value conversion
- **Alternative**: Direct attribute constructor: `MyAttribute(value)`

### ScalarUtility<Return, V>
- **Call Method**: `Return call(V value)`
- **Purpose**: Base class for scalar value utilities
- **Usage**: Single value conversion to attributes
- **Review**: ✅ **Keep** - Core base class for scalar utilities
- **Alternative**: Direct attribute constructor or factory methods

### ListUtility<T, V>
- **Call Method**: `T call(List<V> values)`
- **Purpose**: Converts lists of values into attributes
- **Usage**: For attributes that accept multiple values
- **Review**: ✅ **Keep** - Useful for list-based attributes
- **Alternative**: `MyAttribute.fromList(values)` or `MyAttribute(values)`

### IntUtility<T>
- **Call Method**: `T call(int value)`
- **Purpose**: Integer value conversion
- **Additional Methods**: `T zero()` - creates attribute with value 0
- **Usage**: For integer-based attributes
- **Review**: ✅ **Keep** - Provides convenient zero() method
- **Alternative**: Direct constructor `MyAttribute(intValue)` or `MyAttribute.zero()`

### DoubleUtility<T>
- **Call Method**: `T call(double value)`
- **Purpose**: Double value conversion
- **Additional Methods**:
  - `T zero()` - creates attribute with value 0
  - `T infinity()` - creates attribute with double.infinity
- **Usage**: For double-based attributes
- **Review**: ✅ **Keep** - Provides convenient zero() and infinity() methods
- **Alternative**: Direct constructor `MyAttribute(doubleValue)` or named constructors

### StringUtility<T>
- **Call Method**: `T call(String value)`
- **Purpose**: String value conversion
- **Usage**: For string-based attributes
- **Review**: ✅ **Keep** - Simple and clear for string attributes
- **Alternative**: Direct constructor `MyAttribute(stringValue)`

## DTO/Attribute Utilities

### EdgeInsetsGeometryUtility<T> ✅ VERIFIED
- **Call Method**: `T call(double p1, [double? p2, double? p3, double? p4])`
- **Purpose**: Handles padding and margin values using CSS-like shorthand
- **Parameters**:
  - `p1` - all sides (if only parameter) or top
  - `p2` - horizontal (left/right) or right
  - `p3` - bottom
  - `p4` - left
- **Usage**: `padding(8)` or `padding(8, 16)` or `padding(8, 16, 12, 4)`
- **Review**: ✅ **Keep** - Essential for spacing with convenient shorthand
- **Alternative**: `only(top: 8, bottom: 8, left: 8, right: 8)` or direct EdgeInsets

### BoxConstraintsUtility<T> ❌ NOT FOUND
- **Status**: No direct BoxConstraintsUtility found in codebase
- **Alternative**: Generated utilities for specific constraint fields

### DecorationUtility<T> ❌ NO CALL METHOD
- **Call Method**: **NONE** - This is a parent utility that provides access to sub-utilities
- **Sub-utilities**:
  - `box` - BoxDecorationUtility
  - `shape` - ShapeDecorationUtility
- **Purpose**: Provides access to decoration sub-utilities
- **Usage**: `decoration.box.color(Colors.red)` or `decoration.shape.circle()`
- **Review**: ✅ **Keep** - Organizational utility for decoration types
- **Alternative**: Direct access to BoxDecorationUtility or ShapeDecorationUtility

### BoxDecorationUtility<T> ✅ VERIFIED
- **Call Method**: `T call({BoxBorder? border, BorderRadiusGeometry? borderRadius, BoxShape? shape, BlendMode? backgroundBlendMode, Color? color, DecorationImage? image, Gradient? gradient, List<BoxShadow>? boxShadow})`
- **Purpose**: Creates BoxDecoration with named parameters
- **Usage**: For container decorations with multiple properties
- **Review**: ✅ **Keep** - Essential for complex decorations
- **Alternative**: Direct BoxDecoration constructor

### BorderUtility<T> ✅ VERIFIED
- **Call Method**: `T call({Color? color, double? width, BorderStyle? style, double? strokeAlign})`
- **Purpose**: Border configuration using named parameters (NOT Border objects)
- **Additional Methods**: `T none()` - creates no border
- **Usage**: For border styling with convenience parameters
- **Review**: ✅ **Keep** - Convenient API for border creation
- **Alternative**: `all(color: Colors.red, width: 2)` or direct Border construction

### BoxBorderUtility<T> ✅ VERIFIED
- **Call Method**: `T call({Color? color, double? width, BorderStyle? style, double? strokeAlign})`
- **Purpose**: Box border configuration (wraps BorderUtility)
- **Usage**: For container borders
- **Review**: ⚠️ **Consider Deprecation** - Redundant with BorderUtility
- **Alternative**: Use `BorderUtility` directly

### GradientUtility<T> ❌ NO CALL METHOD
- **Call Method**: **NONE** - This is a parent utility that provides access to sub-utilities
- **Sub-utilities**:
  - `radial` - RadialGradientUtility
  - `linear` - LinearGradientUtility
  - `sweep` - SweepGradientUtility
- **Purpose**: Provides access to gradient type utilities
- **Usage**: `gradient.linear(colors: [Colors.red, Colors.blue])` or `gradient.radial(...)`
- **Review**: ✅ **Keep** - Organizational utility for gradient types
- **Alternative**: Direct access to specific gradient utilities

### RadialGradientUtility<T> ✅ VERIFIED
- **Call Method**: `T call({AlignmentGeometry? center, double? radius, TileMode? tileMode, AlignmentGeometry? focal, double? focalRadius, GradientTransform? transform, List<Color>? colors, List<double>? stops})`
- **Purpose**: Creates RadialGradient with named parameters
- **Usage**: For radial gradient backgrounds
- **Review**: ✅ **Keep** - Essential for radial gradients
- **Alternative**: Direct RadialGradient constructor

### LinearGradientUtility<T> ✅ VERIFIED
- **Call Method**: `T call({AlignmentGeometry? begin, AlignmentGeometry? end, TileMode? tileMode, GradientTransform? transform, List<Color>? colors, List<double>? stops})`
- **Purpose**: Creates LinearGradient with named parameters
- **Usage**: For linear gradient backgrounds
- **Review**: ✅ **Keep** - Essential for linear gradients
- **Alternative**: Direct LinearGradient constructor

### SweepGradientUtility<T> ✅ VERIFIED
- **Call Method**: `T call({AlignmentGeometry? center, double? startAngle, double? endAngle, TileMode? tileMode, GradientTransform? transform, List<Color>? colors, List<double>? stops})`
- **Purpose**: Creates SweepGradient with named parameters
- **Usage**: For sweep gradient backgrounds
- **Review**: ✅ **Keep** - Essential for sweep gradients
- **Alternative**: Direct SweepGradient constructor

### BoxShadowListUtility<T> ✅ VERIFIED
- **Call Method**: `T call(List<BoxShadow> value)`
- **Purpose**: Shadow effects using BoxShadow list
- **Usage**: For drop shadows and elevation
- **Review**: ✅ **Keep** - Important for visual effects
- **Alternative**: Direct BoxShadow list construction

### BorderRadiusGeometryUtility<T> ✅ VERIFIED
- **Call Method**: Generated based on BorderRadius fields
- **Purpose**: Border radius configuration
- **Usage**: For rounded corners
- **Review**: ✅ **Keep** - Frequently used for UI styling
- **Alternative**: Direct BorderRadius constructor

### TextStyleUtility<T> ✅ VERIFIED
- **Call Method**: Generated based on TextStyle fields
- **Purpose**: Text styling with named parameters
- **Usage**: For text appearance
- **Review**: ✅ **Keep** - Essential for text styling
- **Alternative**: Direct TextStyle constructor

## Color Utilities

### ColorUtility<T>
- **Call Method**: `T call(Color color)`
- **Purpose**: Direct color values
- **Additional Methods**:
  - `T ref(ColorToken ref)` - reference color tokens
  - Color directive methods (withOpacity, darken, lighten, etc.)
- **Usage**: For color attributes
- **Review**: ✅ **Keep** - Essential color utility with rich directive API
- **Alternative**: `MyAttribute.color(Colors.red)` or `MyAttribute(ColorDto(Colors.red))`

### ColorListUtility<T>
- **Call Method**: `T call(List<ColorDto> colors)`
- **Purpose**: Multiple color values
- **Usage**: For gradients or multi-color attributes
- **Review**: ⚠️ **Consider Deprecation** - Limited use case, complex API
- **Alternative**: `MyAttribute.colors([Colors.red, Colors.blue])` or direct constructor

### FoundationColorUtility<T, C>
- **Call Method**: `T call()`
- **Purpose**: Predefined color constants
- **Usage**: For foundation color system
- **Review**: ✅ **Keep** - Useful for design system colors
- **Alternative**: Direct color constants `MyAttribute.primaryColor()` or static getters

## Special Utilities

### TextDirectiveUtility<T>
- **Call Method**: `T call(Modifier<String> modifier)`
- **Purpose**: Text transformation modifiers
- **Additional Methods**:
  - `T capitalize()`, `T uppercase()`, `T lowercase()`, `T titleCase()`, `T sentenceCase()`
- **Usage**: For text transformations
- **Review**: ✅ **Keep** - Unique functionality for text processing
- **Alternative**: Extension methods on String or direct text processing functions

### ContextVariant
- **Call Method**: `VariantAttribute call([Attribute? p1, Attribute? p2, ..., Attribute? p20])`
- **Purpose**: Context-based style variants
- **Usage**: For responsive and conditional styling
- **Review**: ✅ **Keep** - Core feature for responsive design
- **Alternative**: `VariantAttribute.create(variant, Style.create([...attributes]))`

### NestedStyleUtility
- **Call Method**: `NestedStyleAttribute call(Style style, [Style? style2, ..., Style? style6])`
- **Purpose**: Combining multiple styles
- **Additional Methods**: `NestedStyleAttribute list(List<Style> mixes)`
- **Usage**: For style composition
- **Review**: ⚠️ **Consider Deprecation** - Style.combine() provides same functionality
- **Alternative**: `Style.combine([style1, style2, style3])` or `Style.merge(otherStyle)`

### SpreadFunctionParams<ParamT, ReturnT>
- **Call Method**: `ReturnT call([ParamT? p1, ParamT? p2, ..., ParamT? p20])`
- **Purpose**: Helper for spreading parameters to functions
- **Usage**: Internal utility for parameter handling
- **Review**: ⚠️ **Consider Deprecation** - Complex API, limited use case
- **Alternative**: Direct function calls with explicit parameters or List-based APIs

## Token Classes

All token classes follow the same pattern:

### ColorToken
- **Call Method**: `ColorRef call()`
- **Purpose**: Creates a color reference
- **Usage**: For theme-based colors
- **Review**: ✅ **Keep** - Essential for design system tokens
- **Alternative**: Direct token resolution `token.resolve(context)` or theme access

### SpaceToken
- **Call Method**: `double call()`
- **Purpose**: Returns a unique identifier (negative hashCode)
- **Usage**: For spacing tokens
- **Review**: ⚠️ **Consider Deprecation** - Confusing API (returns hashCode, not actual value)
- **Alternative**: `token.resolve(context)` for actual value or direct theme access

### RadiusToken
- **Call Method**: `RadiusRef call()`
- **Purpose**: Creates a radius reference
- **Usage**: For theme-based radius values
- **Review**: ✅ **Keep** - Consistent with other token patterns
- **Alternative**: Direct token resolution `token.resolve(context)` or theme access

### TextStyleToken
- **Call Method**: `TextStyleRef call()`
- **Purpose**: Creates a text style reference
- **Usage**: For theme-based text styles
- **Review**: ✅ **Keep** - Important for typography systems
- **Alternative**: Direct token resolution `token.resolve(context)` or theme access

### BreakpointToken
- **Call Method**: `BreakpointRef call()`
- **Purpose**: Creates a breakpoint reference
- **Usage**: For responsive design breakpoints
- **Review**: ✅ **Keep** - Essential for responsive design
- **Alternative**: Direct token resolution `token.resolve(context)` or theme access

## Widget Modifier Utilities

### PaddingModifierSpecUtility<T> ❌ NO CALL METHOD
- **Call Method**: **NONE** - Only has `only()` method and sub-utilities
- **Available Methods**:
  - `only({EdgeInsetsGeometryDto? padding})` - Creates attribute with padding
  - `padding` - EdgeInsetsGeometryUtility for padding values
- **Purpose**: Padding widget modifier configuration
- **Usage**: `padding.all(8)` or `padding.only(top: 8, left: 16)`
- **Review**: ✅ **Keep** - Essential widget modifier with functional configuration
- **Alternative**: Direct PaddingModifierSpec constructor

### SizedBoxModifierSpecUtility<T> ✅ VERIFIED
- **Call Method**: `T call({double? width, double? height})`
- **Purpose**: Size constraint modifier
- **Additional Methods**:
  - `T square(double value)` - equal width and height
  - `T as(Size size)` - from Size object
  - `width` - DoubleUtility for width only
  - `height` - DoubleUtility for height only
- **Usage**: For sizing widgets
- **Review**: ✅ **Keep** - Convenient API for sizing
- **Alternative**: Direct SizedBoxModifierSpec constructor

### AlignModifierSpecUtility<T>
- **Call Method**: `T call({AlignmentGeometry? alignment, double? widthFactor, double? heightFactor})`
- **Purpose**: Alignment modifier
- **Usage**: For widget alignment
- **Review**: ✅ **Keep** - Important for layout control
- **Alternative**: `AlignModifierSpec(alignment: Alignment.center)`

### FlexibleModifierSpecUtility<T>
- **Call Method**: `T call({int? flex, FlexFit? fit})`
- **Purpose**: Flexible widget modifier
- **Additional Methods**:
  - `T tight({int? flex})`, `T loose({int? flex})`, `T expanded({int? flex})`
- **Usage**: For flex layouts
- **Review**: ✅ **Keep** - Rich API for flex behavior
- **Alternative**: `FlexibleModifierSpec(flex: 1, fit: FlexFit.tight)` or named constructors

### AspectRatioModifierSpecUtility<T>
- **Call Method**: `T call(double value)`
- **Purpose**: Aspect ratio constraint
- **Usage**: For maintaining aspect ratios
- **Review**: ✅ **Keep** - Simple and clear API
- **Alternative**: `AspectRatioModifierSpec(aspectRatio: 16/9)`

### IntrinsicHeightModifierSpecUtility<T>
- **Call Method**: `T call()`
- **Purpose**: Intrinsic height modifier
- **Usage**: For intrinsic sizing
- **Review**: ✅ **Keep** - Simple parameterless modifier
- **Alternative**: `IntrinsicHeightModifierSpec()` or const instance

### IntrinsicWidthModifierSpecUtility<T>
- **Call Method**: `T call()`
- **Purpose**: Intrinsic width modifier
- **Usage**: For intrinsic sizing
- **Review**: ✅ **Keep** - Simple parameterless modifier
- **Alternative**: `IntrinsicWidthModifierSpec()` or const instance

### ClipRectModifierSpecUtility<T>
- **Call Method**: `T call({CustomClipper<Rect>? clipper, Clip? clipBehavior})`
- **Purpose**: Rectangle clipping
- **Usage**: For clipping widgets
- **Review**: ✅ **Keep** - Useful for custom clipping
- **Alternative**: `ClipRectModifierSpec(clipBehavior: Clip.antiAlias)`

### ClipTriangleModifierSpecUtility<T>
- **Call Method**: `T call({Clip? clipBehavior})`
- **Purpose**: Triangle clipping
- **Usage**: For triangle-shaped clipping
- **Review**: ⚠️ **Consider Deprecation** - Very specific use case
- **Alternative**: Custom clipper with `ClipPathModifierSpec` or direct widget usage

### FractionallySizedBoxModifierSpecUtility<T>
- **Call Method**: `T call({AlignmentGeometry? alignment, double? widthFactor, double? heightFactor})`
- **Purpose**: Fractional sizing
- **Usage**: For percentage-based sizing
- **Review**: ✅ **Keep** - Useful for responsive sizing
- **Alternative**: `FractionallySizedBoxModifierSpec(widthFactor: 0.5)`

### ResetModifierSpecUtility<T>
- **Call Method**: `T call()`
- **Purpose**: Reset modifier (no-op)
- **Usage**: For resetting modifiers
- **Review**: ⚠️ **Consider Deprecation** - Unclear purpose, potential confusion
- **Alternative**: Omit modifier entirely or use explicit null values

## Context Variant Utilities

### OnContextVariantUtility
- **Properties**: Platform variants (android, ios, web, etc.), breakpoint variants (small, medium, large), brightness variants (light, dark), directionality variants (ltr, rtl), orientation variants (landscape, portrait), widget state variants (hover, focus, disabled, etc.)
- **Purpose**: Provides access to all context variants
- **Usage**: Accessed via `$on` global utility
- **Review**: ✅ **Keep** - Essential for responsive and conditional styling
- **Alternative**: Direct variant instantiation `OnPlatformVariant(TargetPlatform.android)`

### WithModifierUtility<T>
- **Call Method**: Inherits from ModifierUtility
- **Purpose**: Widget modifier application
- **Usage**: For applying widget modifiers
- **Review**: ✅ **Keep** - Core modifier application utility
- **Alternative**: Direct modifier attribute creation or Style composition

## Enum Utilities

Most enum utilities follow this pattern:

### BorderStyleUtility<T>
- **Call Method**: `T call(BorderStyle value)`
- **Additional Methods**: `T none()`, `T solid()`
- **Purpose**: Border style selection
- **Usage**: For border styling
- **Review**: ✅ **Keep** - Convenient enum value access
- **Alternative**: `MyAttribute(BorderStyle.solid)` or enum extension methods

### ClipUtility<T>
- **Call Method**: `T call(Clip value)`
- **Additional Methods**: `T none()`, `T hardEdge()`, `T antiAlias()`, `T antiAliasWithSaveLayer()`
- **Purpose**: Clipping behavior
- **Usage**: For widget clipping
- **Review**: ✅ **Keep** - Useful for clipping configuration
- **Alternative**: `MyAttribute(Clip.antiAlias)` or enum extension methods

### FlexFitUtility<T>
- **Call Method**: `T call(FlexFit value)`
- **Additional Methods**: `T tight()`, `T loose()`
- **Purpose**: Flex fitting behavior
- **Usage**: For flex layouts
- **Review**: ✅ **Keep** - Clear API for flex behavior
- **Alternative**: `MyAttribute(FlexFit.tight)` or enum extension methods

### TextBaselineUtility<T>
- **Call Method**: `T call(TextBaseline value)`
- **Additional Methods**: `T alphabetic()`, `T ideographic()`
- **Purpose**: Text baseline alignment
- **Usage**: For text positioning
- **Review**: ✅ **Keep** - Important for text layout
- **Alternative**: `MyAttribute(TextBaseline.alphabetic)` or enum extension methods

### TextWidthBasisUtility<T>
- **Call Method**: `T call(TextWidthBasis value)`
- **Additional Methods**: `T parent()`, `T longestLine()`
- **Purpose**: Text width calculation basis
- **Usage**: For text layout
- **Review**: ✅ **Keep** - Useful for text layout control
- **Alternative**: `MyAttribute(TextWidthBasis.parent)` or enum extension methods

## Special Cases

### GapUtility<T>
- **Call Method**: `T call(double value)`
- **Additional Methods**: `T ref(SpaceToken ref)`
- **Purpose**: Gap spacing
- **Usage**: For spacing in layouts
- **Review**: ✅ **Keep** - Essential for layout spacing
- **Alternative**: `MyAttribute.gap(8.0)` or direct constructor

### RadiusUtility<T> ✅ VERIFIED
- **Call Method**: `T call(double radius)` - creates circular radius
- **Additional Methods**:
  - `T ref(RadiusToken ref)` - from radius token
  - Generated methods from Radius constructors
- **Purpose**: Radius values with convenient circular creation
- **Usage**: For border radius
- **Review**: ✅ **Keep** - Convenient circular radius creation
- **Alternative**: Direct Radius.circular() constructor

### OffsetUtility<T> ✅ VERIFIED - INCONSISTENT API
- **Call Method**: **NONE** - Uses `T as(Offset offset)` instead
- **Available Methods**:
  - `T as(Offset offset)` - Creates attribute from Offset
  - `T zero()` - Creates Offset.zero
  - `T infinite()` - Creates Offset.infinite
- **Purpose**: Offset positioning
- **Usage**: For positioning elements
- **Review**: ⚠️ **CRITICAL ISSUE** - Inconsistent API (uses `as` instead of `call`)
- **Alternative**: Should be `T call(Offset offset)` for consistency

### ImageRepeatUtility<T> ✅ VERIFIED
- **Call Method**: `T call([ImageRepeat value = ImageRepeat.repeat])`
- **Purpose**: Image repeat behavior with default value
- **Additional Methods**: Generated methods for each ImageRepeat enum value
- **Usage**: For background images
- **Review**: ✅ **Keep** - Useful for image styling with sensible default
- **Alternative**: Direct ImageRepeat enum values or generated enum methods

## Generated Utility Pattern

Many utilities are generated and follow this pattern:
```dart
T call({
  FieldType1? field1,
  FieldType2? field2,
  // ... more fields
}) {
  return only(
    field1: field1,
    field2: field2,
    // ... more fields
  );
}
```

- **Review**: ✅ **Keep** - Essential pattern for complex DTOs
- **Purpose**: Provides flexible attribute creation with named parameters
- **Alternative**: Direct DTO constructors or builder pattern
- **Usage**: Used for complex DTOs with multiple optional parameters

## Critical Issues Found

### API Inconsistencies That Need Immediate Attention

1. **DecorationUtility** - Misleading documentation
   - **Issue**: Does NOT have a call method accepting Decoration objects
   - **Reality**: Parent utility providing access to BoxDecorationUtility and ShapeDecorationUtility
   - **Fix**: Update documentation to clarify it's an organizational utility

2. **BorderUtility** - Parameter mismatch
   - **Issue**: Does NOT accept Border objects as expected
   - **Reality**: Uses named parameters (color, width, style, strokeAlign)
   - **Fix**: Documentation should clarify it creates borders from parameters, not Border objects

3. **EdgeInsetsGeometryUtility** - Unexpected API
   - **Issue**: Does NOT accept EdgeInsetsGeometry objects
   - **Reality**: Uses CSS-like positional parameters (p1, p2, p3, p4)
   - **Fix**: This is actually a good API, but needs clear documentation

4. **OffsetUtility** - Inconsistent method naming
   - **Issue**: Uses `as()` instead of `call()` method
   - **Reality**: Breaks the standard utility pattern
   - **Fix**: Should be renamed to `call()` for consistency

5. **PaddingModifierSpecUtility** - No call method
   - **Issue**: Documentation suggests it has a call method
   - **Reality**: Only has `only()` method and sub-utilities
   - **Fix**: Update documentation to reflect actual API

## Deprecation Recommendations

### High Priority for Deprecation

1. **SpaceToken.call()** - Returns hashCode instead of actual value, confusing API
   - **Alternative**: Use `token.resolve(context)` for actual spacing value

2. **NestedStyleUtility** - Redundant with existing Style.combine() functionality
   - **Alternative**: Use `Style.combine([style1, style2])` or `style1.merge(style2)`

3. **BoxBorderUtility** - Duplicates BorderUtility functionality
   - **Alternative**: Use `BorderUtility` directly

4. **SpreadFunctionParams** - Complex API with limited use cases
   - **Alternative**: Use explicit parameter lists or List-based APIs

5. **OffsetUtility.as()** - Inconsistent naming (should be `call()`)
   - **Alternative**: Rename to `call()` or use direct constructor

### Medium Priority for Deprecation

1. **ColorListUtility** - Limited use case, complex API
   - **Alternative**: Use direct list constructors or factory methods

2. **ClipTriangleModifierSpecUtility** - Very specific use case
   - **Alternative**: Use custom clipper with `ClipPathModifierSpec`

3. **ResetModifierSpecUtility** - Unclear purpose and potential confusion
   - **Alternative**: Omit modifier entirely or use explicit null values

### Migration Strategy

When deprecating utilities, provide clear migration paths:

```dart
@Deprecated('Use Style.combine([style1, style2]) instead.')
NestedStyleAttribute call(Style style1, [Style? style2]) {
  // Implementation
}
```

For token call methods that should be replaced:
```dart
@Deprecated('Use token.resolve(context) to get the actual value.')
double call() => hashCode * -1.0;
```

## Alternative Patterns

### Direct Attribute Construction
```dart
// Instead of: utility.call(value)
// Use: MyAttribute(value)
final attribute = BoxSpecAttribute(color: Colors.red);
```

### Factory Methods
```dart
// Instead of: utility.call(params...)
// Use: MyAttribute.factoryMethod(params...)
final attribute = BoxSpecAttribute.withColor(Colors.red);
```

### Extension Methods
```dart
// Instead of: utility.call(enumValue)
// Use: enumValue.toAttribute()
extension BorderStyleExt on BorderStyle {
  BoxSpecAttribute toBoxAttribute() => BoxSpecAttribute(borderStyle: this);
}
```

### Style Composition
```dart
// Instead of: nestedUtility.call(style1, style2)
// Use: Style.combine([style1, style2])
final combinedStyle = Style.combine([baseStyle, overrideStyle]);
```

## Verification Summary

### ✅ Utilities with Verified Call Methods

1. **EdgeInsetsGeometryUtility** - `call(double p1, [double? p2, double? p3, double? p4])`
2. **BoxDecorationUtility** - `call({BoxBorder? border, ...})` (8 named parameters)
3. **BorderUtility** - `call({Color? color, double? width, BorderStyle? style, double? strokeAlign})`
4. **BoxBorderUtility** - `call({Color? color, double? width, BorderStyle? style, double? strokeAlign})`
5. **RadialGradientUtility** - `call({AlignmentGeometry? center, ...})` (8 named parameters)
6. **LinearGradientUtility** - `call({AlignmentGeometry? begin, ...})` (6 named parameters)
7. **SweepGradientUtility** - `call({AlignmentGeometry? center, ...})` (7 named parameters)
8. **SizedBoxModifierSpecUtility** - `call({double? width, double? height})`
9. **AlignModifierSpecUtility** - `call({AlignmentGeometry? alignment, double? widthFactor, double? heightFactor})`
10. **FlexibleModifierSpecUtility** - `call({int? flex, FlexFit? fit})`
11. **AspectRatioModifierSpecUtility** - `call(double value)`
12. **IntrinsicHeightModifierSpecUtility** - `call()`
13. **ClipRectModifierSpecUtility** - `call({CustomClipper<Rect>? clipper, Clip? clipBehavior})`
14. **ClipTriangleModifierSpecUtility** - `call({Clip? clipBehavior})`
15. **FractionallySizedBoxModifierSpecUtility** - `call({AlignmentGeometry? alignment, double? widthFactor, double? heightFactor})`
16. **ResetModifierSpecUtility** - `call()`
17. **RadiusUtility** - `call(double radius)`
18. **ImageRepeatUtility** - `call([ImageRepeat value = ImageRepeat.repeat])`
19. **GapUtility** - `call(double value)`
20. **SpacingSideUtility** - `call(double value)`

### ❌ Utilities WITHOUT Call Methods

1. **DecorationUtility** - Parent utility, provides `box` and `shape` sub-utilities
2. **GradientUtility** - Parent utility, provides `radial`, `linear`, `sweep` sub-utilities
3. **PaddingModifierSpecUtility** - Only has `only()` method and `padding` sub-utility

### ⚠️ Utilities with Non-Standard APIs

1. **OffsetUtility** - Uses `as(Offset offset)` instead of `call()`
2. **SpaceToken** - `call()` returns hashCode, not actual value
3. **All Token Classes** - `call()` returns reference objects, not resolved values

### 📋 Common Patterns Identified

1. **Generated DTO Utilities** - Use named parameters matching DTO fields
2. **Scalar Utilities** - Accept single values of their type
3. **Enum Utilities** - Accept enum values with optional defaults
4. **Modifier Utilities** - Use named parameters for widget modifier properties
5. **Parent Utilities** - Provide access to sub-utilities without own call methods
6. **Token Utilities** - Return reference objects that resolve in context

### 🔧 Recommended Actions

1. **Fix OffsetUtility** - Rename `as()` to `call()` for consistency
2. **Clarify Documentation** - Update docs for utilities without call methods
3. **Consider SpaceToken API** - The hashCode return is confusing
4. **Standardize Patterns** - Ensure consistent naming across all utilities
5. **Add Type Safety** - Consider stronger typing for utility parameters
