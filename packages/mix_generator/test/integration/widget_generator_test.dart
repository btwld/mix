import 'package:logging/logging.dart';
import 'package:test/test.dart';

import '../support/widget_generator_test_support.dart';

String _severeMessages(Iterable<LogRecord> logs) {
  return logs
      .where((record) => record.level == Level.SEVERE)
      .map((record) => record.message)
      .join();
}

String _contextStyleSource({
  required String factoryDeclaration,
  String imports = r'''
import 'package:flutter/widgets.dart';
''',
  String extraDeclarations = '',
}) {
  return '''
library input;

$imports
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

$extraDeclarations
class ContextStyle extends Style<BoxSpec> {
  const ContextStyle();

  ContextStyle merge(ContextStyle? other) => this;

  Box call({Key? key, Widget? child}) {
    return Box(key: key, style: this, child: child);
  }
}

@MixWidget()
$factoryDeclaration
''';
}

void main() {
  group('MixWidgetGenerator validation', () {
    test('rejects non-final top-level variables', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
var cardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('only supports top-level final variables'),
      );
    });

    test('rejects private declarations', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final _cardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('does not support private declarations'),
      );
    });

    test('rejects stylers without a call method', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class CustomSpec extends Spec<CustomSpec> {
  const CustomSpec();
}

class CustomButtonStyle extends Style<CustomSpec> {
  const CustomButtonStyle();

  CustomButtonStyle merge(CustomButtonStyle? other) => this;
}

@MixWidget()
final solidButtonStyle = CustomButtonStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('No callable `call()` method found for CustomButtonStyle'),
      );
    });

    test('renders custom widgets through styler call methods', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class ButtonSpec extends Spec<ButtonSpec> {
  const ButtonSpec();
}

class ButtonStyler extends Style<ButtonSpec> {
  const ButtonStyler();

  ButtonStyler color(Color value) => this;

  ButtonStyler merge(ButtonStyler? other) => this;

  Button call({
    Key? key,
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return Button(
      key: key,
      style: this,
      onPressed: onPressed,
      child: child,
    );
  }
}

class Button extends Widget {
  final Key? key;
  final ButtonStyler style;
  final VoidCallback onPressed;
  final Widget child;

  const Button({
    this.key,
    required this.style,
    required this.onPressed,
    required this.child,
  });
}

@MixWidget()
ButtonStyler primaryButtonStyle({Color color = Colors.blue}) {
  return ButtonStyler().color(color);
}
''';

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('class PrimaryButton extends StatelessWidget'));
      expect(output, contains('final Color color;'));
      expect(output, contains('final VoidCallback onPressed;'));
      expect(output, contains('final Widget child;'));
      expect(output, contains('return primaryButtonStyle('));
      expect(output, contains(').call('));
      expect(output, contains('key: key'));
      expect(output, contains('onPressed: onPressed'));
      expect(output, contains('child: child'));
      expect(output, isNot(contains('return Button(')));
    });

    test('injects BuildContext into function-backed style factories', () async {
      final source = _contextStyleSource(
        factoryDeclaration: r'''
ContextStyle contextualButtonStyle(
  BuildContext context, {
  bool compact = false,
}) {
  return const ContextStyle();
}
''',
      );

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(
        output,
        contains('class ContextualButton extends StatelessWidget'),
      );
      expect(output, isNot(contains('final BuildContext context;')));
      expect(output, isNot(contains('this.context')));
      expect(output, contains('final bool compact;'));
      expect(output, contains('this.compact = false'));
      expect(output, contains('final Widget? child;'));
      expect(output, isNot(contains('.merge(style)')));
      expect(output, contains('context,'));
      expect(output, contains('compact: compact'));
      expect(
        output,
        allOf(
          contains('return contextualButtonStyle('),
          contains(').call(key: key, child: child);'),
        ),
      );
      expect(output, contains('child: child'));
    });

    test('does not shadow public factory parameters named context', () async {
      final source = _contextStyleSource(
        factoryDeclaration: r'''
ContextStyle contextualButtonStyle(String context) {
  return const ContextStyle();
}
''',
      );

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('final String context;'));
      expect(output, contains('contextualButtonStyle(this.context).call('));
    });

    test('rejects BuildContext factory parameters with wrong names', () async {
      final source = _contextStyleSource(
        factoryDeclaration: r'''
ContextStyle contextualButtonStyle(BuildContext themeContext) {
  return const ContextStyle();
}
''',
      );

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains(
          'can inject only a first required positional BuildContext parameter named `context`',
        ),
      );
    });

    test('rejects named BuildContext factory parameters', () async {
      final source = _contextStyleSource(
        factoryDeclaration: r'''
ContextStyle contextualButtonStyle({required BuildContext context}) {
  return const ContextStyle();
}
''',
      );

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains(
          'can inject only a first required positional BuildContext parameter named `context`',
        ),
      );
    });

    test('rejects optional positional BuildContext factory parameters', () async {
      final source = _contextStyleSource(
        factoryDeclaration: r'''
ContextStyle contextualButtonStyle([BuildContext? context]) {
  return const ContextStyle();
}
''',
      );

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains(
          'can inject only a first required positional BuildContext parameter named `context`',
        ),
      );
    });

    test('rejects later positional BuildContext factory parameters', () async {
      final source = _contextStyleSource(
        factoryDeclaration: r'''
ContextStyle contextualButtonStyle(bool compact, BuildContext context) {
  return const ContextStyle();
}
''',
      );

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('does not expose BuildContext factory parameters'),
      );
    });

    test('rejects non-Flutter classes named BuildContext', () async {
      final source = _contextStyleSource(
        imports: r'''
import 'package:flutter/widgets.dart' hide BuildContext;
''',
        extraDeclarations: r'''
class BuildContext {
  const BuildContext();
}
''',
        factoryDeclaration: r'''
ContextStyle contextualButtonStyle(BuildContext context) {
  return const ContextStyle();
}
''',
      );

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains(
          'requires `Widget`, `StatelessWidget`, and `BuildContext` to be '
          'available without an import prefix',
        ),
      );
    });

    test('rejects non-style targets', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final headingText = 'hello';
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('returning a Style<T> subtype'));
    });

    test('rejects fake Style base classes', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart' hide Style;
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class Style<T> {
  const Style();
}

class FakeBoxStyler extends Style<BoxSpec> {
  const FakeBoxStyler();
}

@MixWidget()
final fakeBoxStyle = FakeBoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('returning a Style<T> subtype'));
    });

    test('rejects nullable styler targets', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final BoxStyler? cardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('does not support nullable styler types'),
      );
    });

    test('rejects style targets without a resolvable spec type', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class BrokenStyle extends Style<dynamic> {
  const BrokenStyle();

  BrokenStyle merge(BrokenStyle? other) => this;
}

@MixWidget()
final brokenStyle = BrokenStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('Could not determine the Style<T> spec type'),
      );
    });

    test(
      'rejects base Style declarations without a concrete styler type',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final Style<BoxSpec> cardStyle = BoxStyler();
''';

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains(
            'requires a concrete styler type with a callable `call()` method',
          ),
        );
      },
    );

    test('rejects call methods that do not return widgets', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class CustomSpec extends Spec<CustomSpec> {
  const CustomSpec();
}

class CustomStyle extends Style<CustomSpec> {
  const CustomStyle();

  CustomStyle merge(CustomStyle? other) => this;

  String call() => 'no widget';
}

@MixWidget()
final customStyle = CustomStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('must return a Flutter Widget'));
    });

    test('rejects call methods whose key parameter is not Key?', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class CustomSpec extends Spec<CustomSpec> {
  const CustomSpec();
}

class CustomStyle extends Style<CustomSpec> {
  const CustomStyle();

  CustomStyle merge(CustomStyle? other) => this;

  Widget call({String? key}) => const Widget();
}

@MixWidget()
final customStyle = CustomStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('must be `Key?`'));
    });

    test(
      'omits key forwarding when the call method has no key parameter',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class PlainSpec extends Spec<PlainSpec> {
  const PlainSpec();
}

class PlainStyle extends Style<PlainSpec> {
  const PlainStyle();

  PlainStyle merge(PlainStyle? other) => this;

  Widget call({Widget? child}) => child ?? const Widget();
}

@MixWidget()
final plainStyle = PlainStyle();
''';

        final output = await generateMixWidgetOutput(inputSource: source);

        expect(output, contains('return plainStyle.call(child: child);'));
        expect(output, isNot(contains('key: key')));
      },
    );

    test('rejects private call parameters', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class PrivateParamSpec extends Spec<PrivateParamSpec> {
  const PrivateParamSpec();
}

class PrivateParamStyle extends Style<PrivateParamSpec> {
  const PrivateParamStyle();

  PrivateParamStyle merge(PrivateParamStyle? other) => this;

  Widget call({String? _label}) => const Widget();
}

@MixWidget()
final privateParamStyle = PrivateParamStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains(
          'Parameter `_label` cannot be private in a generated @MixWidget wrapper',
        ),
      );
    });

    test('rejects optional positional call parameters', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class LabelSpec extends Spec<LabelSpec> {
  const LabelSpec();
}

class LabelStyle extends Style<LabelSpec> {
  const LabelStyle();

  LabelStyle merge(LabelStyle? other) => this;

  Widget call([String label = 'x']) => const Widget();
}

@MixWidget()
final labelStyle = LabelStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('parameter `label` is optional positional'),
      );
    });

    test(
      'rejects call parameter defaults that reference invisible identifiers',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import 'banner_style.dart';

part 'input.g.dart';

@MixWidget()
final bannerStyle = BannerStyle();
''';

        final logs = await runMixWidgetWithLogs(
          source,
          extraSources: {
            'mix_generator|lib/banner_style.dart': r'''
library banner_style;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'hidden_defaults.dart';

class BannerSpec extends Spec<BannerSpec> {
  const BannerSpec();
}

class BannerStyle extends Style<BannerSpec> {
  const BannerStyle();

  BannerStyle merge(BannerStyle? other) => this;

  Banner call({String label = defaultLabel}) => Banner(label: label);
}

class Banner extends Widget {
  final String label;

  const Banner({this.label = defaultLabel});
}
''',
            'mix_generator|lib/hidden_defaults.dart': r'''
library hidden_defaults;

const defaultLabel = 'banner';
''',
          },
        );

        expect(_severeMessages(logs), contains('references `defaultLabel`'));
      },
    );

    test('rejects call parameter defaults shadowed by a same-named '
        'declaration in the annotated library', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import 'banner_style.dart';

part 'input.g.dart';

const defaultLabel = 'wrong banner';

@MixWidget()
final bannerStyle = BannerStyle();
''';

      final logs = await runMixWidgetWithLogs(
        source,
        extraSources: {
          'mix_generator|lib/banner_style.dart': r'''
library banner_style;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

const defaultLabel = 'style banner';

class BannerSpec extends Spec<BannerSpec> {
  const BannerSpec();
}

class BannerStyle extends Style<BannerSpec> {
  const BannerStyle();

  BannerStyle merge(BannerStyle? other) => this;

  Banner call({String label = defaultLabel}) => Banner(label: label);
}

class Banner extends Widget {
  final String label;

  const Banner({this.label = defaultLabel});
}
''',
        },
      );

      expect(
        _severeMessages(logs),
        contains('resolves to a different declaration'),
      );
    });

    test('forwards call method context parameters via this.context', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class ContextWidget extends Widget {
  final String context;

  const ContextWidget({required this.context});
}

class ContextStyler extends Style<ContextSpec> {
  const ContextStyler();

  ContextStyler merge(ContextStyler? other) => this;

  ContextWidget call({required String context}) {
    return ContextWidget(context: context);
  }
}

class ContextSpec extends Spec<ContextSpec> {
  const ContextSpec();
}

@MixWidget()
final contextStyle = ContextStyler();
''';

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('final String context;'));
      expect(output, contains('context: this.context'));
    });

    test('rejects generic call methods', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class CustomSpec extends Spec<CustomSpec> {
  const CustomSpec();
}

class CustomStyle extends Style<CustomSpec> {
  const CustomStyle();

  CustomStyle merge(CustomStyle? other) => this;

  Widget call<T>() => const Widget();
}

@MixWidget()
final customStyle = CustomStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('must not be generic'));
    });

    test('rejects invalid annotation target kinds', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
class CardStyle {}
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains(
          'only supports top-level final variables and top-level functions',
        ),
      );
    });

    test(
      'rejects explicit generated names that collide with another declaration',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class Toolbar {}

@MixWidget(name: 'Toolbar')
final toolbarStyle = BoxStyler();
''';

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains(
            'Generated widget name `Toolbar` conflicts with an existing declaration',
          ),
        );
      },
    );

    test(
      'rejects explicit generated names that are not valid class identifiers',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget(name: 'my-card')
final myCardStyle = BoxStyler();
''';

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains('is not a valid Dart class identifier'),
        );
      },
    );

    test('rejects private explicit generated names', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget(name: '_Card')
final cardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('requires a public generated class name'),
      );
    });

    test(
      'rejects generated names that collide with another declaration in the library',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class MyCard {}

@MixWidget()
final myCardStyle = BoxStyler();
''';

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains(
            'Generated widget name `MyCard` conflicts with an existing declaration',
          ),
        );
      },
    );

    test(
      'rejects duplicate generated names across annotated declarations',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final myCardStyle = BoxStyler();

@MixWidget()
final myCardStyler = BoxStyler();
''';

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains(
            'Generated widget name `MyCard` is duplicated in this library',
          ),
        );
      },
    );

    test('rejects declarations whose derived widget name is empty', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final Styler = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('could not derive a widget name from `Styler`'),
      );
    });

    test(
      'rejects parameter collisions between factory and widget params',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
BoxStyler chipStyle({required Widget child}) => BoxStyler();
''';

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains('Duplicate generated parameter `child`'),
        );
      },
    );

    test('rejects reserved parameter `key`', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
BoxStyler chipStyle({required Color key}) => BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('Parameter `key` is reserved by @MixWidget.'),
      );
    });

    test('rejects reserved parameter `build`', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
BoxStyler chipStyle({required Widget build}) => BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('Parameter `build` is reserved by @MixWidget.'),
      );
    });

    test('allows factory parameters named style', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
BoxStyler chipStyle({BoxStyler? style}) {
  return BoxStyler().merge(style);
}
''';

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('final BoxStyler? style;'));
      expect(output, contains('return chipStyle(style: style).call('));
      expect(output, isNot(contains('.merge(style)')));
    });

    test('does not synthesize style parameters for variables', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final chipStyle = BoxStyler();
''';

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('class Chip extends StatelessWidget'));
      expect(output, isNot(contains('final BoxStyler? style;')));
      expect(output, isNot(contains('this.style')));
      expect(output, isNot(contains('chipStyle(style: style)')));
      expect(output, isNot(contains('.merge(style)')));
      expect(output, contains('return chipStyle.call('));
    });

    test('does not need prefixed built-in widget references', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart' as mix;
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final prefixedCardStyle = mix.BoxStyler();
''';

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('class PrefixedCard extends StatelessWidget'));
      expect(output, contains('final Widget? child;'));
      expect(
        output,
        contains('return prefixedCardStyle.call(key: key, child: child);'),
      );
    });

    test('allows hidden built-in widget classes', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart' hide Box;
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final hiddenBoxStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(logs.where((record) => record.level == Level.SEVERE), isEmpty);
    });

    test('rejects Mix-owned wrappers without a concrete call method', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class NoCallBoxStyle extends Style<BoxSpec> {
  const NoCallBoxStyle();

  NoCallBoxStyle merge(NoCallBoxStyle? other) => this;
}

@MixWidget(name: 'NoCallBox')
final noCallBoxStyle = NoCallBoxStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('No callable `call()` method found for NoCallBoxStyle'),
      );
    });

    test('resolves imported styler types across files', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import 'shared_styles.dart';

part 'input.g.dart';

@MixWidget()
final BoxStyler importedCardStyle = sharedCardStyle;
''';

      final logs = await runMixWidgetWithLogs(
        source,
        extraSources: {
          'mix_generator|lib/shared_styles.dart': r'''
library shared_styles;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

final sharedCardStyle = BoxStyler();
''',
        },
      );

      expect(logs.where((record) => record.level == Level.SEVERE), isEmpty);
    });

    test('rejects optional positional factory parameters', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
BoxStyler pillStyle([double padding = 8]) => BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains(
          'factory parameter `padding` is optional positional. Use a '
          'required positional or named parameter instead.',
        ),
      );
    });

    test('rejects generic style factory functions', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
BoxStyler tokenStyle<T>(T value) => BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('does not support generic style factories'),
      );
    });

    test(
      'rejects libraries without an unprefixed Flutter widgets import',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart' as fw;
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final cardStyle = BoxStyler();
''';

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains(
            'requires `Widget`, `StatelessWidget`, and `BuildContext` to be '
            'available without an import prefix',
          ),
        );
      },
    );

    test(
      'rejects partial Flutter widget imports that hide generated base types',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart' show Widget;
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final cardStyle = BoxStyler();
''';

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains(
            'requires `Widget`, `StatelessWidget`, and `BuildContext` to be '
            'available without an import prefix',
          ),
        );
      },
    );

    test('uses inherited call methods for styler subclasses', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class SubStyler extends BoxStyler {
  const SubStyler();
}

@MixWidget(name: 'SubCard')
final subCardStyle = SubStyler();
''';

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('class SubCard extends StatelessWidget'));
      expect(output, contains('final Widget? child;'));
      expect(
        output,
        contains('return subCardStyle.call(key: key, child: child);'),
      );
    });
  });
}
