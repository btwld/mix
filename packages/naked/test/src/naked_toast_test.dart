import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked/src/naked_toast.dart';

void main() {
  group('Rendering and Setup', () {
    testWidgets('renders child and toastWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NakedToastLayer(
            onRemove: (entry) {},
            toastWidget: const Text('ToastWidget'),
            child: const Text('Child'),
          ),
        ),
      );

      expect(find.text('Child'), findsOneWidget);
      expect(find.text('ToastWidget'), findsOneWidget);
    });

    testWidgets('NakedToastLayerState.of finds the state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NakedToastLayer(
            onRemove: (_) {},
            toastWidget: const Text('ToastWidget'),
            child: const Text('Child'),
          ),
        ),
      );

      final finder = find.text('Child');
      expect(finder, findsOneWidget);

      final textContext = tester.element(finder);

      NakedToastLayerState? state;
      expect(() => state = NakedToastLayer.of(textContext), returnsNormally);
      expect(state, isNotNull);
    });

    testWidgets('NakedToastLayerState.of throws if no ancestor',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(
                  () => NakedToastLayer.of(context), throwsA(isA<Exception>()));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('toastStream emits correct initial state (empty list)',
        (WidgetTester tester) async {
      List<NakedToastEntry> streamEntries = [];
      await tester.pumpWidget(
        MaterialApp(
          home: NakedToastLayer(
            onRemove: (_) {},
            toastWidget: const Text('ToastWidget'),
            child: Builder(builder: (context) {
              return StreamBuilder<List<NakedToastEntry>>(
                stream: NakedToastLayer.of(context).toastStream,
                initialData: const [],
                builder: (context, snapshot) {
                  streamEntries = snapshot.data ?? [];
                  return Text('Toast Count: ${snapshot.data?.length}');
                },
              );
            }),
          ),
        ),
      );

      await tester.pump();

      expect(streamEntries, isEmpty);
      expect(find.text('Toast Count: 0'), findsOneWidget);
    });
  });

  group('Toast Management', () {
    testWidgets('addToast adds an entry and updates the stream',
        (WidgetTester tester) async {
      const key = Key('text-key');

      await tester.pumpWidget(
        MaterialApp(
          home: NakedToastLayer(
            onRemove: (_) {},
            toastWidget: const Text('ToastWidget'),
            child: Builder(builder: (context) {
              final state = NakedToastLayer.of(context);
              return StreamBuilder<List<NakedToastEntry>>(
                stream: state.toastStream,
                initialData: const [],
                builder: (context, snapshot) {
                  return Text(
                    key: key,
                    'Toast Count: ${snapshot.data?.length}',
                  );
                },
              );
            }),
          ),
        ),
      );

      await tester.pump();

      final finder = find.byKey(key);
      expect(finder, findsOneWidget);

      final textContext = tester.element(finder);

      final state = NakedToastLayer.of(textContext);
      state.addToast(NakedToastEntry(
        context: textContext,
        toast: (context, remove) => const Text('Test Toast'),
        duration: const Duration(seconds: 1),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Toast Count: 1'), findsOneWidget);
    });

    testWidgets(
        'toast is automatically removed via onRemove callback after duration',
        (WidgetTester tester) async {
      const key = Key('text-key');
      int count = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: NakedToastLayer(
            onRemove: (entry) {
              count++;
            },
            toastWidget: const Text('ToastWidget'),
            child: Builder(builder: (context) {
              final state = NakedToastLayer.of(context);
              return StreamBuilder<List<NakedToastEntry>>(
                stream: state.toastStream,
                initialData: const [],
                builder: (context, snapshot) {
                  return Text(
                    key: key,
                    'Toast Count: ${snapshot.data?.length}',
                  );
                },
              );
            }),
          ),
        ),
      );

      await tester.pump();

      final finder = find.byKey(key);
      final textContext = tester.element(finder);
      final state = NakedToastLayer.of(textContext);

      state.addToast(
        NakedToastEntry(
          context: textContext,
          toast: (context, remove) => const Text('Test Toast'),
          duration: const Duration(seconds: 1),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(count, 1);
    });

    testWidgets(
        'removeToast removes an entry, updates stream, cancels timer, and returns index',
        (WidgetTester tester) async {
      const key = Key('text-key');
      int count = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: NakedToastLayer(
            onRemove: (entry) {
              count++;
            },
            toastWidget: const Text('ToastWidget'),
            child: Builder(builder: (context) {
              final state = NakedToastLayer.of(context);
              return StreamBuilder<List<NakedToastEntry>>(
                stream: state.toastStream,
                initialData: const [],
                builder: (context, snapshot) {
                  return Text(
                    key: key,
                    'Toast Count: ${snapshot.data?.length}',
                  );
                },
              );
            }),
          ),
        ),
      );

      await tester.pump();

      final finder = find.byKey(key);
      final textContext = tester.element(finder);
      final state = NakedToastLayer.of(textContext);

      final entry = NakedToastEntry(
        context: textContext,
        toast: (context, remove) => const Text('Test Toast'),
        duration: const Duration(seconds: 1),
      );
      state.addToast(entry);

      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final index = state.removeToast(entry);
      expect(index, 0);

      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(count, 0);
    });

    testWidgets('removeToast does nothing and returns null if entry not found',
        (WidgetTester tester) async {
      const key = Key('text-key');
      int count = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: NakedToastLayer(
            onRemove: (entry) {
              count++;
            },
            toastWidget: const Text('ToastWidget'),
            child: Builder(builder: (context) {
              final state = NakedToastLayer.of(context);
              return StreamBuilder<List<NakedToastEntry>>(
                stream: state.toastStream,
                initialData: const [],
                builder: (context, snapshot) {
                  return Text(
                    key: key,
                    'Toast Count: ${snapshot.data?.length}',
                  );
                },
              );
            }),
          ),
        ),
      );

      await tester.pump();

      final finder = find.byKey(key);
      final textContext = tester.element(finder);
      final state = NakedToastLayer.of(textContext);

      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final entry = NakedToastEntry(
        context: textContext,
        toast: (context, remove) => const Text('Test Toast'),
        duration: const Duration(seconds: 1),
      );

      final index = state.removeToast(entry);
      expect(index, null);

      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(count, 0);
    });

    testWidgets('indexOf returns correct index or null',
        (WidgetTester tester) async {
      const key = Key('text-key');

      await tester.pumpWidget(
        MaterialApp(
          home: NakedToastLayer(
            onRemove: (_) {},
            toastWidget: const Text('ToastWidget'),
            child: Builder(builder: (context) {
              final state = NakedToastLayer.of(context);
              return StreamBuilder<List<NakedToastEntry>>(
                stream: state.toastStream,
                initialData: const [],
                builder: (context, snapshot) {
                  return Text(
                    key: key,
                    'Toast Count: ${snapshot.data?.length}',
                  );
                },
              );
            }),
          ),
        ),
      );

      await tester.pump();

      final finder = find.byKey(key);
      final textContext = tester.element(finder);
      final state = NakedToastLayer.of(textContext);

      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      NakedToastEntry createEntry() => NakedToastEntry(
            context: textContext,
            toast: (context, remove) => const Text('Test Toast'),
            duration: const Duration(seconds: 1),
          );

      final entry = createEntry();
      state.addToast(entry);

      final index = state.indexOf(entry);
      expect(index, 0);

      final index2 = state.indexOf(createEntry());
      expect(index2, null);
    });
  });

  group('Lifecycle', () {
    testWidgets('dispose cancels timers and closes stream',
        (WidgetTester tester) async {
      const key = Key('text-key');

      await tester.pumpWidget(
        MaterialApp(
          home: NakedToastLayer(
            onRemove: (_) {},
            toastWidget: const Text('ToastWidget'),
            child: const Text(key: key, 'child'),
          ),
        ),
      );

      await tester.pump();

      final finder = find.byKey(key);
      final textContext = tester.element(finder);
      final state = NakedToastLayer.of(textContext);

      final layerContext = tester.element(find.byType(NakedToastLayer));

      bool streamClosed = false;

      final stream = state.toastStream;
      final subscription = stream.listen(
        null,
        onDone: () {
          streamClosed = true;
        },
        cancelOnError: false,
      );

      final entry = NakedToastEntry(
        context: layerContext,
        toast: (context, remove) => const Text('Test Toast'),
        duration: const Duration(seconds: 1),
      );
      state.addToast(entry);

      await tester.pumpAndSettle();

      await tester.pumpWidget(Container());

      await tester.pump(const Duration(seconds: 1));

      expect(streamClosed, isTrue);
      addTearDown(() async {
        await subscription.cancel();
      });
    });
  });
}
