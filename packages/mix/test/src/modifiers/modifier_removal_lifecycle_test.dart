import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

class _ScopeHost extends StatefulWidget {
  const _ScopeHost({super.key, required this.child});
  final Widget child;
  @override
  State<_ScopeHost> createState() => _ScopeHostState();
}

class _ScopeHostState extends State<_ScopeHost> {
  List<Type> order = const [RotateModifier, PaddingModifier];
  void reverseOrder() =>
      setState(() => order = const [PaddingModifier, RotateModifier]);
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: MixScope(orderOfModifiers: order, child: widget.child),
  );
}

class _StyledChild extends StatefulWidget {
  const _StyledChild({super.key, required this.keepConfig});
  final bool keepConfig;
  @override
  State<_StyledChild> createState() => _StyledChildState();
}

class _StyledChildState extends State<_StyledChild> {
  bool extras = true;
  void exit() => setState(() => extras = false);
  @override
  Widget build(BuildContext context) {
    var style = BoxStyler().size(64, 32);
    if (extras) {
      style = style.wrap(
        WidgetModifierConfig.padding(
          EdgeInsetsGeometryMix.all(10),
        ).rotate(radians: 0.4),
      );
    }
    if (extras || widget.keepConfig) {
      style = style.animate(
        const CurveAnimationConfig(
          duration: Duration(seconds: 1),
          curve: Curves.linear,
        ),
      );
    }
    return Center(child: Box(style: style));
  }
}

void main() {
  for (final keepConfig in [true, false]) {
    testWidgets(
      'inherited-only order update with null target, keepConfig=$keepConfig',
      (tester) async {
        final scope = GlobalKey<_ScopeHostState>();
        final child = GlobalKey<_StyledChildState>();
        await tester.pumpWidget(
          _ScopeHost(
            key: scope,
            child: _StyledChild(key: child, keepConfig: keepConfig),
          ),
        );
        await tester.pumpAndSettle();
        child.currentState!.exit();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        final rotation = find.byType(Transform);
        final padding = find.byType(Padding);
        expect(
          tester.widget<Padding>(padding).padding,
          const EdgeInsets.all(9),
        );
        expect(
          find.descendant(of: rotation, matching: padding),
          findsOneWidget,
        );
        scope.currentState!.reverseOrder();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1));
        expect(
          find.descendant(of: padding, matching: rotation),
          findsOneWidget,
        );
        expect(
          tester
              .widget<Padding>(padding)
              .padding
              .resolve(TextDirection.ltr)
              .left,
          closeTo(8.99, 1e-7),
        );
        await tester.pump(const Duration(milliseconds: 899));
        expect(rotation, findsNothing);
        expect(padding, findsNothing);
      },
    );
  }
}
