import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

/// Canonical-payload round-trip tests for every styler branch. The reference
/// property: for a representative styler, encoding to wire then decoding
/// preserves the styler and re-encoding reproduces the wire byte-for-byte. This
/// pins encode/decode symmetry per branch so future codec consolidation cannot
/// silently change the wire output.
///
/// The existing per-styler tests already assert the exact encode snapshot; these
/// add decode-side symmetry and metadata fidelity for every built-in branch.
void main() {
  const icon = IconData(0xe88a, fontFamily: 'MaterialIcons');
  final image = MemoryImage(Uint8List.fromList([0, 1, 2, 3]));

  final contract =
      (MixSchemaContractBuilder()
            ..registry.iconData('home', icon)
            ..registry.imageProvider('pixels', image))
          .builtIn()
          .freeze();

  JsonMap encode(Object styler) {
    final result = contract.encode(styler);
    return switch (result) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };
  }

  T decode<T extends Object>(JsonMap payload) {
    final result = contract.decode<T>(payload);
    return switch (result) {
      MixSchemaDecodeSuccess<T>(:final value) => value,
      MixSchemaDecodeFailure<T>(:final errors) => fail('$errors'),
    };
  }

  void expectRoundTrips<T extends Object>(T styler) {
    final canonical = encode(styler);
    // Decoding the canonical wire must reconstruct the original styler with no
    // silent field loss — wire idempotence alone would pass even if encode
    // dropped a set field, so assert styler fidelity too.
    expect(decode<T>(canonical), styler);
    // And re-encoding the decoded styler is the identity on canonical wire.
    expect(encode(decode<T>(canonical)), canonical);
  }

  WidgetModifierConfig testModifier() {
    return WidgetModifierConfig.modifiers([OpacityModifierMix(opacity: 0.5)]);
  }

  CurveAnimationConfig testAnimation() {
    return CurveAnimationConfig.easeInOut(
      const Duration(milliseconds: 120),
      delay: const Duration(milliseconds: 10),
    );
  }

  test('BoxStyler round-trips through canonical wire with field fidelity', () {
    expectRoundTrips<BoxStyler>(
      BoxStyler(
        alignment: Alignment.center,
        padding: EdgeInsetsMix(top: 8),
        decoration: BoxDecorationMix(color: const Color(0xCC336699)),
        clipBehavior: Clip.hardEdge,
      ),
    );
  });

  test('TextStyler round-trips through canonical wire with field fidelity', () {
    expectRoundTrips<TextStyler>(
      TextStyler(
        textAlign: TextAlign.end,
        softWrap: false,
        selectionColor: const Color(0x800000FF),
        style: TextStyleMix(
          color: const Color(0xFF112233),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  });

  test('FlexStyler round-trips through canonical wire with field fidelity', () {
    expectRoundTrips<FlexStyler>(
      FlexStyler(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        clipBehavior: Clip.hardEdge,
      ),
    );
  });

  test(
    'StackStyler round-trips through canonical wire with field fidelity',
    () {
      expectRoundTrips<StackStyler>(
        StackStyler(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.antiAlias,
        ),
      );
    },
  );

  test('IconStyler round-trips through canonical wire with field fidelity', () {
    expectRoundTrips<IconStyler>(
      IconStyler(
        icon: icon,
        color: const Color(0xFF112233),
        size: 24,
        blendMode: BlendMode.srcIn,
      ),
    );
  });

  test(
    'ImageStyler round-trips through canonical wire with field fidelity',
    () {
      expectRoundTrips<ImageStyler>(
        ImageStyler(
          image: image as ImageProvider<Object>,
          width: 64,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      );
    },
  );

  test(
    'FlexBoxStyler round-trips through canonical wire with field fidelity',
    () {
      expectRoundTrips<FlexBoxStyler>(
        FlexBoxStyler(
          padding: EdgeInsetsMix.all(8),
          decoration: BoxDecorationMix(color: const Color(0xFF112233)),
          direction: Axis.vertical,
          spacing: 4,
          flexClipBehavior: Clip.hardEdge,
        ),
      );
    },
  );

  test(
    'StackBoxStyler round-trips through canonical wire with field fidelity',
    () {
      expectRoundTrips<StackBoxStyler>(
        StackBoxStyler(
          margin: EdgeInsetsMix(top: 4),
          stackAlignment: Alignment.center,
          fit: StackFit.passthrough,
          stackClipBehavior: Clip.none,
        ),
      );
    },
  );

  test(
    'BoxStyler preserves variants, modifiers, and animation across wire',
    () {
      expectRoundTrips<BoxStyler>(
        BoxStyler(
          variants: [
            VariantStyle(
              const NamedVariant('compact'),
              BoxStyler(clipBehavior: Clip.hardEdge),
            ),
          ],
          modifier: testModifier(),
          animation: testAnimation(),
        ),
      );
    },
  );

  test(
    'TextStyler preserves variants, modifiers, and animation across wire',
    () {
      expectRoundTrips<TextStyler>(
        TextStyler(
          variants: [
            VariantStyle(const NamedVariant('label'), TextStyler(maxLines: 1)),
          ],
          modifier: testModifier(),
          animation: testAnimation(),
        ),
      );
    },
  );

  test(
    'FlexStyler preserves variants, modifiers, and animation across wire',
    () {
      expectRoundTrips<FlexStyler>(
        FlexStyler(
          variants: [
            VariantStyle(const NamedVariant('dense'), FlexStyler(spacing: 2)),
          ],
          modifier: testModifier(),
          animation: testAnimation(),
        ),
      );
    },
  );

  test(
    'StackStyler preserves variants, modifiers, and animation across wire',
    () {
      expectRoundTrips<StackStyler>(
        StackStyler(
          variants: [
            VariantStyle(
              const NamedVariant('overlay'),
              StackStyler(fit: StackFit.expand),
            ),
          ],
          modifier: testModifier(),
          animation: testAnimation(),
        ),
      );
    },
  );

  test(
    'IconStyler preserves variants, modifiers, and animation across wire',
    () {
      expectRoundTrips<IconStyler>(
        IconStyler(
          variants: [
            VariantStyle(const NamedVariant('small'), IconStyler(size: 16)),
          ],
          modifier: testModifier(),
          animation: testAnimation(),
        ),
      );
    },
  );

  test(
    'ImageStyler preserves variants, modifiers, and animation across wire',
    () {
      expectRoundTrips<ImageStyler>(
        ImageStyler(
          variants: [
            VariantStyle(const NamedVariant('thumb'), ImageStyler(width: 32)),
          ],
          modifier: testModifier(),
          animation: testAnimation(),
        ),
      );
    },
  );

  test(
    'FlexBoxStyler preserves variants, modifiers, and animation across wire',
    () {
      expectRoundTrips<FlexBoxStyler>(
        FlexBoxStyler(
          variants: [
            VariantStyle(
              const NamedVariant('toolbar'),
              FlexBoxStyler(spacing: 2),
            ),
          ],
          modifier: testModifier(),
          animation: testAnimation(),
        ),
      );
    },
  );

  test(
    'StackBoxStyler preserves variants, modifiers, and animation across wire',
    () {
      expectRoundTrips<StackBoxStyler>(
        StackBoxStyler(
          variants: [
            VariantStyle(
              const NamedVariant('badge'),
              StackBoxStyler(fit: StackFit.expand),
            ),
          ],
          modifier: testModifier(),
          animation: testAnimation(),
        ),
      );
    },
  );

  test('FlexBoxStyler round-trips combined box, flex, and metadata fields', () {
    expectRoundTrips<FlexBoxStyler>(
      FlexBoxStyler(
        alignment: Alignment.center,
        padding: EdgeInsetsMix(left: 8, top: 4),
        decoration: BoxDecorationMix(color: const Color(0xFF112233)),
        clipBehavior: Clip.hardEdge,
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        flexClipBehavior: Clip.antiAlias,
        spacing: 6,
        variants: [
          VariantStyle(
            const NamedVariant('combined'),
            FlexBoxStyler(spacing: 2),
          ),
        ],
        modifier: testModifier(),
        animation: testAnimation(),
      ),
    );
  });

  test(
    'StackBoxStyler round-trips combined box, stack, and metadata fields',
    () {
      expectRoundTrips<StackBoxStyler>(
        StackBoxStyler(
          alignment: Alignment.topLeft,
          margin: EdgeInsetsMix(bottom: 10),
          clipBehavior: Clip.antiAlias,
          stackAlignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
          stackClipBehavior: Clip.none,
          variants: [
            VariantStyle(
              const NamedVariant('combined'),
              StackBoxStyler(fit: StackFit.passthrough),
            ),
          ],
          modifier: testModifier(),
          animation: testAnimation(),
        ),
      );
    },
  );
}
