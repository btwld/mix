import 'package:build_test/build_test.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:test/test.dart';

import '../core/test_helpers.dart';

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
                // skipEquals -> no generated `props` body.
                isNot(contains('List<Object?> get props =>')),
                // Equality surface still emits and references `props`.
                contains('bool operator ==(Object other)'),
                contains('propsEquals(props, other.props)'),
                contains('int get hashCode => propsHash(runtimeType, props)'),
                contains('bool get stringify => true;'),
                contains('Map<String, String> getDiff(Equatable other)'),
                // copyWith + lerp still emit (their flags are on).
                contains('BoxSpec copyWith('),
                contains('BoxSpec lerp(BoxSpec? other, double t)'),
              ]),
            ),
          },
        );
      },
    );

    test(
      'StylerGenerator unwraps Prop<T> and preserves nested generics',
      () async {
        const source = r'''
library styler_case;

import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/prop.dart';
import 'package:mix/src/core/style.dart';

part 'styler_case.g.dart';

class EdgeInsetsGeometry {}

class Shadow {}

class BoxSpec {
  final EdgeInsetsGeometry? padding;
  final List<Shadow>? shadows;

  const BoxSpec({this.padding, this.shadows});
}

@MixableStyler()
class BoxStyler extends Style<BoxSpec> {
  final Prop<EdgeInsetsGeometry>? $padding;
  final Prop<List<Shadow>>? $shadows;

  const BoxStyler({
    Prop<EdgeInsetsGeometry>? padding,
    Prop<List<Shadow>>? shadows,
    Object? variants,
    Object? modifier,
    Object? animation,
  }) : $padding = padding,
       $shadows = shadows,
       super(variants: variants, modifier: modifier, animation: animation);

  static BoxStyler create({
    Prop<EdgeInsetsGeometry>? padding,
    Prop<List<Shadow>>? shadows,
    Object? variants,
    Object? modifier,
    Object? animation,
  }) => BoxStyler(
    padding: padding,
    shadows: shadows,
    variants: variants,
    modifier: modifier,
    animation: animation,
  );
}
''';

        await testBuilder(
          partBuilder(const StylerGenerator()),
          {
            ...mixAnnotationsSources,
            'mix_generator|lib/styler_case.dart': source,
            'mix|lib/src/core/prop.dart': propStub,
            'mix|lib/src/core/style.dart': styleStub,
          },
          generateFor: {'mix_generator|lib/styler_case.dart'},
          outputs: {
            'mix_generator|lib/styler_case.g.dart': decodedMatches(
              allOf(
                contains(
                  'mixin _\$BoxStylerMixin on Style<BoxSpec>, Diagnosticable',
                ),
                contains(r'Prop<EdgeInsetsGeometry>? get $padding;'),
                contains(r'Prop<List<Shadow>>? get $shadows;'),
                contains('BoxStyler padding(EdgeInsetsGeometryMix value)'),
                contains('BoxStyler shadows(List<Shadow> value)'),
                contains(r'padding: MixOps.resolve(context, $padding),'),
                contains(r'shadows: MixOps.resolve(context, $shadows),'),
              ),
            ),
          },
        );
      },
    );

    test('StylerGenerator does not unwrap local Prop lookalikes', () async {
      const source = r'''
library styler_case;

import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

part 'styler_case.g.dart';

class Prop<T> {
  const Prop();
}

class EdgeInsetsGeometry {}

class BoxSpec {
  final EdgeInsetsGeometry? padding;

  const BoxSpec({this.padding});
}

@MixableStyler()
class BoxStyler extends Style<BoxSpec> {
  final Prop<EdgeInsetsGeometry>? $padding;

  const BoxStyler({
    Prop<EdgeInsetsGeometry>? padding,
    Object? variants,
    Object? modifier,
    Object? animation,
  }) : $padding = padding,
       super(variants: variants, modifier: modifier, animation: animation);

  static BoxStyler create({
    Prop<EdgeInsetsGeometry>? padding,
    Object? variants,
    Object? modifier,
    Object? animation,
  }) => BoxStyler(
    padding: padding,
    variants: variants,
    modifier: modifier,
    animation: animation,
  );
}
''';

      await testBuilder(
        partBuilder(const StylerGenerator()),
        {
          ...mixAnnotationsSources,
          'mix_generator|lib/styler_case.dart': source,
          'mix|lib/src/core/style.dart': styleStub,
        },
        generateFor: {'mix_generator|lib/styler_case.dart'},
        outputs: {
          'mix_generator|lib/styler_case.g.dart': decodedMatches(
            allOf(
              contains(r'Prop<EdgeInsetsGeometry>? get $padding;'),
              contains('BoxStyler padding(Prop<EdgeInsetsGeometry> value)'),
              isNot(contains('BoxStyler padding(EdgeInsetsGeometryMix value)')),
            ),
          ),
        },
      );
    });

    test(
      'StylerGenerator preserves prefixes in generated field types',
      () async {
        const source = r'''
library styler_case;

import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/prop.dart' as mix_prop;
import 'package:mix/src/core/style.dart';
import 'visible.dart' as v;

part 'styler_case.g.dart';

class BoxSpec {
  final v.VisibleType? value;

  const BoxSpec({this.value});
}

@MixableStyler()
class BoxStyler extends Style<BoxSpec> {
  final mix_prop.Prop<v.VisibleType>? $value;

  const BoxStyler({
    mix_prop.Prop<v.VisibleType>? value,
    Object? variants,
    Object? modifier,
    Object? animation,
  }) : $value = value,
       super(variants: variants, modifier: modifier, animation: animation);

  static BoxStyler create({
    mix_prop.Prop<v.VisibleType>? value,
    Object? variants,
    Object? modifier,
    Object? animation,
  }) => BoxStyler(
    value: value,
    variants: variants,
    modifier: modifier,
    animation: animation,
  );
}
''';

        await testBuilder(
          partBuilder(const StylerGenerator()),
          {
            ...mixAnnotationsSources,
            'mix_generator|lib/styler_case.dart': source,
            'mix_generator|lib/visible.dart': visibleTypeStub,
            'mix|lib/src/core/prop.dart': propStub,
            'mix|lib/src/core/style.dart': styleStub,
          },
          generateFor: {'mix_generator|lib/styler_case.dart'},
          outputs: {
            'mix_generator|lib/styler_case.g.dart': decodedMatches(
              allOf(
                contains(r'mix_prop.Prop<v.VisibleType>? get $value;'),
                contains('BoxStyler value(v.VisibleType value)'),
              ),
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

// Intermediate class introduces its own generic parameter `A` while
// binding `Mix<BoxConstraints>`. The resolve-target must be
// `BoxConstraints`, not `A`.
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
                // Must resolve to BoxConstraints (the Mix binding), not int.
                contains('BoxConstraints resolve(BuildContext context)'),
                contains('return BoxConstraints('),
              ),
            ),
          },
        );
      },
    );
  });
}
