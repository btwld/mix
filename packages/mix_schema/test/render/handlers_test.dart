import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  late SchemaEngine engine;

  setUp(() {
    engine = SchemaEngine();
  });

  Widget wrap(Widget child) {
    return MaterialApp(
      home: SchemaScope(
        engine: engine,
        trust: SchemaTrust.standard,
        child: Scaffold(body: child),
      ),
    );
  }

  Widget buildSchema(SchemaNode root, {void Function(SchemaEvent)? onEvent}) {
    final schema = UiSchemaRoot(
      id: 'test',
      schemaVersion: '0.1',
      root: root,
      trust: SchemaTrust.standard,
    );
    return wrap(SchemaWidget(schema: schema, onEvent: onEvent));
  }

  group('BoxHandler', () {
    testWidgets('renders Box widget', (tester) async {
      await tester.pumpWidget(buildSchema(
        const BoxNode(
          nodeId: 'box1',
          style: {'padding': DirectValue(16.0)},
          child: TextNode(nodeId: 't', content: DirectValue('inside')),
        ),
      ));

      expect(find.byType(Box), findsWidgets);
      expect(find.text('inside'), findsOneWidget);
    });

    testWidgets('applies color style', (tester) async {
      await tester.pumpWidget(buildSchema(
        const BoxNode(
          nodeId: 'box1',
          style: {'color': DirectValue('#0000FF')},
        ),
      ));

      expect(find.byType(Box), findsWidgets);
    });

    testWidgets('renders without child', (tester) async {
      await tester.pumpWidget(buildSchema(
        const BoxNode(nodeId: 'box1'),
      ));

      expect(find.byType(Box), findsWidgets);
    });

    testWidgets('wraps with Semantics when specified', (tester) async {
      await tester.pumpWidget(buildSchema(
        const BoxNode(
          nodeId: 'box1',
          semantics: SchemaSemantics(label: 'container'),
        ),
      ));

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'container',
        ),
        findsOneWidget,
      );
    });
  });

  group('TextHandler', () {
    testWidgets('renders StyledText with content', (tester) async {
      await tester.pumpWidget(buildSchema(
        const TextNode(
          nodeId: 't1',
          content: DirectValue('Hello World'),
        ),
      ));

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('applies text style properties', (tester) async {
      await tester.pumpWidget(buildSchema(
        const TextNode(
          nodeId: 't1',
          content: DirectValue('Styled'),
          style: {
            'fontSize': DirectValue(24.0),
            'fontWeight': DirectValue('bold'),
          },
        ),
      ));

      expect(find.text('Styled'), findsOneWidget);
    });

    testWidgets('renders empty string content', (tester) async {
      await tester.pumpWidget(buildSchema(
        const TextNode(
          nodeId: 't1',
          content: DirectValue(''),
        ),
      ));

      expect(find.text(''), findsOneWidget);
    });

    testWidgets('wraps with Semantics when specified', (tester) async {
      await tester.pumpWidget(buildSchema(
        const TextNode(
          nodeId: 't1',
          content: DirectValue('labeled'),
          semantics: SchemaSemantics(
            role: 'heading',
            label: 'section title',
          ),
        ),
      ));

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'section title',
        ),
        findsOneWidget,
      );
    });
  });

  group('FlexHandler', () {
    testWidgets('renders column by default', (tester) async {
      await tester.pumpWidget(buildSchema(
        const FlexNode(
          nodeId: 'f1',
          children: [
            TextNode(nodeId: 't1', content: DirectValue('A')),
            TextNode(nodeId: 't2', content: DirectValue('B')),
          ],
        ),
      ));

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('renders row when direction is row', (tester) async {
      await tester.pumpWidget(buildSchema(
        const FlexNode(
          nodeId: 'f1',
          direction: DirectValue('row'),
          children: [
            TextNode(nodeId: 't1', content: DirectValue('Left')),
            TextNode(nodeId: 't2', content: DirectValue('Right')),
          ],
        ),
      ));

      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
    });

    testWidgets('renders with spacing', (tester) async {
      await tester.pumpWidget(buildSchema(
        const FlexNode(
          nodeId: 'f1',
          direction: DirectValue('column'),
          spacing: DirectValue(16.0),
          children: [
            TextNode(nodeId: 't1', content: DirectValue('Spaced')),
          ],
        ),
      ));

      expect(find.text('Spaced'), findsOneWidget);
    });

    testWidgets('wraps with Semantics when specified', (tester) async {
      await tester.pumpWidget(buildSchema(
        const FlexNode(
          nodeId: 'f1',
          semantics: SchemaSemantics(label: 'list group'),
          children: [
            TextNode(nodeId: 't1', content: DirectValue('Item')),
          ],
        ),
      ));

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'list group',
        ),
        findsOneWidget,
      );
    });
  });

  group('StackHandler', () {
    testWidgets('renders StackBox with children', (tester) async {
      await tester.pumpWidget(buildSchema(
        const StackNode(
          nodeId: 's1',
          children: [
            BoxNode(nodeId: 'b1'),
            TextNode(nodeId: 't1', content: DirectValue('Overlay')),
          ],
        ),
      ));

      expect(find.text('Overlay'), findsOneWidget);
    });

    testWidgets('applies alignment', (tester) async {
      await tester.pumpWidget(buildSchema(
        const StackNode(
          nodeId: 's1',
          alignment: DirectValue('center'),
          children: [
            TextNode(nodeId: 't1', content: DirectValue('Centered')),
          ],
        ),
      ));

      expect(find.text('Centered'), findsOneWidget);
    });
  });

  group('IconHandler', () {
    testWidgets('renders StyledIcon with known icon name', (tester) async {
      await tester.pumpWidget(buildSchema(
        const IconNode(
          nodeId: 'i1',
          icon: DirectValue('star'),
        ),
      ));

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('renders help_outline for unknown icon', (tester) async {
      await tester.pumpWidget(buildSchema(
        const IconNode(
          nodeId: 'i1',
          icon: DirectValue('nonexistent_icon'),
        ),
      ));

      expect(find.byIcon(Icons.help_outline), findsOneWidget);
    });

    testWidgets('applies size style', (tester) async {
      await tester.pumpWidget(buildSchema(
        const IconNode(
          nodeId: 'i1',
          icon: DirectValue('star'),
          style: {'size': DirectValue(48.0)},
        ),
      ));

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('wraps with Semantics when specified', (tester) async {
      await tester.pumpWidget(buildSchema(
        const IconNode(
          nodeId: 'i1',
          icon: DirectValue('star'),
          semantics: SchemaSemantics(label: 'favorite icon'),
        ),
      ));

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'favorite icon',
        ),
        findsOneWidget,
      );
    });
  });

  group('ImageHandler', () {
    testWidgets('renders StyledImage', (tester) async {
      // Suppress image load errors in test environment
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.toString().contains('NetworkImage') ||
            details.toString().contains('HTTP request failed')) {
          return; // ignore network image errors in tests
        }
        originalOnError?.call(details);
      };

      await tester.pumpWidget(buildSchema(
        const ImageNode(
          nodeId: 'img1',
          src: DirectValue('https://example.com/test.png'),
          alt: 'Test image',
        ),
      ));

      expect(find.byType(StyledImage), findsOneWidget);

      FlutterError.onError = originalOnError;
    });

    testWidgets('wraps with Semantics for alt text', (tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.toString().contains('NetworkImage') ||
            details.toString().contains('HTTP request failed')) {
          return;
        }
        originalOnError?.call(details);
      };

      await tester.pumpWidget(buildSchema(
        const ImageNode(
          nodeId: 'img1',
          src: DirectValue('https://example.com/test.png'),
          alt: 'Photo of a cat',
          semantics: SchemaSemantics(
            role: 'img',
            label: 'Photo of a cat',
          ),
        ),
      ));

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Photo of a cat',
        ),
        findsOneWidget,
      );

      FlutterError.onError = originalOnError;
    });
  });

  group('PressableHandler', () {
    testWidgets('emits TapEvent on press', (tester) async {
      SchemaEvent? received;

      await tester.pumpWidget(buildSchema(
        const PressableNode(
          nodeId: 'btn1',
          actionId: 'my_action',
          semantics: SchemaSemantics(role: 'button', label: 'click me'),
          child: TextNode(nodeId: 't1', content: DirectValue('Click')),
        ),
        onEvent: (e) => received = e,
      ));

      await tester.tap(find.text('Click'));
      await tester.pump();

      expect(received, isA<TapEvent>());
      expect((received! as TapEvent).nodeId, 'btn1');
      expect((received! as TapEvent).actionId, 'my_action');
    });

    testWidgets('wraps with Semantics', (tester) async {
      await tester.pumpWidget(buildSchema(
        const PressableNode(
          nodeId: 'btn1',
          semantics: SchemaSemantics(
            role: 'button',
            label: 'Submit form',
          ),
          child: TextNode(nodeId: 't1', content: DirectValue('Submit')),
        ),
      ));

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Submit form',
        ),
        findsOneWidget,
      );
    });
  });

  group('WrapHandler', () {
    testWidgets('renders Wrap with spacing', (tester) async {
      await tester.pumpWidget(buildSchema(
        const WrapNode(
          nodeId: 'w1',
          spacing: DirectValue(8.0),
          runSpacing: DirectValue(4.0),
          children: [
            TextNode(nodeId: 't1', content: DirectValue('Tag1')),
            TextNode(nodeId: 't2', content: DirectValue('Tag2')),
            TextNode(nodeId: 't3', content: DirectValue('Tag3')),
          ],
        ),
      ));

      expect(find.text('Tag1'), findsOneWidget);
      expect(find.text('Tag2'), findsOneWidget);
      expect(find.text('Tag3'), findsOneWidget);

      // Verify Wrap widget with correct spacing
      final wrapWidget = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrapWidget.spacing, 8.0);
      expect(wrapWidget.runSpacing, 4.0);
    });
  });

  group('InputHandler', () {
    testWidgets('renders text input with label', (tester) async {
      await tester.pumpWidget(buildSchema(
        const InputNode(
          nodeId: 'input1',
          inputType: 'text',
          fieldId: 'name',
          label: DirectValue('Your Name'),
          hint: DirectValue('Enter your name'),
        ),
      ));

      expect(find.text('Your Name'), findsOneWidget);
      expect(find.text('Enter your name'), findsOneWidget);
    });

    testWidgets('emits ChangeEvent on text change', (tester) async {
      SchemaEvent? received;

      await tester.pumpWidget(buildSchema(
        const InputNode(
          nodeId: 'input1',
          inputType: 'text',
          fieldId: 'email',
          label: DirectValue('Email'),
        ),
        onEvent: (e) => received = e,
      ));

      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.pump();

      expect(received, isA<ChangeEvent>());
      expect((received! as ChangeEvent).field, 'email');
      expect((received! as ChangeEvent).value, 'test@example.com');
    });

    testWidgets('renders toggle input', (tester) async {
      await tester.pumpWidget(buildSchema(
        const InputNode(
          nodeId: 'toggle1',
          inputType: 'toggle',
          fieldId: 'darkMode',
          label: DirectValue('Dark Mode'),
          value: DirectValue(false),
        ),
      ));

      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.byType(SwitchListTile), findsOneWidget);
    });

    testWidgets('renders slider input', (tester) async {
      await tester.pumpWidget(buildSchema(
        const InputNode(
          nodeId: 'slider1',
          inputType: 'slider',
          fieldId: 'volume',
          label: DirectValue('Volume'),
          value: DirectValue(0.5),
          inputProps: {
            'min': DirectValue(0.0),
            'max': DirectValue(1.0),
          },
        ),
      ));

      expect(find.text('Volume'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });
  });

  group('RepeatHandler', () {
    testWidgets('renders items from bound data', (tester) async {
      const schema = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: RepeatNode(
          nodeId: 'rep1',
          items: BindingValue('items'),
          template: TextNode(
            nodeId: 'item_text',
            content: BindingValue('item.name'),
          ),
        ),
        trust: SchemaTrust.standard,
        environment: SchemaEnvironment(data: {
          'items': [
            {'name': 'Alpha'},
            {'name': 'Beta'},
            {'name': 'Gamma'},
          ]
        }),
      );

      await tester.pumpWidget(wrap(SchemaWidget(schema: schema)));

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Gamma'), findsOneWidget);
    });
  });

  group('ScrollableHandler', () {
    testWidgets('renders scrollable content', (tester) async {
      await tester.pumpWidget(buildSchema(
        const ScrollableNode(
          nodeId: 'scroll1',
          direction: DirectValue('vertical'),
          child: FlexNode(
            nodeId: 'flex1',
            direction: DirectValue('column'),
            children: [
              TextNode(nodeId: 't1', content: DirectValue('Scrollable 1')),
              TextNode(nodeId: 't2', content: DirectValue('Scrollable 2')),
            ],
          ),
        ),
      ));

      expect(find.text('Scrollable 1'), findsOneWidget);
      expect(find.text('Scrollable 2'), findsOneWidget);
    });
  });

  group('Data binding across handlers', () {
    testWidgets('resolves binding values in text', (tester) async {
      const schema = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: TextNode(
          nodeId: 't1',
          content: BindingValue('greeting'),
        ),
        trust: SchemaTrust.standard,
        environment: SchemaEnvironment(data: {'greeting': 'Hello, Alice!'}),
      );

      await tester.pumpWidget(wrap(SchemaWidget(schema: schema)));
      expect(find.text('Hello, Alice!'), findsOneWidget);
    });

    testWidgets('resolves nested binding paths', (tester) async {
      const schema = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: TextNode(
          nodeId: 't1',
          content: BindingValue('user.profile.name'),
        ),
        trust: SchemaTrust.standard,
        environment: SchemaEnvironment(data: {
          'user': {
            'profile': {'name': 'Bob'}
          }
        }),
      );

      await tester.pumpWidget(wrap(SchemaWidget(schema: schema)));
      expect(find.text('Bob'), findsOneWidget);
    });
  });

  group('Animation config', () {
    testWidgets('renders box with animation without crashing', (tester) async {
      await tester.pumpWidget(buildSchema(
        const BoxNode(
          nodeId: 'anim_box',
          style: {'padding': DirectValue(16.0)},
          animation: SchemaAnimation(durationMs: 300, curve: 'easeOut'),
          child: TextNode(nodeId: 't1', content: DirectValue('Animated')),
        ),
      ));

      expect(find.text('Animated'), findsOneWidget);
    });

    testWidgets('renders text with animation', (tester) async {
      await tester.pumpWidget(buildSchema(
        const TextNode(
          nodeId: 'anim_text',
          content: DirectValue('Animated Text'),
          style: {'fontSize': DirectValue(20.0)},
          animation: SchemaAnimation(
            durationMs: 200,
            curve: 'easeInOut',
            delayMs: 100,
          ),
        ),
      ));

      expect(find.text('Animated Text'), findsOneWidget);
    });
  });
}
