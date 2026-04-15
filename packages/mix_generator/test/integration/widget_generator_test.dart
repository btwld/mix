import 'package:logging/logging.dart';
import 'package:test/test.dart';

import '../support/widget_generator_test_support.dart';

String _severeMessages(Iterable<LogRecord> logs) {
  return logs
      .where((record) => record.level == Level.SEVERE)
      .map((record) => record.message)
      .join();
}

String _mixStubWithBoxOverrides({
  String? boxCallSnippet,
  String? boxClassDefinition,
}) {
  var updated = mixStub;

  if (boxCallSnippet != null) {
    updated = replaceSnippet(updated, boxStylerCallSnippet, boxCallSnippet);
  }

  if (boxClassDefinition != null) {
    updated = replaceSnippet(updated, boxClassSnippet, boxClassDefinition);
  }

  return updated;
}

void main() {
  group('MixWidgetGenerator validation', () {
    test('rejects non-final top-level variables', () async {
      const source = r'''
library input;

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

    test('rejects non-style targets', () async {
      const source = r'''
library input;

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

@MixWidget(widgetBuilder: MixWidgetBuilder.box())
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

    test('rejects private explicit generated names', () async {
      const source = r'''
library input;

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

    test('rejects declarations whose derived widget name is empty', () async {
      const source = r'''
library input;

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

    test('rejects target widgets without unnamed constructors', () async {
      const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final cardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(
        source,
        mixSourceOverride: _mixStubWithBoxOverrides(
          boxCallSnippet: r'''
  Box call({Key? key, Widget? child}) {
    return Box.named(key: key, style: this, child: child);
  }
''',
          boxClassDefinition: r'''
class Box extends Widget {
  final Key? key;
  final Style<BoxSpec> style;
  final StyleSpec<BoxSpec>? styleSpec;
  final Widget? child;

  const Box.named({
    this.key,
    this.style = const BoxStyler(),
    this.styleSpec,
    this.child,
  });
}
''',
        ),
      );

      expect(
        _severeMessages(logs),
        contains('must expose an unnamed constructor'),
      );
    });

    test('rejects target widgets missing key parameters', () async {
      const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final cardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(
        source,
        mixSourceOverride: _mixStubWithBoxOverrides(
          boxCallSnippet: r'''
  Box call({Key? key, Widget? child}) {
    return Box(style: this, child: child);
  }
''',
          boxClassDefinition: r'''
class Box extends Widget {
  final Style<BoxSpec> style;
  final StyleSpec<BoxSpec>? styleSpec;
  final Widget? child;

  const Box({
    this.style = const BoxStyler(),
    this.styleSpec,
    this.child,
  });
}
''',
        ),
      );

      expect(
        _severeMessages(logs),
        contains('must expose a `key` constructor parameter'),
      );
    });

    test('rejects target widgets missing style parameters', () async {
      const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final cardStyle = BoxStyler();
''';

      final logs = await runMixWidgetWithLogs(
        source,
        mixSourceOverride: _mixStubWithBoxOverrides(
          boxCallSnippet: r'''
  Box call({Key? key, Widget? child}) {
    return Box(key: key, child: child);
  }
''',
          boxClassDefinition: r'''
class Box extends Widget {
  final Key? key;
  final StyleSpec<BoxSpec>? styleSpec;
  final Widget? child;

  const Box({
    this.key,
    this.styleSpec,
    this.child,
  });
}
''',
        ),
      );

      expect(
        _severeMessages(logs),
        contains('must expose a `style` constructor parameter'),
      );
    });

    test(
      'rejects built-in mappings that drift from the styler call return type',
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
      },
    );

    test(
      'rejects target widgets with extra required positional params not exposed by call',
      () async {
        const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final cardStyle = BoxStyler();
''';

        final logs = await runMixWidgetWithLogs(
          source,
          mixSourceOverride: _mixStubWithBoxOverrides(
            boxCallSnippet: r'''
  Box call({Key? key, Widget? child}) {
    return Box(const Widget(), key: key, style: this, child: child);
  }
''',
            boxClassDefinition: r'''
class Box extends Widget {
  final Widget extra;
  final Key? key;
  final Style<BoxSpec> style;
  final StyleSpec<BoxSpec>? styleSpec;
  final Widget? child;

  const Box(
    this.extra, {
    this.key,
    this.style = const BoxStyler(),
    this.styleSpec,
    this.child,
  });
}
''',
          ),
        );

        expect(
          _severeMessages(logs),
          contains(
            'requires constructor parameter `extra` that is not exposed by Box.call()',
          ),
        );
      },
    );

    test(
      'rejects target widgets with extra required named params not exposed by call',
      () async {
        const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
final cardStyle = BoxStyler();
''';

        final logs = await runMixWidgetWithLogs(
          source,
          mixSourceOverride: _mixStubWithBoxOverrides(
            boxCallSnippet: r'''
  Box call({Key? key, Widget? child}) {
    return Box(key: key, style: this, extra: const Widget(), child: child);
  }
''',
            boxClassDefinition: r'''
class Box extends Widget {
  final Key? key;
  final Style<BoxSpec> style;
  final StyleSpec<BoxSpec>? styleSpec;
  final Widget extra;
  final Widget? child;

  const Box({
    this.key,
    this.style = const BoxStyler(),
    this.styleSpec,
    required this.extra,
    this.child,
  });
}
''',
          ),
        );

        expect(
          _severeMessages(logs),
          contains(
            'requires constructor parameter `extra` that is not exposed by Box.call()',
          ),
        );
      },
    );

    test(
      'rejects call params missing from the target widget constructor',
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
      },
    );

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
        contains(
          'Parameter `child` is positional in Box.call() but named in Box',
        ),
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
        contains(
          'Parameter `child` from Box.call() is not compatible with Box.child',
        ),
      );
    });

    test(
      'rejects positional call params with incompatible parameter types',
      () async {
        const source = r'''
library input;

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class WrongTypeBoxStyler extends Style<BoxSpec> {
  const WrongTypeBoxStyler();

  WrongTypeBoxStyler merge(WrongTypeBoxStyler? other) => this;

  Box call(Widget? child) {
    return Box('fallback', key: const Key(), style: this);
  }
}

@MixWidget(widgetBuilder: MixWidgetBuilder.box())
final cardStyle = WrongTypeBoxStyler();
''';

        final logs = await runMixWidgetWithLogs(
          source,
          mixSourceOverride: _mixStubWithBoxOverrides(
            boxCallSnippet: r'''
  Box call({Key? key, Widget? child}) {
    return Box('fallback', key: key, style: this);
  }
''',
            boxClassDefinition: r'''
class Box extends Widget {
  final String child;
  final Key? key;
  final Style<BoxSpec> style;
  final StyleSpec<BoxSpec>? styleSpec;

  const Box(
    this.child, {
    this.key,
    this.style = const BoxStyler(),
    this.styleSpec,
  });
}
''',
          ),
        );

        expect(
          _severeMessages(logs),
          contains(
            'Parameter `child` from Box.call() is not compatible with Box.child',
          ),
        );
      },
    );

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
