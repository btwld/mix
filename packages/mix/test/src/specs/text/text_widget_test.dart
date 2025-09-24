import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Default parameters for StyledText matches Text', () {
    testWidgets('should have the same default parameters', (tester) async {
      const testText = 'Hello World';
      const styledTextKey = Key('styled-text');
      const textKey = Key('text');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                StyledText(testText, style: null, styleSpec: StyleSpec(spec: const TextSpec()), key: styledTextKey),
                Text(testText, key: textKey),
              ],
            ),
          ),
        ),
      );

      /// Get widgets by key
      final styledTextFinder = find.byKey(styledTextKey);
      final textFinder = find.byKey(textKey);

      /// Find the Text widget inside the StyledText widget
      final styledText = tester.widget<Text>(
        find.descendant(of: styledTextFinder, matching: find.byType(Text)),
      );
      final text = tester.widget<Text>(textFinder);

      /// Compare the default parameters with detailed error messages
      expect(
        styledText.style,
        text.style,
        reason:
            'StyledText style (${styledText.style}) should match Text style (${text.style})',
      );
      expect(
        styledText.strutStyle,
        text.strutStyle,
        reason:
            'StyledText strutStyle (${styledText.strutStyle}) should match Text strutStyle (${text.strutStyle})',
      );
      expect(
        styledText.textAlign,
        text.textAlign,
        reason:
            'StyledText textAlign (${styledText.textAlign}) should match Text textAlign (${text.textAlign})',
      );
      expect(
        styledText.textDirection,
        text.textDirection,
        reason:
            'StyledText textDirection (${styledText.textDirection}) should match Text textDirection (${text.textDirection})',
      );
      expect(
        styledText.locale,
        text.locale,
        reason:
            'StyledText locale (${styledText.locale}) should match Text locale (${text.locale})',
      );
      expect(
        styledText.softWrap,
        text.softWrap,
        reason:
            'StyledText softWrap (${styledText.softWrap}) should match Text softWrap (${text.softWrap})',
      );
      expect(
        styledText.overflow,
        text.overflow,
        reason:
            'StyledText overflow (${styledText.overflow}) should match Text overflow (${text.overflow})',
      );
      expect(
        styledText.textScaler,
        text.textScaler,
        reason:
            'StyledText textScaler (${styledText.textScaler}) should match Text textScaler (${text.textScaler})',
      );
      expect(
        styledText.maxLines,
        text.maxLines,
        reason:
            'StyledText maxLines (${styledText.maxLines}) should match Text maxLines (${text.maxLines})',
      );
      expect(
        styledText.semanticsLabel,
        text.semanticsLabel,
        reason:
            'StyledText semanticsLabel (${styledText.semanticsLabel}) should match Text semanticsLabel (${text.semanticsLabel})',
      );
      expect(
        styledText.textWidthBasis,
        text.textWidthBasis,
        reason:
            'StyledText textWidthBasis (${styledText.textWidthBasis}) should match Text textWidthBasis (${text.textWidthBasis})',
      );
      expect(
        styledText.textHeightBehavior,
        text.textHeightBehavior,
        reason:
            'StyledText textHeightBehavior (${styledText.textHeightBehavior}) should match Text textHeightBehavior (${text.textHeightBehavior})',
      );
      expect(
        styledText.selectionColor,
        text.selectionColor,
        reason:
            'StyledText selectionColor (${styledText.selectionColor}) should match Text selectionColor (${text.selectionColor})',
      );
      expect(
        styledText.data,
        text.data,
        reason:
            'StyledText data (${styledText.data}) should match Text data (${text.data})',
      );
    });
  });
}
