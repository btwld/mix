import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

Builder _partBuilder(Generator generator) =>
    PartBuilder([generator], '.g.dart');

void main() {
  group('generator smoke', () {
    test('SpecGenerator handles nullable list fields end-to-end', () async {
      const source = r'''
library spec_case;

part 'spec_case.g.dart';

class MixableSpec {
  final int methods;
  final int components;

  const MixableSpec({this.methods = 0x01 | 0x02 | 0x04, this.components = 0});
}

class Spec<T> {
  const Spec();
}

class Shadow {}

@MixableSpec()
class BoxSpec extends Spec<BoxSpec> {
  final List<Shadow>? shadows;

  const BoxSpec({this.shadows});
}
''';

      await testBuilder(
        _partBuilder(const SpecGenerator()),
        {'mix_generator|lib/spec_case.dart': source},
        generateFor: {'mix_generator|lib/spec_case.dart'},
        outputs: {
          'mix_generator|lib/spec_case.g.dart': decodedMatches(
            allOf(
              contains(
                'mixin _\$BoxSpecMethods on Spec<BoxSpec>, Diagnosticable',
              ),
              contains('List<Shadow>? get shadows;'),
              contains('BoxSpec copyWith({List<Shadow>? shadows})'),
              contains('shadows: shadows ?? this.shadows'),
              contains("IterableProperty<Shadow>('shadows', shadows)"),
              contains('MixOps.lerp(shadows, other?.shadows, t)'),
            ),
          ),
        },
      );
    });

    test(
      'StylerGenerator unwraps Prop<T> and preserves nested generics',
      () async {
        const source = r'''
library styler_case;

part 'styler_case.g.dart';

class MixableStyler {
  final int methods;

  const MixableStyler({
    this.methods = 0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20,
  });
}

class Prop<T> {
  const Prop();
}

class Style<T> {
  final Object? $variants;
  final Object? $modifier;
  final Object? $animation;

  const Style({Object? variants, Object? modifier, Object? animation})
    : $variants = variants,
      $modifier = modifier,
      $animation = animation;
}

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
          _partBuilder(const StylerGenerator()),
          {'mix_generator|lib/styler_case.dart': source},
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

    test(
      'MixableGenerator emits declared getters and defaultValue fallback',
      () async {
        const source = r'''
library mix_case;

part 'mix_case.g.dart';

class Mixable {
  final int methods;
  final String? resolveToType;

  const Mixable({this.methods = 0x01 | 0x02 | 0x04 | 0x08, this.resolveToType});
}

class Prop<T> {
  const Prop();
}

class Mix<T> {
  const Mix();
}

mixin DefaultValue<T> {
  T get defaultValue;
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
          _partBuilder(const MixableGenerator()),
          {'mix_generator|lib/mix_case.dart': source},
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
  });
}
