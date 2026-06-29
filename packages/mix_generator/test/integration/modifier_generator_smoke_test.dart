import 'package:build_test/build_test.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:test/test.dart';

import '../core/test_helpers.dart';

const _mixElementSource = r'''
library mix_element;

abstract class Mix<T> {
  const Mix();

  List<Object?> get props;
}
''';

const _modifierSupportSources = {
  ...mixAnnotationsSources,
  'mix|lib/src/core/mix_element.dart': _mixElementSource,
};

String _modifierSource(String body) {
  return '''
library modifier_case;

import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/mix_element.dart';

part 'modifier_case.g.dart';

enum DiagnosticLevel { info }

enum DiagnosticsTreeStyle { singleLine }

class DiagnosticPropertiesBuilder {
  void add(Object? property) {}
}

class DiagnosticsNode {
  String toString({DiagnosticLevel? minLevel}) => super.toString();
}

class DiagnosticableNode<T> extends DiagnosticsNode {
  DiagnosticableNode({String? name, Object? value, DiagnosticsTreeStyle? style});
}

class DiagnosticsProperty<T> {
  const DiagnosticsProperty(String name, T? value);
}

class DoubleProperty extends DiagnosticsProperty<double> {
  const DoubleProperty(super.name, super.value);
}

class FlagProperty extends DiagnosticsProperty<bool> {
  const FlagProperty(String name, {bool? value, String? ifTrue})
    : super(name, value);
}

class IterableProperty<T> extends DiagnosticsProperty<Iterable<T>> {
  const IterableProperty(super.name, super.value);
}

mixin Diagnosticable {
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {}
}

bool propsEquals(List<Object?> a, List<Object?> b) => true;
int propsHash(Type runtimeType, List<Object?> props) => 0;
Map<String, String> propsDiff(List<Object?> a, List<Object?> b) => const {};

mixin Equatable {
  List<Object?> get props;
  bool get stringify => true;
  Map<String, String> getDiff(Equatable other) => const {};
}

class Widget {
  const Widget();
}

class BuildContext {}

abstract class Spec<T extends Spec<T>> with Equatable {
  const Spec();

  Type get type => T;
  T copyWith();
  T lerp(covariant T? other, double t);
}

abstract class WidgetModifier<Self extends WidgetModifier<Self>>
    extends Spec<Self> {
  const WidgetModifier();

  Widget build(Widget child);
}

abstract class ModifierMix<S extends WidgetModifier<S>> extends Mix<S> {
  const ModifierMix();

  ModifierMix<S> merge(covariant ModifierMix<S>? other);
  S resolve(BuildContext context);
}

class Prop<T> {
  const Prop();

  static Prop<T>? maybe<T>(T? value) => value == null ? null : Prop<T>();
  static Prop<T>? maybeMix<T>(Mix<T>? value) =>
      value == null ? null : Prop<T>();
}

class MixOps {
  static T? resolve<T>(BuildContext context, Prop<T>? prop) => null;
  static P? merge<P extends Prop<V>, V>(P? a, P? b) => b ?? a;
  static T? lerp<T>(T? a, T? b, double t) => a;
  static T? lerpSnap<T>(T? a, T? b, double t) => a;
}

$body
''';
}

Future<void> _expectInvalidSetterType(String setterTypeSource) async {
  final result = await testBuilder(
    partBuilder(const ModifierGenerator()),
    {
      ..._modifierSupportSources,
      'mix_generator|lib/modifier_case.dart': _modifierSource('''
$setterTypeSource

@MixableModifier()
final class ShadowModifier with _\$ShadowModifier {
  @MixableField(setterType: ShadowListMix)
  @override
  final List<int> shadows;

  const ShadowModifier({List<int>? shadows}) : shadows = shadows ?? const [];

  @override
  Widget build(Widget child) => child;
}
'''),
    },
    generateFor: {'mix_generator|lib/modifier_case.dart'},
  );

  expect(result.succeeded, isFalse);
  expect(
    result.errors.join('\n'),
    contains('modifier setterType must extend Mix<List<int>>'),
  );
}

const _opacityMixinGolden = r'''
mixin _$OpacityModifier
    implements WidgetModifier<OpacityModifier>, Diagnosticable {
  double get opacity;

  @override
  Type get type => OpacityModifier;

  @override
  OpacityModifier copyWith({double? opacity}) {
    return OpacityModifier(opacity ?? this.opacity);
  }

  @override
  OpacityModifier lerp(OpacityModifier? other, double t) {
    return OpacityModifier(MixOps.lerp(opacity, other?.opacity, t));
  }

  @override
  List<Object?> get props => [opacity];
''';

const _opacityMixGolden = r'''
class OpacityModifierMix extends ModifierMix<OpacityModifier>
    with Diagnosticable {
  final Prop<double>? opacity;

  const OpacityModifierMix.create({this.opacity});

  OpacityModifierMix({double? opacity})
    : this.create(opacity: Prop.maybe(opacity));

  @override
  OpacityModifier resolve(BuildContext context) {
    return OpacityModifier(MixOps.resolve(context, opacity));
  }
''';

void main() {
  group('ModifierGenerator', () {
    test('emits resolving spec-style modifier output', () async {
      const body = r'''
@MixableModifier()
final class OpacityModifier with _$OpacityModifier {
  @override
  final double opacity;

  const OpacityModifier([double? opacity]) : opacity = opacity ?? 1.0;

  @override
  Widget build(Widget child) => child;
}
''';

      await expectGeneratorOutputResolves(
        builder: partBuilder(const ModifierGenerator()),
        sources: {
          ..._modifierSupportSources,
          'mix_generator|lib/modifier_case.dart': _modifierSource(body),
        },
        inputAsset: 'mix_generator|lib/modifier_case.dart',
        outputAsset: 'mix_generator|lib/modifier_case.g.dart',
        outputMatcher: allOf([
          contains(_opacityMixinGolden),
          contains(_opacityMixGolden),
          contains('bool operator ==(Object other)'),
          contains('Map<String, String> getDiff(Equatable other)'),
          contains('Widget build(Widget child);'),
          contains("DoubleProperty('opacity', opacity)"),
          isNot(contains('Methods')),
          isNot(contains('on WidgetModifier')),
        ]),
      );
    });

    test('skips generated lerp when annotation disables lerp', () async {
      const body = r'''
@MixableModifier(lerp: false)
final class VisibilityModifier with _$VisibilityModifier {
  @override
  final bool visible;

  const VisibilityModifier([bool? visible]) : visible = visible ?? true;

  @override
  VisibilityModifier lerp(VisibilityModifier? other, double t) => this;

  @override
  Widget build(Widget child) => child;
}
''';

      await expectGeneratorOutputResolves(
        builder: partBuilder(const ModifierGenerator()),
        sources: {
          ..._modifierSupportSources,
          'mix_generator|lib/modifier_case.dart': _modifierSource(body),
        },
        inputAsset: 'mix_generator|lib/modifier_case.dart',
        outputAsset: 'mix_generator|lib/modifier_case.g.dart',
        outputMatcher: allOf([
          contains('mixin _\$VisibilityModifier'),
          contains('VisibilityModifier copyWith({bool? visible})'),
          isNot(contains('VisibilityModifier lerp(')),
          contains(
            "FlagProperty('visible', value: visible, ifTrue: 'visible')",
          ),
        ]),
      );
    });

    test(
      'emits positional constructor calls for positional modifier fields',
      () async {
        const body = r'''
@MixableModifier()
final class PositionalModifier with _$PositionalModifier {
  @override
  final double opacity;

  const PositionalModifier([double? opacity]) : opacity = opacity ?? 1.0;

  @override
  Widget build(Widget child) => child;
}
''';

        await expectGeneratorOutputResolves(
          builder: partBuilder(const ModifierGenerator()),
          sources: {
            ..._modifierSupportSources,
            'mix_generator|lib/modifier_case.dart': _modifierSource(body),
          },
          inputAsset: 'mix_generator|lib/modifier_case.dart',
          outputAsset: 'mix_generator|lib/modifier_case.g.dart',
          outputMatcher: allOf([
            contains('PositionalModifier(opacity ?? this.opacity)'),
            contains(
              'PositionalModifier(MixOps.lerp(opacity, other?.opacity, t))',
            ),
            contains('PositionalModifier(MixOps.resolve(context, opacity))'),
            isNot(contains('opacity: MixOps.resolve(context, opacity)')),
          ]),
        );
      },
    );

    test('preserves constructor order instead of sorting fields', () async {
      const body = r'''
@MixableModifier()
final class ConstructorOrderModifier with _$ConstructorOrderModifier {
  @override
  final double? alpha;
  @override
  final double? zeta;

  const ConstructorOrderModifier({this.zeta, this.alpha});

  @override
  Widget build(Widget child) => child;
}
''';

      await expectGeneratorOutputResolves(
        builder: partBuilder(const ModifierGenerator()),
        sources: {
          ..._modifierSupportSources,
          'mix_generator|lib/modifier_case.dart': _modifierSource(body),
        },
        inputAsset: 'mix_generator|lib/modifier_case.dart',
        outputAsset: 'mix_generator|lib/modifier_case.g.dart',
        outputMatcher: allOf([
          contains('List<Object?> get props => [zeta, alpha];'),
          predicate<String>((code) {
            return code.indexOf('zeta: zeta ?? this.zeta') <
                code.indexOf('alpha: alpha ?? this.alpha');
          }, 'copyWith uses constructor order'),
          predicate<String>((code) {
            return code.indexOf('final Prop<double>? zeta;') <
                code.indexOf('final Prop<double>? alpha;');
          }, 'ModifierMix fields use constructor order'),
        ]),
      );
    });

    test(
      'uses MixableField setterType for Mix-typed constructor params',
      () async {
        const body = r'''
class ShadowListMix extends Mix<List<int>> {
  const ShadowListMix();

  @override
  List<Object?> get props => const [];
}

@MixableModifier()
final class ShadowModifier with _$ShadowModifier {
  @MixableField(setterType: ShadowListMix)
  @override
  final List<int> shadows;

  const ShadowModifier({List<int>? shadows}) : shadows = shadows ?? const [];

  @override
  Widget build(Widget child) => child;
}
''';

        await expectGeneratorOutputResolves(
          builder: partBuilder(const ModifierGenerator()),
          sources: {
            ..._modifierSupportSources,
            'mix_generator|lib/modifier_case.dart': _modifierSource(body),
          },
          inputAsset: 'mix_generator|lib/modifier_case.dart',
          outputAsset: 'mix_generator|lib/modifier_case.g.dart',
          outputMatcher: allOf([
            contains('final Prop<List<int>>? shadows;'),
            contains('ShadowModifierMix({ShadowListMix? shadows})'),
            contains('shadows: Prop.maybeMix(shadows)'),
            contains('shadows: MixOps.resolve(context, shadows)'),
            contains('shadows: MixOps.merge(shadows, other.shadows)'),
            isNot(contains('Prop.maybe(shadows)')),
          ]),
        );
      },
    );

    test('rejects modifier setterType that does not extend Mix', () async {
      await _expectInvalidSetterType(r'''
class ShadowListMix {
  const ShadowListMix();
}
''');
    });

    test(
      'rejects modifier setterType whose Mix value type does not match field',
      () async {
        await _expectInvalidSetterType(r'''
class WrongMix extends Mix<int> {
  const WrongMix();

  @override
  List<Object?> get props => const [];
}
typedef ShadowListMix = WrongMix;
''');
      },
    );

    test('rejects modifier setterType with nullable Mix value type', () async {
      await _expectInvalidSetterType(r'''
class ShadowListMix extends Mix<List<int>?> {
  const ShadowListMix();

  @override
  List<Object?> get props => const [];
}
''');
    });

    test('rejects modifier setterType with dynamic Mix value type', () async {
      await _expectInvalidSetterType(r'''
class ShadowListMix extends Mix<dynamic> {
  const ShadowListMix();

  @override
  List<Object?> get props => const [];
}
''');
    });

    test('rejects raw modifier Mix setterType', () async {
      await _expectInvalidSetterType(r'''
class ShadowListMix extends Mix {
  const ShadowListMix();

  @override
  List<Object?> get props => const [];
}
''');
    });

    test(
      'fails when an emitted field is not in the unnamed constructor',
      () async {
        final result = await testBuilder(
          partBuilder(const ModifierGenerator()),
          {
            ..._modifierSupportSources,
            'mix_generator|lib/modifier_case.dart': _modifierSource(r'''
@MixableModifier()
final class InvalidModifier with _$InvalidModifier {
  @override
  final double opacity;

  const InvalidModifier();

  @override
  Widget build(Widget child) => child;
}
'''),
          },
          generateFor: {'mix_generator|lib/modifier_case.dart'},
        );

        expect(result.succeeded, isFalse);
        expect(
          result.errors.join('\n'),
          contains(
            'Generated field `opacity` must map to an unnamed-constructor parameter',
          ),
        );
      },
    );

    test('fails when annotation target is not a class', () async {
      final result = await testBuilder(
        partBuilder(const ModifierGenerator()),
        {
          ..._modifierSupportSources,
          'mix_generator|lib/modifier_case.dart': r'''
library modifier_case;

import 'package:mix_annotations/mix_annotations.dart';

part 'modifier_case.g.dart';

@MixableModifier()
const invalidModifier = 1;
''',
        },
        generateFor: {'mix_generator|lib/modifier_case.dart'},
      );

      expect(result.succeeded, isFalse);
      expect(
        result.errors.join('\n'),
        contains('@MixableModifier can only be applied to classes.'),
      );
    });
  });
}
