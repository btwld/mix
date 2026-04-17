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
  String callMethod = r'''
  ContextButton call({
    required String label,
    bool loading = false,
  }) {
    return ContextButton(
      label: label,
      loading: loading,
      style: this,
    );
  }
''',
  String widgetClass = r'''
class ContextButton extends Widget {
  final Key? key;
  final ContextStyle style;
  final String label;
  final bool loading;

  const ContextButton({
    this.key,
    this.style = const ContextStyle(),
    required this.label,
    this.loading = false,
  });
}
''',
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
class ContextSpec {
  const ContextSpec();
}

class ContextStyle extends Style<ContextSpec> {
  const ContextStyle();

  ContextStyle merge(ContextStyle? other) => this;

$callMethod
}

$widgetClass

@MixWidget(styleable: true)
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

    test('generates wrappers for custom call return widgets', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

typedef VoidCallback = void Function();

class CustomSpec {
  const CustomSpec();
}

class CustomButtonStyle extends Style<CustomSpec> {
  const CustomButtonStyle();

  CustomButtonStyle merge(CustomButtonStyle? other) => this;

  CustomButton call({
    required String label,
    required VoidCallback? onPressed,
    bool loading = false,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      loading: loading,
      style: this,
    );
  }
}

class CustomButton extends Widget {
  final Key? key;
  final CustomButtonStyle style;
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const CustomButton({
    this.key,
    this.style = const CustomButtonStyle(),
    required this.label,
    required this.onPressed,
    this.loading = false,
  });
}

@MixWidget(styleable: true)
final solidButtonStyle = CustomButtonStyle();
''';

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('class SolidButton extends StatelessWidget'));
      expect(output, contains('final String label;'));
      expect(output, contains('final void Function()? onPressed;'));
      expect(output, contains('final bool loading;'));
      expect(output, contains('final CustomButtonStyle? style;'));
      expect(output, contains('final baseStyle = solidButtonStyle;'));
      expect(
        output,
        contains('final effectiveStyle = baseStyle.merge(style);'),
      );
      expect(output, contains('return CustomButton('));
      expect(output, contains('label: label,'));
      expect(output, contains('onPressed: onPressed,'));
      expect(output, contains('loading: loading,'));
      expect(output, contains('key: key,'));
      expect(output, contains('style: effectiveStyle,'));
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
      expect(output, contains('final baseStyle = contextualButtonStyle('));
      expect(output, contains('context,'));
      expect(output, contains('compact: compact'));
      expect(
        output,
        contains('final effectiveStyle = baseStyle.merge(style);'),
      );
      expect(output, contains('return ContextButton('));
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
      expect(
        output,
        contains('final baseStyle = contextualButtonStyle(this.context);'),
      );
    });

    test('does not shadow mirrored call parameters named context', () async {
      final source = _contextStyleSource(
        factoryDeclaration: 'final contextStyle = ContextStyle();',
        callMethod: r'''
  ContextButton call({
    required String context,
    bool loading = false,
  }) {
    return ContextButton(
      context: context,
      loading: loading,
      style: this,
    );
  }
''',
        widgetClass: r'''
class ContextButton extends Widget {
  final Key? key;
  final ContextStyle style;
  final String context;
  final bool loading;

  const ContextButton({
    this.key,
    this.style = const ContextStyle(),
    required this.context,
    this.loading = false,
  });
}
''',
      );

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('final String context;'));
      expect(output, contains('context: this.context,'));
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

    test(
      'rejects mirrored context params when BuildContext is injected',
      () async {
        final source = _contextStyleSource(
          factoryDeclaration: r'''
ContextStyle contextualButtonStyle(BuildContext context) {
  return const ContextStyle();
}
''',
          callMethod: r'''
  ContextButton call({
    required String context,
    bool loading = false,
  }) {
    return ContextButton(
      context: context,
      loading: loading,
      style: this,
    );
  }
''',
          widgetClass: r'''
class ContextButton extends Widget {
  final Key? key;
  final ContextStyle style;
  final String context;
  final bool loading;

  const ContextButton({
    this.key,
    this.style = const ContextStyle(),
    required this.context,
    this.loading = false,
  });
}
''',
        );

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains(
            'Parameter `context` conflicts with the injected BuildContext used by @MixWidget.',
          ),
        );
      },
    );

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

  Box call({Widget? child}) {
    return Box(style: this, child: child);
  }
}

@MixWidget(widgetBuilder: BoxBuilder())
final brokenStyle = BrokenStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('Could not determine the Style<T> spec type'),
      );
    });

    test('rejects incompatible widgetBuilder overrides', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget(widgetBuilder: BoxBuilder())
final headingStyle = TextStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('BoxBuilder targets BoxSpec'),
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
      'rejects explicit generated names that collide with the source declaration',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget(name: 'toolbarStyle')
final toolbarStyle = BoxStyler();
''';

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains(
            'Generated widget name `toolbarStyle` conflicts with an existing declaration',
          ),
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
      ('style', 'BoxStyler'),
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

    test('rejects styler types without a concrete call method', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class BrokenBoxStyler extends Style<BoxSpec> {
  const BrokenBoxStyler();

  BrokenBoxStyler merge(BrokenBoxStyler? other) => this;
}

@MixWidget(widgetBuilder: BoxBuilder())
final brokenStyle = BrokenBoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('must expose a concrete instance `call()` method'),
      );
    });

    test('rejects call methods that do not return widgets', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class BrokenBoxStyler extends Style<BoxSpec> {
  const BrokenBoxStyler();

  BrokenBoxStyler merge(BrokenBoxStyler? other) => this;

  String call({Widget? child}) => 'nope';
}

@MixWidget(widgetBuilder: BoxBuilder())
final brokenStyle = BrokenBoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('call() must return a Widget subtype'),
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
  });
}
