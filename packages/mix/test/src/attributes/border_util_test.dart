import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Border Utilities', () {
    group('BorderSideUtility', () {
      final utility = BorderSideUtility(UtilityTestAttribute.new);

      test('call() creates BorderSideMix', () {
        final borderSideMix = BorderSideMix.only(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
        );
        final attr = utility(borderSideMix);
        expect(attr.value, isA<MixProp<BorderSide>>());
      });

      test('as() creates BorderSideMix from BorderSide', () {
        const borderSide = BorderSide(
          color: Colors.blue,
          width: 3.0,
          style: BorderStyle.solid,
        );
        final attr = utility.as(borderSide);
        expect(attr.value, isA<MixProp<BorderSide>>());
      });

      test('none() creates BorderSide.none', () {
        final attr = utility.none();
        expect(attr.value, isA<MixProp<BorderSide>>());
      });

      test('only() creates BorderSideMix with specified properties', () {
        final attr = utility.only(
          color: Colors.green,
          width: 1.5,
          style: BorderStyle.solid,
          strokeAlign: 0.5,
        );
        expect(attr.value, isA<MixProp<BorderSide>>());
      });

      group('Property Utilities', () {
        test('color() creates border side with color', () {
          final attr = utility.color(Colors.purple);
          expect(attr.value, isA<MixProp<BorderSide>>());
        });

        test('color.red() creates border side with red color', () {
          final attr = utility.color.red();
          expect(attr.value, isA<MixProp<BorderSide>>());
        });

        test('width() creates border side with width', () {
          final attr = utility.width(4.0);
          expect(attr.value, isA<MixProp<BorderSide>>());
        });

        test('width.zero() creates border side with zero width', () {
          final attr = utility.width.zero();
          expect(attr.value, isA<MixProp<BorderSide>>());
        });

        test('style() creates border side with style', () {
          final attr = utility.style(BorderStyle.solid);
          expect(attr.value, isA<MixProp<BorderSide>>());
        });

        test('style.solid() creates border side with solid style', () {
          final attr = utility.style.solid();
          expect(attr.value, isA<MixProp<BorderSide>>());
        });

        test('style.none() creates border side with none style', () {
          final attr = utility.style.none();
          expect(attr.value, isA<MixProp<BorderSide>>());
        });

        test('strokeAlign() creates border side with stroke align', () {
          final attr = utility.strokeAlign(0.8);
          expect(attr.value, isA<MixProp<BorderSide>>());
        });

        test('strokeAlign.inside() creates border side with inside stroke align', () {
          final attr = utility.strokeAlign.inside();
          expect(attr.value, isA<MixProp<BorderSide>>());
        });

        test('strokeAlign.center() creates border side with center stroke align', () {
          final attr = utility.strokeAlign.center();
          expect(attr.value, isA<MixProp<BorderSide>>());
        });

        test('strokeAlign.outside() creates border side with outside stroke align', () {
          final attr = utility.strokeAlign.outside();
          expect(attr.value, isA<MixProp<BorderSide>>());
        });
      });

      test('token() creates border side from token', () {
        const token = MixToken<BorderSide>('test.borderSide');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<BorderSide>>());
      });
    });

    group('BorderUtility', () {
      final utility = BorderUtility(UtilityTestAttribute.new);

      test('call() creates BorderMix', () {
        final borderMix = BorderMix.only(
          top: BorderSideMix.only(color: Colors.red, width: 1.0),
          bottom: BorderSideMix.only(color: Colors.blue, width: 2.0),
        );
        final attr = utility(borderMix);
        expect(attr.value, isA<MixProp<Border>>());
      });

      test('as() creates BorderMix from Border', () {
        const border = Border(
          top: BorderSide(color: Colors.red, width: 1.0),
          bottom: BorderSide(color: Colors.blue, width: 2.0),
        );
        final attr = utility.as(border);
        expect(attr.value, isA<MixProp<Border>>());
      });

      test('none() creates Border.none', () {
        final attr = utility.none();
        expect(attr.value, isA<MixProp<Border>>());
      });

      test('only() creates BorderMix with specified sides', () {
        final attr = utility.only(
          top: BorderSideMix.only(color: Colors.red, width: 1.0),
          bottom: BorderSideMix.only(color: Colors.blue, width: 2.0),
          left: BorderSideMix.only(color: Colors.green, width: 3.0),
          right: BorderSideMix.only(color: Colors.yellow, width: 4.0),
        );
        expect(attr.value, isA<MixProp<Border>>());
      });

      group('Side Utilities', () {
        test('all() creates border with all sides', () {
          final attr = utility.all(BorderSideMix.only(color: Colors.black, width: 2.0));
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('all.color() creates border with all sides colored', () {
          final attr = utility.all.color(Colors.orange);
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('all.width() creates border with all sides width', () {
          final attr = utility.all.width(3.0);
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('top() creates border with top side', () {
          final attr = utility.top(BorderSideMix.only(color: Colors.red, width: 1.0));
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('top.color() creates border with top side colored', () {
          final attr = utility.top.color(Colors.red);
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('bottom() creates border with bottom side', () {
          final attr = utility.bottom(BorderSideMix.only(color: Colors.blue, width: 2.0));
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('bottom.width() creates border with bottom side width', () {
          final attr = utility.bottom.width(2.0);
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('left() creates border with left side', () {
          final attr = utility.left(BorderSideMix.only(color: Colors.green, width: 3.0));
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('left.style() creates border with left side style', () {
          final attr = utility.left.style.solid();
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('right() creates border with right side', () {
          final attr = utility.right(BorderSideMix.only(color: Colors.yellow, width: 4.0));
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('right.strokeAlign() creates border with right side stroke align', () {
          final attr = utility.right.strokeAlign.center();
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('vertical() creates border with top and bottom sides', () {
          final attr = utility.vertical(BorderSideMix.only(color: Colors.purple, width: 1.5));
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('vertical.color() creates border with vertical sides colored', () {
          final attr = utility.vertical.color(Colors.purple);
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('horizontal() creates border with left and right sides', () {
          final attr = utility.horizontal(BorderSideMix.only(color: Colors.cyan, width: 2.5));
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('horizontal.width() creates border with horizontal sides width', () {
          final attr = utility.horizontal.width(2.5);
          expect(attr.value, isA<MixProp<Border>>());
        });
      });

      group('Global Properties', () {
        test('color() creates border with all sides colored', () {
          final attr = utility.color(Colors.teal);
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('width() creates border with all sides width', () {
          final attr = utility.width(1.8);
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('style() creates border with all sides style', () {
          final attr = utility.style(BorderStyle.solid);
          expect(attr.value, isA<MixProp<Border>>());
        });

        test('strokeAlign() creates border with all sides stroke align', () {
          final attr = utility.strokeAlign(0.6);
          expect(attr.value, isA<MixProp<Border>>());
        });
      });

      test('token() creates border from token', () {
        const token = MixToken<Border>('test.border');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<Border>>());
      });
    });

    group('BorderDirectionalUtility', () {
      final utility = BorderDirectionalUtility(UtilityTestAttribute.new);

      test('call() creates BorderDirectionalMix', () {
        final borderMix = BorderDirectionalMix.only(
          top: BorderSideMix.only(color: Colors.red, width: 1.0),
          start: BorderSideMix.only(color: Colors.blue, width: 2.0),
        );
        final attr = utility(borderMix);
        expect(attr.value, isA<MixProp<BorderDirectional>>());
      });

      test('as() creates BorderDirectionalMix from BorderDirectional', () {
        const border = BorderDirectional(
          top: BorderSide(color: Colors.red, width: 1.0),
          start: BorderSide(color: Colors.blue, width: 2.0),
        );
        final attr = utility.as(border);
        expect(attr.value, isA<MixProp<BorderDirectional>>());
      });

      test('none() creates BorderDirectional.none', () {
        final attr = utility.none();
        expect(attr.value, isA<MixProp<BorderDirectional>>());
      });

      test('only() creates BorderDirectionalMix with specified sides', () {
        final attr = utility.only(
          top: BorderSideMix.only(color: Colors.red, width: 1.0),
          bottom: BorderSideMix.only(color: Colors.blue, width: 2.0),
          start: BorderSideMix.only(color: Colors.green, width: 3.0),
          end: BorderSideMix.only(color: Colors.yellow, width: 4.0),
        );
        expect(attr.value, isA<MixProp<BorderDirectional>>());
      });

      group('Side Utilities', () {
        test('all() creates border with all sides', () {
          final attr = utility.all(BorderSideMix.only(color: Colors.black, width: 2.0));
          expect(attr.value, isA<MixProp<BorderDirectional>>());
        });

        test('top() creates border with top side', () {
          final attr = utility.top(BorderSideMix.only(color: Colors.red, width: 1.0));
          expect(attr.value, isA<MixProp<BorderDirectional>>());
        });

        test('bottom() creates border with bottom side', () {
          final attr = utility.bottom(BorderSideMix.only(color: Colors.blue, width: 2.0));
          expect(attr.value, isA<MixProp<BorderDirectional>>());
        });

        test('start() creates border with start side', () {
          final attr = utility.start(BorderSideMix.only(color: Colors.green, width: 3.0));
          expect(attr.value, isA<MixProp<BorderDirectional>>());
        });

        test('end() creates border with end side', () {
          final attr = utility.end(BorderSideMix.only(color: Colors.yellow, width: 4.0));
          expect(attr.value, isA<MixProp<BorderDirectional>>());
        });

        test('vertical() creates border with top and bottom sides', () {
          final attr = utility.vertical(BorderSideMix.only(color: Colors.purple, width: 1.5));
          expect(attr.value, isA<MixProp<BorderDirectional>>());
        });

        test('horizontal() creates border with start and end sides', () {
          final attr = utility.horizontal(BorderSideMix.only(color: Colors.cyan, width: 2.5));
          expect(attr.value, isA<MixProp<BorderDirectional>>());
        });
      });

      test('token() creates border directional from token', () {
        const token = MixToken<BorderDirectional>('test.borderDirectional');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<BorderDirectional>>());
      });
    });

    group('BoxBorderUtility', () {
      final utility = BoxBorderUtility(UtilityTestAttribute.new);

      test('call() creates BoxBorderMix from BorderMix', () {
        final borderMix = BorderMix.only(
          top: BorderSideMix.only(color: Colors.red, width: 1.0),
        );
        final attr = utility(borderMix);
        expect(attr.value, isA<MixProp<BoxBorder>>());
      });

      test('call() creates BoxBorderMix from BorderDirectionalMix', () {
        final borderMix = BorderDirectionalMix.only(
          start: BorderSideMix.only(color: Colors.blue, width: 2.0),
        );
        final attr = utility(borderMix);
        expect(attr.value, isA<MixProp<BoxBorder>>());
      });

      test('as() creates BoxBorderMix from Border', () {
        const border = Border(
          top: BorderSide(color: Colors.red, width: 1.0),
        );
        final attr = utility.as(border);
        expect(attr.value, isA<MixProp<BoxBorder>>());
      });

      test('as() creates BoxBorderMix from BorderDirectional', () {
        const border = BorderDirectional(
          start: BorderSide(color: Colors.blue, width: 2.0),
        );
        final attr = utility.as(border);
        expect(attr.value, isA<MixProp<BoxBorder>>());
      });

      test('only() creates BoxBorderMix with specified sides', () {
        final attr = utility.only(
          top: BorderSideMix.only(color: Colors.red, width: 1.0),
          bottom: BorderSideMix.only(color: Colors.blue, width: 2.0),
          left: BorderSideMix.only(color: Colors.green, width: 3.0),
          right: BorderSideMix.only(color: Colors.yellow, width: 4.0),
        );
        expect(attr.value, isA<MixProp<BoxBorder>>());
      });

      group('Delegated Properties', () {
        test('all() creates box border with all sides', () {
          final attr = utility.all(BorderSideMix.only(color: Colors.black, width: 2.0));
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('top() creates box border with top side', () {
          final attr = utility.top(BorderSideMix.only(color: Colors.red, width: 1.0));
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('bottom() creates box border with bottom side', () {
          final attr = utility.bottom(BorderSideMix.only(color: Colors.blue, width: 2.0));
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('left() creates box border with left side', () {
          final attr = utility.left(BorderSideMix.only(color: Colors.green, width: 3.0));
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('right() creates box border with right side', () {
          final attr = utility.right(BorderSideMix.only(color: Colors.yellow, width: 4.0));
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('start() creates box border with start side', () {
          final attr = utility.start(BorderSideMix.only(color: Colors.purple, width: 1.5));
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('end() creates box border with end side', () {
          final attr = utility.end(BorderSideMix.only(color: Colors.cyan, width: 2.5));
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('horizontal() creates box border with horizontal sides', () {
          final attr = utility.horizontal(BorderSideMix.only(color: Colors.orange, width: 1.8));
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('vertical() creates box border with vertical sides', () {
          final attr = utility.vertical(BorderSideMix.only(color: Colors.pink, width: 2.2));
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('color() creates box border with all sides colored', () {
          final attr = utility.color(Colors.teal);
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('width() creates box border with all sides width', () {
          final attr = utility.width(1.8);
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('style() creates box border with all sides style', () {
          final attr = utility.style(BorderStyle.solid);
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('strokeAlign() creates box border with all sides stroke align', () {
          final attr = utility.strokeAlign(0.6);
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });

        test('none() creates box border with no sides', () {
          final attr = utility.none();
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });
      });

      group('Directional Properties', () {
        test('directional() provides access to BorderDirectionalUtility', () {
          final attr = utility.directional.start(BorderSideMix.only(color: Colors.red, width: 1.0));
          expect(attr.value, isA<MixProp<BoxBorder>>());
        });
      });

      test('token() creates box border from token', () {
        const token = MixToken<BoxBorder>('test.boxBorder');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<BoxBorder>>());
      });
    });
  });
}
