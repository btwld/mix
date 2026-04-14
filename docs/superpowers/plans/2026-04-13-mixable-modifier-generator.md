# MixableModifier Generator Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `@MixableModifier()` annotation and generator that reads fields from a `WidgetModifier` subclass and generates the full `ModifierMix` class.

**Architecture:** New annotation in `mix_annotations`, new generator + builder in `mix_generator`. The generator reads `final` fields from the annotated `WidgetModifier`, uses `MixTypeRegistry` for Prop wrapper resolution, and emits a standalone class (not a mixin) extending `ModifierMix<T>`.

**Tech Stack:** Dart, `source_gen`, `analyzer`, `build`, `mix_annotations`

---

## File Structure

| Action | File | Responsibility |
|--------|------|----------------|
| Create | `packages/mix_annotations/lib/src/mixable_modifier.dart` | Annotation class |
| Modify | `packages/mix_annotations/lib/mix_annotations.dart` | Export new annotation |
| Create | `packages/mix_generator/lib/src/core/builders/modifier_mix_builder.dart` | Builds the generated class string |
| Create | `packages/mix_generator/lib/src/modifier_generator.dart` | Generator: validates, extracts fields, delegates to builder |
| Modify | `packages/mix_generator/lib/mix_generator.dart` | Register new generator + export |
| Modify | `packages/mix_generator/lib/src/core/builders/index.dart` | Export new builder |
| Modify | `packages/mix_generator/build.yaml` | Register new builder for modifiers dir |
| Create | `packages/mix_generator/test/core/builders/modifier_mix_builder_test.dart` | Unit tests for builder |

---

### Task 1: Add `MixableModifier` annotation

**Files:**
- Create: `packages/mix_annotations/lib/src/mixable_modifier.dart`
- Modify: `packages/mix_annotations/lib/mix_annotations.dart`

- [ ] **Step 1: Create the annotation class**

Create `packages/mix_annotations/lib/src/mixable_modifier.dart`:

```dart
/// Annotation for generating ModifierMix classes from WidgetModifier subclasses.
///
/// Annotate a class extending `WidgetModifier<T>` to generate the corresponding
/// `ModifierMix` class with resolve, merge, debugFillProperties, and props.
///
/// Example usage:
/// ```dart
/// @MixableModifier()
/// final class OpacityModifier extends WidgetModifier<OpacityModifier>
///     with Diagnosticable {
///   final double opacity;
///   const OpacityModifier({double? opacity}) : opacity = opacity ?? 1.0;
///   // copyWith, lerp, build, props, debugFillProperties...
/// }
/// ```
///
/// This generates `OpacityModifierMix` in the `.g.dart` part file.
class MixableModifier {
  const MixableModifier();
}

const mixableModifier = MixableModifier();
```

- [ ] **Step 2: Export the annotation**

In `packages/mix_annotations/lib/mix_annotations.dart`, add:

```dart
export 'src/mixable_modifier.dart';
```

- [ ] **Step 3: Commit**

```bash
git add packages/mix_annotations/lib/src/mixable_modifier.dart packages/mix_annotations/lib/mix_annotations.dart
git commit -m "feat(mix_annotations): add MixableModifier annotation"
```

---

### Task 2: Create `ModifierMixBuilder`

**Files:**
- Create: `packages/mix_generator/lib/src/core/builders/modifier_mix_builder.dart`
- Modify: `packages/mix_generator/lib/src/core/builders/index.dart`

- [ ] **Step 1: Write the failing test**

Create `packages/mix_generator/test/core/builders/modifier_mix_builder_test.dart`:

```dart
import 'package:mix_generator/src/core/builders/modifier_mix_builder.dart';
import 'package:mix_generator/src/core/registry/mix_type_registry.dart';
import 'package:test/test.dart';

void main() {
  group('ModifierMixBuilder', () {
    group('className', () {
      test('generates correct class name from modifier name', () {
        final builder = ModifierMixBuilder(
          modifierName: 'OpacityModifier',
          fields: [],
        );
        expect(builder.className, equals('OpacityModifierMix'));
      });
    });

    group('build', () {
      test('generates class extending ModifierMix with Diagnosticable', () {
        final builder = ModifierMixBuilder(
          modifierName: 'OpacityModifier',
          fields: [],
        );
        final code = builder.build();

        expect(
          code,
          contains(
            'class OpacityModifierMix extends ModifierMix<OpacityModifier> with Diagnosticable',
          ),
        );
      });

      test('generates create constructor with Prop fields', () {
        final builder = ModifierMixBuilder(
          modifierName: 'OpacityModifier',
          fields: [
            ModifierFieldModel(
              name: 'opacity',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('final Prop<double>? opacity;'));
        expect(code, contains('const OpacityModifierMix.create({this.opacity});'));
      });

      test('generates public constructor with Prop.maybe for direct types', () {
        final builder = ModifierMixBuilder(
          modifierName: 'OpacityModifier',
          fields: [
            ModifierFieldModel(
              name: 'opacity',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('OpacityModifierMix({double? opacity})'));
        expect(code, contains('opacity: Prop.maybe(opacity)'));
      });

      test('generates public constructor with Prop.maybeMix for mix types', () {
        final builder = ModifierMixBuilder(
          modifierName: 'ClipRRectModifier',
          fields: [
            ModifierFieldModel(
              name: 'borderRadius',
              typeName: 'BorderRadiusGeometry',
              propWrapperKind: PropWrapperKind.maybeMix,
              mixTypeName: 'BorderRadiusGeometryMix',
            ),
            ModifierFieldModel(
              name: 'clipBehavior',
              typeName: 'Clip',
              propWrapperKind: PropWrapperKind.maybe,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('BorderRadiusGeometryMix? borderRadius'));
        expect(code, contains('borderRadius: Prop.maybeMix(borderRadius)'));
        expect(code, contains('Clip? clipBehavior'));
        expect(code, contains('clipBehavior: Prop.maybe(clipBehavior)'));
      });

      test('generates resolve method', () {
        final builder = ModifierMixBuilder(
          modifierName: 'OpacityModifier',
          fields: [
            ModifierFieldModel(
              name: 'opacity',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('@override'));
        expect(code, contains('OpacityModifier resolve(BuildContext context)'));
        expect(code, contains('return OpacityModifier('));
        expect(code, contains('opacity: MixOps.resolve(context, opacity)'));
      });

      test('generates merge method', () {
        final builder = ModifierMixBuilder(
          modifierName: 'OpacityModifier',
          fields: [
            ModifierFieldModel(
              name: 'opacity',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('@override'));
        expect(code, contains('OpacityModifierMix merge(OpacityModifierMix? other)'));
        expect(code, contains('if (other == null) return this;'));
        expect(code, contains('return OpacityModifierMix.create('));
        expect(code, contains('opacity: MixOps.merge(opacity, other.opacity)'));
      });

      test('generates debugFillProperties', () {
        final builder = ModifierMixBuilder(
          modifierName: 'OpacityModifier',
          fields: [
            ModifierFieldModel(
              name: 'opacity',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('@override'));
        expect(
          code,
          contains('void debugFillProperties(DiagnosticPropertiesBuilder properties)'),
        );
        expect(code, contains('super.debugFillProperties(properties)'));
        expect(code, contains("DiagnosticsProperty('opacity', opacity)"));
      });

      test('generates props getter', () {
        final builder = ModifierMixBuilder(
          modifierName: 'OpacityModifier',
          fields: [
            ModifierFieldModel(
              name: 'opacity',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('@override'));
        expect(code, contains('List<Object?> get props => ['));
        expect(code, contains('opacity,'));
      });

      test('handles multiple fields', () {
        final builder = ModifierMixBuilder(
          modifierName: 'ClipOvalModifier',
          fields: [
            ModifierFieldModel(
              name: 'clipper',
              typeName: 'CustomClipper<Rect>',
              propWrapperKind: PropWrapperKind.maybe,
            ),
            ModifierFieldModel(
              name: 'clipBehavior',
              typeName: 'Clip',
              propWrapperKind: PropWrapperKind.maybe,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('final Prop<CustomClipper<Rect>>? clipper;'));
        expect(code, contains('final Prop<Clip>? clipBehavior;'));
        expect(code, contains('clipper: MixOps.resolve(context, clipper)'));
        expect(code, contains('clipBehavior: MixOps.resolve(context, clipBehavior)'));
      });

      test('generates empty class when no fields', () {
        final builder = ModifierMixBuilder(
          modifierName: 'NoopModifier',
          fields: [],
        );
        final code = builder.build();

        expect(
          code,
          contains('class NoopModifierMix extends ModifierMix<NoopModifier>'),
        );
        expect(code, contains('const NoopModifierMix.create();'));
        expect(code, contains('List<Object?> get props => [];'));
      });
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd packages/mix_generator && dart test test/core/builders/modifier_mix_builder_test.dart`
Expected: FAIL — cannot find `modifier_mix_builder.dart`

- [ ] **Step 3: Create `ModifierFieldModel` and `ModifierMixBuilder`**

Create `packages/mix_generator/lib/src/core/builders/modifier_mix_builder.dart`:

```dart
/// Modifier Mix builder for generating ModifierMix classes.
///
/// Generates a full standalone class from @MixableModifier annotations.
library;

import '../registry/mix_type_registry.dart';

/// Represents a field from a WidgetModifier for code generation.
class ModifierFieldModel {
  /// The field name.
  final String name;

  /// The Dart type name of the field.
  final String typeName;

  /// The kind of Prop wrapper to use.
  final PropWrapperKind propWrapperKind;

  /// The Mix type name (only set when propWrapperKind is maybeMix).
  final String? mixTypeName;

  const ModifierFieldModel({
    required this.name,
    required this.typeName,
    required this.propWrapperKind,
    this.mixTypeName,
  });

  /// The type used in the public constructor parameter.
  String get publicParamType {
    if (propWrapperKind == PropWrapperKind.maybeMix && mixTypeName != null) {
      return mixTypeName!;
    }

    return typeName;
  }

  /// The Prop factory call expression.
  String get propFactoryCall {
    switch (propWrapperKind) {
      case PropWrapperKind.maybeMix:
        return 'Prop.maybeMix($name)';
      case PropWrapperKind.maybe:
        return 'Prop.maybe($name)';
      case PropWrapperKind.listMix:
      case PropWrapperKind.none:
        return 'Prop.maybe($name)';
    }
  }
}

/// Builds a full ModifierMix class from modifier field models.
class ModifierMixBuilder {
  final String modifierName;
  final List<ModifierFieldModel> fields;

  const ModifierMixBuilder({
    required this.modifierName,
    required this.fields,
  });

  /// The generated class name (e.g., OpacityModifier -> OpacityModifierMix).
  String get className => '${modifierName}Mix';

  String _buildFields() {
    if (fields.isEmpty) return '';

    final buffer = StringBuffer();
    for (final field in fields) {
      buffer.writeln('  final Prop<${field.typeName}>? ${field.name};');
    }
    buffer.writeln();

    return buffer.toString();
  }

  String _buildCreateConstructor() {
    if (fields.isEmpty) {
      return '  const $className.create();\n';
    }

    final buffer = StringBuffer();
    buffer.write('  const $className.create({');
    buffer.write(fields.map((f) => 'this.${f.name}').join(', '));
    buffer.writeln('});');

    return buffer.toString();
  }

  String _buildPublicConstructor() {
    if (fields.isEmpty) {
      return '  $className() : this.create();\n';
    }

    final buffer = StringBuffer();

    // Constructor signature
    buffer.writeln('  $className({');
    for (final field in fields) {
      buffer.writeln('    ${field.publicParamType}? ${field.name},');
    }
    buffer.writeln('  }) : this.create(');

    // Prop wrapping
    for (int i = 0; i < fields.length; i++) {
      final field = fields[i];
      final comma = i < fields.length - 1 ? ',' : ',';
      buffer.writeln('      ${field.name}: ${field.propFactoryCall}$comma');
    }
    buffer.writeln('    );');

    return buffer.toString();
  }

  String _buildResolve() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln('  $modifierName resolve(BuildContext context) {');
    buffer.writeln('    return $modifierName(');

    for (final field in fields) {
      buffer.writeln('      ${field.name}: MixOps.resolve(context, ${field.name}),');
    }

    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildMerge() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln('  $className merge($className? other) {');
    buffer.writeln('    if (other == null) return this;');
    buffer.writeln();
    buffer.writeln('    return $className.create(');

    for (final field in fields) {
      buffer.writeln(
        '      ${field.name}: MixOps.merge(${field.name}, other.${field.name}),',
      );
    }

    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildDebugFillProperties() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln(
      '  void debugFillProperties(DiagnosticPropertiesBuilder properties) {',
    );
    buffer.writeln('    super.debugFillProperties(properties);');

    if (fields.isNotEmpty) {
      buffer.writeln('    properties');
      for (int i = 0; i < fields.length; i++) {
        final field = fields[i];
        final separator = i == fields.length - 1 ? ';' : '';
        buffer.writeln(
          "      ..add(DiagnosticsProperty('${field.name}', ${field.name}))$separator",
        );
      }
    }

    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildProps() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.write('  List<Object?> get props => [');

    if (fields.isEmpty) {
      buffer.writeln('];');
    } else {
      buffer.writeln();
      for (final field in fields) {
        buffer.writeln('    ${field.name},');
      }
      buffer.writeln('  ];');
    }

    return buffer.toString();
  }

  /// Builds the complete class code.
  String build() {
    final buffer = StringBuffer();

    buffer.writeln(
      'class $className extends ModifierMix<$modifierName> with Diagnosticable {',
    );

    // Fields
    buffer.write(_buildFields());

    // Constructors
    buffer.writeln(_buildCreateConstructor());
    buffer.writeln(_buildPublicConstructor());

    // Methods
    buffer.writeln(_buildResolve());
    buffer.writeln(_buildMerge());
    buffer.writeln(_buildDebugFillProperties());
    buffer.writeln(_buildProps());

    buffer.writeln('}');

    return buffer.toString();
  }
}
```

- [ ] **Step 4: Export from index**

In `packages/mix_generator/lib/src/core/builders/index.dart`, add:

```dart
export 'modifier_mix_builder.dart';
```

- [ ] **Step 5: Run test to verify it passes**

Run: `cd packages/mix_generator && dart test test/core/builders/modifier_mix_builder_test.dart`
Expected: ALL PASS

- [ ] **Step 6: Commit**

```bash
git add packages/mix_generator/lib/src/core/builders/modifier_mix_builder.dart packages/mix_generator/lib/src/core/builders/index.dart packages/mix_generator/test/core/builders/modifier_mix_builder_test.dart
git commit -m "feat(mix_generator): add ModifierMixBuilder for generating ModifierMix classes"
```

---

### Task 3: Create `ModifierGenerator`

**Files:**
- Create: `packages/mix_generator/lib/src/modifier_generator.dart`
- Modify: `packages/mix_generator/lib/mix_generator.dart`

- [ ] **Step 1: Create the generator**

Create `packages/mix_generator/lib/src/modifier_generator.dart`:

```dart
/// Modifier generator for ModifierMix class code generation.
///
/// Generates a full ModifierMix class from @MixableModifier annotations.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/modifier_mix_builder.dart';
import 'core/registry/mix_type_registry.dart';

/// Main generator for ModifierMix class code.
///
/// Triggers on @MixableModifier annotations and generates:
/// - A full ModifierMix class (resolve, merge, debugFillProperties, props)
class ModifierGenerator extends GeneratorForAnnotation<MixableModifier> {
  const ModifierGenerator();

  bool _isWidgetModifierClass(ClassElement element) {
    for (final interface in element.allSupertypes) {
      if (interface.element.name == 'WidgetModifier') return true;
    }

    return false;
  }

  String? _extractModifierType(ClassElement classElement) {
    // Look for WidgetModifier<T> in the supertype hierarchy
    final supertype = classElement.supertype;
    if (supertype != null && supertype.typeArguments.isNotEmpty) {
      return supertype.typeArguments.first.getDisplayString();
    }

    for (final interface in classElement.allSupertypes) {
      if (interface.element.name == 'WidgetModifier' &&
          interface.typeArguments.isNotEmpty) {
        return interface.typeArguments.first.getDisplayString();
      }
    }

    return null;
  }

  List<ModifierFieldModel> _extractFields(ClassElement classElement) {
    const registry = MixTypeRegistry();

    // Get only fields declared directly on this class (not inherited)
    final fields = classElement.fields
        .where((f) => !f.isStatic && !f.isSynthetic && f.isFinal)
        .toList();

    // Sort by name for stable ordering
    fields.sort((a, b) => a.name!.compareTo(b.name!));

    return fields.map((field) {
      final name = field.name!;
      final type = field.type;
      final typeName = _getBaseTypeName(type);

      final propWrapperKind = registry.getPropWrapperKind(
        typeName,
        isList: _isList(type),
        listElementType: _getListElementType(type),
        fieldName: name,
      );

      final mixTypeName = propWrapperKind == PropWrapperKind.maybeMix
          ? registry.getMixType(typeName)
          : null;

      return ModifierFieldModel(
        name: name,
        typeName: typeName,
        propWrapperKind: propWrapperKind,
        mixTypeName: mixTypeName,
      );
    }).toList();
  }

  String _getBaseTypeName(DartType type) {
    final displayString = type.getDisplayString();
    if (displayString.endsWith('?')) {
      return displayString.substring(0, displayString.length - 1);
    }

    return displayString;
  }

  bool _isList(DartType type) {
    if (type is! InterfaceType) return false;

    return type.element.name == 'List';
  }

  String? _getListElementType(DartType type) {
    if (type is! InterfaceType) return null;
    if (type.element.name != 'List') return null;
    if (type.typeArguments.isEmpty) return null;

    return _getBaseTypeName(type.typeArguments.first);
  }

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@MixableModifier can only be applied to classes.',
        element: element,
      );
    }

    final classElement = element;
    final modifierName = classElement.name;
    if (modifierName == null) {
      throw InvalidGenerationSourceError(
        '@MixableModifier class must have a name.',
        element: element,
      );
    }

    if (!_isWidgetModifierClass(classElement)) {
      throw InvalidGenerationSourceError(
        '@MixableModifier can only be applied to classes extending WidgetModifier<T>.',
        element: element,
      );
    }

    final fields = _extractFields(classElement);

    final builder = ModifierMixBuilder(
      modifierName: modifierName,
      fields: fields,
    );

    return builder.build();
  }
}
```

- [ ] **Step 2: Register the generator in `mix_generator.dart`**

Add the import and builder function to `packages/mix_generator/lib/mix_generator.dart`:

Add import:
```dart
import 'src/modifier_generator.dart';
```

Add export:
```dart
export 'src/modifier_generator.dart';
```

Add builder function:
```dart
/// Entry point for the modifier_generator builder.
///
/// Triggers on @MixableModifier annotations and generates:
/// - Full ModifierMix class (resolve, merge, debugFillProperties, props)
Builder modifierGenerator(BuilderOptions _) {
  return SharedPartBuilder(
    [ModifierGenerator()],
    'modifier_generator',
    formatOutput: (code, version) {
      return DartFormatter(languageVersion: version).format(code);
    },
  );
}
```

- [ ] **Step 3: Commit**

```bash
git add packages/mix_generator/lib/src/modifier_generator.dart packages/mix_generator/lib/mix_generator.dart
git commit -m "feat(mix_generator): add ModifierGenerator for @MixableModifier"
```

---

### Task 4: Register the builder in `build.yaml`

**Files:**
- Modify: `packages/mix_generator/build.yaml`

- [ ] **Step 1: Add the modifier_generator builder**

In the `builders:` section of `packages/mix_generator/build.yaml`, add:

```yaml
  modifier_generator:
    import: 'package:mix_generator/mix_generator.dart'
    builder_factories: ['modifierGenerator']
    build_extensions: {'.dart': ['.modifier_generator.g.part']}
    auto_apply: dependents
    build_to: cache
    applies_builders: ['source_gen:combining_builder']
```

In the `targets: $default: builders:` section, add:

```yaml
      modifier_generator:
        enabled: true
        generate_for:
          - lib/src/modifiers/**/*.dart
        options:
          debug: false
```

- [ ] **Step 2: Commit**

```bash
git add packages/mix_generator/build.yaml
git commit -m "chore(mix_generator): register modifier_generator builder in build.yaml"
```

---

### Task 5: Apply `@MixableModifier()` to `OpacityModifier` as proof-of-concept

**Files:**
- Modify: `packages/mix/lib/src/modifiers/opacity_modifier.dart`

- [ ] **Step 1: Add the annotation and part directive, remove hand-written Mix class**

Replace the contents of `packages/mix/lib/src/modifiers/opacity_modifier.dart` with:

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

part 'opacity_modifier.g.dart';

/// Modifier that applies opacity to its child.
///
/// Wraps the child in an [Opacity] widget with the specified opacity value.
@MixableModifier()
final class OpacityModifier extends WidgetModifier<OpacityModifier>
    with Diagnosticable {
  /// Opacity value between 0.0 and 1.0 (inclusive).
  final double opacity;
  const OpacityModifier({double? opacity}) : opacity = opacity ?? 1.0;

  @override
  OpacityModifier copyWith({double? opacity}) {
    return OpacityModifier(opacity: opacity ?? this.opacity);
  }

  @override
  OpacityModifier lerp(OpacityModifier? other, double t) {
    if (other == null) return this;

    return OpacityModifier(opacity: MixOps.lerp(opacity, other.opacity, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(PercentProperty('opacity', opacity));
  }

  @override
  List<Object?> get props => [opacity];

  @override
  Widget build(Widget child) {
    return Opacity(opacity: opacity, child: child);
  }
}

/// Utility class for applying opacity modifications.
///
/// Provides convenient methods for creating OpacityModifierMix instances.
final class OpacityModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, OpacityModifierMix> {
  const OpacityModifierUtility(super.utilityBuilder);

  T call(double value) =>
      utilityBuilder(OpacityModifierMix.create(opacity: Prop.value(value)));

  T token(MixToken<double> token) =>
      utilityBuilder(OpacityModifierMix.create(opacity: Prop.token(token)));
}
```

Note: The `OpacityModifier` constructor changes from positional `([double? opacity])` to named `({double? opacity})` to match the generated resolve() call pattern.

- [ ] **Step 2: Add `mix_annotations` dependency to mix package if not already present**

Check `packages/mix/pubspec.yaml` — if `mix_annotations` is not listed as a dependency, add it. Also verify `mix_generator` is in `dev_dependencies`.

- [ ] **Step 3: Run code generation**

Run: `melos run gen:build`
Expected: Generates `packages/mix/lib/src/modifiers/opacity_modifier.g.dart` containing `OpacityModifierMix` class.

- [ ] **Step 4: Verify the generated output matches expected pattern**

Read `packages/mix/lib/src/modifiers/opacity_modifier.g.dart` and verify it contains:
- `class OpacityModifierMix extends ModifierMix<OpacityModifier> with Diagnosticable`
- `final Prop<double>? opacity;`
- `const OpacityModifierMix.create({this.opacity});`
- `OpacityModifierMix({double? opacity}) : this.create(opacity: Prop.maybe(opacity));`
- `OpacityModifier resolve(BuildContext context)` with `MixOps.resolve`
- `OpacityModifierMix merge(OpacityModifierMix? other)` with `MixOps.merge`
- `debugFillProperties` and `props`

- [ ] **Step 5: Run tests**

Run: `melos run ci`
Expected: All tests pass — the generated class is functionally equivalent to the hand-written one.

- [ ] **Step 6: Commit**

```bash
git add packages/mix/lib/src/modifiers/opacity_modifier.dart packages/mix/lib/src/modifiers/opacity_modifier.g.dart
git commit -m "feat(mix): apply @MixableModifier to OpacityModifier as proof-of-concept"
```

---

### Task 6: Run all tests and analysis

**Files:** None (verification only)

- [ ] **Step 1: Run full test suite**

Run: `melos run ci`
Expected: All tests pass.

- [ ] **Step 2: Run analysis**

Run: `melos run analyze`
Expected: No analysis errors.

- [ ] **Step 3: Run generator unit tests**

Run: `cd packages/mix_generator && dart test`
Expected: All tests pass including new builder tests.
