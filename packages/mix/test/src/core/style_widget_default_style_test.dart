import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('StyleWidget default style', () {
    test('uses IdentityStyle with the concrete default spec', () {
      expectIdentityStyle(const Box().style, const BoxSpec());
      expectIdentityStyle(const StyledText('').style, const TextSpec());
      expectIdentityStyle(const StyledIcon().style, const IconSpec());
      expectIdentityStyle(const StyledImage().style, const ImageSpec());
      expectIdentityStyle(const FlexBox().style, const FlexBoxSpec());
      expectIdentityStyle(const RowBox().style, const FlexBoxSpec());
      expectIdentityStyle(const ColumnBox().style, const FlexBoxSpec());
      expectIdentityStyle(const StackBox().style, const StackBoxSpec());
    });

    test('preserves explicit concrete widget styles', () {
      final boxStyle = BoxStyler().width(100);
      final textStyle = TextStyler().fontSize(16);
      final iconStyle = IconStyler().size(24);
      final imageStyle = ImageStyler().width(200);
      final flexBoxStyle = FlexBoxStyler().direction(Axis.vertical);
      final stackBoxStyle = StackBoxStyler().fit(StackFit.expand);

      expect(Box(style: boxStyle).style, same(boxStyle));
      expect(StyledText('', style: textStyle).style, same(textStyle));
      expect(StyledIcon(style: iconStyle).style, same(iconStyle));
      expect(StyledImage(style: imageStyle).style, same(imageStyle));
      expect(FlexBox(style: flexBoxStyle).style, same(flexBoxStyle));
      expect(RowBox(style: flexBoxStyle).style, same(flexBoxStyle));
      expect(ColumnBox(style: flexBoxStyle).style, same(flexBoxStyle));
      expect(StackBox(style: stackBoxStyle).style, same(stackBoxStyle));
    });

    testWidgets('routes styleSpec directly without resolving style', (
      tester,
    ) async {
      const boxKey = Key('box');
      final ignoredStyle = BoxStyler().width(999);
      final directSpec = StyleSpec(
        spec: BoxStyler()
            .width(120)
            .height(80)
            .color(Colors.green)
            .resolve(MockBuildContext())
            .spec,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Box(key: boxKey, style: ignoredStyle, styleSpec: directSpec),
        ),
      );

      final styledContainer = tester.widget<Container>(
        find.descendant(
          of: find.byKey(boxKey),
          matching: find.byType(Container),
        ),
      );

      expect(styledContainer.constraints?.maxWidth, 120);
      expect(styledContainer.constraints?.maxHeight, 80);
      expect(
        (styledContainer.decoration as BoxDecoration?)?.color,
        Colors.green,
      );
    });

    testWidgets('default Box inherits parent style', (tester) async {
      const boxKey = Key('box');
      final parentStyle = BoxStyler().width(120).height(80).color(Colors.green);

      await tester.pumpWidget(
        MaterialApp(
          home: StyleBuilder<BoxSpec>(
            style: parentStyle,
            inheritable: true,
            builder: (context, spec) => const Box(key: boxKey),
          ),
        ),
      );

      final styledContainer = tester.widget<Container>(
        find.descendant(
          of: find.byKey(boxKey),
          matching: find.byType(Container),
        ),
      );

      expect(styledContainer.constraints?.minWidth, 120);
      expect(styledContainer.constraints?.maxWidth, 120);
      expect(styledContainer.constraints?.minHeight, 80);
      expect(styledContainer.constraints?.maxHeight, 80);
      expect(
        (styledContainer.decoration as BoxDecoration?)?.color,
        Colors.green,
      );
    });
  });
}

void expectIdentityStyle<S extends Spec<S>>(Style<S> style, S spec) {
  expect(
    style,
    isA<IdentityStyle<S>>().having((style) => style.spec, 'spec', spec),
  );
}
