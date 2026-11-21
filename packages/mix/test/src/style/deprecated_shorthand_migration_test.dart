// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

double? _asDouble(double? value) => value;

Color? _asColor(Color? value) => value;

BoxShadowMix _shadowOf(BoxStyler style) {
  final decoration =
      (style.$decoration!.sources.single as MixSource<Decoration>).mix
          as DecorationMix<BoxDecoration>;
  final shadows =
      (decoration.$boxShadow!.sources.single as MixSource<List<BoxShadow>>).mix
          as BoxShadowListMix;

  return shadows.items.single;
}

void main() {
  final context = MockBuildContext();

  EdgeInsets paddingOf(BoxStyler style, TextDirection direction) {
    final geometry = style.$padding!.resolveProp(context);
    return geometry.resolve(direction);
  }

  EdgeInsets marginOf(BoxStyler style, TextDirection direction) {
    final geometry = style.$margin!.resolveProp(context);
    return geometry.resolve(direction);
  }

  BoxConstraints constraintsOf(BoxStyler style) {
    return style.$constraints!.resolveProp(context);
  }

  BoxDecoration decorationOf(BoxStyler style) {
    return style.$decoration!.resolveProp(context) as BoxDecoration;
  }

  group('paddingOnly and marginOnly migrations', () {
    final cases =
        <
          ({
            String name,
            double? horizontal,
            double? vertical,
            double? start,
            double? end,
            double? left,
            double? right,
            double? top,
            double? bottom,
            BoxStyler Function() migratedPadding,
            BoxStyler Function() migratedMargin,
          })
        >[
          (
            name: 'horizontal plus explicit left',
            horizontal: 16,
            vertical: null,
            start: null,
            end: null,
            left: 4,
            right: null,
            top: null,
            bottom: null,
            migratedPadding: () => BoxStyler().padding(.horizontal(16).left(4)),
            migratedMargin: () => BoxStyler().margin(.horizontal(16).left(4)),
          ),
          (
            name: 'vertical plus explicit top and bottom',
            horizontal: null,
            vertical: 12,
            start: null,
            end: null,
            left: null,
            right: null,
            top: 2,
            bottom: 6,
            migratedPadding: () =>
                BoxStyler().padding(.vertical(12).top(2).bottom(6)),
            migratedMargin: () =>
                BoxStyler().margin(.vertical(12).top(2).bottom(6)),
          ),
          (
            name: 'start and end',
            horizontal: null,
            vertical: null,
            start: 4,
            end: 16,
            left: null,
            right: null,
            top: null,
            bottom: null,
            migratedPadding: () => BoxStyler().padding(.start(4).end(16)),
            migratedMargin: () => BoxStyler().margin(.start(4).end(16)),
          ),
          (
            name: 'horizontal fallback with start override',
            horizontal: 16,
            vertical: 8,
            start: 4,
            end: null,
            left: null,
            right: null,
            top: null,
            bottom: null,
            migratedPadding: () => BoxStyler().padding(
              .directional(start: 4, end: 16, top: 8, bottom: 8),
            ),
            migratedMargin: () => BoxStyler().margin(
              .directional(start: 4, end: 16, top: 8, bottom: 8),
            ),
          ),
          (
            name: 'omitted values',
            horizontal: null,
            vertical: null,
            start: null,
            end: null,
            left: null,
            right: null,
            top: null,
            bottom: null,
            migratedPadding: () => BoxStyler().padding(.only()),
            migratedMargin: () => BoxStyler().margin(.only()),
          ),
        ];

    for (final item in cases) {
      for (final direction in TextDirection.values) {
        test('${item.name} padding matches in $direction', () {
          final legacy = BoxStyler().paddingOnly(
            horizontal: item.horizontal,
            vertical: item.vertical,
            start: item.start,
            end: item.end,
            left: item.left,
            right: item.right,
            top: item.top,
            bottom: item.bottom,
          );
          expect(
            paddingOf(item.migratedPadding(), direction),
            paddingOf(legacy, direction),
          );
        });

        test('${item.name} margin matches in $direction', () {
          final legacy = BoxStyler().marginOnly(
            horizontal: item.horizontal,
            vertical: item.vertical,
            start: item.start,
            end: item.end,
            left: item.left,
            right: item.right,
            top: item.top,
            bottom: item.bottom,
          );
          expect(
            marginOf(item.migratedMargin(), direction),
            marginOf(legacy, direction),
          );
        });
      }
    }

    test('reversed horizontal chain is not equivalent', () {
      final legacy = BoxStyler().paddingOnly(horizontal: 16, left: 4);
      final reversed = BoxStyler().padding(.left(4).horizontal(16));
      expect(paddingOf(reversed, .ltr), isNot(paddingOf(legacy, .ltr)));
    });

    test('reversed vertical chain is not equivalent', () {
      final legacy = BoxStyler().marginOnly(vertical: 12, top: 2);
      final reversed = BoxStyler().margin(.top(2).vertical(12));
      expect(marginOf(reversed, .ltr), isNot(marginOf(legacy, .ltr)));
    });

    test('physical left does not flip in RTL', () {
      final legacy = BoxStyler().paddingOnly(horizontal: 16, left: 4);
      final migrated = BoxStyler().padding(.horizontal(16).left(4));
      expect(paddingOf(migrated, .rtl), paddingOf(legacy, .rtl));
      expect(paddingOf(migrated, .rtl).left, 4);
      expect(paddingOf(migrated, .rtl).right, 16);
    });

    test('start and end flip in RTL', () {
      final migrated = BoxStyler().padding(.start(4).end(16));
      expect(
        paddingOf(migrated, .ltr),
        const EdgeInsets.only(left: 4, right: 16),
      );
      expect(
        paddingOf(migrated, .rtl),
        const EdgeInsets.only(left: 16, right: 4),
      );
    });
  });

  group('constraintsOnly migration', () {
    test('width then minWidth keeps the max from width', () {
      final legacy = BoxStyler().constraintsOnly(width: 200, minWidth: 100);
      final migrated = BoxStyler().width(200).minWidth(100);
      expect(constraintsOf(migrated), constraintsOf(legacy));
      expect(constraintsOf(migrated).minWidth, 100);
      expect(constraintsOf(migrated).maxWidth, 200);
    });

    test('width then maxWidth keeps the min from width', () {
      final legacy = BoxStyler().constraintsOnly(width: 200, maxWidth: 320);
      final migrated = BoxStyler().width(200).maxWidth(320);
      expect(constraintsOf(migrated), constraintsOf(legacy));
    });

    test('height then minHeight and maxHeight', () {
      final legacy = BoxStyler().constraintsOnly(
        height: 80,
        minHeight: 40,
        maxHeight: 300,
      );
      final migrated = BoxStyler().height(80).minHeight(40).maxHeight(300);
      expect(constraintsOf(migrated), constraintsOf(legacy));
    });

    BoxStyler migratedConstraints({
      double? width,
      double? height,
      double? minWidth,
      double? maxWidth,
      double? minHeight,
      double? maxHeight,
    }) {
      return BoxStyler().constraints(
        BoxConstraintsMix(
          minWidth: minWidth ?? width,
          maxWidth: maxWidth ?? width,
          minHeight: minHeight ?? height,
          maxHeight: maxHeight ?? height,
        ),
      );
    }

    test('nullable width and maxWidth keep independent fallbacks', () {
      final width = _asDouble(200);
      final maxWidth = _asDouble(320);
      final legacy = BoxStyler().constraintsOnly(
        width: width,
        maxWidth: maxWidth,
      );
      expect(
        constraintsOf(migratedConstraints(width: width, maxWidth: maxWidth)),
        constraintsOf(legacy),
      );
      expect(constraintsOf(legacy).minWidth, 200);
      expect(constraintsOf(legacy).maxWidth, 320);
    });

    test('nullable height and minHeight keep independent fallbacks', () {
      final height = _asDouble(80);
      final minHeight = _asDouble(40);
      final legacy = BoxStyler().constraintsOnly(
        height: height,
        minHeight: minHeight,
      );
      expect(
        constraintsOf(
          migratedConstraints(height: height, minHeight: minHeight),
        ),
        constraintsOf(legacy),
      );
      expect(constraintsOf(legacy).minHeight, 40);
      expect(constraintsOf(legacy).maxHeight, 80);
    });
  });

  group('border helper migrations', () {
    const color = Colors.red;
    const width = 2.0;

    test('uniform chain matches borderAll', () {
      const borderStyle = BorderStyle.none;
      const align = BorderSide.strokeAlignOutside;
      final legacy = BoxStyler().borderAll(
        color: color,
        width: width,
        style: borderStyle,
        strokeAlign: align,
      );
      final migrated = BoxStyler().border(
        .color(color).width(width).style(borderStyle).strokeAlign(align),
      );
      expect(decorationOf(migrated).border, decorationOf(legacy).border);
    });

    test('side chain matches borderTop', () {
      const borderStyle = BorderStyle.none;
      const align = BorderSide.strokeAlignOutside;
      final legacy = BoxStyler().borderTop(
        color: color,
        width: width,
        style: borderStyle,
        strokeAlign: align,
      );
      final migrated = BoxStyler().border(
        .top(.color(color).width(width).style(borderStyle).strokeAlign(align)),
      );
      expect(decorationOf(migrated).border, decorationOf(legacy).border);
    });

    test('nullable side uses BorderSideMix', () {
      final sideColor = _asColor(Colors.blue);
      final sideWidth = _asDouble(null);
      final sideStyle = BorderStyle.none;
      final sideAlign = _asDouble(BorderSide.strokeAlignInside);
      final legacy = BoxStyler().borderTop(
        color: sideColor,
        width: sideWidth,
        style: sideStyle,
        strokeAlign: sideAlign,
      );
      final migrated = BoxStyler().border(
        .top(
          BorderSideMix(
            color: sideColor,
            width: sideWidth,
            style: sideStyle,
            strokeAlign: sideAlign,
          ),
        ),
      );
      expect(decorationOf(migrated).border, decorationOf(legacy).border);
    });

    test('reusable side matches borderAll', () {
      final sharedSide = BorderSideMix(color: color, width: width);
      final legacy = BoxStyler().borderAll(color: color, width: width);
      final migrated = BoxStyler().border(.all(sharedSide));
      expect(decorationOf(migrated).border, decorationOf(legacy).border);
    });
  });

  group('shadowOnly migration', () {
    test('known fields match the shadow chain', () {
      const color = Colors.black54;
      const offset = Offset(2, 4);
      const blurRadius = 6.0;
      const spreadRadius = 1.0;
      final legacy = BoxStyler().shadowOnly(
        color: color,
        offset: offset,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      );
      final migrated = BoxStyler().shadow(
        .color(color)
            .offset(x: offset.dx, y: offset.dy)
            .blurRadius(blurRadius)
            .spreadRadius(spreadRadius),
      );
      expect(decorationOf(migrated).boxShadow, decorationOf(legacy).boxShadow);
    });

    test('omitted offset is an unset prop on both shadows', () {
      final legacy = BoxStyler().shadowOnly(color: Colors.black, blurRadius: 4);
      final migrated = BoxStyler().shadow(
        BoxShadowMix(color: Colors.black, blurRadius: 4),
      );
      expect(_shadowOf(legacy).$offset, isNull);
      expect(_shadowOf(migrated).$offset, isNull);
      expect(_shadowOf(migrated).$color, isNotNull);
      expect(_shadowOf(migrated).$blurRadius, isNotNull);
    });
  });

  group('transformReset migration', () {
    test('identity matrix and default center alignment', () {
      final legacy = BoxStyler().transformReset();
      final migrated = BoxStyler().transform(.identity());
      expect(migrated.$transform!.resolveProp(context), Matrix4.identity());
      expect(legacy.$transform!.resolveProp(context), Matrix4.identity());
      expect(migrated.$transformAlignment, resolvesTo(Alignment.center));
      expect(legacy.$transformAlignment, resolvesTo(Alignment.center));
    });
  });
}
