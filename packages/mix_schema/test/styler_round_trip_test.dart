import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

/// Canonical-payload round-trip tests for every styler branch (REFACTOR_PLAN.md
/// Phase 6). The reference property: for a representative styler, encoding to
/// wire then decoding and re-encoding reproduces the wire byte-for-byte — i.e.
/// `encode ∘ decode` is the identity on canonical wire. This pins encode/decode
/// symmetry per branch so the still-pending styler-table consolidation cannot
/// silently change the wire output.
///
/// The existing per-styler tests already assert the exact encode snapshot; these
/// add the decode-side symmetry the audit found missing for flex/stack/icon/
/// image/flex_box/stack_box.
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

  test('box', () {
    expectRoundTrips<BoxStyler>(
      BoxStyler(
        alignment: Alignment.center,
        padding: EdgeInsetsMix(top: 8),
        decoration: BoxDecorationMix(color: const Color(0xCC336699)),
        clipBehavior: Clip.hardEdge,
      ),
    );
  });

  test('text', () {
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

  test('flex', () {
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

  test('stack', () {
    expectRoundTrips<StackStyler>(
      StackStyler(
        alignment: Alignment.center,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
      ),
    );
  });

  test('icon', () {
    expectRoundTrips<IconStyler>(
      IconStyler(
        icon: icon,
        color: const Color(0xFF112233),
        size: 24,
        blendMode: BlendMode.srcIn,
      ),
    );
  });

  test('image', () {
    expectRoundTrips<ImageStyler>(
      ImageStyler(
        image: image as ImageProvider<Object>,
        width: 64,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  });

  test('flex_box', () {
    expectRoundTrips<FlexBoxStyler>(
      FlexBoxStyler(
        padding: EdgeInsetsMix.all(8),
        decoration: BoxDecorationMix(color: const Color(0xFF112233)),
        direction: Axis.vertical,
        spacing: 4,
        flexClipBehavior: Clip.hardEdge,
      ),
    );
  });

  test('stack_box', () {
    expectRoundTrips<StackBoxStyler>(
      StackBoxStyler(
        margin: EdgeInsetsMix(top: 4),
        stackAlignment: Alignment.center,
        fit: StackFit.passthrough,
        stackClipBehavior: Clip.none,
      ),
    );
  });
}
