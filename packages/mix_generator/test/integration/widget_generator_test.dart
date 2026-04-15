import 'package:logging/logging.dart';
import 'package:test/test.dart';

import '../support/widget_generator_test_support.dart';

String _severeMessages(Iterable<LogRecord> logs) {
  return logs
      .where((record) => record.level == Level.SEVERE)
      .map((record) => record.message)
      .join();
}

void main() {
  group('MixWidgetGenerator validation', () {
    test('rejects private declarations', () async {
      const source = r'''
library input;

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

    test('rejects unsupported styler families without widgetBuilder', () async {
      const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class CustomSpec {
  const CustomSpec();
}

class CustomStyler extends Style<CustomSpec> {
  const CustomStyler();

  CustomStyler merge(CustomStyler? other) => this;
}

@MixWidget()
final customStyle = CustomStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('No Mix widget mapping found for CustomStyler'),
      );
    });

    test('rejects incompatible widgetBuilder overrides', () async {
      const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget(widgetBuilder: MixWidgetBuilder.box())
final headingStyle = TextStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('MixWidgetBuilder.box is not compatible with TextSpec'),
      );
    });

    test('rejects invalid annotation target kinds', () async {
      const source = r'''
library input;

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

    test(
      'rejects generated names that collide with another declaration in the library',
      () async {
        const source = r'''
library input;

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

    test(
      'rejects parameter collisions between factory and widget params',
      () async {
        const source = r'''
library input;

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

    test('rejects styler types without a concrete call method', () async {
      const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class BrokenBoxStyler extends Style<BoxSpec> {
  const BrokenBoxStyler();

  BrokenBoxStyler merge(BrokenBoxStyler? other) => this;
}

@MixWidget(widgetBuilder: MixWidgetBuilder.box())
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

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class BrokenBoxStyler extends Style<BoxSpec> {
  const BrokenBoxStyler();

  BrokenBoxStyler merge(BrokenBoxStyler? other) => this;

  String call({Widget? child}) => 'nope';
}

@MixWidget(widgetBuilder: MixWidgetBuilder.box())
final brokenStyle = BrokenBoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('call() must return a Widget subtype'),
      );
    });

    test('rejects built-in mappings that drift from the styler call return type',
        () async {
      const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class DriftFlexBoxStyler extends FlexBoxStyler {
  const DriftFlexBoxStyler();

  @override
  RowBox call({Key? key, required List<Widget> children}) {
    return RowBox(key: key, style: this, children: children);
  }
}

@MixWidget()
final layoutStyle = DriftFlexBoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(_severeMessages(logs), contains('mapping drifted from RowBox'));
    });

    test('rejects call params missing from the target widget constructor',
        () async {
      const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class BoxWithTrailingStyler extends Style<BoxSpec> {
  const BoxWithTrailingStyler();

  BoxWithTrailingStyler merge(BoxWithTrailingStyler? other) => this;

  Box call({Widget? child, Widget? trailing}) {
    return Box(style: this, child: child);
  }
}

@MixWidget(widgetBuilder: MixWidgetBuilder.box())
final cardStyle = BoxWithTrailingStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('Parameter `trailing` from Box.call() is missing from Box'),
      );
    });

    test('rejects call params with incompatible parameter kinds', () async {
      const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class PositionalBoxStyler extends Style<BoxSpec> {
  const PositionalBoxStyler();

  PositionalBoxStyler merge(PositionalBoxStyler? other) => this;

  Box call(Widget? child) {
    return Box(style: this, child: child);
  }
}

@MixWidget(widgetBuilder: MixWidgetBuilder.box())
final cardStyle = PositionalBoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('Parameter `child` is positional in Box.call() but named in Box'),
      );
    });

    test('rejects call params with incompatible parameter types', () async {
      const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class WrongTypeBoxStyler extends Style<BoxSpec> {
  const WrongTypeBoxStyler();

  WrongTypeBoxStyler merge(WrongTypeBoxStyler? other) => this;

  Box call({String? child}) {
    return Box(style: this);
  }
}

@MixWidget(widgetBuilder: MixWidgetBuilder.box())
final cardStyle = WrongTypeBoxStyler();
''';

      final logs = await runMixWidgetWithLogs(source);

      expect(
        _severeMessages(logs),
        contains('Parameter `child` from Box.call() is not compatible with Box.child'),
      );
    });

    test('resolves imported styler types across files', () async {
      const source = r'''
library input;

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

import 'package:mix/mix.dart';

final sharedCardStyle = BoxStyler();
''',
        },
      );

      expect(logs.where((record) => record.level == Level.SEVERE), isEmpty);
    });
  });
}
