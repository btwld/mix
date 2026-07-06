import 'package:build_test/build_test.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:test/test.dart';

import '../core/test_helpers.dart';

const legacyFlutterSources = {
  'flutter|lib/foundation.dart': r'''
class DiagnosticPropertiesBuilder {
  void add(Object? property) {}
}

class DiagnosticsProperty<T> {
  const DiagnosticsProperty(String name, Object? value);
}

mixin Diagnosticable {
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {}
}
''',
};

const legacyMixSources = {
  'mix|lib/mix.dart': r'''
export 'src/animation/animation_config.dart';
export 'src/core/prop.dart';
export 'src/core/spec.dart';
export 'src/core/style.dart';
export 'src/core/style_spec.dart';
export 'src/core/style_widget.dart';
export 'src/modifiers/widget_modifier_config.dart';
export 'src/variants/variant.dart';

class MixOps {
  static T? merge<T>(T? a, T? b) => b ?? a;
  static List<T>? mergeList<T>(List<T>? a, List<T>? b) => b ?? a;
  static List<VariantStyle<S>>? mergeVariants<S extends Spec<S>>(
    List<VariantStyle<S>>? a,
    List<VariantStyle<S>>? b,
  ) => b ?? a;
  static WidgetModifierConfig? mergeModifier(
    WidgetModifierConfig? a,
    WidgetModifierConfig? b,
  ) => b ?? a;
  static AnimationConfig? mergeAnimation(
    AnimationConfig? a,
    AnimationConfig? b,
  ) => b ?? a;
  static T? resolve<T>(Object context, Prop<T>? prop) => null;
}
''',
  'mix|lib/src/animation/animation_config.dart': r'''
class AnimationConfig {}
''',
  'mix|lib/src/core/prop.dart': r'''
class Prop<T> {
  const Prop();
}
''',
  'mix|lib/src/core/spec.dart': r'''
abstract class Spec<T extends Spec<T>> {
  const Spec();
}
''',
  'mix|lib/src/core/style.dart': r'''
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../modifiers/widget_modifier_config.dart';
import '../variants/variant.dart';
import 'spec.dart';
import 'style_spec.dart';

abstract class Style<S extends Spec<S>> {
  final List<VariantStyle<S>>? $variants;
  final WidgetModifierConfig? $modifier;
  final AnimationConfig? $animation;

  const Style({
    required List<VariantStyle<S>>? variants,
    required WidgetModifierConfig? modifier,
    required AnimationConfig? animation,
  }) : $variants = variants,
       $modifier = modifier,
       $animation = animation;

  StyleSpec<S> resolve(BuildContext context);
  Style<S> merge(covariant Style<S>? other);
}
''',
  'mix|lib/src/core/style_spec.dart': r'''
import 'spec.dart';

class StyleSpec<S extends Spec<S>> {
  const StyleSpec({required S spec, Object? animation, Object? widgetModifiers});
}
''',
  'mix|lib/src/core/style_widget.dart': r'''
import 'package:flutter/widgets.dart';

import 'spec.dart';
import 'style.dart';
import 'style_spec.dart';

abstract class StyleWidget<S extends Spec<S>> extends Widget {
  final Style<S> style;
  final StyleSpec<S>? styleSpec;

  const StyleWidget({
    required this.style,
    this.styleSpec,
    super.key,
  });
}
''',
  'mix|lib/src/modifiers/widget_modifier_config.dart': r'''
class WidgetModifierConfig {
  const WidgetModifierConfig();
  Object? resolve(Object context) => null;
}
''',
  'mix|lib/src/variants/variant.dart': r'''
import '../core/spec.dart';

class VariantStyle<S extends Spec<S>> {
  const VariantStyle();
}
''',
};

void main() {
  group('generator smoke', () {
    test('SpecGenerator handles nullable list fields end-to-end', () async {
      const source = r'''
library spec_case;

import 'package:mix_annotations/mix_annotations.dart';

part 'spec_case.g.dart';

enum DiagnosticLevel { info }

enum DiagnosticsTreeStyle { singleLine }

class DiagnosticPropertiesBuilder {}

class DiagnosticsNode {
  String toString({DiagnosticLevel? minLevel}) => super.toString();
}

class DiagnosticableNode<T> extends DiagnosticsNode {
  DiagnosticableNode({Object? name, Object? value, Object? style});
}

class IterableProperty<T> {
  const IterableProperty(String name, Object? value);
}

abstract class Diagnosticable {
  const Diagnosticable();
}

bool propsEquals(List<Object?> a, List<Object?> b) => true;
int propsHash(Type runtimeType, List<Object?> props) => 0;
Map<String, String> propsDiff(List<Object?> a, List<Object?> b) => const {};

mixin Equatable {
  List<Object?> get props;
  bool get stringify => true;
  Map<String, String> getDiff(Equatable other) => const {};
}

abstract class Spec<T extends Spec<T>> with Equatable {
  Type get type;
  T copyWith();
  T lerp(T? other, double t);
}

class Shadow {}

@MixableSpec()
class BoxSpec with _$BoxSpec {
  final List<Shadow>? shadows;

  const BoxSpec({this.shadows});
}
''';

      await testBuilder(
        partBuilder(const SpecGenerator()),
        {...mixAnnotationsSources, 'mix_generator|lib/spec_case.dart': source},
        generateFor: {'mix_generator|lib/spec_case.dart'},
        outputs: {
          'mix_generator|lib/spec_case.g.dart': decodedMatches(
            allOf([
              contains(
                'mixin _\$BoxSpec implements Spec<BoxSpec>, Diagnosticable',
              ),
              contains('Type get type => BoxSpec;'),
              contains('List<Shadow>? get shadows;'),
              contains('BoxSpec copyWith({List<Shadow>? shadows})'),
              contains('shadows: shadows ?? this.shadows'),
              contains("IterableProperty<Shadow>('shadows', shadows)"),
              contains('MixOps.lerp(shadows, other?.shadows, t)'),
              contains('propsEquals(props, other.props)'),
              contains('propsHash(runtimeType, props)'),
              contains('typedef _\$BoxSpecMethods = _\$BoxSpec;'),
            ]),
          ),
        },
      );
    });

    test(
      'SpecGenerator output re-resolves cleanly against its host library',
      () async {
        // Self-contained fixture: declares every symbol the generated `.g.dart`
        // references (Spec, Diagnosticable, MixOps, propsX helpers, etc.).
        // The analyzer-smoke helper would catch e.g. the `_$BoxSpecMethods`
        // interpolation bug that bare `contains(...)` matchers happily ship.
        const source = r'''
library spec_case;

import 'package:mix_annotations/mix_annotations.dart';

part 'spec_case.g.dart';

enum DiagnosticLevel { info }
enum DiagnosticsTreeStyle { singleLine }

class DiagnosticPropertiesBuilder {
  void add(Object? property) {}
}

class DiagnosticsNode {
  String toString({DiagnosticLevel? minLevel}) => super.toString();
}

class DiagnosticableNode<T> extends DiagnosticsNode {
  DiagnosticableNode({Object? name, Object? value, Object? style});
}

class IntProperty {
  const IntProperty(String name, Object? value);
}

abstract class Diagnosticable {
  const Diagnosticable();
}

bool propsEquals(List<Object?> a, List<Object?> b) => true;
int propsHash(Type runtimeType, List<Object?> props) => 0;
Map<String, String> propsDiff(List<Object?> a, List<Object?> b) => const {};

mixin Equatable {
  List<Object?> get props;
  bool get stringify => true;
  Map<String, String> getDiff(Equatable other) => const {};
}

abstract class Spec<T extends Spec<T>> with Equatable {
  Type get type;
  T copyWith();
  T lerp(T? other, double t);
}

class MixOps {
  static T? lerp<T>(T? a, T? b, double t) => a;
  static T? lerpSnap<T>(T? a, T? b, double t) => a;
}

@MixableSpec()
class TinySpec with _$TinySpec {
  final int? n;

  const TinySpec({this.n});
}
''';

        await expectGeneratorOutputResolves(
          builder: partBuilder(const SpecGenerator()),
          sources: {
            ...mixAnnotationsSources,
            'mix_generator|lib/spec_case.dart': source,
          },
          inputAsset: 'mix_generator|lib/spec_case.dart',
          outputAsset: 'mix_generator|lib/spec_case.g.dart',
          outputMatcher: allOf([
            contains('MixOps.lerpSnap(n, other?.n, t)'),
            isNot(contains('MixOps.lerp(n, other?.n, t)')),
          ]),
        );
      },
    );

    test(
      'SpecGenerator with skipEquals lets user author props end-to-end',
      () async {
        // User hand-rolls `props`; generator must still emit `==`, `hashCode`,
        // `getDiff`, `stringify` so the user-authored `props` powers a real
        // equality surface.
        const source = r'''
library spec_case;

import 'package:mix_annotations/mix_annotations.dart';

part 'spec_case.g.dart';

enum DiagnosticLevel { info }

enum DiagnosticsTreeStyle { singleLine }

class DiagnosticPropertiesBuilder {}

class DiagnosticsNode {
  String toString({DiagnosticLevel? minLevel}) => super.toString();
}

class DiagnosticableNode<T> extends DiagnosticsNode {
  DiagnosticableNode({Object? name, Object? value, Object? style});
}

class DiagnosticsProperty<T> {
  const DiagnosticsProperty(String name, T? value);
}

abstract class Diagnosticable {
  const Diagnosticable();
}

bool propsEquals(List<Object?> a, List<Object?> b) => true;
int propsHash(Type runtimeType, List<Object?> props) => 0;
Map<String, String> propsDiff(List<Object?> a, List<Object?> b) => const {};

mixin Equatable {
  List<Object?> get props;
  bool get stringify => true;
  Map<String, String> getDiff(Equatable other) => const {};
}

abstract class Spec<T extends Spec<T>> with Equatable {
  Type get type;
  T copyWith();
  T lerp(T? other, double t);
}

class Color {}

@MixableSpec(methods: GeneratedSpecMethods.skipEquals)
class BoxSpec with _$BoxSpec {
  final Color? color;
  final int? id; // hand-rolled props excludes this from equality

  const BoxSpec({this.color, this.id});

  @override
  List<Object?> get props => [color];
}
''';

        await testBuilder(
          partBuilder(const SpecGenerator()),
          {
            ...mixAnnotationsSources,
            'mix_generator|lib/spec_case.dart': source,
          },
          generateFor: {'mix_generator|lib/spec_case.dart'},
          outputs: {
            'mix_generator|lib/spec_case.g.dart': decodedMatches(
              allOf([
                contains(
                  'mixin _\$BoxSpec implements Spec<BoxSpec>, Diagnosticable',
                ),
                contains('Color? get color;'),
                contains('int? get id;'),
                // `skipEquals` suppresses the generated `props` body.
                isNot(contains('List<Object?> get props =>')),
                // Equality surface still emits and references `props`.
                contains('bool operator ==(Object other)'),
                contains('propsEquals(props, other.props)'),
                contains('int get hashCode => propsHash(runtimeType, props)'),
                contains('bool get stringify => true;'),
                contains('Map<String, String> getDiff(Equatable other)'),
                // `copyWith` and `lerp` still emit because their flags are on.
                contains('BoxSpec copyWith('),
                contains('BoxSpec lerp(BoxSpec? other, double t)'),
              ]),
            ),
          },
        );
      },
    );

    test(
      'MixableGenerator emits declared getters and defaultValue fallback',
      () async {
        const source = r'''
library mix_case;

import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/mix_element.dart' hide Mixable;

part 'mix_case.g.dart';

class Prop<T> {
  const Prop();
}

class BoxConstraints {
  final double? minWidth;

  const BoxConstraints({this.minWidth});
}

@Mixable()
class BoxConstraintsMix extends Mix<BoxConstraints> with DefaultValue<BoxConstraints> {
  final Prop<double>? $minWidth;

  const BoxConstraintsMix({Prop<double>? minWidth}) : $minWidth = minWidth;

  static BoxConstraintsMix create({Prop<double>? minWidth}) =>
      BoxConstraintsMix(minWidth: minWidth);

  @override
  BoxConstraints get defaultValue => const BoxConstraints(minWidth: 10);
}
''';

        await testBuilder(
          partBuilder(const MixableGenerator()),
          {
            ...mixAnnotationsSources,
            'mix_generator|lib/mix_case.dart': source,
            'mix|lib/src/core/mix_element.dart': mixElementStub,
          },
          generateFor: {'mix_generator|lib/mix_case.dart'},
          outputs: {
            'mix_generator|lib/mix_case.g.dart': decodedMatches(
              allOf(
                contains('mixin _\$BoxConstraintsMixMixin'),
                contains(
                  'on Mix<BoxConstraints>, DefaultValue<BoxConstraints>, Diagnosticable {',
                ),
                contains(r'Prop<double>? get $minWidth;'),
                contains(
                  r'minWidth: MixOps.merge($minWidth, other?.$minWidth),',
                ),
                contains(
                  r'minWidth: MixOps.resolve(context, $minWidth) ?? defaultValue.minWidth,',
                ),
                contains(r"DiagnosticsProperty('minWidth', $minWidth)"),
              ),
            ),
          },
        );
      },
    );

    test(
      'MixableGenerator preserves prefixes in generated field types',
      () async {
        const source = r'''
library mix_case;

import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/mix_element.dart' hide Mixable;
import 'visible.dart' as v;

part 'mix_case.g.dart';

class Prop<T> {
  const Prop();
}

class Target {
  final v.VisibleType? value;

  const Target({this.value});
}

@Mixable()
class TargetMix extends Mix<Target> {
  final Prop<v.VisibleType>? $value;

  const TargetMix({Prop<v.VisibleType>? value}) : $value = value;

  static TargetMix create({Prop<v.VisibleType>? value}) =>
      TargetMix(value: value);
}
''';

        await testBuilder(
          partBuilder(const MixableGenerator()),
          {
            ...mixAnnotationsSources,
            'mix_generator|lib/mix_case.dart': source,
            'mix_generator|lib/visible.dart': visibleTypeStub,
            'mix|lib/src/core/mix_element.dart': mixElementStub,
          },
          generateFor: {'mix_generator|lib/mix_case.dart'},
          outputs: {
            'mix_generator|lib/mix_case.g.dart': decodedMatches(
              contains(r'Prop<v.VisibleType>? get $value;'),
            ),
          },
        );
      },
    );

    test(
      'MixableGenerator resolves target through intermediate generic supertype',
      () async {
        const source = r'''
library mix_case;

import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/mix_element.dart' hide Mixable;

part 'mix_case.g.dart';

class Prop<T> {
  const Prop();
}

class BoxConstraints {
  final double? minWidth;

  const BoxConstraints({this.minWidth});
}

// This intermediate class introduces its own generic parameter `A` while
// binding `Mix<BoxConstraints>`. The resolve target must be `BoxConstraints`,
// not `A`.
class ConstraintsMix<A> extends Mix<BoxConstraints> {
  const ConstraintsMix();
}

@Mixable()
class BoxConstraintsMix extends ConstraintsMix<int> {
  final Prop<double>? $minWidth;

  const BoxConstraintsMix({Prop<double>? minWidth}) : $minWidth = minWidth;

  static BoxConstraintsMix create({Prop<double>? minWidth}) =>
      BoxConstraintsMix(minWidth: minWidth);
}
''';

        await testBuilder(
          partBuilder(const MixableGenerator()),
          {
            ...mixAnnotationsSources,
            'mix_generator|lib/mix_case.dart': source,
            'mix|lib/src/core/mix_element.dart': mixElementStub,
          },
          generateFor: {'mix_generator|lib/mix_case.dart'},
          outputs: {
            'mix_generator|lib/mix_case.g.dart': decodedMatches(
              allOf(
                // The generated method must resolve to the Mix binding,
                // `BoxConstraints`, not `int`.
                contains('BoxConstraints resolve(BuildContext context)'),
                contains('return BoxConstraints('),
              ),
            ),
          },
        );
      },
    );
  });

  group('StylerGenerator legacy smoke', () {
    test('emits legacy styler mixin from handwritten @MixableStyler', () async {
      const source = r'''
library styler_case;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'styler_case.g.dart';

@MixableSpec()
class BoxSpec extends Spec<BoxSpec> {
  final Color? color;

  const BoxSpec({this.color});
}

@MixableStyler()
class BoxStyler extends Style<BoxSpec>
    with Diagnosticable, _$BoxStylerMixin {
  final Prop<Color>? $color;

  const BoxStyler({Color? color})
      : $color = null,
        super(variants: null, modifier: null, animation: null);

  const BoxStyler.create({
    Prop<Color>? color,
    super.variants,
    super.modifier,
    super.animation,
  }) : $color = color;
}
''';

      await testBuilder(
        partBuilder(const StylerGenerator()),
        {
          ...mixAnnotationsSources,
          ...legacyFlutterSources,
          ...widgetStub,
          ...legacyMixSources,
          'mix_generator|lib/styler_case.dart': source,
        },
        generateFor: {'mix_generator|lib/styler_case.dart'},
        outputs: {
          'mix_generator|lib/styler_case.g.dart': decodedMatches(
            allOf([
              contains(
                'mixin _\$BoxStylerMixin on Style<BoxSpec>, Diagnosticable',
              ),
              contains(r'Prop<Color>? get $color;'),
              contains('BoxStyler color(Color value)'),
              contains('return merge(BoxStyler(color: value));'),
              contains(r'color: MixOps.merge($color, other?.$color),'),
              contains(
                r'final spec = BoxSpec(color: MixOps.resolve(context, $color));',
              ),
              contains(r"DiagnosticsProperty('color', $color)"),
              contains('List<Object?> get props =>'),
              isNot(contains(r'get $variants;')),
              isNot(contains(r'get $modifier;')),
              isNot(contains(r'get $animation;')),
            ]),
          ),
        },
      );
    });

    test('emits legacy call method from MixableSpec target', () async {
      const source = r'''
library styler_case;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/core/style_widget.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'styler_case.g.dart';

@MixableSpec(target: Box.new)
class BoxSpec extends Spec<BoxSpec> {
  const BoxSpec();
}

class Box extends StyleWidget<BoxSpec> {
  const Box({
    Key? key,
    required super.style,
    this.child,
  }) : super(key: key);

  final Widget? child;
}

@MixableStyler()
class BoxStyler extends Style<BoxSpec>
    with Diagnosticable, _$BoxStylerMixin {
  const BoxStyler()
      : super(variants: null, modifier: null, animation: null);

  const BoxStyler.create({
    super.variants,
    super.modifier,
    super.animation,
  });
}
''';

      await testBuilder(
        partBuilder(const StylerGenerator()),
        {
          ...mixAnnotationsSources,
          ...legacyFlutterSources,
          ...widgetStub,
          ...legacyMixSources,
          'mix_generator|lib/styler_case.dart': source,
        },
        generateFor: {'mix_generator|lib/styler_case.dart'},
        outputs: {
          'mix_generator|lib/styler_case.g.dart': decodedMatches(
            allOf([
              contains('Box call({Key? key, Widget? child})'),
              contains('return Box(key: key, style: this, child: child);'),
            ]),
          ),
        },
      );
    });
  });

  group('MixWidgetGenerator smoke', () {
    test(
      'variable-backed style: emits Card delegating to cardStyle.call',
      () async {
        const source = r'''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'widget_case.g.dart';

class BoxSpec {
  const BoxSpec();
}

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({Key? key, Widget? child}) => const _Stub();
}

class _Stub extends StatelessWidget {
  const _Stub();
  @override
  Widget build(BuildContext context) => const _Stub();
}

@MixWidget()
final cardStyle = const BoxStyler();
''';

        await expectGeneratorOutputResolves(
          builder: partBuilder(const MixWidgetGenerator()),
          sources: {
            ...mixAnnotationsSources,
            ...widgetStub,
            'mix|lib/src/core/style.dart': styleStub,
            'mix_generator|lib/widget_case.dart': source,
          },
          inputAsset: 'mix_generator|lib/widget_case.dart',
          outputAsset: 'mix_generator|lib/widget_case.g.dart',
          outputMatcher: allOf([
            contains('class Card extends StatelessWidget'),
            contains('const Card({super.key, this.child});'),
            contains('final Widget? child;'),
            contains('return cardStyle.call('),
            contains('key: this.key'),
            contains('child: this.child'),
          ]),
        );
      },
    );

    test(
      'function-backed style: routes factory params back into the factory',
      () async {
        const source = r'''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'widget_case.g.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({Key? key, Widget? child}) => const _Stub();
}

class _Stub extends StatelessWidget {
  const _Stub();
  @override
  Widget build(BuildContext context) => const _Stub();
}

@MixWidget()
BoxStyler badgeStyle({Color? color, BoxStyler? style}) => const BoxStyler();
''';

        await expectGeneratorOutputResolves(
          builder: partBuilder(const MixWidgetGenerator()),
          sources: {
            ...mixAnnotationsSources,
            ...widgetStub,
            'mix|lib/src/core/style.dart': styleStub,
            'mix_generator|lib/widget_case.dart': source,
          },
          inputAsset: 'mix_generator|lib/widget_case.dart',
          outputAsset: 'mix_generator|lib/widget_case.g.dart',
          outputMatcher: allOf([
            contains('class Badge extends StatelessWidget'),
            contains('final Color? color;'),
            contains('final BoxStyler? style;'),
            contains('final Widget? child;'),
            contains('return badgeStyle('),
            contains('color: this.color'),
            contains('style: this.style'),
          ]),
        );
      },
    );

    test('generic styler call params use concrete type arguments', () async {
      const source = r'''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'widget_case.g.dart';

class BoxSpec { const BoxSpec(); }

class GenericStyler<T> extends Style<BoxSpec> {
  const GenericStyler();

  Widget call({
    Key? key,
    required T value,
    required List<T> values,
  }) => const _Stub();
}

class _Stub extends StatelessWidget {
  const _Stub();
  @override
  Widget build(BuildContext context) => const _Stub();
}

@MixWidget()
final genericStyle = const GenericStyler<String>();
''';

      await expectGeneratorOutputResolves(
        builder: partBuilder(const MixWidgetGenerator()),
        sources: {
          ...mixAnnotationsSources,
          ...widgetStub,
          'mix|lib/src/core/style.dart': styleStub,
          'mix_generator|lib/widget_case.dart': source,
        },
        inputAsset: 'mix_generator|lib/widget_case.dart',
        outputAsset: 'mix_generator|lib/widget_case.g.dart',
        outputMatcher: allOf([
          contains('class Generic extends StatelessWidget'),
          contains('final String value;'),
          contains('final List<String> values;'),
          isNot(contains('final T value;')),
          isNot(contains('final List<T> values;')),
        ]),
      );
    });

    test('inherited generic call params use concrete type arguments', () async {
      const source = r'''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'widget_case.g.dart';

class BoxSpec { const BoxSpec(); }

class BaseStyler<T> extends Style<BoxSpec> {
  const BaseStyler();

  Widget call({
    Key? key,
    required T value,
    required List<T> values,
  }) => const _Stub();
}

class StringStyler extends BaseStyler<String> {
  const StringStyler();
}

class _Stub extends StatelessWidget {
  const _Stub();
  @override
  Widget build(BuildContext context) => const _Stub();
}

@MixWidget()
final inheritedStyle = const StringStyler();
''';

      await expectGeneratorOutputResolves(
        builder: partBuilder(const MixWidgetGenerator()),
        sources: {
          ...mixAnnotationsSources,
          ...widgetStub,
          'mix|lib/src/core/style.dart': styleStub,
          'mix_generator|lib/widget_case.dart': source,
        },
        inputAsset: 'mix_generator|lib/widget_case.dart',
        outputAsset: 'mix_generator|lib/widget_case.g.dart',
        outputMatcher: allOf([
          contains('class Inherited extends StatelessWidget'),
          contains('final String value;'),
          contains('final List<String> values;'),
          isNot(contains('final T value;')),
          isNot(contains('final List<T> values;')),
        ]),
      );
    });

    test(
      'generic styler call emits generic widget and forwards call type',
      () async {
        const source = r'''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'widget_case.g.dart';

class BoxSpec { const BoxSpec(); }

class RadioValue {}

enum Variant { surface }

class RadioStyler extends Style<BoxSpec> {
  const RadioStyler();

  Widget call<T extends RadioValue>({
    Key? key,
    required T value,
    required List<T> values,
  }) => const _Stub();
}

class _Stub extends StatelessWidget {
  const _Stub();
  @override
  Widget build(BuildContext context) => const _Stub();
}

@MixWidget(name: 'FortalRadio')
RadioStyler fortalRadioStyle({Variant variant = Variant.surface}) =>
    const RadioStyler();
''';

        await expectGeneratorOutputResolves(
          builder: partBuilder(const MixWidgetGenerator()),
          sources: {
            ...mixAnnotationsSources,
            ...widgetStub,
            'mix|lib/src/core/style.dart': styleStub,
            'mix_generator|lib/widget_case.dart': source,
          },
          inputAsset: 'mix_generator|lib/widget_case.dart',
          outputAsset: 'mix_generator|lib/widget_case.g.dart',
          outputMatcher: allOf([
            contains(
              'class FortalRadio<T extends RadioValue> extends StatelessWidget',
            ),
            contains('this.variant = Variant.surface'),
            contains('required this.value'),
            contains('required this.values'),
            contains('final T value;'),
            contains('final List<T> values;'),
            contains('return fortalRadioStyle('),
            contains('variant: this.variant'),
            contains('.call<T>('),
            contains('value: this.value'),
            contains('values: this.values'),
          ]),
        );
      },
    );

    test('generic styler call can return its widget type parameter', () async {
      const source = r'''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'widget_case.g.dart';

class BoxSpec { const BoxSpec(); }

class TypedStyler extends Style<BoxSpec> {
  const TypedStyler();

  T call<T extends Widget>({Key? key, required T child}) => child;
}

@MixWidget(name: 'TypedHost')
final typedStyle = const TypedStyler();
''';

      await expectGeneratorOutputResolves(
        builder: partBuilder(const MixWidgetGenerator()),
        sources: {
          ...mixAnnotationsSources,
          ...widgetStub,
          'mix|lib/src/core/style.dart': styleStub,
          'mix_generator|lib/widget_case.dart': source,
        },
        inputAsset: 'mix_generator|lib/widget_case.dart',
        outputAsset: 'mix_generator|lib/widget_case.g.dart',
        outputMatcher: allOf([
          contains('class TypedHost<T extends Widget> extends StatelessWidget'),
          contains('required this.child'),
          contains('final T child;'),
          contains('return typedStyle.call<T>('),
          contains('child: this.child'),
        ]),
      );
    });

    test('positional call param surfaces as a positional widget arg', () async {
      const source = r'''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'widget_case.g.dart';

class TextSpec { const TextSpec(); }

class TextStyler extends Style<TextSpec> {
  const TextStyler();
  Widget call(String text, {Key? key}) => const _Stub();
}

class _Stub extends StatelessWidget {
  const _Stub();
  @override
  Widget build(BuildContext context) => const _Stub();
}

@MixWidget()
TextStyler labelStyle({Color? color}) => const TextStyler();
''';

      await expectGeneratorOutputResolves(
        builder: partBuilder(const MixWidgetGenerator()),
        sources: {
          ...mixAnnotationsSources,
          ...widgetStub,
          'mix|lib/src/core/style.dart': styleStub,
          'mix_generator|lib/widget_case.dart': source,
        },
        inputAsset: 'mix_generator|lib/widget_case.dart',
        outputAsset: 'mix_generator|lib/widget_case.g.dart',
        outputMatcher: allOf([
          contains('class Label extends StatelessWidget'),
          contains('this.text'),
          contains('final String text;'),
          contains('final Color? color;'),
          contains('return labelStyle(color: this.color).call('),
          contains('this.text'),
          contains('key: this.key'),
        ]),
      );
    });

    test('custom styler with required call params + non-key call', () async {
      const source = r'''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'widget_case.g.dart';

class ButtonSpec { const ButtonSpec(); }

class ButtonStyler extends Style<ButtonSpec> {
  const ButtonStyler();
  Widget call({
    Key? key,
    required VoidCallback onPressed,
    required Widget child,
  }) => const _Stub();
}

class _Stub extends StatelessWidget {
  const _Stub();
  @override
  Widget build(BuildContext context) => const _Stub();
}

@MixWidget()
ButtonStyler primaryButtonStyle({Color color = const Color(0xFF0000FF)}) =>
    const ButtonStyler();
''';

      await expectGeneratorOutputResolves(
        builder: partBuilder(const MixWidgetGenerator()),
        sources: {
          ...mixAnnotationsSources,
          ...widgetStub,
          'mix|lib/src/core/style.dart': styleStub,
          'mix_generator|lib/widget_case.dart': source,
        },
        inputAsset: 'mix_generator|lib/widget_case.dart',
        outputAsset: 'mix_generator|lib/widget_case.g.dart',
        outputMatcher: allOf([
          contains('class PrimaryButton extends StatelessWidget'),
          contains('required this.onPressed'),
          contains('required this.child'),
          contains('this.color = const Color(0xFF0000FF)'),
          // Formatter may wrap `primaryButtonStyle(color: this.color)` across
          // lines; assert the call invocation without whitespace.
          contains('primaryButtonStyle('),
          contains('color: this.color'),
          contains('.call('),
          contains('onPressed: this.onPressed'),
          contains('child: this.child'),
        ]),
      );
    });

    test(
      'styler without Key? key on call() omits key forwarding in build',
      () async {
        const source = r'''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'widget_case.g.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({Widget? child}) => const _Stub();
}

class _Stub extends StatelessWidget {
  const _Stub();
  @override
  Widget build(BuildContext context) => const _Stub();
}

@MixWidget()
final keyLessStyle = const BoxStyler();
''';

        await expectGeneratorOutputResolves(
          builder: partBuilder(const MixWidgetGenerator()),
          sources: {
            ...mixAnnotationsSources,
            ...widgetStub,
            'mix|lib/src/core/style.dart': styleStub,
            'mix_generator|lib/widget_case.dart': source,
          },
          inputAsset: 'mix_generator|lib/widget_case.dart',
          outputAsset: 'mix_generator|lib/widget_case.g.dart',
          outputMatcher: allOf([
            contains('class KeyLess extends StatelessWidget'),
            contains('const KeyLess({super.key, this.child});'),
            contains('return keyLessStyle.call('),
            contains('child: this.child'),
            isNot(contains('key: this.key')),
          ]),
        );
      },
    );

    test('name override on @MixWidget(name:) wins', () async {
      const source = r'''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'widget_case.g.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({Key? key, Widget? child}) => const _Stub();
}

class _Stub extends StatelessWidget {
  const _Stub();
  @override
  Widget build(BuildContext context) => const _Stub();
}

@MixWidget(name: 'MyFancyCard')
final cardStyle = const BoxStyler();
''';

      await expectGeneratorOutputResolves(
        builder: partBuilder(const MixWidgetGenerator()),
        sources: {
          ...mixAnnotationsSources,
          ...widgetStub,
          'mix|lib/src/core/style.dart': styleStub,
          'mix_generator|lib/widget_case.dart': source,
        },
        inputAsset: 'mix_generator|lib/widget_case.dart',
        outputAsset: 'mix_generator|lib/widget_case.g.dart',
        outputMatcher: contains('class MyFancyCard extends StatelessWidget'),
      );
    });

    test(
      'BuildContext param named context forwards from this.context',
      () async {
        const source = r'''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'widget_case.g.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({Key? key, Widget? child}) => const _Stub();
}

class _Stub extends StatelessWidget {
  const _Stub();
  @override
  Widget build(BuildContext context) => const _Stub();
}

@MixWidget()
BoxStyler contextualStyle({BuildContext? context}) => const BoxStyler();
''';

        await expectGeneratorOutputResolves(
          builder: partBuilder(const MixWidgetGenerator()),
          sources: {
            ...mixAnnotationsSources,
            ...widgetStub,
            'mix|lib/src/core/style.dart': styleStub,
            'mix_generator|lib/widget_case.dart': source,
          },
          inputAsset: 'mix_generator|lib/widget_case.dart',
          outputAsset: 'mix_generator|lib/widget_case.g.dart',
          outputMatcher: allOf([
            contains('class Contextual extends StatelessWidget'),
            contains('final BuildContext? context;'),
            contains('return contextualStyle('),
            contains('context: this.context'),
            contains('key: this.key'),
            contains('child: this.child'),
          ]),
        );
      },
    );

    test(
      'function-backed style resolves with this-qualified factory and call args',
      () async {
        const source = r'''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'widget_case.g.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({Key? key, required Widget child}) => const _Stub();
}

class _Stub extends StatelessWidget {
  const _Stub();
  @override
  Widget build(BuildContext context) => const _Stub();
}

@MixWidget()
BoxStyler chipStyle(Color color, {BoxStyler? style}) => const BoxStyler();
''';

        await expectGeneratorOutputResolves(
          builder: partBuilder(const MixWidgetGenerator()),
          sources: {
            ...mixAnnotationsSources,
            ...widgetStub,
            'mix|lib/src/core/style.dart': styleStub,
            'mix_generator|lib/widget_case.dart': source,
          },
          inputAsset: 'mix_generator|lib/widget_case.dart',
          outputAsset: 'mix_generator|lib/widget_case.g.dart',
          outputMatcher: allOf([
            contains('class Chip extends StatelessWidget'),
            contains('return chipStyle('),
            contains('this.color'),
            contains('style: this.style'),
            contains('key: this.key'),
            contains('child: this.child'),
          ]),
        );
      },
    );
  });
}
