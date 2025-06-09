import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Enum Utilities', () {
    group('VerticalDirectionUtility', () {
      final utility = VerticalDirectionUtility(UtilityTestAttribute.new);

      test('should create attribute with up direction', () {
        final attribute = utility.up();
        expect(attribute.value, VerticalDirection.up);
      });

      test('should create attribute with down direction', () {
        final attribute = utility.down();
        expect(attribute.value, VerticalDirection.down);
      });

      test('should create attribute with call method', () {
        final attribute = utility(VerticalDirection.up);
        expect(attribute.value, VerticalDirection.up);
      });
    });

    group('BorderStyleUtility', () {
      final utility = BorderStyleUtility(UtilityTestAttribute.new);

      test('should create attribute with solid style', () {
        final attribute = utility.solid();
        expect(attribute.value, BorderStyle.solid);
      });

      test('should create attribute with none style', () {
        final attribute = utility.none();
        expect(attribute.value, BorderStyle.none);
      });

      test('should create attribute with call method', () {
        final attribute = utility(BorderStyle.solid);
        expect(attribute.value, BorderStyle.solid);
      });
    });

    group('ClipUtility', () {
      final utility = ClipUtility(UtilityTestAttribute.new);

      test('should create attribute with hardEdge clip', () {
        final attribute = utility.hardEdge();
        expect(attribute.value, Clip.hardEdge);
      });

      test('should create attribute with antiAlias clip', () {
        final attribute = utility.antiAlias();
        expect(attribute.value, Clip.antiAlias);
      });

      test('should create attribute with antiAliasWithSaveLayer clip', () {
        final attribute = utility.antiAliasWithSaveLayer();
        expect(attribute.value, Clip.antiAliasWithSaveLayer);
      });

      test('should create attribute with none clip', () {
        final attribute = utility.none();
        expect(attribute.value, Clip.none);
      });

      test('should create attribute with call method', () {
        final attribute = utility(Clip.antiAlias);
        expect(attribute.value, Clip.antiAlias);
      });
    });

    group('AxisUtility', () {
      final utility = AxisUtility(UtilityTestAttribute.new);

      test('should create attribute with horizontal axis', () {
        final attribute = utility.horizontal();
        expect(attribute.value, Axis.horizontal);
      });

      test('should create attribute with vertical axis', () {
        final attribute = utility.vertical();
        expect(attribute.value, Axis.vertical);
      });

      test('should create attribute with call method', () {
        final attribute = utility(Axis.horizontal);
        expect(attribute.value, Axis.horizontal);
      });
    });

    group('MainAxisAlignmentUtility', () {
      final utility = MainAxisAlignmentUtility(UtilityTestAttribute.new);

      test('should create attribute with start alignment', () {
        final attribute = utility.start();
        expect(attribute.value, MainAxisAlignment.start);
      });

      test('should create attribute with end alignment', () {
        final attribute = utility.end();
        expect(attribute.value, MainAxisAlignment.end);
      });

      test('should create attribute with center alignment', () {
        final attribute = utility.center();
        expect(attribute.value, MainAxisAlignment.center);
      });

      test('should create attribute with spaceBetween alignment', () {
        final attribute = utility.spaceBetween();
        expect(attribute.value, MainAxisAlignment.spaceBetween);
      });

      test('should create attribute with spaceAround alignment', () {
        final attribute = utility.spaceAround();
        expect(attribute.value, MainAxisAlignment.spaceAround);
      });

      test('should create attribute with spaceEvenly alignment', () {
        final attribute = utility.spaceEvenly();
        expect(attribute.value, MainAxisAlignment.spaceEvenly);
      });

      test('should create attribute with call method', () {
        final attribute = utility(MainAxisAlignment.center);
        expect(attribute.value, MainAxisAlignment.center);
      });
    });

    group('TextAlignUtility', () {
      final utility = TextAlignUtility(UtilityTestAttribute.new);

      test('should create attribute with left alignment', () {
        final attribute = utility.left();
        expect(attribute.value, TextAlign.left);
      });

      test('should create attribute with right alignment', () {
        final attribute = utility.right();
        expect(attribute.value, TextAlign.right);
      });

      test('should create attribute with center alignment', () {
        final attribute = utility.center();
        expect(attribute.value, TextAlign.center);
      });

      test('should create attribute with justify alignment', () {
        final attribute = utility.justify();
        expect(attribute.value, TextAlign.justify);
      });

      test('should create attribute with start alignment', () {
        final attribute = utility.start();
        expect(attribute.value, TextAlign.start);
      });

      test('should create attribute with end alignment', () {
        final attribute = utility.end();
        expect(attribute.value, TextAlign.end);
      });

      test('should create attribute with call method', () {
        final attribute = utility(TextAlign.center);
        expect(attribute.value, TextAlign.center);
      });
    });

    group('ImageRepeatUtility', () {
      final utility = ImageRepeatUtility(UtilityTestAttribute.new);

      test('should create attribute with repeat', () {
        final attribute = utility.repeat();
        expect(attribute.value, ImageRepeat.repeat);
      });

      test('should create attribute with repeatX', () {
        final attribute = utility.repeatX();
        expect(attribute.value, ImageRepeat.repeatX);
      });

      test('should create attribute with repeatY', () {
        final attribute = utility.repeatY();
        expect(attribute.value, ImageRepeat.repeatY);
      });

      test('should create attribute with noRepeat', () {
        final attribute = utility.noRepeat();
        expect(attribute.value, ImageRepeat.noRepeat);
      });

      test('should create attribute with default repeat using call', () {
        final attribute = utility();
        expect(attribute.value, ImageRepeat.repeat);
      });

      test('should create attribute with specific value using call', () {
        final attribute = utility(ImageRepeat.noRepeat);
        expect(attribute.value, ImageRepeat.noRepeat);
      });
    });
  });
}