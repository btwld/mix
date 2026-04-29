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

    test('rejects custom specs without @MixWidgetRenderer', () async {
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
        allOf(
          contains('No renderer found for CustomSpec'),
          contains('@MixWidgetRenderer'),
        ),
      );
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
        contains('style: contextualButtonStyle(context, compact: compact)'),
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
      expect(output, contains('style: contextualButtonStyle(this.context)'));
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
          'BuildContext injection requires Flutter BuildContext from package:flutter/widgets.dart',
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

    test('renders custom widgets via @MixWidgetRenderer on the spec', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidgetRenderer(Button)
class ButtonSpec extends Spec<ButtonSpec> {
  const ButtonSpec();
}

class ButtonStyler extends Style<ButtonSpec> {
  const ButtonStyler();

  ButtonStyler color(Color value) => this;

  ButtonStyler merge(ButtonStyler? other) => this;
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
      expect(output, contains('return Button('));
      expect(output, contains('style: primaryButtonStyle(color: color)'));
      expect(output, contains('onPressed: onPressed'));
      expect(output, contains('child: child'));
    });

    test('rejects abstract renderer classes', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

abstract class AbstractButton extends Widget {
  const AbstractButton();
}

@MixWidgetRenderer(AbstractButton)
class CustomSpec extends Spec<CustomSpec> {
  const CustomSpec();
}

class CustomStyle extends Style<CustomSpec> {
  const CustomStyle();

  CustomStyle merge(CustomStyle? other) => this;
}

@MixWidget()
final customStyle = CustomStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('must reference a concrete widget class'),
      );
    });

    test('rejects renderers whose key parameter is not Key?', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class WrongKeyWidget extends Widget {
  final String? key;
  final Style<CustomSpec> style;

  const WrongKeyWidget({this.key, required this.style});
}

@MixWidgetRenderer(WrongKeyWidget)
class CustomSpec extends Spec<CustomSpec> {
  const CustomSpec();
}

class CustomStyle extends Style<CustomSpec> {
  const CustomStyle();

  CustomStyle merge(CustomStyle? other) => this;
}

@MixWidget()
final customStyle = CustomStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('must be `Key?`'));
    });

    test(
      'rejects renderer parameter defaults that reference invisible identifiers',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import 'banner_renderer.dart';

part 'input.g.dart';

class BannerStyle extends Style<BannerSpec> {
  const BannerStyle();

  BannerStyle merge(BannerStyle? other) => this;
}

@MixWidget()
final bannerStyle = BannerStyle();
''';

        final logs = await runMixWidgetWithLogs(
          source,
          extraSources: {
            'mix_generator|lib/banner_renderer.dart': r'''
library banner_renderer;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import 'hidden_defaults.dart';

class Banner extends Widget {
  final Key? key;
  final Style<BannerSpec> style;
  final String label;

  const Banner({this.key, required this.style, this.label = defaultLabel});
}

@MixWidgetRenderer(Banner)
class BannerSpec extends Spec<BannerSpec> {
  const BannerSpec();
}
''',
            'mix_generator|lib/hidden_defaults.dart': r'''
library hidden_defaults;

const defaultLabel = 'banner';
''',
          },
        );

        expect(
          _severeMessages(logs),
          contains('references `defaultLabel`'),
        );
      },
    );

    test('forwards renderer constructor context parameters via this.context',
        () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class ContextWidget extends Widget {
  final Key? key;
  final Style<ContextSpec> style;
  final String context;

  const ContextWidget({
    this.key,
    required this.style,
    required this.context,
  });
}

@MixWidgetRenderer(ContextWidget)
class ContextSpec extends Spec<ContextSpec> {
  const ContextSpec();
}

class ContextStyler extends Style<ContextSpec> {
  const ContextStyler();

  ContextStyler merge(ContextStyler? other) => this;
}

@MixWidget()
final contextStyle = ContextStyler();
''';

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('final String context;'));
      expect(output, contains('context: this.context'));
    });

    test('ignores annotations not from the mix_annotations package', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart' as mix_annotations;

part 'input.g.dart';

class MixWidgetRenderer {
  final Type widget;
  const MixWidgetRenderer(this.widget);
}

@MixWidgetRenderer(Box)
class CustomSpec extends Spec<CustomSpec> {
  const CustomSpec();
}

class CustomStyle extends Style<CustomSpec> {
  const CustomStyle();

  CustomStyle merge(CustomStyle? other) => this;
}

@mix_annotations.MixWidget()
final customStyle = CustomStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        allOf(
          contains('No renderer found for CustomSpec'),
          contains('@MixWidgetRenderer'),
        ),
      );
    });

    test('rejects renderer types that are not widgets', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class NotAWidget {
  const NotAWidget();
}

@MixWidgetRenderer(NotAWidget)
class CustomSpec extends Spec<CustomSpec> {
  const CustomSpec();
}

class CustomStyle extends Style<CustomSpec> {
  const CustomStyle();

  CustomStyle merge(CustomStyle? other) => this;
}

@MixWidget()
final customStyle = CustomStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('must reference a Flutter Widget subclass'),
      );
    });

    test('rejects renderers without a style: parameter', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class StylelessWidget extends Widget {
  const StylelessWidget();
}

@MixWidgetRenderer(StylelessWidget)
class CustomSpec extends Spec<CustomSpec> {
  const CustomSpec();
}

class CustomStyle extends Style<CustomSpec> {
  const CustomStyle();

  CustomStyle merge(CustomStyle? other) => this;
}

@MixWidget()
final customStyle = CustomStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('must declare a named `style:` parameter'),
      );
    });

    test('rejects renderers with incompatible style: parameter type', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class WrongStyleWidget extends Widget {
  final Style<BoxSpec> style;

  const WrongStyleWidget({required this.style});
}

@MixWidgetRenderer(WrongStyleWidget)
class CustomSpec extends Spec<CustomSpec> {
  const CustomSpec();
}

class CustomStyle extends Style<CustomSpec> {
  const CustomStyle();

  CustomStyle merge(CustomStyle? other) => this;
}

@MixWidget()
final customStyle = CustomStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('style parameter must accept the styler type'),
      );
    });

    test('rejects generic renderer classes', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class GenericRenderer<T> extends Widget {
  final Key? key;
  final Style<CustomSpec> style;
  final T value;

  const GenericRenderer({this.key, required this.style, required this.value});
}

@MixWidgetRenderer(GenericRenderer)
class CustomSpec extends Spec<CustomSpec> {
  const CustomSpec();
}

class CustomStyle extends Style<CustomSpec> {
  const CustomStyle();

  CustomStyle merge(CustomStyle? other) => this;
}

@MixWidget()
final customStyle = CustomStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('Generic renderers are not yet supported'),
      );
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

    for (final reservedParameter in [
      ('key', 'Color'),
      ('styleSpec', 'Widget'),
    ]) {
      test('rejects reserved parameter `${reservedParameter.$1}`', () async {
        final source =
            '''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
BoxStyler chipStyle({required ${reservedParameter.$2} ${reservedParameter.$1}}) => BoxStyler();
''';

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains(
            'Parameter `${reservedParameter.$1}` is reserved by @MixWidget.',
          ),
        );
      });
    }

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
      expect(output, contains('style: chipStyle(style: style)'));
    });

    test('emits prefixed built-in widget references', () async {
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
        contains(
          'return mix.Box(key: key, style: prefixedCardStyle, child: child);',
        ),
      );
    });

    test('rejects hidden built-in renderer widgets', () async {
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

      expect(
        _severeMessages(logs),
        contains('could not reference renderer widget `Box`'),
      );
    });

    test(
      'generates Mix-owned wrappers without a concrete call method',
      () async {
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

        final output = await generateMixWidgetOutput(inputSource: source);

        expect(output, contains('class NoCallBox extends StatelessWidget'));
        expect(output, contains('final Widget? child;'));
        expect(
          output,
          contains(
            'return Box(key: key, style: noCallBoxStyle, child: child);',
          ),
        );
      },
    );

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

    test('uses built-in renderer for styler subclasses', () async {
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
        contains('return Box(key: key, style: subCardStyle, child: child);'),
      );
    });
  });
}
