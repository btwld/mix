import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

Builder _partBuilder(Generator generator) =>
    PartBuilder([generator], '.g.dart');

const _mixStubSource = r'''
library mix;
class Style<T> { const Style(); }
''';

Future<void> _expectInvalid(String source, String messageFragment) async {
  final result = await testBuilder(
    _partBuilder(const MixWidgetGenerator()),
    {'mix|lib/mix.dart': _mixStubSource, 'mix_generator|lib/case.dart': source},
    generateFor: {'mix_generator|lib/case.dart'},
    onLog: (_) {},
  );
  expect(result.succeeded, isFalse);
  expect(result.errors.join('\n'), contains(messageFragment));
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
import 'package:mix/mix.dart';
part 'case.g.dart';
class MixWidget { final String name; final bool stylable; const MixWidget(this.name, {this.stylable = false}); }
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
import 'package:mix/mix.dart';
part 'case.g.dart';
class MixWidget { final String name; final bool stylable; const MixWidget(this.name, {this.stylable = false}); }
class BoxSpec {}
class Key { const Key(); }
class BuildContext {}
abstract class Widget { const Widget({Key? key}); }
abstract class StatelessWidget extends Widget { const StatelessWidget({Key? key}) : super(key: key); Widget build(BuildContext context); }
class SizedBox extends StatelessWidget { const SizedBox({Key? key}) : super(key: key); @override Widget build(BuildContext context) => this; }
class Box extends StatelessWidget {
  const Box({Key? key, Object? style, Widget? child}) : super(key: key);
  @override
  Widget build(BuildContext context) => const SizedBox();
}
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

    test('rejects stylable when Styler call has a style param', () async {
      const source = r'''
library c;
import 'package:mix/mix.dart';
part 'case.g.dart';
class MixWidget { final String name; final bool stylable; const MixWidget(this.name, {this.stylable = false}); }
class BoxSpec {}
class Key { const Key(); }
class BuildContext {}
abstract class Widget { const Widget({Key? key}); }
abstract class StatelessWidget extends Widget { const StatelessWidget({Key? key}) : super(key: key); Widget build(BuildContext context); }
class SizedBox extends StatelessWidget { const SizedBox({Key? key}) : super(key: key); @override Widget build(BuildContext context) => this; }
class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  BoxStyler merge(BoxStyler? other) => this;
  SizedBox call({Key? key, BoxStyler? style}) => const SizedBox();
}
@MixWidget('Bad', stylable: true)
final bad = const BoxStyler();
''';
      await _expectInvalid(source, 'reserves the `style`');
    });
  });
}
