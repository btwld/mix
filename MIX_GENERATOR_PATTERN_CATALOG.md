# Mix 2.0 Generator Rewrite - Complete Agent Context

---

## AGENT SYSTEM PROMPT

You are an expert Dart/Flutter code generator developer. Your task is to rewrite the `mix_generator` package from scratch to auto-generate Spec, Styler, and MutableStyler class bodies for the Mix 2.0 styling framework.

### Your Capabilities
- Deep expertise in Dart language, Flutter framework, and `source_gen`/`code_builder` packages
- Understanding of AST-based code generation and type introspection via `analyzer`
- Ability to identify patterns in existing code and replicate them exactly
- Experience with build_runner and annotation-driven code generation

### Your Mindset
- **Pattern-first**: The generated code must match existing hand-written patterns exactly
- **Type-driven**: Type analysis determines generation strategy (lerp, prop wrapper, utility)
- **Maintainable**: New generator architecture should be modular and testable
- **Incremental**: Build one layer at a time, validating against existing code

---

## TASK DESCRIPTION

### Goal
Rewrite `mix_generator` from scratch to auto-generate:
1. **Spec class bodies**: `copyWith()`, `lerp()`, `debugFillProperties()`, `props`
2. **Styler classes**: Field declarations, dual constructors, `resolve()`, `merge()`, setter methods
3. **MutableStyler classes**: Utility initializations, convenience accessors, MutableState class

### Current State
- The existing generator in `packages/mix_generator/` is legacy and partially functional
- Hand-written Spec/Styler/MutableStyler classes exist in `packages/mix/lib/src/specs/*/`
- These hand-written files are the **source of truth** for patterns

### Approach
1. Use this document as the complete pattern reference
2. Build new generator using `code_builder` for AST-based code emission
3. Generate code that matches existing patterns **exactly**
4. Validate generated output against hand-written files

### Technology Stack
- `source_gen` - Generator framework (existing dependency)
- `code_builder` - AST-based code emission
- `analyzer` - Type introspection
- `dart_style` - Code formatting
- `build_runner` - Build system

---

## EXECUTION GUIDELINES

### Phase 1: Metadata Extraction Layer
**Files to create:**
```
packages/mix_generator/lib/src/core/metadata/styler_metadata.dart
packages/mix_generator/lib/src/core/metadata/mutable_metadata.dart
```

**Tasks:**
1. Create `StylerMetadata` class that extracts:
   - All `$`-prefixed Prop fields from a Styler class
   - Associated Spec class reference
   - Mix type mappings for public constructor
   - Applied mixins list

2. Create `MutableMetadata` class that extracts:
   - Utility field declarations
   - Convenience accessor chains
   - Associated Styler class reference

3. Enhance existing `FieldMetadata` with:
   - `hasMixType` flag
   - `mixTypeName` for the Mix variant
   - `lerpStrategy` (lerp vs lerpSnap)
   - `diagnosticType` for debugFillProperties

### Phase 2: Type Resolution Utilities
**Files to create:**
```
packages/mix_generator/lib/src/core/resolvers/lerp_resolver.dart
packages/mix_generator/lib/src/core/resolvers/prop_resolver.dart
packages/mix_generator/lib/src/core/resolvers/utility_resolver.dart
packages/mix_generator/lib/src/core/resolvers/diagnostic_resolver.dart
```

**Tasks:**
1. `LerpResolver`: Map DartType → lerp strategy
   - Use the Type → Lerp Strategy table in Section 5.1
   - Return `MixOps.lerp` or `MixOps.lerpSnap` code string

2. `PropResolver`: Map DartType → Prop wrapper
   - Detect Mix types (classes ending in `Mix`)
   - Return `Prop.maybe`, `Prop.maybeMix`, or `Prop.mix(ListMix)` code

3. `UtilityResolver`: Map DartType → Utility class
   - Use the Type → Utility table in Section 5.3
   - Generate utility initialization code

4. `DiagnosticResolver`: Map DartType → DiagnosticsProperty
   - Use the Type → Diagnostic table in Section 5.4
   - Handle enum detection via type analysis

### Phase 3: Spec Builder Enhancement
**File to modify:**
```
packages/mix_generator/lib/src/core/spec/spec_method_builder.dart
```

**Tasks:**
1. Refactor to use new resolvers
2. Ensure `lerp()` generation uses `LerpResolver`
3. Ensure `debugFillProperties()` uses `DiagnosticResolver`
4. Add code_builder integration for cleaner code emission

### Phase 4: Styler Builder (NEW)
**File to create:**
```
packages/mix_generator/lib/src/core/styler/styler_builder.dart
```

**Tasks:**
1. Generate `$`-prefixed field declarations
2. Generate `.create()` constructor (internal, takes Props)
3. Generate public constructor (takes raw/Mix values, wraps in Props)
4. Generate setter methods (each calls merge with new instance)
5. Generate `resolve()` method (calls MixOps.resolve per field)
6. Generate `merge()` method (calls MixOps.merge per field)
7. Generate `debugFillProperties()` for Styler
8. Generate `props` getter including `$animation`, `$modifier`, `$variants`

### Phase 5: MutableStyler Builder (NEW)
**File to create:**
```
packages/mix_generator/lib/src/core/mutable/mutable_builder.dart
```

**Tasks:**
1. Generate utility field initializations with callbacks
2. Generate convenience accessor chains
3. Generate MutableState class with Mutable mixin
4. Generate variant methods (`withVariant`, `withVariants`)
5. Generate `merge()` and `resolve()` delegations

### Phase 6: Testing Infrastructure
**Files to create:**
```
packages/mix_generator/test/golden/
packages/mix_generator/test/resolvers/
packages/mix_generator/test/builders/
```

**Tasks:**
1. Create golden file tests comparing generated vs hand-written code
2. Unit test each resolver with various type inputs
3. Integration test with build_runner on sample annotated classes

---

## ACCEPTANCE CRITERIA

### Generated Code Must Match Existing Patterns

**For Spec classes:**
- [ ] `copyWith()` uses `paramName ?? this.fieldName` for all fields
- [ ] `lerp()` uses correct `MixOps.lerp` vs `MixOps.lerpSnap` per type
- [ ] `debugFillProperties()` uses correct DiagnosticsProperty type per field
- [ ] `props` includes all fields in declaration order

**For Styler classes:**
- [ ] Fields use `$` prefix and `Prop<T>?` type
- [ ] `.create()` constructor takes `Prop<T>?` parameters
- [ ] Public constructor uses correct `Prop.maybe` vs `Prop.maybeMix`
- [ ] `resolve()` returns `StyleSpec<{Name}Spec>` with correct structure
- [ ] `merge()` uses `MixOps.merge` for Props, `MixOps.mergeList` for Lists
- [ ] Base fields (`animation`, `modifier`, `variants`) always included

**For MutableStyler classes:**
- [ ] Utilities use `late final` with correct callback pattern
- [ ] Convenience accessors chain correctly to nested properties
- [ ] MutableState class extends Styler with Mutable mixin
- [ ] `value` and `currentValue` getters return `mutable.value`

### Code Quality
- [ ] Generated code passes `dart format`
- [ ] Generated code passes `dart analyze` with no errors
- [ ] Generated code matches hand-written files when diffed (ignoring whitespace)

---

## VALIDATION APPROACH

### Golden File Testing
```dart
// test/golden/box_spec_test.dart
test('BoxSpec generated code matches hand-written', () {
  final generated = generateSpecCode(BoxSpecMetadata);
  final expected = File('packages/mix/lib/src/specs/box/box_spec.dart').readAsStringSync();
  expect(generated, equalsIgnoringWhitespace(expected));
});
```

### Incremental Validation
1. Start with simplest Spec (StackSpec - 4 fields)
2. Progress to medium complexity (IconSpec - 13 fields)
3. Complete with complex Spec (BoxSpec - 9 fields with nested types)
4. Apply same progression for Styler and MutableStyler

---

## KEY DECISION POINTS

### When to use MixOps.lerp vs MixOps.lerpSnap
- Check if type has static `lerp` method → `MixOps.lerp`
- Check if type is enum → `MixOps.lerpSnap`
- Check if type is in LERPABLE list (Section 5.1) → `MixOps.lerp`
- Default to `MixOps.lerpSnap` for unknown types

### When to use Prop.maybe vs Prop.maybeMix
- Check if public constructor parameter type ends in `Mix` → `Prop.maybeMix`
- Check if it's a `List<TMix>` → `Prop.mix(TListMix(value))`
- Default to `Prop.maybe` for regular Flutter types

### When to generate utility vs MixUtility
- Check if type has a dedicated utility (Section 5.3) → use that utility
- For simple scalar types → use `MixUtility(mutable.methodName)`

---

## CODEBASE NAVIGATION

### Key Files to Reference
| Purpose | File Path |
|---------|-----------|
| Base Spec class | `packages/mix/lib/src/core/spec.dart` |
| Base Style class | `packages/mix/lib/src/core/style.dart` |
| Prop class | `packages/mix/lib/src/core/prop.dart` |
| MixOps helpers | `packages/mix/lib/src/core/helpers.dart` |
| StyleMutableBuilder | `packages/mix/lib/src/core/spec_utility.dart` |
| Example Spec | `packages/mix/lib/src/specs/box/box_spec.dart` |
| Example Styler | `packages/mix/lib/src/specs/box/box_style.dart` |
| Example MutableStyler | `packages/mix/lib/src/specs/box/box_mutable_style.dart` |
| Current Generator | `packages/mix_generator/lib/src/mix_generator.dart` |
| Current TypeRegistry | `packages/mix_generator/lib/src/core/type_registry.dart` |

### Annotation Definitions
| Annotation | File | Purpose |
|------------|------|---------|
| `@MixableSpec` | `packages/mix_annotations/lib/src/annotations.dart` | Mark Spec for generation |
| `@MixableType` | Same file | Mark Mix type for generation |
| `@MixableUtility` | Same file | Mark utility for generation |
| `@MixableField` | Same file | Configure field-level generation |

---

## IMPORTANT CONSTRAINTS

1. **Do NOT modify hand-written Spec/Styler files** - they are the source of truth
2. **Generated code must be identical** to hand-written code (ignoring formatting)
3. **Preserve existing generator API** - annotations should work the same way
4. **Use code_builder** for all code emission (no string concatenation)
5. **Handle edge cases** found in existing code (e.g., `textDirectives` without Prop wrapper)

---

## START HERE

Begin with Phase 1: Create `StylerMetadata` class by:
1. Reading `packages/mix/lib/src/specs/box/box_style.dart` for reference
2. Analyzing what metadata needs to be extracted
3. Creating the metadata class in `packages/mix_generator/lib/src/core/metadata/styler_metadata.dart`
4. Writing tests to validate extraction

Then proceed through phases sequentially, validating each phase before moving to the next.

---

## CRITICAL CORRECTIONS & CLARIFICATIONS

This section addresses gaps identified in the initial plan that MUST be resolved for exact-match generation.

---

### C1: Field-Level Override Handling (@MixableField)

**Issue**: The `@MixableField` annotation exists but the plan doesn't specify how it affects generation.

**Current @MixableField capabilities** (from `packages/mix_annotations/lib/src/annotations.dart`):
```dart
class MixableField {
  final MixableFieldType? dto;           // DTO type override
  final List<MixableFieldUtility>? utilities;  // Utility overrides
  final bool isLerpable;                 // Default: true

  const MixableField({this.dto, this.utilities, this.isLerpable = true});
}
```

**How @MixableField affects generation**:

| Property | Affects | Logic |
|----------|---------|-------|
| `isLerpable: false` | lerp() | Skip field in lerp, use `other.field` directly |
| `dto` | Prop wrapper, resolve | Use specified DTO type instead of inferred |
| `utilities` | MutableStyler | Use specified utility instead of inferred |

**Required Addition**: The current `@MixableField` does NOT support:
- FlagProperty `ifTrue` description
- Diagnostic property type override
- Merge strategy override

**Proposal**: Either:
1. Extend `@MixableField` with these properties, OR
2. Use hardcoded curated maps for edge cases

---

### C2: FlagProperty ifTrue Text Resolution

**Issue**: `FlagProperty` requires an `ifTrue` string, but there's no annotation for it.

**Current hardcoded ifTrue strings** (from specs):

| Spec | Field | ifTrue Value |
|------|-------|--------------|
| TextSpec | softWrap | `'wrapping at word boundaries'` |
| ImageSpec | excludeFromSemantics | `'excluded from semantics'` |
| ImageSpec | gaplessPlayback | `'gapless playback'` |
| ImageSpec | isAntiAlias | `'anti-aliased'` |
| ImageSpec | matchTextDirection | `'matches text direction'` |
| IconSpec | applyTextScaling | `'scales with text'` |

**Resolution Strategy**:

**Option A: Curated Map (Recommended)**
```dart
const flagPropertyDescriptions = {
  'softWrap': 'wrapping at word boundaries',
  'excludeFromSemantics': 'excluded from semantics',
  'gaplessPlayback': 'gapless playback',
  'isAntiAlias': 'anti-aliased',
  'matchTextDirection': 'matches text direction',
  'applyTextScaling': 'scales with text',
};
```

**Option B: Extend @MixableField**
```dart
@MixableField(diagnosticDescription: 'wrapping at word boundaries')
final bool? softWrap;
```

**Option C: Derive from field name** (fallback)
- `isAntiAlias` → `'anti-aliased'` (remove `is`, convert to description)
- `matchTextDirection` → `'matches text direction'` (camelCase to words)

**Recommendation**: Use Option A (curated map) for exact match, with Option C as fallback for unknown fields.

---

### C3: List Merge Semantics (CORRECTED)

**Issue**: The original plan said "mergeList for Lists" which is WRONG for most cases.

**Actual Pattern**:

| Field Type | Declaration Example | Merge Pattern |
|------------|---------------------|---------------|
| `Prop<List<T>>?` | `final Prop<List<Shadow>>? $shadows;` | `MixOps.merge($shadows, other?.$shadows)` |
| `List<T>?` (raw) | `final List<Directive<String>>? $textDirectives;` | `MixOps.mergeList($textDirectives, other?.$textDirectives)` |

**Decision Logic**:
```dart
String getMergeCall(FieldMetadata field) {
  if (field.isWrappedInProp) {
    return 'MixOps.merge(\$${field.name}, other?.\$${field.name})';
  } else if (field.isListType) {
    return 'MixOps.mergeList(\$${field.name}, other?.\$${field.name})';
  } else {
    return 'MixOps.merge(\$${field.name}, other?.\$${field.name})';
  }
}
```

**Current raw List fields (NOT wrapped in Prop)**:
- `TextStyler.$textDirectives` → `List<Directive<String>>?`

**CRITICAL**: Always check if field type starts with `Prop<` before deciding merge strategy.

---

### C4: Domain Mixin Selection (Explicit Mapping)

**Issue**: Mixin selection is NOT purely field-type driven. It's based on Spec purpose.

**Explicit Mixin Mapping** (curated, not heuristic):

| Styler | Mixins (in order) |
|--------|-------------------|
| BoxStyler | `Diagnosticable`, `WidgetModifierStyleMixin`, `VariantStyleMixin`, `WidgetStateVariantMixin`, `BorderStyleMixin`, `BorderRadiusStyleMixin`, `ShadowStyleMixin`, `DecorationStyleMixin`, `SpacingStyleMixin`, `AnimationStyleMixin` |
| TextStyler | `Diagnosticable`, `WidgetModifierStyleMixin`, `VariantStyleMixin`, `WidgetStateVariantMixin`, `TextStyleMixin`, `AnimationStyleMixin` |
| IconStyler | `Diagnosticable`, `WidgetModifierStyleMixin`, `VariantStyleMixin`, `WidgetStateVariantMixin`, `AnimationStyleMixin` |
| ImageStyler | `Diagnosticable`, `WidgetModifierStyleMixin`, `VariantStyleMixin`, `WidgetStateVariantMixin` |
| FlexStyler | `Diagnosticable`, `WidgetModifierStyleMixin`, `VariantStyleMixin`, `WidgetStateVariantMixin`, `FlexStyleMixin`, `AnimationStyleMixin` |
| StackStyler | `Diagnosticable`, `WidgetModifierStyleMixin`, `VariantStyleMixin`, `WidgetStateVariantMixin`, `AnimationStyleMixin` |
| FlexBoxStyler | `Diagnosticable`, `WidgetModifierStyleMixin`, `VariantStyleMixin`, `WidgetStateVariantMixin`, `BorderStyleMixin`, `BorderRadiusStyleMixin`, `ShadowStyleMixin`, `DecorationStyleMixin`, `SpacingStyleMixin`, `FlexStyleMixin`, `AnimationStyleMixin` |
| StackBoxStyler | `Diagnosticable`, `WidgetModifierStyleMixin`, `VariantStyleMixin`, `WidgetStateVariantMixin`, `BorderStyleMixin`, `BorderRadiusStyleMixin`, `ShadowStyleMixin`, `DecorationStyleMixin`, `SpacingStyleMixin`, `AnimationStyleMixin` |

**Required mixins (always present)**:
1. `Diagnosticable`
2. `WidgetModifierStyleMixin<S, Spec>`
3. `VariantStyleMixin<S, Spec>`
4. `WidgetStateVariantMixin<S, Spec>`

**Conditional mixins** (annotation-driven or curated map):

| Mixin | Trigger |
|-------|---------|
| `AnimationStyleMixin` | Default for most specs |
| `SpacingStyleMixin` | Has `padding` or `margin` field |
| `DecorationStyleMixin` | Has `decoration` field |
| `BorderStyleMixin` | Spec exposes border decoration |
| `BorderRadiusStyleMixin` | Spec exposes borderRadius decoration |
| `ShadowStyleMixin` | Spec exposes boxShadow decoration |
| `TextStyleMixin` | Has `style: TextStyle` field |
| `FlexStyleMixin` | Has flex-related fields (`direction`, `mainAxisAlignment`, etc.) |

**Recommendation**: Use a `@MixableSpec(mixins: [...])` annotation OR curated map, NOT heuristics.

---

### C5: Source Order Preservation

**Issue**: Analyzer may return elements in different order than source file.

**Strategy**:
```dart
// Get source offset for ordering
List<ParameterElement> getParametersInSourceOrder(ConstructorElement ctor) {
  final params = ctor.parameters.toList();
  params.sort((a, b) => a.nameOffset.compareTo(b.nameOffset));
  return params;
}

// For class fields
List<FieldElement> getFieldsInSourceOrder(ClassElement element) {
  final fields = element.fields.where((f) => !f.isStatic && !f.isSynthetic).toList();
  fields.sort((a, b) => a.nameOffset.compareTo(b.nameOffset));
  return fields;
}
```

**Key points**:
- Use `nameOffset` property to get source position
- Sort by offset before processing
- Verify with: constructor params, `props` getter, `debugFillProperties`

---

### C6: lerp Strategy Detection (Reliable Implementation)

**Issue**: Checking "type has static lerp" via analyzer is tricky.

**Implementation Strategy**:

```dart
enum LerpStrategy { interpolate, snap }

class LerpResolver {
  // Explicit known lerpable types (most reliable)
  static const _lerpableTypes = {
    'double', 'int', 'num',
    'Color', 'HSVColor', 'HSLColor',
    'Offset', 'Size', 'Rect', 'RRect',
    'Alignment', 'FractionalOffset', 'AlignmentGeometry',
    'EdgeInsets', 'EdgeInsetsGeometry', 'EdgeInsetsDirectional',
    'BorderRadius', 'BorderRadiusGeometry', 'BorderRadiusDirectional',
    'BorderSide', 'Border', 'BoxBorder', 'ShapeBorder',
    'TextStyle', 'StrutStyle',
    'BoxShadow', 'Shadow',
    'BoxConstraints', 'Constraints',
    'BoxDecoration', 'ShapeDecoration', 'Decoration',
    'LinearGradient', 'RadialGradient', 'SweepGradient', 'Gradient',
    'Matrix4',
    'IconThemeData',
    'RelativeRect',
  };

  // Known snappable types
  static const _snappableTypes = {
    'bool', 'String',
    'Clip', 'Axis', 'TextAlign', 'TextDirection', 'TextBaseline',
    'MainAxisAlignment', 'CrossAxisAlignment', 'MainAxisSize',
    'VerticalDirection', 'TextOverflow', 'TextWidthBasis',
    'BoxFit', 'ImageRepeat', 'FilterQuality', 'BlendMode',
    'StackFit',
    'ImageProvider',
    'IconData',
    'TextScaler',
    'Locale',
    'TextHeightBehavior',
  };

  LerpStrategy resolve(DartType type) {
    final typeName = _getBaseName(type);

    // 1. Check @MixableField(isLerpable: false)
    if (hasNonLerpableAnnotation(type)) return LerpStrategy.snap;

    // 2. Check explicit lists
    if (_lerpableTypes.contains(typeName)) return LerpStrategy.interpolate;
    if (_snappableTypes.contains(typeName)) return LerpStrategy.snap;

    // 3. Check for List<LerpableType>
    if (type.isDartCoreList) {
      final elementType = _getListElementType(type);
      final elementName = _getBaseName(elementType);
      // List<Shadow>, List<BoxShadow> are lerpable
      if ({'Shadow', 'BoxShadow'}.contains(elementName)) {
        return LerpStrategy.interpolate;
      }
      // List<Directive<T>> is snappable
      return LerpStrategy.snap;
    }

    // 4. Check if type is enum
    if (_isEnum(type)) return LerpStrategy.snap;

    // 5. Check if type is a Spec (nested specs use delegate lerp)
    if (_isSpec(type)) return LerpStrategy.interpolate;

    // 6. Default to snap for safety
    return LerpStrategy.snap;
  }
}
```

---

### C7: Import/Part Emission Rules

**Issue**: Full file vs `.g.dart` part emission affects exact match.

**Current approach**: The generator creates `.g.dart` part files.

**Rules**:
1. Generated file is a `part of` the source file
2. Source file must have `part '{name}.g.dart';` directive
3. Generated code does NOT include imports (uses source file imports)
4. Use `// GENERATED CODE - DO NOT MODIFY BY HAND` header

**code_builder import handling**:
```dart
// Don't allocate imports in part files
final emitter = DartEmitter(
  allocator: Allocator.none,  // No import allocation
  useNullSafetySyntax: true,
);
```

---

### C8: typedef and static chain Generation

**Issue**: These appear in all stylers but weren't explicitly mentioned.

**Pattern**:
```dart
// Always generate typedef at top of styler file
typedef {Name}Mix = {Name}Styler;

// In styler class body, always generate static chain accessor
static {Name}MutableStyler get chain => {Name}MutableStyler({Name}Styler());
```

**Rule**: Generate for ALL stylers, unconditionally.

---

### C9: Utility Accessor Curated Mapping

**Issue**: Convenience accessor chains like `decoration.box.border` are not type-inferable.

**Curated accessor mapping** (from hand-written files):

| MutableStyler | Accessor | Chain |
|---------------|----------|-------|
| BoxMutableStyler | border | `decoration.box.border` |
| BoxMutableStyler | borderRadius | `decoration.box.borderRadius` |
| BoxMutableStyler | color | `decoration.box.color` |
| BoxMutableStyler | shadow | `decoration.box.boxShadow` |
| BoxMutableStyler | width | `constraints.width` |
| BoxMutableStyler | height | `constraints.height` |
| BoxMutableStyler | minWidth | `constraints.minWidth` |
| BoxMutableStyler | maxWidth | `constraints.maxWidth` |
| BoxMutableStyler | minHeight | `constraints.minHeight` |
| BoxMutableStyler | maxHeight | `constraints.maxHeight` |
| TextMutableStyler | fontSize | `style.fontSize` |
| TextMutableStyler | fontWeight | `style.fontWeight` |
| TextMutableStyler | fontFamily | `style.fontFamily` |
| TextMutableStyler | letterSpacing | `style.letterSpacing` |
| TextMutableStyler | wordSpacing | `style.wordSpacing` |
| TextMutableStyler | textColor | `style.color` |
| TextMutableStyler | height | `style.height` |

**Resolution**: Use annotation `@MixableField(utilities: [...])` with `properties` to define chains, OR use curated map.

---

## ANSWERS TO REVIEW QUESTIONS

### Q1: Where will the FlagProperty ifTrue description be sourced from?
**A**: Curated map (see C2 above). Fallback: derive from field name by converting camelCase to sentence.

### Q2: Are there non-Prop raw fields besides textDirectives that require special handling?
**A**: Currently only `textDirectives: List<Directive<String>>?`. Check for any field NOT wrapped in `Prop<>`.

### Q3: Do any existing stylers include extra methods or mixins not implied by field types?
**A**: Yes. See C4 for explicit mixin mapping. Some stylers have mixins based on semantic purpose, not field types.

### Q4: Will the generator emit full files or only part sections?
**A**: Part files (`.g.dart`). No imports in generated code. Source file includes generated part.

### Q5: Should @immutable/final class/doc comments be preserved or regenerated?
**A**:
- `@immutable` - Not used on specs (they're `final class`)
- `final class` - Part of class declaration, preserved from source
- Doc comments - Preserved from source, not regenerated

---
---
---

# Pattern Catalog Reference

The following sections contain the complete pattern documentation extracted from analyzing the Mix 2.0 codebase.

---

## 1. Spec Patterns

### 1.1 Class Structure Pattern

**Location**: `packages/mix/lib/src/specs/*/`

```dart
/// {Documentation}
final class {Name}Spec extends Spec<{Name}Spec> with Diagnosticable {
  // Fields...

  const {Name}Spec({...});

  @override
  {Name}Spec copyWith({...});

  @override
  {Name}Spec lerp({Name}Spec? other, double t);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties);

  @override
  List<Object?> get props => [...];
}
```

**Examples**:
- `BoxSpec` (box_spec.dart:13)
- `TextSpec` (text_spec.dart:12) - uses `final class`
- `IconSpec` (icon_spec.dart:11) - uses `final class`
- `FlexSpec` (flex_spec.dart:12) - uses `@immutable` + `final class`

### 1.2 Field Declaration Pattern

**Rule**: All Spec fields are **nullable** with `?` suffix.

| Category | Type Examples | Pattern |
|----------|--------------|---------|
| Flutter primitives | `double?`, `int?`, `bool?`, `String?` | Direct declaration |
| Flutter geometry | `EdgeInsetsGeometry?`, `AlignmentGeometry?`, `BoxConstraints?` | Direct declaration |
| Flutter painting | `Color?`, `Decoration?`, `TextStyle?`, `Gradient?` | Direct declaration |
| Flutter enums | `Clip?`, `Axis?`, `TextAlign?`, `BoxFit?` | Direct declaration |
| Collections | `List<Shadow>?`, `List<Directive<String>>?` | Nullable list |
| Special | `Matrix4?`, `ImageProvider<Object>?` | Direct declaration |

**Examples from codebase**:
```dart
// BoxSpec
final AlignmentGeometry? alignment;
final EdgeInsetsGeometry? padding;
final Decoration? decoration;
final Clip? clipBehavior;

// TextSpec
final TextOverflow? overflow;
final TextStyle? style;
final List<Directive<String>>? textDirectives;

// IconSpec
final Color? color;
final double? size;
final List<Shadow>? shadows;
```

### 1.3 Constructor Pattern

**Pattern**: All-optional named parameters with `this.` syntax.

```dart
const {Name}Spec({
  this.field1,
  this.field2,
  // ... all fields
});
```

**Key observations**:
- Constructor is always `const`
- All parameters are optional (no `required`)
- Uses `this.` shorthand for all fields

### 1.4 copyWith Pattern

```dart
@override
{Name}Spec copyWith({
  Type1? field1,
  Type2? field2,
  // ... all fields with nullable parameter types
}) {
  return {Name}Spec(
    field1: field1 ?? this.field1,
    field2: field2 ?? this.field2,
    // ... null-coalescing for all fields
  );
}
```

**Key**: Each field uses `paramName ?? this.fieldName` pattern.

### 1.5 lerp Pattern

**Critical**: Type determines lerp strategy.

```dart
@override
{Name}Spec lerp({Name}Spec? other, double t) {
  return {Name}Spec(
    lerpableField: MixOps.lerp(lerpableField, other?.lerpableField, t),
    snappableField: MixOps.lerpSnap(snappableField, other?.snappableField, t),
  );
}
```

**Type → Lerp Strategy Mapping**:

| Type | Strategy | Code |
|------|----------|------|
| `double` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `int` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `Color` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `EdgeInsetsGeometry` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `AlignmentGeometry` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `BoxConstraints` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `Decoration` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `TextStyle` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `StrutStyle` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `Matrix4` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `Rect` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `List<Shadow>` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `List<BoxShadow>` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `bool` | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `String` | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `Clip` (enum) | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `Axis` (enum) | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `TextAlign` (enum) | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `TextDirection` (enum) | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `BoxFit` (enum) | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `BlendMode` (enum) | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `ImageProvider<Object>` | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `IconData` | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `TextScaler` | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `List<Directive<String>>` | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `Locale` | snap | `MixOps.lerpSnap(a, other?.a, t)` |

**Decision Rule**:
- If type has a static `lerp` method → use `MixOps.lerp` (interpolate)
- If type is enum → use `MixOps.lerpSnap` (snap)
- If type is discrete/non-interpolatable → use `MixOps.lerpSnap` (snap)

### 1.6 debugFillProperties Pattern

```dart
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  super.debugFillProperties(properties);
  properties
    ..add({DiagnosticType}('{fieldName}', fieldName))
    ..add({DiagnosticType}('{fieldName}', fieldName));
}
```

**Type → DiagnosticProperty Mapping**:

| Type | Diagnostic Property |
|------|---------------------|
| `Color` | `ColorProperty('name', value)` |
| `double` | `DoubleProperty('name', value)` |
| `int` | `IntProperty('name', value)` |
| `String` | `StringProperty('name', value)` |
| `bool` | `FlagProperty('name', value: value, ifTrue: 'description')` |
| enum types | `EnumProperty<EnumType>('name', value)` |
| `List<T>` | `IterableProperty<T>('name', value)` |
| other | `DiagnosticsProperty('name', value)` |

**Examples**:
```dart
// BoxSpec
..add(DiagnosticsProperty('alignment', alignment))
..add(EnumProperty<Clip>('clipBehavior', clipBehavior))

// TextSpec
..add(EnumProperty<TextOverflow>('overflow', overflow))
..add(IntProperty('maxLines', maxLines))
..add(FlagProperty('softWrap', value: softWrap, ifTrue: 'wrapping at word boundaries'))

// IconSpec
..add(ColorProperty('color', color))
..add(DoubleProperty('size', size))
..add(IterableProperty<Shadow>('shadows', shadows))
```

### 1.7 props Pattern

```dart
@override
List<Object?> get props => [
  field1,
  field2,
  // ... all fields in declaration order
];
```

---

## 2. Styler Patterns

### 2.1 Class Structure Pattern

**Location**: `packages/mix/lib/src/specs/*/`

```dart
typedef {Name}Mix = {Name}Styler;

class {Name}Styler extends Style<{Name}Spec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<{Name}Styler, {Name}Spec>,
        VariantStyleMixin<{Name}Styler, {Name}Spec>,
        WidgetStateVariantMixin<{Name}Styler, {Name}Spec>,
        // ... domain-specific mixins
        AnimationStyleMixin<{Name}Styler, {Name}Spec> {

  // $-prefixed Prop fields
  final Prop<Type>? $fieldName;

  // .create() constructor (internal)
  const {Name}Styler.create({...});

  // Public constructor
  {Name}Styler({...}) : this.create(...);

  // Static chain accessor
  static {Name}MutableStyler get chain => {Name}MutableStyler({Name}Styler());

  // Setter methods
  {Name}Styler fieldName(Type value);

  // resolve()
  @override
  StyleSpec<{Name}Spec> resolve(BuildContext context);

  // merge()
  @override
  {Name}Styler merge({Name}Styler? other);

  // debugFillProperties()
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties);

  // props getter
  @override
  List<Object?> get props => [...];
}
```

### 2.2 Field Declaration Pattern

**Rule**: All Styler fields are `Prop<T>?` wrapped with `$` prefix.

```dart
final Prop<AlignmentGeometry>? $alignment;
final Prop<EdgeInsetsGeometry>? $padding;
final Prop<Decoration>? $decoration;
final Prop<Clip>? $clipBehavior;
```

**Exceptions**:
- `List<Directive<String>>? $textDirectives` - NOT wrapped in Prop (TextStyler:50)

### 2.3 Dual Constructor Pattern

**.create() Constructor** (internal, takes Props):
```dart
const {Name}Styler.create({
  Prop<Type1>? field1,
  Prop<Type2>? field2,
  super.animation,
  super.modifier,
  super.variants,
}) : $field1 = field1,
     $field2 = field2;
```

**Public Constructor** (takes raw values, converts to Props):
```dart
{Name}Styler({
  Type1? field1,
  MixType2? field2,  // Mix types for mergeable fields
  AnimationConfig? animation,
  WidgetModifierConfig? modifier,
  List<VariantStyle<{Name}Spec>>? variants,
}) : this.create(
       field1: Prop.maybe(field1),           // For non-Mix types
       field2: Prop.maybeMix(field2),        // For Mix types
       animation: animation,
       modifier: modifier,
       variants: variants,
     );
```

**Prop Wrapper Decision**:

| Public Parameter Type | Prop Wrapper |
|-----------------------|--------------|
| `Type?` (Flutter type) | `Prop.maybe(value)` |
| `TypeMix?` (Mix type) | `Prop.maybeMix(value)` |
| `List<ShadowMix>?` | `Prop.mix(ShadowListMix(value))` |
| `List<Directive<String>>?` | Pass through (no wrapper) |

### 2.4 Setter Method Pattern

```dart
/// Sets the {description}.
{Name}Styler fieldName(Type value) {
  return merge({Name}Styler(fieldName: value));
}
```

**All setter methods**:
1. Take a single value parameter
2. Call `merge()` with a new Styler instance
3. Return `{Name}Styler`

### 2.5 resolve() Pattern

```dart
@override
StyleSpec<{Name}Spec> resolve(BuildContext context) {
  final spec = {Name}Spec(
    field1: MixOps.resolve(context, $field1),
    field2: MixOps.resolve(context, $field2),
    // Special: pass through non-Prop fields directly
    textDirectives: $textDirectives,
  );

  return StyleSpec(
    spec: spec,
    animation: $animation,
    widgetModifiers: $modifier?.resolve(context),
  );
}
```

### 2.6 merge() Pattern

```dart
@override
{Name}Styler merge({Name}Styler? other) {
  return {Name}Styler.create(
    field1: MixOps.merge($field1, other?.$field1),
    field2: MixOps.merge($field2, other?.$field2),
    // Special: mergeList for List types
    textDirectives: MixOps.mergeList($textDirectives, other?.$textDirectives),
    // Base fields always included
    animation: MixOps.mergeAnimation($animation, other?.$animation),
    modifier: MixOps.mergeModifier($modifier, other?.$modifier),
    variants: MixOps.mergeVariants($variants, other?.$variants),
  );
}
```

**Merge Decision**:

| Field Type | Merge Pattern |
|------------|---------------|
| `Prop<T>?` | `MixOps.merge($field, other?.$field)` |
| `List<T>?` | `MixOps.mergeList($field, other?.$field)` |
| `AnimationConfig?` | `MixOps.mergeAnimation($animation, other?.$animation)` |
| `WidgetModifierConfig?` | `MixOps.mergeModifier($modifier, other?.$modifier)` |
| `List<VariantStyle<S>>?` | `MixOps.mergeVariants($variants, other?.$variants)` |

### 2.7 Common Mixins Pattern

**Required mixins** (all Stylers):
- `Diagnosticable`
- `WidgetModifierStyleMixin<{Name}Styler, {Name}Spec>`
- `VariantStyleMixin<{Name}Styler, {Name}Spec>`
- `WidgetStateVariantMixin<{Name}Styler, {Name}Spec>`
- `AnimationStyleMixin<{Name}Styler, {Name}Spec>`

**Domain mixins** (based on fields):

| Spec Features | Mixin |
|---------------|-------|
| Has padding/margin | `SpacingStyleMixin<{Name}Styler>` |
| Has decoration | `DecorationStyleMixin<{Name}Styler>` |
| Has border | `BorderStyleMixin<{Name}Styler>` |
| Has borderRadius | `BorderRadiusStyleMixin<{Name}Styler>` |
| Has shadow | `ShadowStyleMixin<{Name}Styler>` |
| Has transform | `TransformStyleMixin<{Name}Styler>` |
| Has constraints | `ConstraintStyleMixin<{Name}Styler>` |
| Has TextStyle | `TextStyleMixin<{Name}Styler>` |
| Has flex properties | `FlexStyleMixin<{Name}Styler>` |

---

## 3. MutableStyler Patterns

### 3.1 Class Structure Pattern

```dart
class {Name}MutableStyler extends StyleMutableBuilder<{Name}Spec>
    with
        UtilityVariantMixin<{Name}Styler, {Name}Spec>,
        UtilityWidgetStateVariantMixin<{Name}Styler, {Name}Spec> {

  // Utility declarations
  late final fieldName = {Utility}Type<{Name}Styler>(...);

  // Convenience accessors
  late final shortcut = utility.nested.property;

  // Mutable state
  @override
  @protected
  late final {Name}MutableState mutable;

  // Constructor
  {Name}MutableStyler([{Name}Styler? attribute]) {
    mutable = {Name}MutableState(attribute ?? {Name}Styler());
  }

  // Direct methods
  {Name}Styler methodName(Type v) => mutable.methodName(v);

  // Animation
  {Name}Styler animate(AnimationConfig animation) => mutable.animate(animation);

  // Variant methods
  @override
  {Name}Styler withVariant(Variant variant, {Name}Styler style);

  @override
  {Name}Styler withVariants(List<VariantStyle<{Name}Spec>> variants);

  // merge() and resolve()
  @override
  {Name}MutableStyler merge(Style<{Name}Spec>? other);

  @override
  StyleSpec<{Name}Spec> resolve(BuildContext context);

  // Value accessors
  @override
  {Name}Styler get currentValue => mutable.value;

  @override
  {Name}Styler get value => mutable.value;
}

class {Name}MutableState extends {Name}Styler with Mutable<{Name}Styler, {Name}Spec> {
  {Name}MutableState({Name}Styler style) {
    value = style;
  }
}
```

### 3.2 Utility Initialization Pattern

```dart
late final fieldName = {Utility}Type<{Name}Styler>(
  (prop) => mutable.merge({Name}Styler.create(fieldName: Prop.mix(prop))),
);
```

**Type → Utility Mapping**:

| Field Type | Utility | Callback |
|------------|---------|----------|
| `EdgeInsetsGeometry` | `EdgeInsetsGeometryUtility` | `(prop) => mutable.merge({Name}Styler.create(fieldName: Prop.mix(prop)))` |
| `BoxConstraints` | `BoxConstraintsUtility` | Same pattern |
| `Decoration` | `DecorationUtility` | Same pattern |
| `TextStyle` | `TextStyleUtility` | Same pattern |
| `StrutStyle` | `StrutStyleUtility` | Same pattern |
| `TextHeightBehavior` | `TextHeightBehaviorUtility` | Same pattern |
| `Color` | `ColorUtility` | Same pattern |
| Simple types | `MixUtility` | `MixUtility(mutable.methodName)` |

### 3.3 Convenience Accessor Pattern

```dart
// Nested property delegation
late final border = decoration.box.border;
late final borderRadius = decoration.box.borderRadius;
late final color = decoration.box.color;
late final shadow = decoration.box.boxShadow;

// Constraint shortcuts
late final width = constraints.width;
late final height = constraints.height;
late final minWidth = constraints.minWidth;
late final maxWidth = constraints.maxWidth;

// Text style shortcuts
late final fontSize = style.fontSize;
late final fontWeight = style.fontWeight;
late final fontFamily = style.fontFamily;
```

### 3.4 Deprecated Utility Pattern

```dart
@Deprecated(
  'Use direct methods like \$box.onHovered() instead. '
  'Note: Returns {Name}Style for consistency with other utility methods like animate().',
)
late final on = OnContextVariantUtility<{Name}Spec, {Name}Styler>(
  (v) => mutable.variants([v]),
);
```

---

## 4. Mix Type Patterns

### 4.1 Class Structure Pattern

```dart
@immutable
sealed class {Name}Mix<T extends {FlutterType}> extends Mix<T> {
  final Prop<FieldType1>? $field1;
  final Prop<FieldType2>? $field2;

  const {Name}Mix({...}) : ...;

  // Factory constructors
  factory {Name}Mix.value(T value);
  static {Name}Mix? maybeValue(T? value);

  // Convenience constructors
  static {Subtype}Mix fieldName(FieldType value);

  // Methods
  @override
  {Name}Mix<T> merge(covariant {Name}Mix<T>? other);
}
```

### 4.2 Subclass Pattern

```dart
final class {Subtype}Mix extends {Name}Mix<{FlutterType}> with Diagnosticable {
  // Additional fields specific to this subtype
  final Prop<Type>? $specificField;

  // Public constructor
  {Subtype}Mix({
    Type? field1,
    MixType? mixField,
  }) : this.create(
         field1: Prop.maybe(field1),
         mixField: Prop.maybeMix(mixField),
       );

  // Internal constructor
  const {Subtype}Mix.create({...}) : ...;

  // Value constructor
  {Subtype}Mix.value({FlutterType} value) : this(...);

  // Fluent methods
  {Subtype}Mix fieldName(Type value) => merge({Subtype}Mix.fieldName(value));

  @override
  {FlutterType} resolve(BuildContext context) {
    return {FlutterType}(
      field1: MixOps.resolve(context, $field1),
      field2: MixOps.resolve(context, $field2) ?? defaultValue,
    );
  }

  @override
  {Subtype}Mix merge({Subtype}Mix? other) {
    return {Subtype}Mix.create(
      field1: MixOps.merge($field1, other?.$field1),
      field2: MixOps.merge($field2, other?.$field2),
    );
  }
}
```

---

## 5. Mapping Tables

### 5.1 Type → Lerp Strategy

```
LERPABLE (use MixOps.lerp):
  - double, int
  - Color, HSVColor, HSLColor
  - Offset, Size, Rect, RRect
  - Alignment, FractionalOffset, AlignmentGeometry
  - EdgeInsets, EdgeInsetsGeometry
  - BorderRadius, BorderRadiusGeometry
  - RelativeRect
  - TextStyle, StrutStyle
  - BoxShadow, Shadow
  - List<BoxShadow>, List<Shadow>
  - Border, ShapeBorder
  - LinearGradient, RadialGradient, SweepGradient
  - BoxConstraints
  - IconThemeData
  - Matrix4
  - Decoration (BoxDecoration, ShapeDecoration)
  - Nested Spec types (delegates to inner lerp)

SNAPPABLE (use MixOps.lerpSnap):
  - bool, String
  - All enums (Clip, Axis, TextAlign, TextDirection, etc.)
  - ImageProvider<Object>
  - IconData
  - TextScaler
  - Locale
  - TextHeightBehavior
  - FilterQuality
  - List<Directive<T>>
  - Callbacks/Functions
```

### 5.2 Type → Prop Wrapper

| Public Type | Prop Method |
|-------------|-------------|
| `T` (non-Mix Flutter type) | `Prop.maybe(value)` |
| `TMix` (Mix type) | `Prop.maybeMix(value)` |
| `List<TMix>` (List of Mix) | `Prop.mix(TListMix(value))` |
| `List<T>` (direct pass) | No wrapper (direct assignment) |

### 5.3 Type → Utility Class

| Type | Utility |
|------|---------|
| `EdgeInsetsGeometry` | `EdgeInsetsGeometryUtility` |
| `BoxConstraints` | `BoxConstraintsUtility` |
| `Decoration` | `DecorationUtility` |
| `TextStyle` | `TextStyleUtility` |
| `StrutStyle` | `StrutStyleUtility` |
| `TextHeightBehavior` | `TextHeightBehaviorUtility` |
| `Color` | `ColorUtility` |
| `Gradient` | `GradientUtility` |
| `BoxBorder` | `BoxBorderUtility` |
| `BorderRadiusGeometry` | `BorderRadiusGeometryUtility` |
| `DecorationImage` | `DecorationImageUtility` |
| `ShapeBorder` | `ShapeBorderUtility` |
| `List<BoxShadow>` | `BoxShadowListUtility` |
| `List<Shadow>` | `ShadowListUtility` |
| Simple scalars | `MixUtility(callback)` |

### 5.4 Type → Diagnostic Property

| Type | DiagnosticsProperty |
|------|---------------------|
| `Color` | `ColorProperty` |
| `double` | `DoubleProperty` |
| `int` | `IntProperty` |
| `String` | `StringProperty` |
| `bool` | `FlagProperty` (with ifTrue) |
| `enum` | `EnumProperty<T>` |
| `List<T>` | `IterableProperty<T>` |
| other | `DiagnosticsProperty` |

---

## 6. Generator Architecture

### 6.1 Proposed Directory Structure

```
packages/mix_generator/lib/src/
  mix_generator.dart              # Entry point
  core/
    metadata/
      spec_metadata.dart          # Spec class analysis
      styler_metadata.dart        # NEW: Styler class analysis
      mutable_metadata.dart       # NEW: MutableStyler analysis
      field_metadata.dart         # Field-level metadata
      type_metadata.dart          # Type introspection
    builders/
      spec_builder.dart           # Generate Spec methods
      styler_builder.dart         # NEW: Generate Styler class
      mutable_builder.dart        # NEW: Generate MutableStyler
    resolvers/
      lerp_resolver.dart          # NEW: Type → lerp strategy
      prop_resolver.dart          # NEW: Type → Prop wrapper
      utility_resolver.dart       # NEW: Type → Utility class
      diagnostic_resolver.dart    # NEW: Type → DiagnosticsProperty
    utils/
      code_builder.dart           # code_builder utilities
      type_utils.dart             # Type analysis helpers
```

### 6.2 Metadata Classes

```dart
/// Extracts Spec field information
class SpecFieldMetadata {
  final String name;
  final DartType type;
  final bool isNullable;
  final LerpStrategy lerpStrategy;
  final DiagnosticType diagnosticType;
}

/// Extracts Styler field information
class StylerFieldMetadata {
  final String name;
  final DartType specType;      // Type in Spec
  final DartType? mixType;      // Type in public constructor (if different)
  final PropWrapper propWrapper;
  final String? utilityClass;
}

/// Extracts MutableStyler information
class MutableFieldMetadata {
  final String name;
  final String utilityClass;
  final List<String> convenienceAccessors;
}
```

### 6.3 Resolver Classes

```dart
abstract class LerpResolver {
  LerpStrategy resolveStrategy(DartType type);
  String generateLerpCode(String fieldName, DartType type);
}

abstract class PropResolver {
  PropWrapper resolveWrapper(DartType type, bool hasMixType);
  String generatePropCode(String value, DartType type);
}

abstract class UtilityResolver {
  String? resolveUtility(DartType type);
  String generateUtilityInit(String fieldName, DartType type, String stylerName);
}
```

### 6.4 Builder Classes

```dart
class SpecBodyBuilder {
  String buildCopyWith(SpecMetadata metadata);
  String buildLerp(SpecMetadata metadata);
  String buildDebugFillProperties(SpecMetadata metadata);
  String buildProps(SpecMetadata metadata);
}

class StylerBuilder {
  String buildFields(StylerMetadata metadata);
  String buildCreateConstructor(StylerMetadata metadata);
  String buildPublicConstructor(StylerMetadata metadata);
  String buildSetterMethods(StylerMetadata metadata);
  String buildResolve(StylerMetadata metadata);
  String buildMerge(StylerMetadata metadata);
}

class MutableStylerBuilder {
  String buildUtilities(MutableMetadata metadata);
  String buildConvenienceAccessors(MutableMetadata metadata);
  String buildMutableState(MutableMetadata metadata);
}
```

---

## 7. Implementation Plan

### Phase 1: Metadata Extraction Layer
1. Create `StylerMetadata` class (mirrors SpecMetadata for Stylers)
2. Create `MutableMetadata` class
3. Enhance `FieldMetadata` with Mix-specific properties

### Phase 2: Type Resolution Utilities
1. Implement `LerpResolver` with type lookup table
2. Implement `PropResolver` with Mix type detection
3. Implement `UtilityResolver` with utility mapping
4. Implement `DiagnosticResolver` with property type mapping

### Phase 3: Spec Builder
1. Port existing Spec generation to new architecture
2. Add code_builder integration
3. Generate copyWith, lerp, debugFillProperties, props

### Phase 4: Styler Builder
1. Generate field declarations ($-prefixed Props)
2. Generate dual constructors (.create and public)
3. Generate setter methods
4. Generate resolve() method
5. Generate merge() method
6. Generate mixin applications

### Phase 5: MutableStyler Builder
1. Generate utility initializations
2. Generate convenience accessors
3. Generate MutableState class
4. Generate variant methods

### Phase 6: Testing Infrastructure
1. Golden file tests for each generated artifact
2. Unit tests for resolvers
3. Integration tests with build_runner

---

## 8. File References

### Spec Files Analyzed
- `packages/mix/lib/src/specs/box/box_spec.dart`
- `packages/mix/lib/src/specs/text/text_spec.dart`
- `packages/mix/lib/src/specs/icon/icon_spec.dart`
- `packages/mix/lib/src/specs/flex/flex_spec.dart`
- `packages/mix/lib/src/specs/stack/stack_spec.dart`
- `packages/mix/lib/src/specs/image/image_spec.dart`

### Styler Files Analyzed
- `packages/mix/lib/src/specs/box/box_style.dart`
- `packages/mix/lib/src/specs/text/text_style.dart`
- `packages/mix/lib/src/specs/icon/icon_style.dart`
- `packages/mix/lib/src/specs/flex/flex_style.dart`

### MutableStyler Files Analyzed
- `packages/mix/lib/src/specs/box/box_mutable_style.dart`
- `packages/mix/lib/src/specs/text/text_mutable_style.dart`

### Core Files Analyzed
- `packages/mix/lib/src/core/spec.dart`
- `packages/mix/lib/src/core/style.dart`
- `packages/mix/lib/src/core/prop.dart`
- `packages/mix/lib/src/core/helpers.dart` (MixOps)
- `packages/mix/lib/src/core/spec_utility.dart`
- `packages/mix/lib/src/core/utility.dart`
- `packages/mix/lib/src/core/mix_element.dart`
- `packages/mix/lib/src/core/style_spec.dart`

### Mix Type Files Analyzed
- `packages/mix/lib/src/properties/painting/decoration_mix.dart`
- `packages/mix/lib/src/properties/layout/edge_insets_geometry_mix.dart`
- `packages/mix/lib/src/properties/layout/edge_insets_geometry_util.dart`

### Annotation Files Analyzed
- `packages/mix_annotations/lib/src/annotations.dart`
- `packages/mix_annotations/lib/src/generator_flags.dart`

### Legacy Generator Files Analyzed
- `packages/mix_generator/lib/src/mix_generator.dart`
- `packages/mix_generator/lib/src/core/metadata/spec_metadata.dart`
- `packages/mix_generator/lib/src/core/type_registry.dart`
