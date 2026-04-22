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

  Box call({Widget? child}) {
    return Box(style: BoxStyler(), child: child);
  }
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

  Box call({Widget? child}) {
    return Box(style: this, child: child);
  }
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

    test('rejects incompatible custom widgetBuilder overrides', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class TextBoxBuilder extends MixWidgetBuilder<BoxSpec> {
  const TextBoxBuilder();

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}

@MixWidget(widgetBuilder: TextBoxBuilder())
final headingStyle = TextStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('TextBoxBuilder targets BoxSpec'));
    });

    test('generates wrappers with custom widgetBuilder subclasses', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class GlassCardBuilder extends MixWidgetBuilder<BoxSpec> {
  const GlassCardBuilder();

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}

@MixWidget(widgetBuilder: GlassCardBuilder())
final glassCardStyle = BoxStyler();
''';

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('class GlassCard extends StatelessWidget'));
      expect(output, contains('return const GlassCardBuilder().build('));
      expect(output, contains('glassCardStyle,'));
      expect(output, contains('child: child,'));
    });

    test('ignores same-named non-MixWidget annotations', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart' as annotations;

part 'input.g.dart';

class MixWidget {
  final Object? widgetBuilder;

  const MixWidget({this.widgetBuilder});
}

class Builders {
  static const glassCard = Object();
}

class GlassCardBuilder extends MixWidgetBuilder<BoxSpec> {
  const GlassCardBuilder();

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}

@MixWidget(widgetBuilder: Builders.glassCard)
@annotations.MixWidget(widgetBuilder: GlassCardBuilder())
final glassCardStyle = BoxStyler();
''';

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('return const GlassCardBuilder().build('));
    });

    test('rejects explicit built-in widgetBuilder overrides', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget(widgetBuilder: BoxBuilder())
final cardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('Built-in Mix widget builders are inferred automatically'),
      );
    });

    test('rejects prefixed widgetBuilder constructors', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart' as mix;
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget(widgetBuilder: mix.BoxBuilder())
final cardStyle = mix.BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('must be an unprefixed'));
    });

    test('rejects prefixed custom widgetBuilder constructors', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'custom_builders.dart' as custom;

part 'input.g.dart';

@MixWidget(widgetBuilder: custom.GlassCardBuilder())
final glassCardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(
        source,
        extraSources: {
          'mix_generator|lib/custom_builders.dart': r'''
library custom_builders;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

class GlassCardBuilder extends MixWidgetBuilder<BoxSpec> {
  const GlassCardBuilder();

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}
''',
        },
      );

      expect(_severeMessages(logs), contains('must be an unprefixed'));
    });

    test('rejects named widgetBuilder constructors', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class GlassCardBuilder extends MixWidgetBuilder<BoxSpec> {
  const GlassCardBuilder();
  const GlassCardBuilder.frosted();

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}

@MixWidget(widgetBuilder: GlassCardBuilder.frosted())
final glassCardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('zero-argument unnamed'));
    });

    test('rejects configured widgetBuilder constructors', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class GlassCardBuilder extends MixWidgetBuilder<BoxSpec> {
  final String variant;

  const GlassCardBuilder(this.variant);

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}

@MixWidget(widgetBuilder: GlassCardBuilder('frosted'))
final glassCardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('zero-argument'));
    });

    test('rejects non-const widgetBuilder constructors', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class GlassCardBuilder extends MixWidgetBuilder<BoxSpec> {
  GlassCardBuilder();

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}

@MixWidget(widgetBuilder: GlassCardBuilder())
final glassCardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains("constructor being called isn't a const constructor"),
      );
    });

    test('rejects static const widgetBuilder instances', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class GlassCardBuilder extends MixWidgetBuilder<BoxSpec> {
  const GlassCardBuilder();

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}

class Builders {
  static const glassCard = GlassCardBuilder();
}

@MixWidget(widgetBuilder: Builders.glassCard)
final glassCardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('constructor call'));
    });

    test('rejects function-call widgetBuilder expressions', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class GlassCardBuilder extends MixWidgetBuilder<BoxSpec> {
  const GlassCardBuilder();

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}

GlassCardBuilder makeBuilder() => const GlassCardBuilder();

@MixWidget(widgetBuilder: makeBuilder())
final glassCardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), isNotEmpty);
    });

    test('rejects fake MixWidgetBuilder base classes', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'fake_mix.dart' as fake;

part 'input.g.dart';

class FakeBuilder extends fake.MixWidgetBuilder<BoxSpec> {
  const FakeBuilder();
}

@MixWidget(widgetBuilder: FakeBuilder())
final cardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(
        source,
        extraSources: {
          'mix_generator|lib/fake_mix.dart': r'''
library fake_mix;

class MixWidgetBuilder<T> {
  const MixWidgetBuilder();
}
''',
        },
      );

      expect(_severeMessages(logs), contains('must extend package:mix'));
    });

    test('rejects builders that only implement MixWidgetBuilder', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class ImplementsBuilder implements MixWidgetBuilder<BoxSpec> {
  const ImplementsBuilder();

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}

@MixWidget(widgetBuilder: ImplementsBuilder())
final cardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('must extend package:mix'));
    });

    test('rejects generic custom builder spec mismatches', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class GenericSpec<T> {
  const GenericSpec();
}

class GenericStyle extends Style<GenericSpec<String>> {
  const GenericStyle();

  GenericStyle merge(GenericStyle? other) => this;

  GenericWidget call({Widget? child}) {
    return GenericWidget(style: this, child: child);
  }
}

class GenericWidget extends Widget {
  final Key? key;
  final GenericStyle style;
  final Widget? child;

  const GenericWidget({
    this.key,
    this.style = const GenericStyle(),
    this.child,
  });
}

class GenericBuilder extends MixWidgetBuilder<GenericSpec<int>> {
  const GenericBuilder();

  @override
  Widget build(
    Style<GenericSpec<int>> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Widget();
  }
}

@MixWidget(widgetBuilder: GenericBuilder())
final genericStyle = GenericStyle();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('GenericBuilder targets GenericSpec<int>'),
      );
    });

    test(
      'does not infer built-ins for custom specs with built-in names',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart' hide BoxSpec;
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class BoxSpec {
  const BoxSpec();
}

class LocalBoxStyle extends Style<BoxSpec> {
  const LocalBoxStyle();

  LocalBoxStyle merge(LocalBoxStyle? other) => this;

  LocalBox call({Widget? child}) {
    return LocalBox(style: this, child: child);
  }
}

class LocalBox extends Widget {
  final Key? key;
  final LocalBoxStyle style;
  final Widget? child;

  const LocalBox({
    this.key,
    this.style = const LocalBoxStyle(),
    this.child,
  });
}

@MixWidget(name: 'LocalBoxWrapper')
final localBoxStyle = LocalBoxStyle();
''';

        final output = await generateMixWidgetOutput(inputSource: source);

        expect(output, contains('return LocalBox('));
        expect(output, isNot(contains('BoxBuilder')));
      },
    );

    test('uses prefixes for direct widget fallback constructors', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import 'prefixed_widgets.dart' as custom;

part 'input.g.dart';

@MixWidget()
final prefixedStyle = custom.PrefixedStyler();
''';

      final output = await generateMixWidgetOutput(
        inputSource: source,
        extraSources: {
          'mix_generator|lib/prefixed_widgets.dart': r'''
library prefixed_widgets;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

class PrefixedSpec {
  const PrefixedSpec();
}

class PrefixedStyler extends Style<PrefixedSpec> {
  const PrefixedStyler();

  PrefixedStyler merge(PrefixedStyler? other) => this;

  PrefixedWidget call({Widget? child}) {
    return PrefixedWidget(style: this, child: child);
  }
}

class PrefixedWidget extends Widget {
  final Key? key;
  final Style<PrefixedSpec> style;
  final Widget? child;

  const PrefixedWidget({
    this.key,
    required this.style,
    this.child,
  });
}
''',
        },
      );

      expect(output, contains('return custom.PrefixedWidget('));
      expect(output, contains('style: prefixedStyle'));
    });

    test('rejects unsupported custom builder forwarded parameters', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

typedef VoidCallback = void Function();

class TappableBoxStyler extends Style<BoxSpec> {
  const TappableBoxStyler();

  TappableBoxStyler merge(TappableBoxStyler? other) => this;

  Box call({VoidCallback? onTap}) {
    return Box(style: this);
  }
}

class GlassCardBuilder extends MixWidgetBuilder<BoxSpec> {
  const GlassCardBuilder();

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}

@MixWidget(widgetBuilder: GlassCardBuilder())
final tappableBoxStyle = TappableBoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('parameter `onTap` cannot be forwarded'),
      );
    });

    test(
      'rejects wrong types for custom builder forwarded parameters',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class WrongChildrenStyler extends Style<BoxSpec> {
  const WrongChildrenStyler();

  WrongChildrenStyler merge(WrongChildrenStyler? other) => this;

  Box call({Set<Widget> children = const <Widget>{}}) {
    return Box(style: this);
  }
}

class GlassCardBuilder extends MixWidgetBuilder<BoxSpec> {
  const GlassCardBuilder();

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}

@MixWidget(widgetBuilder: GlassCardBuilder())
final wrongChildrenStyle = WrongChildrenStyler();
''';

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains('parameter `children` has type Set<Widget>'),
        );
      },
    );

    test(
      'rejects same-name forwarded parameters from non-Flutter libraries',
      () async {
        const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import 'fake_widgets.dart' as fake;

part 'input.g.dart';

class WrongChildStyler extends Style<BoxSpec> {
  const WrongChildStyler();

  WrongChildStyler merge(WrongChildStyler? other) => this;

  Box call({fake.Widget? child}) {
    return Box(style: this);
  }
}

class GlassCardBuilder extends MixWidgetBuilder<BoxSpec> {
  const GlassCardBuilder();

  @override
  Widget build(
    Style<BoxSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children = const <Widget>[],
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return Box(key: key, style: style, child: child);
  }
}

@MixWidget(widgetBuilder: GlassCardBuilder())
final wrongChildStyle = WrongChildStyler();
''';

        final logs = await runMixWidgetWithLogs(
          source,
          extraSources: {
            'mix_generator|lib/fake_widgets.dart': r'''
library fake_widgets;

class Widget {
  const Widget();
}
''',
          },
        );

        expect(_severeMessages(logs), contains('parameter `child` has type'));
      },
    );

    test('accepts assignable builder forwarded parameter types', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class FancyWidget extends Widget {
  const FancyWidget();
}

class FancyChildStyler extends Style<BoxSpec> {
  const FancyChildStyler();

  FancyChildStyler merge(FancyChildStyler? other) => this;

  Box call({FancyWidget? child}) {
    return Box(style: this, child: child);
  }
}

@MixWidget()
final fancyChildStyle = FancyChildStyler();
''';

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('final FancyWidget? child;'));
      expect(output, contains('return const BoxBuilder().build('));
    });

    test('substitutes generic styler call parameter types', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class GenericBoxStyler<T extends Widget> extends Style<BoxSpec> {
  const GenericBoxStyler();

  GenericBoxStyler<T> merge(GenericBoxStyler<T>? other) => this;

  Box call({required T child}) {
    return Box(style: this, child: child);
  }
}

@MixWidget()
final genericBoxStyle = GenericBoxStyler<Widget>();
''';

      final output = await generateMixWidgetOutput(inputSource: source);

      expect(output, contains('final Widget child;'));
      expect(output, isNot(contains('final T child;')));
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

@MixWidget()
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

@MixWidget()
final brokenStyle = BrokenBoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('call() must return a Widget subtype'),
      );
    });

    test('rejects non-Flutter classes named Widget as call returns', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart' hide Widget;
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class Widget {
  const Widget();
}

class BrokenBoxStyler extends Style<BoxSpec> {
  const BrokenBoxStyler();

  BrokenBoxStyler merge(BrokenBoxStyler? other) => this;

  Widget call() => const Widget();
}

@MixWidget()
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

    test('rejects styler call() with optional-positional parameters', () async {
      const source = r'''
library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class OptPositionalStyler extends Style<BoxSpec> {
  const OptPositionalStyler();

  OptPositionalStyler merge(OptPositionalStyler? other) => this;

  Box call([Widget? child]) {
    return Box(style: this, child: child);
  }
}

@MixWidget()
final optStyle = OptPositionalStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('optional-positional parameter'));
    });

    test(
      'rejects direct-fallback widget missing key constructor parameter',
      () async {
        final source = _contextStyleSource(
          factoryDeclaration: 'final contextStyle = ContextStyle();',
          widgetClass: r'''
class ContextButton extends Widget {
  final ContextStyle style;
  final String label;
  final bool loading;

  const ContextButton({
    this.style = const ContextStyle(),
    required this.label,
    this.loading = false,
  });
}
''',
        );

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains('to accept a named `key` constructor parameter'),
        );
      },
    );

    test(
      'rejects direct-fallback widget missing style constructor parameter',
      () async {
        final source = _contextStyleSource(
          factoryDeclaration: 'final contextStyle = ContextStyle();',
          widgetClass: r'''
class ContextButton extends Widget {
  final Key? key;
  final String label;
  final bool loading;

  const ContextButton({
    this.key,
    required this.label,
    this.loading = false,
  });
}
''',
        );

        final logs = await runMixWidgetWithLogs(source);

        expect(
          _severeMessages(logs),
          contains('to accept a named `style` constructor parameter'),
        );
      },
    );
  });
}
