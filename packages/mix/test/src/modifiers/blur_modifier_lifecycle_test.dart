import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  for (final initialSigma in [0.0, 4.0]) {
    testWidgets(
      'animated blur preserves child state through zero from $initialSigma',
      (tester) async {
        Future<void> pumpBlur(double sigma) => tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: Center(
                child: Box(
                  style: BoxStyler()
                      .width(200)
                      .wrap(WidgetModifierConfig.blur(sigma))
                      .animate(.linear(const Duration(milliseconds: 400))),
                  child: const _Editor(key: ValueKey('editor')),
                ),
              ),
            ),
          ),
        );

        await pumpBlur(initialSigma);
        final editor = tester.state<_EditorState>(find.byType(_Editor));
        await tester.enterText(find.byType(TextField), 'Retained text');
        await tester.pump();
        editor.controller.selection = const TextSelection.collapsed(offset: 3);
        final editingValue = editor.controller.value;
        var previousProgress = editor.animation.value;

        void expectRetainedEditor() {
          final current = tester.state<_EditorState>(find.byType(_Editor));
          expect(
            (
              current,
              editor.mounted,
              current.controller.value,
              current.focusNode.hasFocus,
              current.animation.isAnimating,
            ),
            (editor, true, editingValue, true, true),
          );
          expect(current.animation.value, greaterThan(previousProgress));
          previousProgress = current.animation.value;
        }

        // Cross zero in both directions, including intermediate animation
        // frames. A local key must not need global-key reparenting to survive.
        for (final sigma in [4.0 - initialSigma, initialSigma]) {
          await pumpBlur(sigma);
          await tester.pump(const Duration(milliseconds: 200));
          expectRetainedEditor();
          await tester.pump(const Duration(milliseconds: 200));
          expectRetainedEditor();
        }

        await tester.pumpWidget(const SizedBox.shrink());
        expect(editor.mounted, isFalse);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

class _Editor extends StatefulWidget {
  const _Editor({super.key});

  @override
  State<_Editor> createState() => _EditorState();
}

class _EditorState extends State<_Editor> with SingleTickerProviderStateMixin {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  late final AnimationController animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..forward();
  }

  @override
  void dispose() {
    animation.dispose();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller, focusNode: focusNode);
  }
}
