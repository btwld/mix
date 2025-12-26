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

### Phase 0: Emission Strategy Decision (CRITICAL)

**This decision must be made FIRST as everything else depends on it.**

**Problem**: With standard `source_gen`, you cannot "fill in a class body" declared in a separate file. Dart doesn't have partial classes or shipped augmentations.

**Why NOT extensions or augmentations**:
- **Extensions** cannot satisfy required overrides (`copyWith`, `lerp`, `debugFillProperties`, `props`) — extension members are not actual class overrides
- **Augmentations** (`augment class`) are NOT a shipped language feature as of Dart 3.10 — relying on them is too risky for production codegen

---

#### Decision: Mixin-Based Spec Method Generation (Stable)

**For Spec classes**: Generate a **mixin** with method overrides into `.g.dart`. The stub class mixes in the generated mixin.

**Spec Stub File** (`box_spec.dart`):
```dart
part 'box_spec.g.dart';

@MixableSpec()
final class BoxSpec extends Spec<BoxSpec>
    with Diagnosticable, _$BoxSpecMethods {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  // ... field declarations only

  const BoxSpec({this.alignment, this.padding, ...});
}
```

**Generated Part File** (`box_spec.g.dart`):
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_spec.dart';

mixin _$BoxSpecMethods on Spec<BoxSpec> {
  // Field accessors (forwarded from class)
  AlignmentGeometry? get alignment;
  EdgeInsetsGeometry? get padding;
  // ... all fields

  @override
  BoxSpec copyWith({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    // ...
  }) {
    return BoxSpec(
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      // ...
    );
  }

  @override
  BoxSpec lerp(BoxSpec? other, double t) {
    return BoxSpec(
      alignment: MixOps.lerp(alignment, other?.alignment, t),
      padding: MixOps.lerp(padding, other?.padding, t),
      // ...
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DiagnosticsProperty('padding', padding));
  }

  @override
  List<Object?> get props => [alignment, padding, ...];
}
```

**Why this works**:
- Mixins with `on Spec<BoxSpec>` can override abstract members from the superclass
- The mixin declares abstract getters for fields, which the class satisfies via its `final` fields
- Standard `source_gen` / `build_runner` model — one `.g.dart` per input library

---

#### For Styler/MutableStyler: Generate Full Classes

Since Styler and MutableStyler are **fully derived** from Spec metadata, generate entire classes into the same `.g.dart` part file:

```dart
// box_spec.g.dart (continues from above)

typedef BoxMix = BoxStyler;

class BoxStyler extends Style<BoxSpec>
    with Diagnosticable, WidgetModifierStyleMixin<BoxStyler, BoxSpec>, ... {
  // Full class body generated
}

class BoxMutableStyler extends StyleMutableBuilder<BoxSpec>
    with UtilityVariantMixin<BoxStyler, BoxSpec>, ... {
  // Full class body generated
}

class BoxMutableState extends BoxStyler with Mutable<BoxStyler, BoxSpec> {
  // ...
}
```

---

#### File Topology & Builder Outputs

**Single builder, single output per Spec**:

| Input File | Trigger Annotation | Generated Output |
|------------|-------------------|------------------|
| `box_spec.dart` | `@MixableSpec()` on `BoxSpec` | `box_spec.g.dart` |

**Contents of generated `.g.dart`**:
1. `_$BoxSpecMethods` mixin (Spec method overrides)
2. `typedef BoxMix = BoxStyler;`
3. `BoxStyler` class (full)
4. `BoxMutableStyler` class (full)
5. `BoxMutableState` class (full)

**No separate style files needed**: The production `box_style.dart` and `box_mutable_style.dart` become unnecessary — all styling code lives in the generated part.

**Migration path**:
1. Hand-written style files remain as **golden references** during development
2. Once generator output matches golden references, hand-written files can be deleted
3. Only `box_spec.dart` (stub) remains as source of truth

**Builder configuration** (`build.yaml`):
```yaml
builders:
  mix_generator:
    import: "package:mix_generator/mix_generator.dart"
    builder_factories: ["mixGenerator"]
    build_extensions: {".dart": [".g.dart"]}
    auto_apply: dependents
    build_to: source
```

---

#### Golden Test Strategy (Updated)

Golden tests compare generated `.g.dart` content against **expected `.g.dart` fixtures**:

```
packages/mix_generator/test/golden/
  ├── expected/
  │   ├── box_spec.g.dart       # Expected generated output
  │   ├── text_spec.g.dart
  │   └── ...
  └── fixtures/
      ├── box_spec_input.dart   # Minimal stub input
      └── ...
```

**Test flow**:
1. Run generator on `fixtures/box_spec_input.dart`
2. Compare output to `expected/box_spec.g.dart`
3. If mismatch, fail with diff

---

### Phase 1: Registries + Metadata Planning Layer

**CRITICAL CORRECTION**: StylerMetadata/MutableMetadata are **derived plans** from Spec, NOT extractors from existing Styler classes. This avoids circular dependency.

**Files to create:**
```
packages/mix_generator/lib/src/core/registry/mix_type_registry.dart
packages/mix_generator/lib/src/core/registry/utility_registry.dart
packages/mix_generator/lib/src/core/metadata/styler_plan.dart
packages/mix_generator/lib/src/core/metadata/mutable_plan.dart
packages/mix_generator/lib/src/core/metadata/field_model.dart
```

**Tasks:**

1. **Build `MixTypeRegistry`** from `@MixableType` annotations:
   ```dart
   class MixTypeRegistry {
     // FlutterType → MixType mapping
     final Map<String, String> mixTypes;
     // FlutterType → ListMixType mapping (if applicable)
     final Map<String, String> listMixTypes;

     bool hasMixType(String flutterType);
     String? getMixType(String flutterType);
     String? getListMixType(String flutterType);
   }
   ```

2. **Build `UtilityRegistry`** from `@MixableUtility` annotations:
   ```dart
   class UtilityRegistry {
     // FlutterType → UtilityType mapping
     final Map<String, String> utilities;
     // Whether utility callback uses Prop.mix(prop) vs direct prop
     final Map<String, bool> usesPropMix;

     String? getUtility(String flutterType);
     bool usesPropMixCallback(String flutterType);
   }
   ```

3. **Create `FieldModel`** with computed effective values:
   ```dart
   class FieldModel {
     final String name;
     final DartType dartType;
     final MixableField? annotation;

     // Computed effective values (resolved once, used everywhere)
     final String effectiveSpecType;
     final String? effectiveMixType;      // from registry or annotation
     final String effectivePublicParamType;
     final bool isLerpableEffective;      // from annotation or type analysis
     final String effectiveUtility;       // from registry or annotation
     final PropWrapperKind propWrapper;   // maybe, maybeMix, mix, none
   }
   ```

4. **Create `StylerPlan`** derived from SpecMetadata + registries:
   ```dart
   class StylerPlan {
     final String specName;
     final String stylerName;
     final List<FieldModel> fields;
     final List<String> mixins;           // from curated map
     final List<String> setterMethods;
     // NOT extracted from existing Styler - COMPUTED from Spec
   }
   ```

5. **Create `MutablePlan`** derived from StylerPlan + utility config:
   ```dart
   class MutablePlan {
     final StylerPlan stylerPlan;
     final List<UtilityDeclaration> utilities;
     final List<ConvenienceAccessor> accessors;  // from curated map
   }
   ```

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
   - Use `MixTypeRegistry` for type lookups
   - Check `FieldModel.isLerpableEffective` first (annotation override)
   - Return `MixOps.lerp` or `MixOps.lerpSnap` code string

2. `PropResolver`: Map DartType → Prop wrapper
   - Use `MixTypeRegistry.hasMixType()` instead of `endsWith('Mix')`
   - Return `Prop.maybe`, `Prop.maybeMix`, or `Prop.mix(ListMix)` code

3. `UtilityResolver`: Map DartType → Utility class
   - Use `UtilityRegistry` for lookups
   - Generate utility initialization code with correct callback pattern

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
7. Generate `debugFillProperties()` for Styler (all DiagnosticsProperty, excludes base fields)
8. Generate `props` getter with `$`-prefixed fields only (base fields handled by super, see C19)

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
3. **No backward compatibility required** - this is a from-scratch rewrite
4. **Use code_builder for complex patterns** (class declarations, method signatures); string templates OK for simple repetitive patterns (see C15)
5. **Handle edge cases** found in existing code (e.g., `textDirectives` without Prop wrapper)

---

## START HERE

**Phase 0 is a design decision** (documented above). Implementation begins with Phase 1.

Begin with Phase 1: Build registries and derived plans:
1. Create `MixTypeRegistry` from curated type mappings (or `@MixableType` scan)
2. Create `UtilityRegistry` from curated utility mappings (or `@MixableUtility` scan)
3. Create `FieldModel` with computed effective values for each Spec field
4. Create `StylerPlan` derived from SpecMetadata + registries (NOT extracted from existing Styler)
5. Create `MutablePlan` derived from StylerPlan + utility config

**Key principle**: All plans are **derived from Spec + registries**, never extracted from existing Styler/MutableStyler classes.

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

### C10: Utility Callback Pattern Decision Rule

**Issue**: Two different utility patterns exist, need explicit decision rule.

**Pattern A: Specialized Utility with Prop.mix callback**
```dart
// For types with corresponding Mix types (EdgeInsetsGeometryMix, DecorationMix, etc.)
late final padding = EdgeInsetsGeometryUtility<BoxStyler>(
  (prop) => mutable.merge(BoxStyler.create(padding: Prop.mix(prop))),
);
```

**Pattern B: MixUtility with method reference**
```dart
// For simple types (enums, scalars, no Mix type)
late final clipBehavior = MixUtility(mutable.clipBehavior);
late final transform = MixUtility(mutable.transform);
```

**Decision Rule**:

| Field Type | Has Mix Type? | Utility Pattern |
|------------|---------------|-----------------|
| `EdgeInsetsGeometry` | Yes (`EdgeInsetsGeometryMix`) | `EdgeInsetsGeometryUtility<S>((prop) => mutable.merge(Styler.create(field: Prop.mix(prop))))` |
| `BoxConstraints` | Yes (`BoxConstraintsMix`) | `BoxConstraintsUtility<S>((prop) => ...)` |
| `Decoration` | Yes (`DecorationMix`) | `DecorationUtility<S>((prop) => ...)` |
| `TextStyle` | Yes (`TextStyleMix`) | `TextStyleUtility<S>((prop) => ...)` |
| `Color` | Yes (`ColorMix`) | `ColorUtility<S>((prop) => mutable.merge(Styler.create(field: prop)))` |
| `Clip` (enum) | No | `MixUtility(mutable.clipBehavior)` |
| `Axis` (enum) | No | `MixUtility(mutable.direction)` |
| `Matrix4` | No | `MixUtility(mutable.transform)` |
| `AlignmentGeometry` | No (uses direct) | `MixUtility(mutable.alignment)` |

**Note**: `ColorUtility` uses `prop` directly (not `Prop.mix(prop)`) because Color is already a simple resolved type.

---

### C11: Edge Cases Consolidation

**Issue**: Edge cases are scattered. Consolidate here.

| Edge Case | Location | Handling |
|-----------|----------|----------|
| `textDirectives` | TextStyler | Raw `List<Directive<String>>?` without Prop wrapper. Uses `MixOps.mergeList`. |
| `shadows` vs `boxShadow` | IconSpec/BoxSpec | `List<Shadow>` in Spec, becomes `Prop<List<Shadow>>?` in Styler. Uses `MixOps.merge`. |
| `FlagProperty ifTrue` | All Specs with bool | Requires curated map (see C2). |
| Nested Spec types | FlexBoxSpec, StackBoxSpec | Contains `BoxSpec` and `FlexSpec`/`StackSpec`. Lerp delegates to nested `.lerp()`. |
| `ImageStyler` | No AnimationStyleMixin | Only styler without AnimationStyleMixin in mixin list. |
| Composite MutableStylers | FlexBoxMutableStyler, StackBoxMutableStyler | Have both box utilities AND flex/stack utilities with prefixed names to avoid collision. |

---

### C12: Error Handling Strategy

**Issue**: What happens when generator encounters unknown situations?

**Strategy**: Fail fast with actionable error messages.

```dart
class GeneratorException implements Exception {
  final String message;
  final String? filePath;
  final int? lineNumber;
  final String? suggestion;

  GeneratorException(this.message, {this.filePath, this.lineNumber, this.suggestion});

  @override
  String toString() {
    final location = filePath != null ? ' at $filePath:$lineNumber' : '';
    final hint = suggestion != null ? '\nSuggestion: $suggestion' : '';
    return 'GeneratorException: $message$location$hint';
  }
}
```

**Error conditions**:

| Situation | Action |
|-----------|--------|
| Unknown type not in lerp tables | Log warning, default to `lerpSnap`, continue |
| Missing expected annotation | Fail with error pointing to class |
| Field type mismatch (Spec vs Styler) | Fail with detailed comparison |
| Unknown utility type | Fall back to `MixUtility`, log warning |
| Mixin not in curated map | Fail with "add to mixin mapping" suggestion |

---

### C13: Testing Normalization Rules

**Issue**: Phase 6 needs explicit comparison rules.

**Normalization for golden file comparison**:

1. **Format both with `dart format`** - Eliminates whitespace differences
2. **Strip generated file header** - Remove `// GENERATED CODE - DO NOT MODIFY BY HAND`
3. **Ignore trailing newlines** - Normalize to single trailing newline
4. **Keep import order** - Don't normalize imports (they should match exactly)

**Test structure**:
```dart
test('BoxStyler generation matches hand-written', () {
  // Input: BoxSpec class with @MixableSpec annotation
  final input = '''
    @MixableSpec()
    final class BoxSpec extends Spec<BoxSpec> { ... }
  ''';

  // Generate
  final generated = StylerBuilder().build(BoxSpecMetadata.fromSource(input));

  // Compare (normalized)
  final expected = File('packages/mix/lib/src/specs/box/box_style.dart')
      .readAsStringSync();

  expect(
    _normalize(generated),
    equals(_normalize(expected)),
  );
});

String _normalize(String code) {
  return DartFormatter().format(code).trim();
}
```

---

### C14: Phase Dependencies (Explicit)

**Clarification**: Each phase's outputs feed the next.

```
Phase 0: Emission Strategy (DESIGN DECISION - COMPLETE)
  └─ Decision: Mixin-based Spec methods + full Styler/MutableStyler classes
  └─ Decision: Single .g.dart per Spec containing all generated code
  └─ Outputs: Stub file structure expectations
       │
       ▼
Phase 1: Registries + Derived Plans
  └─ Inputs: Curated maps OR @MixableType/@MixableUtility annotations
  └─ Outputs: MixTypeRegistry, UtilityRegistry, FieldModel, StylerPlan, MutablePlan
  └─ NOTE: Plans are DERIVED from Spec, not extracted from Styler
       │
       ▼
Phase 2: Resolvers
  └─ Inputs: FieldModel, Registries
  └─ Outputs: LerpResolver, PropResolver, UtilityResolver, DiagnosticResolver
       │
       ▼
Phase 3: Spec Mixin Builder
  └─ Inputs: SpecMetadata, LerpResolver, DiagnosticResolver
  └─ Outputs: _$SpecMethods mixin generator
       │
       ▼
Phase 4: Styler Builder
  └─ Inputs: StylerPlan, PropResolver, all resolvers
  └─ Outputs: Full Styler class generator
       │
       ▼
Phase 5: MutableStyler Builder
  └─ Inputs: MutablePlan, UtilityRegistry, StylerPlan
  └─ Outputs: Full MutableStyler + MutableState class generator
       │
       ▼
Phase 6: Testing
  └─ Inputs: All builders, expected .g.dart fixtures
  └─ Outputs: Golden tests (vs expected .g.dart), compile tests, regression tests
```

**Implementation starts at Phase 1**: Phase 0 is already decided (mixin-based). Build registries first.

---

### C15: code_builder vs String Templates

**Issue**: Constraint #4 (code_builder for all emission) may be over-strict.

**Decision**: Allow string templates for simple, well-defined patterns.

| Pattern | Approach | Reasoning |
|---------|----------|-----------|
| `props` getter | String template | Simple list literal, no nesting |
| `copyWith` body | String template | Repetitive `field ?? this.field` |
| Class declaration with mixins | code_builder | Complex nesting, type parameters |
| Method signatures | code_builder | Proper type handling |
| Utility initializations | String template | Consistent pattern, readable |

**Example - props getter with string template**:
```dart
String buildProps(List<FieldMetadata> fields) {
  final fieldNames = fields.map((f) => f.name).join(', ');
  return '''
  @override
  List<Object?> get props => [$fieldNames];
  ''';
}
```

**Example - class with mixins using code_builder**:
```dart
Class buildStylerClass(StylerMetadata meta) {
  return Class((b) => b
    ..name = meta.stylerName
    ..extend = refer('Style<${meta.specName}>')
    ..mixins.addAll(meta.mixins.map(refer))
    ..fields.addAll(buildFields(meta))
    ..constructors.addAll(buildConstructors(meta))
    ..methods.addAll(buildMethods(meta)));
}
```

---

### C16: isLerpable:false Semantics (Clarified)

**Issue**: "Skip field in lerp, use other.field directly" is ambiguous.

**Possible interpretations**:
1. `other?.field` - Could be null if other is null
2. `t < 0.5 ? this.field : other?.field` - Snap behavior at midpoint
3. `other?.field ?? this.field` - Prefer other when present

**Resolution**: Lock behavior with golden fixture test.

**Create test fixture**:
```dart
@MixableSpec()
final class TestSpec extends Spec<TestSpec> {
  @MixableField(isLerpable: false)
  final String? nonLerpableField;

  final double? lerpableField;

  const TestSpec({this.nonLerpableField, this.lerpableField});
}
```

**Expected lerp output** (to be validated against actual behavior):
```dart
@override
TestSpec lerp(TestSpec? other, double t) {
  return TestSpec(
    // isLerpable: false → snap at t >= 0.5
    nonLerpableField: MixOps.lerpSnap(nonLerpableField, other?.nonLerpableField, t),
    // default → interpolate
    lerpableField: MixOps.lerp(lerpableField, other?.lerpableField, t),
  );
}
```

**Key insight**: `isLerpable: false` should use `MixOps.lerpSnap`, NOT skip the field entirely.

---

### C17: Compile-Level Integration Test

**Issue**: Golden string equality won't catch:
- Missing imports due to `Allocator.none`
- Missing type visibility in source library
- Subtle generic type mismatches

**Required test**:
```dart
test('generated code compiles and analyzes clean', () async {
  // 1. Run generator on test fixture
  final result = await runBuilder(
    mixGenerator,
    {'test_fixtures|lib/box_spec_fixture.dart': boxSpecSource},
  );

  // 2. Write generated output to temp file
  final tempDir = Directory.systemTemp.createTempSync();
  final genFile = File('${tempDir.path}/box_spec.g.dart');
  await genFile.writeAsString(result);

  // 3. Run dart analyze on generated file
  final analyzeResult = await Process.run('dart', ['analyze', tempDir.path]);

  expect(analyzeResult.exitCode, equals(0),
    reason: 'Generated code must pass dart analyze:\n${analyzeResult.stderr}');
});
```

**CI integration**:
- Add `dart analyze packages/mix_generator/test/fixtures/` to CI
- Fail build if any generated fixture has analyzer errors

---

### C18: Field Rename/Alias Handling

**Issue**: Spec field names don't always match Styler public API names or diagnostics labels.

**Known example**: `$textDirectives` in TextStyler is displayed as `'directives'` in debugFillProperties.

**Required naming concepts in FieldModel**:

```dart
class FieldNameModel {
  final String specFieldName;         // Source field name in Spec (e.g., 'textDirectives')
  final String stylerFieldName;       // $-prefixed Styler field (e.g., '$textDirectives')
  final String stylerPublicName;      // Public constructor/setter name (e.g., 'directives')
  final String stylerDiagnosticLabel; // Label in debugFillProperties (e.g., 'directives')
  final String? mutableUtilityName;   // Utility accessor name if different
}
```

**Resolution strategy**:

**Option A: Curated alias map**
```dart
const fieldAliases = {
  'TextStyler': {
    'textDirectives': FieldAlias(
      publicName: 'directives',
      diagnosticLabel: 'directives',
    ),
  },
};
```

**Option B: Annotation-based**
```dart
@MixableField(publicName: 'directives')
final List<Directive<String>>? textDirectives;
```

**Default behavior**: If no alias specified, all names match specFieldName (minus `$` prefix).

---

### C19: Styler props Base-Fields Rule (Golden-Confirmed)

**Issue**: Contradiction between "include base fields" and "base fields NOT included".

**Resolution**: Verify against actual BoxStyler and lock with golden test.

**Expected rule** (to be confirmed via golden test):
```dart
// Styler props does NOT include base fields ($animation, $modifier, $variants)
// Base fields are handled by Style superclass or are intentionally excluded
@override
List<Object?> get props => [
  $alignment,
  $padding,
  $margin,
  $constraints,
  $decoration,
  $clipBehavior,
  $transform,
  // NO: $animation, $modifier, $variants
];
```

**Golden test to lock behavior**:
```dart
test('BoxStyler props excludes base fields', () {
  final props = BoxStyler().props;
  expect(props, isNot(contains(isA<AnimationConfig>())));
  expect(props, isNot(contains(isA<WidgetModifierConfig>())));
});
```

---

### C20: Registry Discovery + Caching

**Issue**: How to build registries from annotations without re-scanning for every Spec.

**Strategy A: Curated maps (recommended for simplicity)**

```dart
// packages/mix_generator/lib/src/core/curated/type_mappings.dart
const mixTypeMap = {
  'EdgeInsetsGeometry': 'EdgeInsetsGeometryMix',
  'BoxConstraints': 'BoxConstraintsMix',
  'Decoration': 'DecorationMix',
  'TextStyle': 'TextStyleMix',
  'Color': 'ColorMix',
  // ...
};

const utilityMap = {
  'EdgeInsetsGeometry': ('EdgeInsetsGeometryUtility', true),  // (utility, usesPropMix)
  'BoxConstraints': ('BoxConstraintsUtility', true),
  'Decoration': ('DecorationUtility', true),
  'Clip': ('MixUtility', false),
  // ...
};
```

**Strategy B: Annotation scanning with caching**

```dart
class RegistryBuilder {
  static MixTypeRegistry? _cachedRegistry;

  static Future<MixTypeRegistry> build(Resolver resolver) async {
    if (_cachedRegistry != null) return _cachedRegistry!;

    // Scan for @MixableType annotations
    final assets = await resolver.findAssets(Glob('lib/**/*.dart'));
    final registry = MixTypeRegistry();

    for (final asset in assets) {
      final library = await resolver.libraryFor(asset);
      for (final element in library.topLevelElements) {
        if (_hasMixableTypeAnnotation(element)) {
          registry.register(element);
        }
      }
    }

    _cachedRegistry = registry;
    return registry;
  }
}
```

**TypeKey normalization** (for robust matching):
```dart
class TypeKey {
  final String baseName;      // 'EdgeInsetsGeometry', 'ImageProvider'
  final String libraryUri;    // 'dart:ui', 'package:flutter/...'
  final List<String> typeArgs; // ['Object'] for ImageProvider<Object>

  // Ignore import aliases, normalize generics
  static TypeKey fromType(DartType type) {
    final element = type.element;
    return TypeKey(
      baseName: element?.name ?? type.getDisplayString(withNullability: false),
      libraryUri: element?.library?.source.uri.toString() ?? '',
      typeArgs: type is ParameterizedType
          ? type.typeArguments.map((t) => t.getDisplayString(withNullability: false)).toList()
          : [],
    );
  }
}
```

**Recommendation**: Start with curated maps (Strategy A). Add annotation scanning later if needed.

---

### C21: Unknown Type Fallback Behavior

**Issue**: Explicit fallback behavior for types not in curated maps.

**Fallback rules**:

| Situation | Fallback | Warning |
|-----------|----------|---------|
| Unknown type in lerp | `MixOps.lerpSnap` | `Warning: Unknown type '{type}' in lerp, defaulting to snap` |
| Unknown type for utility | `MixUtility(mutable.fieldName)` | `Warning: No utility for '{type}', using MixUtility` |
| Unknown type for Prop wrapper | `Prop.maybe(value)` | `Warning: Unknown Mix type for '{type}', using Prop.maybe` |
| Unknown diagnostic type | `DiagnosticsProperty` | No warning (this is expected default) |

**Implementation**:
```dart
class FallbackResolver {
  LerpStrategy resolveLerp(DartType type) {
    if (_curatedLerpable.contains(type.baseName)) return LerpStrategy.interpolate;
    if (_curatedSnappable.contains(type.baseName)) return LerpStrategy.snap;

    log.warning('Unknown type "${type.baseName}" in lerp, defaulting to snap');
    return LerpStrategy.snap;
  }
}
```

**Unit tests for fallbacks**:
```dart
test('unknown type falls back to lerpSnap', () {
  final resolver = LerpResolver();
  expect(resolver.resolve(UnknownType()), equals(LerpStrategy.snap));
});

test('unknown type falls back to MixUtility', () {
  final resolver = UtilityResolver();
  expect(resolver.resolve(UnknownType()), equals('MixUtility'));
});
```

---

### C22: Composite Spec Generation Rules

**Issue**: FlexBoxSpec/StackBoxSpec contain nested BoxSpec and FlexSpec/StackSpec.

**Handling rules**:

**1. Nested Spec fields in lerp**:
```dart
// FlexBoxSpec contains BoxSpec and FlexSpec as composed properties
// Lerp delegates to nested spec's lerp method
@override
FlexBoxSpec lerp(FlexBoxSpec? other, double t) {
  return FlexBoxSpec(
    // Nested specs use their own lerp
    box: box?.lerp(other?.box, t) ?? other?.box,
    flex: flex?.lerp(other?.flex, t) ?? other?.flex,
  );
}
```

**2. Composite MutableStyler utilities**:

FlexBoxMutableStyler has BOTH:
- Box utilities (padding, margin, decoration, etc.) prefixed or accessible via `box.*`
- Flex utilities (direction, mainAxisAlignment, etc.) accessible directly or via `flex.*`

**Collision avoidance**:
```dart
class FlexBoxMutableStyler {
  // Direct access to flex utilities
  late final direction = MixUtility(mutable.direction);
  late final mainAxisAlignment = MixUtility(mutable.mainAxisAlignment);

  // Box utilities via box accessor OR prefixed
  late final box = BoxMutableStyler();  // OR inline
  late final padding = box.padding;
  late final decoration = box.decoration;
}
```

**Curated composite mapping**:
```dart
const compositeSpecs = {
  'FlexBoxSpec': CompositeSpec(
    nestedSpecs: ['BoxSpec', 'FlexSpec'],
    mutableAccessors: {
      'box': 'BoxMutableStyler',
      'flex': 'FlexMutableStyler',
    },
  ),
  'StackBoxSpec': CompositeSpec(
    nestedSpecs: ['BoxSpec', 'StackSpec'],
    mutableAccessors: {
      'box': 'BoxMutableStyler',
      'stack': 'StackMutableStyler',
    },
  ),
};
```

**Golden tests required**:
- FlexBoxSpec lerp correctly delegates to nested specs
- FlexBoxMutableStyler exposes both box and flex utilities without collision
- StackBoxSpec/StackBoxMutableStyler follows same pattern

---

### C23: Curated Maps Consolidation

**Issue**: Curated maps scattered across corrections. Consolidate in one location.

**File structure**:
```
packages/mix_generator/lib/src/core/curated/
  ├── mixin_mappings.dart       # C4: Styler → mixins
  ├── flag_descriptions.dart    # C2: Field → FlagProperty ifTrue
  ├── field_aliases.dart        # C18: Field rename mappings
  ├── convenience_accessors.dart # C9: MutableStyler accessors
  ├── type_mappings.dart        # C20: Flutter type → Mix type/utility
  ├── composite_specs.dart      # C22: Nested spec configurations
  └── index.dart                # Re-exports all curated maps
```

**Validation test**:
```dart
test('all known Specs have mixin mappings', () {
  for (final specName in knownSpecs) {
    expect(
      mixinMappings.containsKey('${specName.replaceAll('Spec', '')}Styler'),
      isTrue,
      reason: 'Missing mixin mapping for $specName',
    );
  }
});

test('all known bool fields have FlagProperty descriptions', () {
  for (final field in knownBoolFields) {
    expect(
      flagDescriptions.containsKey(field.name),
      isTrue,
      reason: 'Missing FlagProperty ifTrue for ${field.name}',
    );
  }
});
```

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

### Q6: Is backward compatibility required?
**A**: **NO**. This is a from-scratch rewrite. No migration path, no feature flags, no legacy support needed.

---
---
---

# Pattern Catalog Reference

The following sections contain the complete pattern documentation extracted from analyzing the Mix 2.0 codebase.

---

## 1. Spec Patterns

### 1.1 Class Structure Pattern

**Location**: `packages/mix/lib/src/specs/*/`

**Current (hand-written)**:
```dart
/// {Documentation}
final class {Name}Spec extends Spec<{Name}Spec> with Diagnosticable {
  // Fields...
  const {Name}Spec({...});

  @override
  {Name}Spec copyWith({...});
  // ... other methods
}
```

**New (stub + generated mixin)** — see Phase 0:
```dart
// {name}_spec.dart (stub)
part '{name}_spec.g.dart';

@MixableSpec()
final class {Name}Spec extends Spec<{Name}Spec>
    with Diagnosticable, _${Name}SpecMethods {
  // Fields only
  final Type1? field1;
  final Type2? field2;

  const {Name}Spec({this.field1, this.field2});
}

// {name}_spec.g.dart (generated mixin)
mixin _${Name}SpecMethods on Spec<{Name}Spec> {
  @override {Name}Spec copyWith({...});
  @override {Name}Spec lerp({Name}Spec? other, double t);
  @override void debugFillProperties(DiagnosticPropertiesBuilder properties);
  @override List<Object?> get props => [...];
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

### 2.8 Styler debugFillProperties Pattern

**IMPORTANT**: Stylers use a DIFFERENT pattern than Specs for diagnostics.

```dart
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  super.debugFillProperties(properties);
  properties
    ..add(DiagnosticsProperty('fieldName', $fieldName))
    ..add(DiagnosticsProperty('fieldName', $fieldName));
}
```

**Key Differences from Spec debugFillProperties**:

| Aspect | Spec Pattern | Styler Pattern |
|--------|--------------|----------------|
| Property type | Type-specific (ColorProperty, IntProperty, etc.) | **Always `DiagnosticsProperty`** |
| Field reference | `fieldName` (direct) | `$fieldName` (Prop wrapper) |
| Base fields | N/A | **NOT included** (no animation, modifier, variants) |
| String name | Matches field name | Matches field name (without `$`) |

**Examples from codebase**:
```dart
// BoxStyler (all DiagnosticsProperty, all $-prefixed)
properties
  ..add(DiagnosticsProperty('alignment', $alignment))
  ..add(DiagnosticsProperty('padding', $padding))
  ..add(DiagnosticsProperty('margin', $margin))
  ..add(DiagnosticsProperty('constraints', $constraints))
  ..add(DiagnosticsProperty('decoration', $decoration))
  ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));

// TextStyler (note: 'directives' not 'textDirectives')
..add(DiagnosticsProperty('directives', $textDirectives));
```

**Edge case**: `$textDirectives` is displayed as `'directives'` (shortened name).

### 2.9 Styler props Pattern

**CONFIRMED RULE** (see C19 for golden test):

```dart
@override
List<Object?> get props => [
  $field1,
  $field2,
  // ... all $-prefixed domain fields in declaration order
  // EXCLUDES: $animation, $modifier, $variants (base fields)
];
```

**Why base fields are excluded**:
- Base fields (`$animation`, `$modifier`, `$variants`) are inherited from `Style` superclass
- Equality comparison should focus on domain-specific fields
- Verified via golden test against BoxStyler.props

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
  mix_generator.dart              # Entry point (triggers on @MixableSpec)
  core/
    registry/
      mix_type_registry.dart      # Flutter type → Mix type mappings
      utility_registry.dart       # Flutter type → Utility class mappings
    plans/
      field_model.dart            # Field with computed effective values
      styler_plan.dart            # DERIVED from Spec + registries
      mutable_plan.dart           # DERIVED from StylerPlan
    builders/
      spec_mixin_builder.dart     # Generate _$SpecMethods mixin
      styler_builder.dart         # Generate full Styler class
      mutable_builder.dart        # Generate full MutableStyler + MutableState
    resolvers/
      lerp_resolver.dart          # Type → lerp strategy
      prop_resolver.dart          # Type → Prop wrapper
      utility_resolver.dart       # Type → Utility class
      diagnostic_resolver.dart    # Type → DiagnosticsProperty
    curated/                      # See C23 for consolidation
      mixin_mappings.dart         # Styler → mixins (C4)
      flag_descriptions.dart      # Field → FlagProperty ifTrue (C2)
      field_aliases.dart          # Field rename mappings (C18)
      convenience_accessors.dart  # MutableStyler accessors (C9)
      type_mappings.dart          # Flutter type → Mix type/utility (C20)
      composite_specs.dart        # Nested spec configurations (C22)
      index.dart                  # Re-exports all curated maps
    utils/
      code_emitter.dart           # code_builder + string template helpers
      type_utils.dart             # Type analysis helpers
```

### 6.2 Plan Classes (Derived, NOT Extracted)

**Key principle**: Plans are DERIVED from Spec + registries, never extracted from existing Styler classes.

```dart
/// Field with all computed effective values (see C18 for naming)
class FieldModel {
  final String specFieldName;           // e.g., 'textDirectives'
  final String stylerFieldName;         // e.g., '$textDirectives'
  final String stylerPublicName;        // e.g., 'directives' (from alias or default)
  final String stylerDiagnosticLabel;   // e.g., 'directives'
  final DartType dartType;
  final MixableField? annotation;

  // Computed from registries + type analysis
  final String effectiveSpecType;
  final String? effectiveMixType;
  final bool isLerpableEffective;
  final String effectiveUtility;
  final PropWrapperKind propWrapper;
  final bool isWrappedInProp;           // false for textDirectives
  final DiagnosticKind diagnosticKind;
}

/// Derived from SpecMetadata + curated maps
class StylerPlan {
  final String specName;                // e.g., 'BoxSpec'
  final String stylerName;              // e.g., 'BoxStyler'
  final List<FieldModel> fields;
  final List<String> mixins;            // from curated map (C4)
  final List<String> setterMethods;
  // NOT extracted from existing Styler - COMPUTED
}

/// Derived from StylerPlan + curated maps
class MutablePlan {
  final StylerPlan stylerPlan;
  final List<UtilityDeclaration> utilities;
  final List<ConvenienceAccessor> accessors;  // from curated map (C9)
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
/// Generates _$SpecMethods mixin (see Phase 0)
class SpecMixinBuilder {
  /// Generate abstract field getters (forwarded from class)
  String buildFieldGetters(SpecMetadata metadata);

  String buildCopyWith(SpecMetadata metadata);
  String buildLerp(SpecMetadata metadata);
  String buildDebugFillProperties(SpecMetadata metadata);
  String buildProps(SpecMetadata metadata);

  /// Generate complete mixin
  String build(SpecMetadata metadata);
}

/// Generates full Styler class (from StylerPlan, not extraction)
class StylerBuilder {
  String buildFields(StylerPlan plan);
  String buildCreateConstructor(StylerPlan plan);
  String buildPublicConstructor(StylerPlan plan);
  String buildSetterMethods(StylerPlan plan);
  String buildResolve(StylerPlan plan);
  String buildMerge(StylerPlan plan);
  String buildDebugFillProperties(StylerPlan plan);
  String buildProps(StylerPlan plan);

  /// Generate complete class
  String build(StylerPlan plan);
}

/// Generates full MutableStyler + MutableState classes (from MutablePlan)
class MutableStylerBuilder {
  String buildUtilities(MutablePlan plan);
  String buildConvenienceAccessors(MutablePlan plan);
  String buildMutableState(MutablePlan plan);

  /// Generate complete MutableStyler + MutableState classes
  String build(MutablePlan plan);
}
```

---

## 7. Implementation Plan (Updated)

**See C14 for phase dependencies.**

### Phase 1: Curated Maps + Registries
1. Create `core/curated/` directory with all curated maps (see C23)
2. Create `MixTypeRegistry` using curated type mappings
3. Create `UtilityRegistry` using curated utility mappings
4. Create `FieldModel` with computed effective values
5. Create `StylerPlan` derived from Spec + registries
6. Create `MutablePlan` derived from StylerPlan

### Phase 2: Type Resolution Utilities
1. Implement `LerpResolver` with type lookup (using curated maps)
2. Implement `PropResolver` with Mix type detection (using registry)
3. Implement `UtilityResolver` with utility mapping (using registry)
4. Implement `DiagnosticResolver` with property type mapping

### Phase 3: Spec Mixin Builder
1. Create `SpecMixinBuilder` to generate `_$SpecMethods` mixin
2. Generate abstract field getters
3. Generate copyWith, lerp, debugFillProperties, props overrides

### Phase 4: Styler Builder
1. Generate typedef and full Styler class
2. Generate field declarations ($-prefixed Props)
3. Generate dual constructors (.create and public)
3. Generate setter methods
4. Generate resolve() method
5. Generate merge() method
6. Generate mixin applications

### Phase 5: MutableStyler Builder
1. Generate full MutableStyler class
2. Generate utility initializations (using curated maps + registry)
3. Generate convenience accessors (using curated map C9)
4. Generate MutableState class
5. Generate variant methods

### Phase 6: Testing Infrastructure
1. **Golden file tests**: Compare generated `.g.dart` to expected fixtures (see Phase 0)
2. **Compile tests**: `dart analyze` on generated output (see C17)
3. **Unit tests**: Each resolver with various type inputs
4. **Curated map tests**: Validation that all known specs have entries (see C23)
5. **Integration tests**: Full build_runner runs on fixture specs

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
