import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  late SchemaEngine engine;

  setUp(() {
    engine = SchemaEngine();
  });

  Widget wrapWithScope(Widget child) {
    return MaterialApp(
      home: SchemaScope(
        engine: engine,
        trust: SchemaTrust.standard,
        child: child,
      ),
    );
  }

  group('SchemaWidget', () {
    testWidgets('renders simple box with text', (tester) async {
      const schema = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: BoxNode(
          nodeId: 'box1',
          style: {'padding': DirectValue(16.0)},
          child: TextNode(
            nodeId: 'text1',
            content: DirectValue('Hello Schema'),
          ),
        ),
        trust: SchemaTrust.standard,
      );

      await tester.pumpWidget(wrapWithScope(
        SchemaWidget(schema: schema),
      ));

      expect(find.text('Hello Schema'), findsOneWidget);
    });

    testWidgets('renders flex with multiple text children', (tester) async {
      const schema = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: FlexNode(
          nodeId: 'flex1',
          direction: DirectValue('column'),
          children: [
            TextNode(nodeId: 't1', content: DirectValue('First')),
            TextNode(nodeId: 't2', content: DirectValue('Second')),
          ],
        ),
        trust: SchemaTrust.standard,
      );

      await tester.pumpWidget(wrapWithScope(
        SchemaWidget(schema: schema),
      ));

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('calls onError for invalid schema', (tester) async {
      const schema = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: TextNode(nodeId: 'text', content: DirectValue(null)),
        trust: SchemaTrust.standard,
      );

      var errorCalled = false;

      await tester.pumpWidget(wrapWithScope(
        SchemaWidget(
          schema: schema,
          onError: (diagnostics) {
            errorCalled = true;
            return const Text('Error');
          },
        ),
      ));

      expect(errorCalled, true);
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('renders icon node', (tester) async {
      const schema = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: IconNode(
          nodeId: 'icon1',
          icon: DirectValue('star'),
        ),
        trust: SchemaTrust.standard,
      );

      await tester.pumpWidget(wrapWithScope(
        SchemaWidget(schema: schema),
      ));

      // StyledIcon should exist in the tree
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('renders nested box layout', (tester) async {
      const schema = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: BoxNode(
          nodeId: 'outer',
          style: {'color': DirectValue('#FF0000'), 'padding': DirectValue(8.0)},
          child: BoxNode(
            nodeId: 'inner',
            child: TextNode(
              nodeId: 'text',
              content: DirectValue('Nested'),
            ),
          ),
        ),
        trust: SchemaTrust.standard,
      );

      await tester.pumpWidget(wrapWithScope(
        SchemaWidget(schema: schema),
      ));

      expect(find.text('Nested'), findsOneWidget);
    });

    testWidgets('emits event on pressable tap', (tester) async {
      const schema = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: PressableNode(
          nodeId: 'btn',
          actionId: 'submit',
          semantics: SchemaSemantics(role: 'button', label: 'Tap me'),
          child: TextNode(
            nodeId: 'label',
            content: DirectValue('Tap me'),
          ),
        ),
        trust: SchemaTrust.standard,
      );

      SchemaEvent? lastEvent;
      await tester.pumpWidget(wrapWithScope(
        SchemaWidget(
          schema: schema,
          onEvent: (event) {
            lastEvent = event;
          },
        ),
      ));

      // Find the tap target
      final tapTarget = find.text('Tap me');
      expect(tapTarget, findsOneWidget);

      await tester.tap(tapTarget);
      await tester.pump();

      expect(lastEvent, isA<TapEvent>());
      expect((lastEvent as TapEvent).actionId, 'submit');
    });

    testWidgets('renders with data binding', (tester) async {
      const schema = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: TextNode(
          nodeId: 'text',
          content: BindingValue('user.name'),
        ),
        trust: SchemaTrust.standard,
        environment: SchemaEnvironment(
          data: {'user': {'name': 'Alice'}},
        ),
      );

      await tester.pumpWidget(wrapWithScope(
        SchemaWidget(schema: schema),
      ));

      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('renders wrap node', (tester) async {
      const schema = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: WrapNode(
          nodeId: 'wrap',
          spacing: DirectValue(4.0),
          children: [
            TextNode(nodeId: 't1', content: DirectValue('Tag1')),
            TextNode(nodeId: 't2', content: DirectValue('Tag2')),
          ],
        ),
        trust: SchemaTrust.standard,
      );

      await tester.pumpWidget(wrapWithScope(
        SchemaWidget(schema: schema),
      ));

      expect(find.text('Tag1'), findsOneWidget);
      expect(find.text('Tag2'), findsOneWidget);
    });
  });

  group('SchemaScope', () {
    testWidgets('provides engine to descendants', (tester) async {
      SchemaEngine? foundEngine;

      await tester.pumpWidget(MaterialApp(
        home: SchemaScope(
          engine: engine,
          trust: SchemaTrust.standard,
          child: Builder(builder: (context) {
            foundEngine = SchemaScope.engineOf(context);
            return const SizedBox.shrink();
          }),
        ),
      ));

      expect(foundEngine, same(engine));
    });

    testWidgets('provides trust to descendants', (tester) async {
      SchemaTrust? foundTrust;

      await tester.pumpWidget(MaterialApp(
        home: SchemaScope(
          engine: engine,
          trust: SchemaTrust.elevated,
          child: Builder(builder: (context) {
            foundTrust = SchemaScope.trustOf(context);
            return const SizedBox.shrink();
          }),
        ),
      ));

      expect(foundTrust, SchemaTrust.elevated);
    });
  });
}
