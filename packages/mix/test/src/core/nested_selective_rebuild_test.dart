import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

// Widget that uses BoxSpec
class BoxWidget extends StatefulWidget {
  const BoxWidget({super.key});

  @override
  State<BoxWidget> createState() => _BoxWidgetState();
}

class _BoxWidgetState extends State<BoxWidget> {
  int buildCount = 0;

  @override
  Widget build(BuildContext context) {
    buildCount++;

    final boxSpec = BoxSpec.of(context);
    return Container(
      width: 100,
      height: 100,
      decoration: boxSpec.decoration,
      child: Text('Box builds: $buildCount'),
    );
  }
}

// Widget that uses TextSpec
class TextWidget extends StatefulWidget {
  const TextWidget({super.key});

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  int buildCount = 0;

  @override
  Widget build(BuildContext context) {
    buildCount++;

    final textSpec = TextSpec.of(context);
    return Text(
      'Text builds: $buildCount',
      style: textSpec.style,
    );
  }
}

// Container widget that holds the ComputedStyleProvider
class StyleContainer extends StatefulWidget {
  const StyleContainer({super.key});

  @override
  State<StyleContainer> createState() => _StyleContainerState();
}

class _StyleContainerState extends State<StyleContainer> {
  late ComputedStyle _computedStyle;
  Color _currentBoxColor = Colors.red;
  double _currentTextSize = 14;

  @override
  void initState() {
    super.initState();
    _updateStyle();
  }

  void _updateStyle() {
    final style = Style(
      $box.color(_currentBoxColor),
      $text.style.fontSize(_currentTextSize),
    );
    final mixData = MixContext.create(MockBuildContext(), style);
    _computedStyle = ComputedStyle.compute(mixData);
  }

  void updateBoxColor(Color color) {
    setState(() {
      _currentBoxColor = color;
      _updateStyle();
    });
  }

  void updateTextSize(double fontSize) {
    setState(() {
      _currentTextSize = fontSize;
      _updateStyle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ComputedStyleProvider(
      style: _computedStyle,
      child: const Column(
        children: [
          BoxWidget(),
          TextWidget(),
        ],
      ),
    );
  }
}

void main() {
  group('Nested Selective Rebuild Test', () {
    testWidgets('Widgets in same tree should rebuild selectively',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StyleContainer(),
          ),
        ),
      );

      // Get references to the widget states
      final boxState = tester.state<_BoxWidgetState>(find.byType(BoxWidget));
      final textState = tester.state<_TextWidgetState>(find.byType(TextWidget));
      final containerState =
          tester.state<_StyleContainerState>(find.byType(StyleContainer));

      debugPrint('\n=== Initial build ===');
      expect(boxState.buildCount, 1,
          reason: 'BoxWidget should build once initially');
      expect(textState.buildCount, 1,
          reason: 'TextWidget should build once initially');

      debugPrint('\n=== Changing only BoxSpec (color red -> blue) ===');
      containerState.updateBoxColor(Colors.blue);
      await tester.pump();

      debugPrint('BoxWidget build count: ${boxState.buildCount} (expected: 2)');
      debugPrint(
          'TextWidget build count: ${textState.buildCount} (expected: 1)');

      expect(boxState.buildCount, 2,
          reason: 'BoxWidget should rebuild when BoxSpec changes');
      expect(textState.buildCount, 1,
          reason: 'TextWidget should NOT rebuild when only BoxSpec changes');

      debugPrint('\n=== Changing only TextSpec (fontSize 14 -> 18) ===');
      containerState.updateTextSize(18);
      await tester.pump();

      debugPrint('BoxWidget build count: ${boxState.buildCount} (expected: 2)');
      debugPrint(
          'TextWidget build count: ${textState.buildCount} (expected: 2)');

      expect(boxState.buildCount, 2,
          reason: 'BoxWidget should NOT rebuild when only TextSpec changes');
      expect(textState.buildCount, 2,
          reason: 'TextWidget should rebuild when TextSpec changes');

      debugPrint('\n=== Changing both specs ===');
      containerState.updateBoxColor(Colors.green);
      await tester.pump();
      containerState.updateTextSize(20);
      await tester.pump();

      debugPrint('BoxWidget build count: ${boxState.buildCount} (expected: 3)');
      debugPrint(
          'TextWidget build count: ${textState.buildCount} (expected: 3)');

      expect(boxState.buildCount, 3,
          reason: 'BoxWidget should rebuild when BoxSpec changes');
      expect(textState.buildCount, 3,
          reason: 'TextWidget should rebuild when TextSpec changes');
    });
  });
}
