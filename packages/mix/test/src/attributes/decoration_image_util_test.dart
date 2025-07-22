import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Decoration Image Utilities', () {
    group('DecorationImageUtility', () {
      final utility = DecorationImageUtility(UtilityTestAttribute.new);

      test('call() creates DecorationImageMix', () {
        final decorationImageMix = DecorationImageMix.only(
          image: const AssetImage('assets/test.png'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          repeat: ImageRepeat.noRepeat,
          filterQuality: FilterQuality.high,
          invertColors: false,
          isAntiAlias: true,
        );
        final attr = utility(decorationImageMix);
        expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
      });

      test('as() creates DecorationImageMix from DecorationImage', () {
        const decorationImage = DecorationImage(
          image: NetworkImage('https://example.com/image.png'),
          fit: BoxFit.contain,
          alignment: Alignment.topLeft,
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.medium,
          invertColors: true,
          isAntiAlias: false,
        );
        final attr = utility.as(decorationImage);
        expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
      });

      group('Property Utilities', () {
        test('provider() creates decoration image with image provider', () {
          const imageProvider = AssetImage('assets/image.png');
          final attr = utility.provider(imageProvider);
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test(
          'provider.network() creates decoration image with network image',
          () {
            final attr = utility.provider.network(
              'https://example.com/image.png',
            );
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test('provider.asset() creates decoration image with asset image', () {
          final attr = utility.provider.asset('assets/image.png');
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('provider.file() creates decoration image with file image', () {
          final file = File('path/to/image.png');
          final attr = utility.provider.file(file);
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test(
          'provider.memory() creates decoration image with memory image',
          () {
            final bytes = Uint8List.fromList([1, 2, 3, 4]);
            final attr = utility.provider.memory(bytes);
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test('fit() creates decoration image with box fit', () {
          final attr = utility.fit(BoxFit.cover);
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('fit.cover() creates decoration image with cover fit', () {
          final attr = utility.fit.cover();
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('fit.contain() creates decoration image with contain fit', () {
          final attr = utility.fit.contain();
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('fit.fill() creates decoration image with fill fit', () {
          final attr = utility.fit.fill();
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('fit.fitWidth() creates decoration image with fit width', () {
          final attr = utility.fit.fitWidth();
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('fit.fitHeight() creates decoration image with fit height', () {
          final attr = utility.fit.fitHeight();
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('fit.none() creates decoration image with no fit', () {
          final attr = utility.fit.none();
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test(
          'fit.scaleDown() creates decoration image with scale down fit',
          () {
            final attr = utility.fit.scaleDown();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test('alignment() creates decoration image with alignment', () {
          final attr = utility.alignment(Alignment.topRight);
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test(
          'alignment.center() creates decoration image with center alignment',
          () {
            final attr = utility.alignment.center();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test(
          'alignment.topLeft() creates decoration image with top left alignment',
          () {
            final attr = utility.alignment.topLeft();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test(
          'alignment.bottomRight() creates decoration image with bottom right alignment',
          () {
            final attr = utility.alignment.bottomRight();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test('centerSlice() creates decoration image with center slice', () {
          const rect = Rect.fromLTWH(10, 10, 20, 20);
          final attr = utility.centerSlice(rect);
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test(
          'centerSlice.zero() creates decoration image with zero center slice',
          () {
            final attr = utility.centerSlice.zero();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test(
          'centerSlice.largest() creates decoration image with largest center slice',
          () {
            final attr = utility.centerSlice.largest();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test(
          'centerSlice.fromLTRB() creates decoration image with LTRB center slice',
          () {
            final attr = utility.centerSlice.fromLTRB(5, 5, 15, 15);
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test(
          'centerSlice.fromLTWH() creates decoration image with LTWH center slice',
          () {
            final attr = utility.centerSlice.fromLTWH(0, 0, 30, 30);
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test('repeat() creates decoration image with image repeat', () {
          final attr = utility.repeat(ImageRepeat.repeatX);
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('repeat.repeat() creates decoration image with repeat', () {
          final attr = utility.repeat.repeat();
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('repeat.repeatX() creates decoration image with repeat X', () {
          final attr = utility.repeat.repeatX();
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('repeat.repeatY() creates decoration image with repeat Y', () {
          final attr = utility.repeat.repeatY();
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('repeat.noRepeat() creates decoration image with no repeat', () {
          final attr = utility.repeat.noRepeat();
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test(
          'filterQuality() creates decoration image with filter quality',
          () {
            final attr = utility.filterQuality(FilterQuality.high);
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test(
          'filterQuality.none() creates decoration image with no filter quality',
          () {
            final attr = utility.filterQuality.none();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test(
          'filterQuality.low() creates decoration image with low filter quality',
          () {
            final attr = utility.filterQuality.low();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test(
          'filterQuality.medium() creates decoration image with medium filter quality',
          () {
            final attr = utility.filterQuality.medium();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test(
          'filterQuality.high() creates decoration image with high filter quality',
          () {
            final attr = utility.filterQuality.high();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test('invertColors() creates decoration image with invert colors', () {
          final attr = utility.invertColors(true);
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test(
          'invertColors.on() creates decoration image with invert colors on',
          () {
            final attr = utility.invertColors.on();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test(
          'invertColors.off() creates decoration image with invert colors off',
          () {
            final attr = utility.invertColors.off();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test('isAntiAlias() creates decoration image with anti alias', () {
          final attr = utility.isAntiAlias(true);
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test(
          'isAntiAlias.on() creates decoration image with anti alias on',
          () {
            final attr = utility.isAntiAlias.on();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );

        test(
          'isAntiAlias.off() creates decoration image with anti alias off',
          () {
            final attr = utility.isAntiAlias.off();
            expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
          },
        );
      });

      group('Common Image Patterns', () {
        test('creates background image with cover fit', () {
          final attr = utility.provider.network('https://example.com/bg.jpg');
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('creates tiled pattern image', () {
          final attr = utility.provider.asset('assets/pattern.png');
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('creates centered logo image', () {
          final attr = utility.provider.asset('assets/logo.png');
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('creates high quality image', () {
          final attr = utility.filterQuality.high();
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });
      });

      group('Edge Cases', () {
        test('handles very small center slice', () {
          final attr = utility.centerSlice.fromLTWH(0, 0, 1, 1);
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('handles very large center slice', () {
          final attr = utility.centerSlice.fromLTWH(0, 0, 1000, 1000);
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('handles empty byte array for memory image', () {
          final bytes = Uint8List.fromList([]);
          final attr = utility.provider.memory(bytes);
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('handles very long URL for network image', () {
          final longUrl = 'https://example.com/${'a' * 1000}.png';
          final attr = utility.provider.network(longUrl);
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });

        test('handles asset path with special characters', () {
          final attr = utility.provider.asset(
            'assets/image-with_special.chars.png',
          );
          expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
        });
      });

      test('token() creates decoration image from token', () {
        const token = MixToken<DecorationImageMix>('test.decorationImage');
        final attr = utility.token(token);
        expect(attr.value, isA<Prop<Mix<DecorationImage>>>());
      });
    });
  });
}
