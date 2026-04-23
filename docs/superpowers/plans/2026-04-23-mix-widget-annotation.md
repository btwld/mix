# `@MixWidget` Annotation + Generator Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `@MixWidget('Name', {stylable})` annotation that generates a `StatelessWidget` wrapper around an annotated top-level Styler (variable or function), reusing the Styler's hand-written `call(...)` method as the widget entry point.

**Architecture:** A new `source_gen` builder (`mix_widget_generator`) follows the three-builder pattern already in `mix_generator.dart`. Input: annotated top-level variable or function whose resolved/return type is a `Style<T>` subtype. Output: a generated `StatelessWidget` class appended to the existing shared `.g.dart` part file. Pure-Dart param models and string builders are covered by unit tests; the analyzer-facing generator class gets a single smoke test and a short validation test.

**Tech Stack:** Dart 3.11+, `analyzer` ^9-11, `source_gen` ^3-5, `build` ^3-5, `build_test`, `source_gen_test`, `test`.

**Reference spec:** `docs/superpowers/specs/2026-04-23-mix-widget-annotation-design.md`

---

## File Structure

| Path | Role | Status |
|------|------|--------|
| `packages/mix_annotations/lib/src/annotations.dart` | Declares `MixWidget` | modify |
| `packages/mix_generator/lib/src/core/models/mix_widget_param_model.dart` | `MixWidgetParam` value object + `mergeParams()` pure function | create |
| `packages/mix_generator/test/core/models/mix_widget_param_model_test.dart` | Unit tests for the param model and merging | create |
| `packages/mix_generator/lib/src/core/builders/mix_widget_builder.dart` | `MixWidgetBuilder` — pure string emitter | create |
| `packages/mix_generator/lib/src/core/builders/index.dart` | Export new builder | modify |
| `packages/mix_generator/test/core/builders/mix_widget_builder_test.dart` | Unit tests that assert the emitted widget string | create |
| `packages/mix_generator/lib/src/mix_widget_generator.dart` | `MixWidgetGenerator extends GeneratorForAnnotation<MixWidget>` | create |
| `packages/mix_generator/lib/mix_generator.dart` | Add `mixWidgetGenerator(BuilderOptions)` factory + export | modify |
| `packages/mix_generator/build.yaml` | New builder entry | modify |
| `packages/mix_generator/test/integration/mix_widget_generator_smoke_test.dart` | End-to-end builder test | create |
| `packages/mix_generator/test/integration/mix_widget_generator_validation_test.dart` | Error path tests | create |

Each file has one focused responsibility: annotation declaration, a pure value object, a pure string emitter, the analyzer-driven generator, and the build wiring.

---

## Task 1: Add `MixWidget` annotation

**Files:**
- Modify: `packages/mix_annotations/lib/src/annotations.dart`

- [ ] **Step 1: Append the annotation class**

Add this block at the end of `packages/mix_annotations/lib/src/annotations.dart`:

```dart
/// Generates a [StatelessWidget] wrapper around an annotated Styler.
///
/// Apply to a top-level variable whose value is a Styler, or to a top-level
/// function that returns a Styler. The generated widget exposes a constructor
/// that mirrors the source's parameters merged with the Styler's `call(...)`
/// signature, and its `build` method invokes that `call(...)` with the
/// widget's fields.
///
/// When [stylable] is true, the generated widget also accepts an optional
/// `style` parameter of the matching Styler type and merges it into the
/// annotated Styler before invoking `call(...)`.
class MixWidget {
  final String name;
  final bool stylable;
  const MixWidget(this.name, {this.stylable = false});
}
```

- [ ] **Step 2: Verify the annotation package analyzes clean**

Run (from repo root):

```bash
cd packages/mix_annotations && dart analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add packages/mix_annotations/lib/src/annotations.dart
git commit -m "feat(mix_annotations): add MixWidget annotation"
```

---

## Task 2: `MixWidgetParam` model + merge logic

**Files:**
- Create: `packages/mix_generator/lib/src/core/models/mix_widget_param_model.dart`
- Create: `packages/mix_generator/test/core/models/mix_widget_param_model_test.dart`

`MixWidgetParam` is a **pure** value object — no analyzer types. It captures the information a downstream string builder needs:

- `name` — parameter name.
- `typeDisplay` — already-rendered type string (e.g. `"Widget?"`, `"List<Widget>"`).
- `isPositional` — true if the source parameter was positional.
- `isRequired` — true if the source parameter has no default and is not nullable.
- `defaultValueCode` — verbatim default literal, or `null`.

This lets the rest of the generator be analyzer-free and fully unit-testable.

- [ ] **Step 1: Write the failing test**

Create `packages/mix_generator/test/core/models/mix_widget_param_model_test.dart`:

```dart
import 'package:mix_generator/src/core/models/mix_widget_param_model.dart';
import 'package:test/test.dart';

void main() {
  group('MixWidgetParam', () {
    test('nullable positional param is not required', () {
      const param = MixWidgetParam(
        name: 'child',
        typeDisplay: 'Widget?',
        isPositional: true,
        isRequired: false,
        defaultValueCode: null,
      );
      expect(param.isRequired, isFalse);
    });
  });

  group('mergeMixWidgetParams', () {
    test('keeps unique params from both lists', () {
      const source = [
        MixWidgetParam(
          name: 'color',
          typeDisplay: 'Color',
          isPositional: false,
          isRequired: false,
          defaultValueCode: 'Colors.white',
        ),
      ];
      const call = [
        MixWidgetParam(
          name: 'child',
          typeDisplay: 'Widget?',
          isPositional: false,
          isRequired: false,
          defaultValueCode: null,
        ),
      ];
      final merged = mergeMixWidgetParams(source: source, call: call);
      expect(merged.map((p) => p.name), ['color', 'child']);
    });

    test('source params win on name collision', () {
      const source = [
        MixWidgetParam(
          name: 'child',
          typeDisplay: 'Widget',
          isPositional: true,
          isRequired: true,
          defaultValueCode: null,
        ),
      ];
      const call = [
        MixWidgetParam(
          name: 'child',
          typeDisplay: 'Widget?',
          isPositional: false,
          isRequired: false,
          defaultValueCode: null,
        ),
      ];
      final merged = mergeMixWidgetParams(source: source, call: call);
      expect(merged, hasLength(1));
      expect(merged.single.typeDisplay, 'Widget');
      expect(merged.single.isRequired, isTrue);
    });

    test('drops key param from call list (handled via super.key)', () {
      const call = [
        MixWidgetParam(
          name: 'key',
          typeDisplay: 'Key?',
          isPositional: false,
          isRequired: false,
          defaultValueCode: null,
        ),
        MixWidgetParam(
          name: 'child',
          typeDisplay: 'Widget?',
          isPositional: false,
          isRequired: false,
          defaultValueCode: null,
        ),
      ];
      final merged = mergeMixWidgetParams(source: const [], call: call);
      expect(merged.map((p) => p.name), ['child']);
    });
  });
}
```

- [ ] **Step 2: Run the test and confirm it fails**

Run (from `packages/mix_generator`):

```bash
dart test test/core/models/mix_widget_param_model_test.dart
```

Expected: Test fails with a compile error (file does not yet exist).

- [ ] **Step 3: Create the model file**

Create `packages/mix_generator/lib/src/core/models/mix_widget_param_model.dart`:

```dart
/// Pure value object describing one parameter of a `@MixWidget` source
/// (function parameter or Styler `call(...)` parameter). Intentionally free of
/// analyzer types so the string builder can be unit-tested in isolation.
class MixWidgetParam {
  final String name;
  final String typeDisplay;
  final bool isPositional;
  final bool isRequired;
  final String? defaultValueCode;

  const MixWidgetParam({
    required this.name,
    required this.typeDisplay,
    required this.isPositional,
    required this.isRequired,
    required this.defaultValueCode,
  });
}

/// Merges the source-function parameter list with the Styler's `call(...)`
/// parameter list by name. On collision, the source entry wins (defaults and
/// required-ness live there). The `key` call parameter is dropped because the
/// generated widget forwards it via `super.key`.
List<MixWidgetParam> mergeMixWidgetParams({
  required List<MixWidgetParam> source,
  required List<MixWidgetParam> call,
}) {
  final byName = <String, MixWidgetParam>{};
  for (final p in source) {
    byName[p.name] = p;
  }
  for (final p in call) {
    if (p.name == 'key') continue;
    byName.putIfAbsent(p.name, () => p);
  }
  return byName.values.toList(growable: false);
}
```

- [ ] **Step 4: Run the test and confirm it passes**

Run:

```bash
dart test test/core/models/mix_widget_param_model_test.dart
```

Expected: 4 tests pass.

- [ ] **Step 5: Commit**

```bash
git add packages/mix_generator/lib/src/core/models/mix_widget_param_model.dart packages/mix_generator/test/core/models/mix_widget_param_model_test.dart
git commit -m "feat(mix_generator): add MixWidgetParam model and merge logic"
```

---

## Task 3: `MixWidgetBuilder` — pure string emitter

**Files:**
- Create: `packages/mix_generator/lib/src/core/builders/mix_widget_builder.dart`
- Modify: `packages/mix_generator/lib/src/core/builders/index.dart`
- Create: `packages/mix_generator/test/core/builders/mix_widget_builder_test.dart`

`MixWidgetBuilder` takes:

- `widgetName` — the string from `@MixWidget('Name')`.
- `sourceKind` — `variable` or `function`.
- `sourceName` — variable or function identifier.
- `sourceParams` — function param list (empty for variables).
- `callParams` — Styler `call(...)` param list. `callHasPositional` flag indicates whether the call signature is positional (e.g. `TextStyler.call(String text)`).
- `stylable` — bool.
- `stylerTypeDisplay` — only needed when `stylable: true`.

It emits the complete `class <Name> extends StatelessWidget { ... }` code as a string. No analyzer use — everything is already a string/bool.

- [ ] **Step 1: Write the failing test**

Create `packages/mix_generator/test/core/builders/mix_widget_builder_test.dart`:

```dart
import 'package:mix_generator/src/core/builders/mix_widget_builder.dart';
import 'package:mix_generator/src/core/models/mix_widget_param_model.dart';
import 'package:test/test.dart';

void main() {
  group('MixWidgetBuilder', () {
    test('variable form with nullable child', () {
      final out = const MixWidgetBuilder(
        widgetName: 'Card',
        sourceKind: MixWidgetSourceKind.variable,
        sourceName: 'card',
        sourceParams: <MixWidgetParam>[],
        callParams: [
          MixWidgetParam(
            name: 'child',
            typeDisplay: 'Widget?',
            isPositional: false,
            isRequired: false,
            defaultValueCode: null,
          ),
        ],
        callHasPositional: false,
        stylable: false,
        stylerTypeDisplay: 'BoxStyler',
      ).build();

      expect(out, contains('class Card extends StatelessWidget'));
      expect(out, contains('final Widget? child;'));
      expect(out, contains('const Card({super.key, this.child});'));
      expect(
        out,
        contains('Widget build(BuildContext context) => card(child: child);'),
      );
    });

    test('function form with overlap merges to single field', () {
      final out = const MixWidgetBuilder(
        widgetName: 'Card1',
        sourceKind: MixWidgetSourceKind.function,
        sourceName: 'createCard',
        sourceParams: [
          MixWidgetParam(
            name: 'child',
            typeDisplay: 'Widget',
            isPositional: true,
            isRequired: true,
            defaultValueCode: null,
          ),
          MixWidgetParam(
            name: 'color',
            typeDisplay: 'Color',
            isPositional: false,
            isRequired: false,
            defaultValueCode: 'Colors.white',
          ),
        ],
        callParams: [
          MixWidgetParam(
            name: 'child',
            typeDisplay: 'Widget?',
            isPositional: false,
            isRequired: false,
            defaultValueCode: null,
          ),
        ],
        callHasPositional: false,
        stylable: false,
        stylerTypeDisplay: 'BoxStyler',
      ).build();

      expect(out, contains('class Card1 extends StatelessWidget'));
      expect(out, contains('final Widget child;'));
      expect(out, contains('final Color color;'));
      expect(
        out,
        contains(
          'const Card1({super.key, required this.child, this.color = Colors.white});',
        ),
      );
      expect(
        out,
        contains(
          'Widget build(BuildContext context) => createCard(child, color: color)(child: child);',
        ),
      );
    });

    test('stylable variable form adds style field and merge call', () {
      final out = const MixWidgetBuilder(
        widgetName: 'Card',
        sourceKind: MixWidgetSourceKind.variable,
        sourceName: 'card',
        sourceParams: <MixWidgetParam>[],
        callParams: [
          MixWidgetParam(
            name: 'child',
            typeDisplay: 'Widget?',
            isPositional: false,
            isRequired: false,
            defaultValueCode: null,
          ),
        ],
        callHasPositional: false,
        stylable: true,
        stylerTypeDisplay: 'BoxStyler',
      ).build();

      expect(out, contains('final BoxStyler? style;'));
      expect(out, contains('this.style'));
      expect(
        out,
        contains(
          'Widget build(BuildContext context) => card.merge(style)(child: child);',
        ),
      );
    });

    test('positional call signature passes argument positionally', () {
      final out = const MixWidgetBuilder(
        widgetName: 'Heading',
        sourceKind: MixWidgetSourceKind.variable,
        sourceName: 'heading',
        sourceParams: <MixWidgetParam>[],
        callParams: [
          MixWidgetParam(
            name: 'text',
            typeDisplay: 'String',
            isPositional: true,
            isRequired: true,
            defaultValueCode: null,
          ),
        ],
        callHasPositional: true,
        stylable: false,
        stylerTypeDisplay: 'TextStyler',
      ).build();

      expect(out, contains('final String text;'));
      expect(
        out,
        contains('const Heading({super.key, required this.text});'),
      );
      expect(
        out,
        contains('Widget build(BuildContext context) => heading(text);'),
      );
    });
  });
}
```

- [ ] **Step 2: Run the test and confirm it fails**

Run (from `packages/mix_generator`):

```bash
dart test test/core/builders/mix_widget_builder_test.dart
```

Expected: Compile error — file does not yet exist.

- [ ] **Step 3: Create the builder**

Create `packages/mix_generator/lib/src/core/builders/mix_widget_builder.dart`:

```dart
import '../models/mix_widget_param_model.dart';

enum MixWidgetSourceKind { variable, function }

/// Emits the full `class <Name> extends StatelessWidget { ... }` source for a
/// `@MixWidget` annotation. Purely string-driven; no analyzer types.
class MixWidgetBuilder {
  final String widgetName;
  final MixWidgetSourceKind sourceKind;
  final String sourceName;
  final List<MixWidgetParam> sourceParams;
  final List<MixWidgetParam> callParams;
  final bool callHasPositional;
  final bool stylable;
  final String stylerTypeDisplay;

  const MixWidgetBuilder({
    required this.widgetName,
    required this.sourceKind,
    required this.sourceName,
    required this.sourceParams,
    required this.callParams,
    required this.callHasPositional,
    required this.stylable,
    required this.stylerTypeDisplay,
  });

  String build() {
    final merged = mergeMixWidgetParams(
      source: sourceParams,
      call: callParams,
    );

    final fields = StringBuffer();
    for (final p in merged) {
      fields.writeln('  final ${p.typeDisplay} ${p.name};');
    }
    if (stylable) {
      fields.writeln('  final $stylerTypeDisplay? style;');
    }

    final ctorParams = StringBuffer('super.key');
    for (final p in merged) {
      ctorParams.write(', ');
      if (p.isRequired) {
        ctorParams.write('required this.${p.name}');
      } else if (p.defaultValueCode != null) {
        ctorParams.write('this.${p.name} = ${p.defaultValueCode}');
      } else {
        ctorParams.write('this.${p.name}');
      }
    }
    if (stylable) {
      ctorParams.write(', this.style');
    }

    final invocation = _buildInvocation();

    return '''
class $widgetName extends StatelessWidget {
${fields.toString().trimRight()}

  const $widgetName({$ctorParams});

  @override
  Widget build(BuildContext context) => $invocation;
}
''';
  }

  String _buildInvocation() {
    final head = switch (sourceKind) {
      MixWidgetSourceKind.variable => sourceName,
      MixWidgetSourceKind.function => '$sourceName(${_renderFnArgs()})',
    };
    final maybeMerge = stylable ? '.merge(style)' : '';
    final callArgs = _renderCallArgs();
    return '$head$maybeMerge($callArgs)';
  }

  String _renderFnArgs() {
    final positional = sourceParams.where((p) => p.isPositional).map((p) => p.name);
    final named =
        sourceParams.where((p) => !p.isPositional).map((p) => '${p.name}: ${p.name}');
    return [...positional, ...named].join(', ');
  }

  String _renderCallArgs() {
    if (callHasPositional) {
      // `call` uses positional params — forward them by name (field name
      // matches param name) in declaration order.
      return callParams.map((p) => p.name).join(', ');
    }
    return callParams
        .where((p) => p.name != 'key')
        .map((p) => '${p.name}: ${p.name}')
        .join(', ');
  }
}
```

- [ ] **Step 4: Export the builder**

Modify `packages/mix_generator/lib/src/core/builders/index.dart` — add:

```dart
export 'mix_widget_builder.dart';
```

- [ ] **Step 5: Run the test and confirm it passes**

Run:

```bash
dart test test/core/builders/mix_widget_builder_test.dart
```

Expected: 4 tests pass.

- [ ] **Step 6: Commit**

```bash
git add packages/mix_generator/lib/src/core/builders/mix_widget_builder.dart packages/mix_generator/lib/src/core/builders/index.dart packages/mix_generator/test/core/builders/mix_widget_builder_test.dart
git commit -m "feat(mix_generator): add MixWidgetBuilder string emitter"
```

---

## Task 4: `MixWidgetGenerator` — analyzer-facing entry point

**Files:**
- Create: `packages/mix_generator/lib/src/mix_widget_generator.dart`
- Create: `packages/mix_generator/test/integration/mix_widget_generator_smoke_test.dart`

This is the one analyzer-touching class. Responsibilities:

1. Dispatch on `Element` type (top-level variable vs top-level function).
2. Resolve the Styler type (variable's static type or function's return type).
3. Validate the type is a `Style<T>` subtype.
4. Locate `call(...)` on the Styler class; validate its presence.
5. Convert each analyzer `FormalParameterElement` to a `MixWidgetParam`.
6. Read annotation fields (`name`, `stylable`).
7. Invoke `MixWidgetBuilder` and return the generated source.

- [ ] **Step 1: Write the failing smoke test**

Create `packages/mix_generator/test/integration/mix_widget_generator_smoke_test.dart`:

```dart
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

Builder _partBuilder(Generator generator) =>
    PartBuilder([generator], '.g.dart');

const _baseSource = r'''
library mix_widget_case;

import 'package:flutter/widgets.dart';

part 'mix_widget_case.g.dart';

class MixWidget {
  final String name;
  final bool stylable;
  const MixWidget(this.name, {this.stylable = false});
}

class Style<T> {
  const Style();
}

class BoxSpec {
  const BoxSpec();
}

class Box extends StatelessWidget {
  final Widget? child;
  const Box({Key? key, required Object style, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) => const SizedBox();
}

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  BoxStyler paddingAll(double v) => this;
  BoxStyler borderRounded(double v) => this;
  BoxStyler color(Color c) => this;
  BoxStyler merge(BoxStyler? other) => this;
  Box call({Key? key, Widget? child}) => Box(style: this, key: key, child: child);
}
''';

void main() {
  group('MixWidgetGenerator smoke', () {
    test('variable form emits widget class and build body', () async {
      const source = '''
$_baseSource

@MixWidget('Card')
final card = BoxStyler().paddingAll(16).borderRounded(8).color(Color(0xFFFFFFFF));
''';

      await testBuilder(
        _partBuilder(const MixWidgetGenerator()),
        {'mix_generator|lib/mix_widget_case.dart': source},
        generateFor: {'mix_generator|lib/mix_widget_case.dart'},
        outputs: {
          'mix_generator|lib/mix_widget_case.g.dart': decodedMatches(
            allOf(
              contains('class Card extends StatelessWidget'),
              contains('final Widget? child;'),
              contains('const Card({super.key, this.child});'),
              contains(
                'Widget build(BuildContext context) => card(child: child);',
              ),
            ),
          ),
        },
      );
    });

    test('function form overlaps collapse to one field', () async {
      const source = '''
$_baseSource

@MixWidget('Card1')
BoxStyler createCard(Widget child, {Color color = const Color(0xFFFFFFFF)}) =>
    BoxStyler().paddingAll(16).borderRounded(8).color(color);
''';

      await testBuilder(
        _partBuilder(const MixWidgetGenerator()),
        {'mix_generator|lib/mix_widget_case.dart': source},
        generateFor: {'mix_generator|lib/mix_widget_case.dart'},
        outputs: {
          'mix_generator|lib/mix_widget_case.g.dart': decodedMatches(
            allOf(
              contains('class Card1 extends StatelessWidget'),
              contains('final Widget child;'),
              contains('final Color color;'),
              contains('required this.child'),
              contains('this.color = const Color(0xFFFFFFFF)'),
              contains(
                'createCard(child, color: color)(child: child)',
              ),
            ),
          ),
        },
      );
    });

    test('stylable: true injects style field and merge call', () async {
      const source = '''
$_baseSource

@MixWidget('Card', stylable: true)
final card = BoxStyler().paddingAll(16);
''';

      await testBuilder(
        _partBuilder(const MixWidgetGenerator()),
        {'mix_generator|lib/mix_widget_case.dart': source},
        generateFor: {'mix_generator|lib/mix_widget_case.dart'},
        outputs: {
          'mix_generator|lib/mix_widget_case.g.dart': decodedMatches(
            allOf(
              contains('final BoxStyler? style;'),
              contains('this.style'),
              contains('card.merge(style)(child: child)'),
            ),
          ),
        },
      );
    });
  });
}
```

- [ ] **Step 2: Run the smoke test and confirm it fails**

Run (from `packages/mix_generator`):

```bash
dart test test/integration/mix_widget_generator_smoke_test.dart
```

Expected: Compile error — `MixWidgetGenerator` does not yet exist.

- [ ] **Step 3: Create the generator**

Create `packages/mix_generator/lib/src/mix_widget_generator.dart`:

```dart
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/mix_widget_builder.dart';
import 'core/models/mix_widget_param_model.dart';

class MixWidgetGenerator extends GeneratorForAnnotation<MixWidget> {
  const MixWidgetGenerator();

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final widgetName = annotation.read('name').stringValue;
    final stylable = annotation.peek('stylable')?.boolValue ?? false;

    if (element is TopLevelVariableElement) {
      return _generateForVariable(
        element: element,
        widgetName: widgetName,
        stylable: stylable,
      );
    }
    if (element is TopLevelFunctionElement) {
      return _generateForFunction(
        element: element,
        widgetName: widgetName,
        stylable: stylable,
      );
    }
    throw InvalidGenerationSource(
      '@MixWidget can only be applied to top-level variables or functions.',
      element: element,
    );
  }

  String _generateForVariable({
    required TopLevelVariableElement element,
    required String widgetName,
    required bool stylable,
  }) {
    final sourceName = element.name!;
    final stylerType = element.type;
    final stylerClass = _resolveStyleClass(stylerType, element);

    final callMethod = _findCall(stylerClass, element);
    final (callParams, callHasPositional) = _convertCallParams(callMethod);

    return MixWidgetBuilder(
      widgetName: widgetName,
      sourceKind: MixWidgetSourceKind.variable,
      sourceName: sourceName,
      sourceParams: const <MixWidgetParam>[],
      callParams: callParams,
      callHasPositional: callHasPositional,
      stylable: stylable,
      stylerTypeDisplay: stylerType.getDisplayString(),
    ).build();
  }

  String _generateForFunction({
    required TopLevelFunctionElement element,
    required String widgetName,
    required bool stylable,
  }) {
    final sourceName = element.name!;
    final returnType = element.returnType;
    final stylerClass = _resolveStyleClass(returnType, element);
    final callMethod = _findCall(stylerClass, element);
    final (callParams, callHasPositional) = _convertCallParams(callMethod);

    final sourceParams = element.formalParameters
        .map(_convertFormalParam)
        .toList(growable: false);

    if (stylable && sourceParams.any((p) => p.name == 'style')) {
      throw InvalidGenerationSource(
        '@MixWidget(stylable: true) reserves the `style` parameter name.',
        element: element,
      );
    }

    return MixWidgetBuilder(
      widgetName: widgetName,
      sourceKind: MixWidgetSourceKind.function,
      sourceName: sourceName,
      sourceParams: sourceParams,
      callParams: callParams,
      callHasPositional: callHasPositional,
      stylable: stylable,
      stylerTypeDisplay: returnType.getDisplayString(),
    ).build();
  }

  InterfaceElement _resolveStyleClass(DartType type, Element element) {
    if (type is! InterfaceType) {
      throw InvalidGenerationSource(
        '@MixWidget target must resolve to a Style<T> subtype.',
        element: element,
      );
    }
    InterfaceType? current = type;
    while (current != null) {
      if (current.element.name == 'Style') {
        return type.element;
      }
      current = current.superclass;
    }
    throw InvalidGenerationSource(
      '@MixWidget target must resolve to a Style<T> subtype.',
      element: element,
    );
  }

  MethodElement _findCall(InterfaceElement styler, Element annotated) {
    for (final m in styler.methods) {
      if (m.name == 'call') return m;
    }
    throw InvalidGenerationSource(
      '@MixWidget Styler ${styler.name} must declare a `call(...)` method.',
      element: annotated,
    );
  }

  (List<MixWidgetParam>, bool) _convertCallParams(MethodElement m) {
    final params = m.formalParameters.map(_convertFormalParam).toList();
    final hasPositional = params.any((p) => p.isPositional);
    return (params, hasPositional);
  }

  MixWidgetParam _convertFormalParam(FormalParameterElement p) {
    final typeStr = p.type.getDisplayString();
    final nullable = typeStr.endsWith('?');
    final hasDefault = p.defaultValueCode != null;
    return MixWidgetParam(
      name: p.name!,
      typeDisplay: typeStr,
      isPositional: p.isPositional,
      isRequired: !nullable && !hasDefault && !p.isOptional,
      defaultValueCode: p.defaultValueCode,
    );
  }
}
```

- [ ] **Step 4: Export the generator**

Modify `packages/mix_generator/lib/mix_generator.dart` — add at the top of the `export` block:

```dart
export 'src/mix_widget_generator.dart';
```

- [ ] **Step 5: Run the smoke test and confirm it passes**

Run (from `packages/mix_generator`):

```bash
dart test test/integration/mix_widget_generator_smoke_test.dart
```

Expected: 3 tests pass.

- [ ] **Step 6: Commit**

```bash
git add packages/mix_generator/lib/src/mix_widget_generator.dart packages/mix_generator/lib/mix_generator.dart packages/mix_generator/test/integration/mix_widget_generator_smoke_test.dart
git commit -m "feat(mix_generator): add MixWidgetGenerator"
```

---

## Task 5: Validation errors

**Files:**
- Create: `packages/mix_generator/test/integration/mix_widget_generator_validation_test.dart`

- [ ] **Step 1: Write the failing test**

Create `packages/mix_generator/test/integration/mix_widget_generator_validation_test.dart`:

```dart
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

Builder _partBuilder(Generator generator) =>
    PartBuilder([generator], '.g.dart');

Future<void> _expectInvalid(String source, String messageFragment) async {
  await expectLater(
    testBuilder(
      _partBuilder(const MixWidgetGenerator()),
      {'mix_generator|lib/case.dart': source},
      generateFor: {'mix_generator|lib/case.dart'},
    ),
    throwsA(
      isA<InvalidGenerationSourceError>().having(
        (e) => e.message,
        'message',
        contains(messageFragment),
      ),
    ),
  );
}

void main() {
  group('MixWidgetGenerator validation', () {
    test('rejects annotation on a class', () async {
      const source = r'''
library c;
part 'case.g.dart';
class MixWidget { final String name; final bool stylable; const MixWidget(this.name, {this.stylable = false}); }
@MixWidget('Bad')
class NotAllowed {}
''';
      await _expectInvalid(source, 'top-level variables or functions');
    });

    test('rejects non-Style type', () async {
      const source = r'''
library c;
part 'case.g.dart';
class MixWidget { final String name; final bool stylable; const MixWidget(this.name, {this.stylable = false}); }
class NotAStyler { const NotAStyler(); NotAStyler call() => this; }
@MixWidget('Bad')
final bad = const NotAStyler();
''';
      await _expectInvalid(source, 'Style<T> subtype');
    });

    test('rejects styler without call()', () async {
      const source = r'''
library c;
part 'case.g.dart';
class MixWidget { final String name; final bool stylable; const MixWidget(this.name, {this.stylable = false}); }
class Style<T> { const Style(); }
class BoxSpec {}
class NoCallStyler extends Style<BoxSpec> { const NoCallStyler(); }
@MixWidget('Bad')
final bad = const NoCallStyler();
''';
      await _expectInvalid(source, 'call(...)');
    });

    test('rejects stylable with style parameter on function', () async {
      const source = r'''
library c;
import 'package:flutter/widgets.dart';
part 'case.g.dart';
class MixWidget { final String name; final bool stylable; const MixWidget(this.name, {this.stylable = false}); }
class Style<T> { const Style(); }
class BoxSpec {}
class Box extends StatelessWidget { const Box({Key? key, Object? style, Widget? child}) : super(key: key); @override Widget build(BuildContext context) => const SizedBox(); }
class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  BoxStyler merge(BoxStyler? other) => this;
  Box call({Key? key, Widget? child}) => Box(key: key, style: this, child: child);
}
@MixWidget('Bad', stylable: true)
BoxStyler build({required BoxStyler style}) => style;
''';
      await _expectInvalid(source, 'reserves the `style`');
    });
  });
}
```

- [ ] **Step 2: Run the validation tests and confirm they pass**

Run (from `packages/mix_generator`):

```bash
dart test test/integration/mix_widget_generator_validation_test.dart
```

Expected: 4 tests pass (no new implementation needed — the generator already covers these branches from Task 4).

- [ ] **Step 3: Commit**

```bash
git add packages/mix_generator/test/integration/mix_widget_generator_validation_test.dart
git commit -m "test(mix_generator): validation cases for MixWidgetGenerator"
```

---

## Task 6: Wire the builder into the build pipeline

**Files:**
- Modify: `packages/mix_generator/lib/mix_generator.dart`
- Modify: `packages/mix_generator/build.yaml`

- [ ] **Step 1: Add the builder factory**

In `packages/mix_generator/lib/mix_generator.dart`, append after the existing `mixableGenerator` factory:

```dart
/// Entry point for the mix_widget_generator builder.
///
/// Triggers on @MixWidget annotations and generates a StatelessWidget wrapper
/// that invokes the annotated Styler's `call(...)` method.
Builder mixWidgetGenerator(BuilderOptions _) {
  return SharedPartBuilder(
    [MixWidgetGenerator()],
    'mix_widget_generator',
    formatOutput: (code, version) {
      return DartFormatter(languageVersion: version).format(code);
    },
  );
}
```

- [ ] **Step 2: Register the builder in `build.yaml`**

In `packages/mix_generator/build.yaml`, add under `builders:` (after the last existing entry):

```yaml
  mix_widget_generator:
    import: 'package:mix_generator/mix_generator.dart'
    builder_factories: ['mixWidgetGenerator']
    build_extensions: {'.dart': ['.mix_widget_generator.g.part']}
    auto_apply: dependents
    build_to: cache
    applies_builders: ['source_gen:combining_builder']
```

Do **not** add a `targets.$default.builders.mix_widget_generator` entry — the new builder is user-facing and should not be scoped to `lib/src/specs/**`.

- [ ] **Step 3: Run the full generator test suite**

Run (from `packages/mix_generator`):

```bash
dart test
```

Expected: all tests pass (unit + integration).

- [ ] **Step 4: Run the repo verification script**

Run (from repo root):

```bash
melos run gen:build && melos run ci && melos run analyze
```

Expected: all green (per `CLAUDE.md`'s pre-commit verification).

- [ ] **Step 5: Commit**

```bash
git add packages/mix_generator/lib/mix_generator.dart packages/mix_generator/build.yaml
git commit -m "feat(mix_generator): register mix_widget_generator builder"
```

---

## Self-Review

1. **Spec coverage:** Annotation (Task 1), signature extraction + merge (Tasks 2, 4), generator emission (Task 3), `stylable` handling (Tasks 2, 3, 4), validation errors (Tasks 4 + 5), builder wiring (Task 6). All sections of the spec map to a task.
2. **Placeholder scan:** No `TBD`/`TODO`/"handle edge cases"/"similar to Task N" — every step carries concrete code or commands.
3. **Type consistency:** `MixWidgetParam`, `mergeMixWidgetParams`, `MixWidgetSourceKind`, `MixWidgetBuilder` names and signatures match across Tasks 2, 3, 4. `MixWidgetGenerator` is referenced consistently in Tasks 4, 5, 6.
4. **No hidden dependencies between tasks:** Tests in earlier tasks don't import from later ones. Task 5 reuses the generator from Task 4 with no new production code — intentional, since error paths already exist in `_generateFor*` helpers.
