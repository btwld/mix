import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

Builder _partBuilder(Generator generator) =>
    PartBuilder([generator], '.g.dart');

const _baseSource = r'''
library mix_widget_case;

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

class Key {
  const Key();
}

class BuildContext {}

abstract class Widget {
  const Widget({Key? key});
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget({Key? key}) : super(key: key);
  Widget build(BuildContext context);
}

class SizedBox extends StatelessWidget {
  const SizedBox({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => this;
}

class Color {
  final int value;
  const Color(this.value);
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

class TextStyler extends Style<BoxSpec> {
  const TextStyler();
  TextStyler size(double v) => this;
  TextStyler merge(TextStyler? other) => this;
  SizedBox call(String text) => const SizedBox();
}
''';

void main() {
  group('MixWidgetGenerator smoke', () {
    test('variable form emits widget class and build body', () async {
      const source =
          '''
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
      const source =
          '''
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
              contains('const Card1(this.child, {super.key,'),
              contains('this.color = const Color(0xFFFFFFFF)'),
              contains('createCard(child, color: color)(child: child)'),
            ),
          ),
        },
      );
    });

    test('stylable: true injects style field and merge call', () async {
      const source =
          '''
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

    test(
      'positional call method keeps positional on widget constructor',
      () async {
        const source =
            '''
$_baseSource

@MixWidget('Heading')
final heading = TextStyler().size(24);
''';

        await testBuilder(
          _partBuilder(const MixWidgetGenerator()),
          {'mix_generator|lib/mix_widget_case.dart': source},
          generateFor: {'mix_generator|lib/mix_widget_case.dart'},
          outputs: {
            'mix_generator|lib/mix_widget_case.g.dart': decodedMatches(
              allOf(
                contains('class Heading extends StatelessWidget'),
                contains('final String text;'),
                contains('const Heading(this.text, {super.key});'),
                contains(
                  'Widget build(BuildContext context) => heading(text);',
                ),
              ),
            ),
          },
        );
      },
    );

    test('inherits call from superclass styler', () async {
      const source =
          '''
$_baseSource

class SubStyler extends BoxStyler {
  const SubStyler();
}

@MixWidget('SubCard')
final subCard = const SubStyler();
''';

      await testBuilder(
        _partBuilder(const MixWidgetGenerator()),
        {'mix_generator|lib/mix_widget_case.dart': source},
        generateFor: {'mix_generator|lib/mix_widget_case.dart'},
        outputs: {
          'mix_generator|lib/mix_widget_case.g.dart': decodedMatches(
            allOf(
              contains('class SubCard extends StatelessWidget'),
              contains('final Widget? child;'),
              contains(
                'Widget build(BuildContext context) => subCard(child: child);',
              ),
            ),
          ),
        },
      );
    });

    test('required nullable named parameter keeps required keyword', () async {
      const source =
          '''
$_baseSource

@MixWidget('RequiredCard')
BoxStyler makeRequiredCard({required Widget? child}) => BoxStyler();
''';

      await testBuilder(
        _partBuilder(const MixWidgetGenerator()),
        {'mix_generator|lib/mix_widget_case.dart': source},
        generateFor: {'mix_generator|lib/mix_widget_case.dart'},
        outputs: {
          'mix_generator|lib/mix_widget_case.g.dart': decodedMatches(
            allOf(
              contains('final Widget? child;'),
              contains('required this.child'),
            ),
          ),
        },
      );
    });
  });
}
