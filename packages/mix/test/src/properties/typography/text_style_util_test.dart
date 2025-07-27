import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';
import 'package:mix/src/properties/typography/text_style_util.dart';

void main() {
  group('Text Style Utilities', () {
    group('TextStyleUtility', () {
      final utility = TextStyleUtility(UtilityTestAttribute.new);

      test('call() creates TextStyleMix', () {
        final textStyleMix = TextStyleMix.only(
          color: Colors.red,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        );
        final attr = utility(textStyleMix);
        expect(
          attr.value,
          resolvesTo(
            TextStyle(
              color: Colors.red,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      });

      test('as() creates TextStyleMix from TextStyle', () {
        const textStyle = TextStyle(
          color: Colors.blue,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          decoration: TextDecoration.underline,
        );
        final attr = utility.as(textStyle);
        // The attribute contains a MixProp<TextStyle> with a TextStyleMix
        expect(attr.value, isA<MixProp<TextStyle>>());
        // And it resolves to the original TextStyle (recreate without const for color conversion)
        expect(
          attr.value,
          resolvesTo(
            TextStyle(
              color: Colors.blue,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      });

      group('Property Utilities', () {
        test('color() creates text style with color', () {
          final attr = utility.color(Colors.green);
          expect(attr.value, resolvesTo(TextStyle(color: Colors.green)));
        });

        test('color.red() creates text style with red color', () {
          final attr = utility.color.red();
          expect(attr.value, resolvesTo(TextStyle(color: Colors.red)));
        });

        test('color.blue() creates text style with blue color', () {
          final attr = utility.color.blue();
          expect(attr.value, resolvesTo(TextStyle(color: Colors.blue)));
        });

        test('fontWeight() creates text style with font weight', () {
          final attr = utility.fontWeight(FontWeight.w600);
          expect(
            attr.value,
            resolvesTo(const TextStyle(fontWeight: FontWeight.w600)),
          );
        });

        test('fontWeight.bold() creates text style with bold font weight', () {
          final attr = utility.fontWeight.bold();
          expect(
            attr.value,
            resolvesTo(const TextStyle(fontWeight: FontWeight.bold)),
          );
        });

        test(
          'fontWeight.normal() creates text style with normal font weight',
          () {
            final attr = utility.fontWeight.normal();
            expect(
              attr.value,
              resolvesTo(const TextStyle(fontWeight: FontWeight.normal)),
            );
          },
        );

        test('fontWeight.w100() creates text style with w100 font weight', () {
          final attr = utility.fontWeight.w100();
          expect(
            attr.value,
            resolvesTo(const TextStyle(fontWeight: FontWeight.w100)),
          );
        });

        test('fontWeight.w900() creates text style with w900 font weight', () {
          final attr = utility.fontWeight.w900();
          expect(
            attr.value,
            resolvesTo(const TextStyle(fontWeight: FontWeight.w900)),
          );
        });

        test('fontStyle() creates text style with font style', () {
          final attr = utility.fontStyle(FontStyle.italic);
          expect(
            attr.value,
            resolvesTo(const TextStyle(fontStyle: FontStyle.italic)),
          );
        });

        test(
          'fontStyle.italic() creates text style with italic font style',
          () {
            final attr = utility.fontStyle.italic();
            expect(
              attr.value,
              resolvesTo(const TextStyle(fontStyle: FontStyle.italic)),
            );
          },
        );

        test(
          'fontStyle.normal() creates text style with normal font style',
          () {
            final attr = utility.fontStyle.normal();
            expect(
              attr.value,
              resolvesTo(const TextStyle(fontStyle: FontStyle.normal)),
            );
          },
        );

        test('decoration() creates text style with text decoration', () {
          final attr = utility.decoration(TextDecoration.underline);
          expect(
            attr.value,
            resolvesTo(const TextStyle(decoration: TextDecoration.underline)),
          );
        });

        test(
          'decoration.underline() creates text style with underline decoration',
          () {
            final attr = utility.decoration.underline();
            expect(
              attr.value,
              resolvesTo(const TextStyle(decoration: TextDecoration.underline)),
            );
          },
        );

        test(
          'decoration.overline() creates text style with overline decoration',
          () {
            final attr = utility.decoration.overline();
            expect(
              attr.value,
              resolvesTo(const TextStyle(decoration: TextDecoration.overline)),
            );
          },
        );

        test(
          'decoration.lineThrough() creates text style with line through decoration',
          () {
            final attr = utility.decoration.lineThrough();
            expect(
              attr.value,
              resolvesTo(
                const TextStyle(decoration: TextDecoration.lineThrough),
              ),
            );
          },
        );

        test('decoration.none() creates text style with no decoration', () {
          final attr = utility.decoration.none();
          expect(
            attr.value,
            resolvesTo(const TextStyle(decoration: TextDecoration.none)),
          );
        });

        test('fontSize() creates text style with font size', () {
          final attr = utility.fontSize(20.0);
          expect(attr.value, resolvesTo(const TextStyle(fontSize: 20.0)));
        });

        test('backgroundColor() creates text style with background color', () {
          final attr = utility.backgroundColor(Colors.yellow);
          expect(
            attr.value,
            resolvesTo(TextStyle(backgroundColor: Colors.yellow)),
          );
        });

        test(
          'backgroundColor.yellow() creates text style with yellow background',
          () {
            final attr = utility.backgroundColor.yellow();
            expect(
              attr.value,
              resolvesTo(TextStyle(backgroundColor: Colors.yellow)),
            );
          },
        );

        test('decorationColor() creates text style with decoration color', () {
          final attr = utility.decorationColor(Colors.purple);
          expect(
            attr.value,
            resolvesTo(TextStyle(decorationColor: Colors.purple)),
          );
        });

        test(
          'decorationColor.purple() creates text style with purple decoration color',
          () {
            final attr = utility.decorationColor.purple();
            expect(
              attr.value,
              resolvesTo(TextStyle(decorationColor: Colors.purple)),
            );
          },
        );

        test('decorationStyle() creates text style with decoration style', () {
          final attr = utility.decorationStyle(TextDecorationStyle.dashed);
          expect(
            attr.value,
            resolvesTo(
              const TextStyle(decorationStyle: TextDecorationStyle.dashed),
            ),
          );
        });

        test(
          'decorationStyle.solid() creates text style with solid decoration style',
          () {
            final attr = utility.decorationStyle.solid();
            expect(
              attr.value,
              resolvesTo(
                const TextStyle(decorationStyle: TextDecorationStyle.solid),
              ),
            );
          },
        );

        test(
          'decorationStyle.double() creates text style with double decoration style',
          () {
            final attr = utility.decorationStyle.double();
            expect(
              attr.value,
              resolvesTo(
                const TextStyle(decorationStyle: TextDecorationStyle.double),
              ),
            );
          },
        );

        test(
          'decorationStyle.dotted() creates text style with dotted decoration style',
          () {
            final attr = utility.decorationStyle.dotted();
            expect(
              attr.value,
              resolvesTo(
                const TextStyle(decorationStyle: TextDecorationStyle.dotted),
              ),
            );
          },
        );

        test(
          'decorationStyle.dashed() creates text style with dashed decoration style',
          () {
            final attr = utility.decorationStyle.dashed();
            expect(
              attr.value,
              resolvesTo(
                const TextStyle(decorationStyle: TextDecorationStyle.dashed),
              ),
            );
          },
        );

        test(
          'decorationStyle.wavy() creates text style with wavy decoration style',
          () {
            final attr = utility.decorationStyle.wavy();
            expect(
              attr.value,
              resolvesTo(
                const TextStyle(decorationStyle: TextDecorationStyle.wavy),
              ),
            );
          },
        );

        test('textBaseline() creates text style with text baseline', () {
          final attr = utility.textBaseline(TextBaseline.alphabetic);
          expect(
            attr.value,
            resolvesTo(const TextStyle(textBaseline: TextBaseline.alphabetic)),
          );
        });

        test(
          'textBaseline.alphabetic() creates text style with alphabetic baseline',
          () {
            final attr = utility.textBaseline.alphabetic();
            expect(
              attr.value,
              resolvesTo(
                const TextStyle(textBaseline: TextBaseline.alphabetic),
              ),
            );
          },
        );

        test(
          'textBaseline.ideographic() creates text style with ideographic baseline',
          () {
            final attr = utility.textBaseline.ideographic();
            expect(
              attr.value,
              resolvesTo(
                const TextStyle(textBaseline: TextBaseline.ideographic),
              ),
            );
          },
        );

        test('fontFamily() creates text style with font family', () {
          final attr = utility.fontFamily('Roboto');
          expect(attr.value, resolvesTo(const TextStyle(fontFamily: 'Roboto')));
        });
      });

      group('Direct Methods', () {
        test('height() creates text style with height', () {
          final attr = utility.height(1.5);
          expect(attr.value, resolvesTo(const TextStyle(height: 1.5)));
        });

        test('wordSpacing() creates text style with word spacing', () {
          final attr = utility.wordSpacing(2.0);
          expect(attr.value, resolvesTo(const TextStyle(wordSpacing: 2.0)));
        });

        test('letterSpacing() creates text style with letter spacing', () {
          final attr = utility.letterSpacing(1.2);
          expect(attr.value, resolvesTo(const TextStyle(letterSpacing: 1.2)));
        });

        test('fontVariations() creates text style with font variations', () {
          final variations = [const FontVariation('wght', 400)];
          final attr = utility.fontVariations(variations);
          expect(attr.value, resolvesTo(TextStyle(fontVariations: variations)));
        });

        test(
          'fontVariation() creates text style with single font variation',
          () {
            const variation = FontVariation('wght', 600);
            final attr = utility.fontVariation(variation);
            expect(
              attr.value,
              resolvesTo(const TextStyle(fontVariations: [variation])),
            );
          },
        );

        test('shadows() creates text style with shadows', () {
          const shadows = [
            Shadow(color: Colors.black, blurRadius: 2.0, offset: Offset(1, 1)),
          ];
          final attr = utility.shadows(shadows);
          expect(attr.value, resolvesTo(TextStyle(shadows: shadows)));
        });

        test('italic() creates text style with italic font style', () {
          final attr = utility.italic();
          expect(
            attr.value,
            resolvesTo(const TextStyle(fontStyle: FontStyle.italic)),
          );
        });

        test('bold() creates text style with bold font weight', () {
          final attr = utility.bold();
          expect(
            attr.value,
            resolvesTo(const TextStyle(fontWeight: FontWeight.bold)),
          );
        });

        test('foreground() creates text style with foreground paint', () {
          final paint = Paint()..color = Colors.red;
          final attr = utility.foreground(paint);

          // Resolve and test specific properties as per testing guide
          final context = MockBuildContext();
          final resolved = attr.value.resolve(context);
          expect(resolved.foreground?.color, paint.color);
        });

        test('background() creates text style with background paint', () {
          final paint = Paint()..color = Colors.blue;
          final attr = utility.background(paint);

          // Resolve and test specific properties as per testing guide
          final context = MockBuildContext();
          final resolved = attr.value.resolve(context);
          expect(resolved.background?.color, paint.color);
        });

        test('fontFeatures() creates text style with font features', () {
          const features = [FontFeature.enable('liga')];
          final attr = utility.fontFeatures(features);
          expect(attr.value, resolvesTo(TextStyle(fontFeatures: features)));
        });

        test('debugLabel() creates text style with debug label', () {
          final attr = utility.debugLabel('test-label');
          expect(
            attr.value,
            resolvesTo(const TextStyle(debugLabel: 'test-label')),
          );
        });

        test(
          'decorationThickness() creates text style with decoration thickness',
          () {
            final attr = utility.decorationThickness(2.0);
            expect(
              attr.value,
              resolvesTo(const TextStyle(decorationThickness: 2.0)),
            );
          },
        );

        test(
          'fontFamilyFallback() creates text style with font family fallback',
          () {
            final fallback = ['Arial', 'sans-serif'];
            final attr = utility.fontFamilyFallback(fallback);
            expect(
              attr.value,
              resolvesTo(TextStyle(fontFamilyFallback: fallback)),
            );
          },
        );
      });

      group('Edge Cases', () {
        test('handles zero font size', () {
          final attr = utility.fontSize(0.0);
          expect(attr.value, resolvesTo(const TextStyle(fontSize: 0.0)));
        });

        test('handles very large font size', () {
          final attr = utility.fontSize(100.0);
          expect(attr.value, resolvesTo(const TextStyle(fontSize: 100.0)));
        });

        test('handles negative letter spacing', () {
          final attr = utility.letterSpacing(-1.0);
          expect(attr.value, resolvesTo(const TextStyle(letterSpacing: -1.0)));
        });

        test('handles zero height', () {
          final attr = utility.height(0.0);
          expect(attr.value, resolvesTo(const TextStyle(height: 0.0)));
        });

        test('handles very large height', () {
          final attr = utility.height(10.0);
          expect(attr.value, resolvesTo(const TextStyle(height: 10.0)));
        });

        test('handles empty font family fallback', () {
          final attr = utility.fontFamilyFallback([]);
          expect(
            attr.value,
            resolvesTo(const TextStyle(fontFamilyFallback: [])),
          );
        });

        test('handles empty font variations', () {
          final attr = utility.fontVariations([]);
          expect(attr.value, resolvesTo(const TextStyle(fontVariations: [])));
        });

        test('handles empty shadows', () {
          final attr = utility.shadows([]);
          expect(attr.value, resolvesTo(const TextStyle(shadows: [])));
        });

        test('handles empty font features', () {
          final attr = utility.fontFeatures([]);
          expect(attr.value, resolvesTo(const TextStyle(fontFeatures: [])));
        });
      });

      test('token() creates text style from token', () {
        const token = MixToken<TextStyle>('test.textStyle');
        final attr = utility.token(token);
        // For tokens, we verify the prop contains the token
        expectProp(attr.value, token);
      });
    });
  });
}
