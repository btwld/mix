import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:mix_generator/src/core/models/field_model.dart';
import 'package:mix_generator/src/core/models/mix_field_model.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

/// Wraps [generator] in a `PartBuilder` that writes a single `.g.dart` part.
Builder partBuilder(Generator generator) => PartBuilder([generator], '.g.dart');

/// Asserts that running [builder] over [sources] produces a generated part
/// file that, when re-resolved together with its host library, surfaces no
/// analyzer errors.
///
/// `contains(...)` matchers in `testBuilder` outputs happily pass syntactically
/// or semantically broken code (e.g., a generated string literal that
/// interpolates an undefined identifier). This helper closes that gap: it
/// captures the generated source, re-feeds the library through
/// `resolveSources`, and fails if any unit reports an error-severity
/// diagnostic. Warnings and infos are ignored.
///
/// Pass [outputMatcher] (typically `allOf([contains(...), ...])`) to also
/// assert on the emitted source shape in the same build run. Useful for
/// scenarios where substring checks document the expected shape while the
/// analyzer resolve check guards against semantic bugs.
///
/// The [sources] map must contain everything the *generated output* references
/// (e.g., `MixOps`), not just what the *input* needs to type-check.
Future<void> expectGeneratorOutputResolves({
  required Builder builder,
  required Map<String, String> sources,
  required String inputAsset,
  required String outputAsset,
  Matcher? outputMatcher,
  String? resolveAsset,
}) async {
  String? generated;
  final capture = predicate<String>((value) {
    generated = value;
    return true;
  }, 'captured generator output');
  final combined = outputMatcher == null
      ? capture
      : allOf([outputMatcher, capture]);
  await testBuilder(
    builder,
    sources,
    generateFor: {inputAsset},
    outputs: {outputAsset: decodedMatches(combined)},
  );

  if (generated == null) {
    fail('Generator produced no output for $outputAsset.');
  }

  await resolveSources({...sources, outputAsset: generated!}, (resolver) async {
    final library = await resolver.libraryFor(
      AssetId.parse(resolveAsset ?? inputAsset),
    );
    final libPath = library.firstFragment.source.fullName;
    final result = await library.session.getResolvedLibrary(libPath);
    if (result is! ResolvedLibraryResult) {
      fail('Could not resolve library at $libPath: $result');
    }

    final errors = <String>[];
    for (final unit in result.units) {
      for (final diagnostic in unit.diagnostics) {
        if (diagnostic.severity != Severity.error) continue;
        final pos = unit.lineInfo.getLocation(diagnostic.offset);
        errors.add(
          '${unit.path}:${pos.lineNumber}:${pos.columnNumber}: '
          '${diagnostic.message} '
          '(${diagnostic.diagnosticCode.name})',
        );
      }
    }

    if (errors.isNotEmpty) {
      fail(
        'Generated output produced ${errors.length} analyzer error(s):\n'
        '  ${errors.join('\n  ')}',
      );
    }
  });
}

/// Stub `Style<T>` library — the minimal shape styler builder tests inspect.
const styleStub = r'''
library mix_style;

class Style<T> {
  final Object? $variants;
  final Object? $modifier;
  final Object? $animation;

  const Style({Object? variants, Object? modifier, Object? animation})
    : $variants = variants,
      $modifier = modifier,
      $animation = animation;
}
''';

/// Stub `Mix<T>` / `Mixable<T>` / `DefaultValue<T>` for `MixableGenerator` tests.
const mixElementStub = r'''
library mix_element;

abstract class Mixable<T> {
  const Mixable();
}

class Mix<T> extends Mixable<T> {
  const Mix();
}

mixin DefaultValue<T> {
  T get defaultValue;
}
''';

/// Stub `Prop<T>` at the canonical Mix path so `propChecker` resolves it.
const propStub = r'''
library prop;

class Prop<T> {
  const Prop();
}
''';

/// Stub library defining `VisibleType` for prefix-preservation tests.
const visibleTypeStub = r'''
library visible;

class VisibleType {}
''';

/// Stub Flutter `widgets.dart` library — the minimal shape
/// `MixWidgetGenerator` inspects. Defines `Widget`, `StatelessWidget`,
/// `BuildContext`, `Key`, plus a `Color` and `VoidCallback` typedef used
/// by the spec's button example.
///
/// `Key` lives at `package:flutter/src/foundation/key.dart` and `Widget`
/// at `package:flutter/src/widgets/framework.dart` — both match the
/// canonical Flutter URLs the `keyChecker` and `widgetChecker` constants
/// in `checkers.dart` look at. The public `widgets.dart` re-exports the
/// framework library so user code importing `package:flutter/widgets.dart`
/// resolves to the same elements.
const widgetStub = {
  'flutter|lib/widgets.dart': "export 'src/widgets/framework.dart';",
  'flutter|lib/src/foundation/key.dart': r'''
library key;

class Key {
  const Key();
}
''',
  'flutter|lib/src/widgets/framework.dart': r'''
library framework;

export '../foundation/key.dart';

class BuildContext {}

abstract class Widget {
  const Widget({this.key});
  final Key? key;
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget({super.key});
  Widget build(BuildContext context);
}

typedef VoidCallback = void Function();

class Color {
  const Color(int value);
}
''',
};

/// Stub matching `mix_annotations` 2.1.2, before `MixWidget` exposed
/// `widgetParameters`. New generators must preserve the legacy `.all()`
/// behavior when they encounter this annotation shape.
const legacyMixWidgetAnnotationSources = {
  'mix_annotations|lib/mix_annotations.dart': "export 'src/annotations.dart';",
  'mix_annotations|lib/src/annotations.dart': r'''
library annotations;

class MixWidget {
  final String? name;

  const MixWidget({this.name});
}
''',
};

/// Stub `mix_annotations` library with the annotation classes and flag
/// constants the generators read.
const mixAnnotationsSources = {
  'mix_annotations|lib/mix_annotations.dart': "export 'src/annotations.dart';",
  'mix_annotations|lib/src/annotations.dart': r'''
library annotations;

class MixableSpec {
  final int methods;
  final int components;
  final List<Type> extraStylerMixins;
  final Function? target;

  const MixableSpec({
    this.methods = 0x01 | 0x02 | 0x04,
    this.components = 0,
    this.extraStylerMixins = const [],
    this.target,
  });
}

class MixableStyler {
  final int methods;

  const MixableStyler({
    this.methods = 0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20,
  });
}

class Mixable {
  final int methods;
  final String? resolveToType;

  const Mixable({this.methods = 0x01 | 0x02 | 0x04 | 0x08, this.resolveToType});
}

class MixableField {
  final bool ignoreSetter;
  final Type? setterType;
  final Type? mixin;
  final bool skipMixin;
  final String? factoryName;
  final bool skipFactory;
  final bool forwardStyler;
  final Type? stylerSurface;

  const MixableField({
    this.ignoreSetter = false,
    this.setterType,
    this.mixin,
    this.skipMixin = false,
    this.factoryName,
    this.skipFactory = false,
    this.forwardStyler = false,
    this.stylerSurface,
  });
}

class MixWidgetParameterSelection {
  final bool includesAll;
  final Set<String> names;

  const MixWidgetParameterSelection.all()
    : includesAll = true,
      names = const {};

  const MixWidgetParameterSelection.only(this.names) : includesAll = false;
}

class MixWidget {
  final String? name;
  final MixWidgetParameterSelection widgetParameters;

  const MixWidget({
    this.name,
    this.widgetParameters = const MixWidgetParameterSelection.all(),
  });
}

class MixableModifier {
  final bool lerp;

  const MixableModifier({this.lerp = true});
}

class GeneratedSpecMethods {
  static const int copyWith = 0x01;
  static const int equals = 0x02;
  static const int lerp = 0x04;
  static const int all = copyWith | equals | lerp;
  static const int skipEquals = all & ~equals;
}
''',
};

/// Builds a [FieldModel] for tests. Pass [typeName] or [effectiveSpecType];
/// the other is inferred.
FieldModel createTestFieldModel({
  required String name,
  String? typeName,
  String? effectiveSpecType,
  bool isNullable = false,
  bool isList = false,
  String? listElementType,
  String? styleSpecArgument,
  bool isLerpable = false,
  DiagnosticKind diagnosticKind = DiagnosticKind.diagnostics,
  String? diagnosticLabel,
  String? flagDescription,
}) {
  final resolvedTypeName =
      typeName ??
      effectiveSpecType?.replaceAll('?', '') ??
      (throw ArgumentError('typeName or effectiveSpecType is required'));
  final resolvedSpecType =
      effectiveSpecType ?? '$resolvedTypeName${isNullable ? '?' : ''}';

  return FieldModel(
    name: name,
    typeName: resolvedTypeName,
    isList: isList,
    listElementType: listElementType,
    styleSpecArgument: styleSpecArgument,
    effectiveSpecType: resolvedSpecType,
    isLerpable: isLerpable,
    diagnosticKind: diagnosticKind,
    diagnosticLabel: diagnosticLabel,
    flagDescription: flagDescription,
  );
}

/// Builds a [MixFieldModel] for tests. [declaredName] defaults to
/// `$<name>` to match the styler/mix field convention.
MixFieldModel createTestMixFieldModel({
  required String name,
  String? declaredName,
  required String dartTypeDisplayString,
}) {
  return MixFieldModel(
    name: name,
    declaredName: declaredName ?? '\$$name',
    fieldTypeCode: dartTypeDisplayString,
  );
}
