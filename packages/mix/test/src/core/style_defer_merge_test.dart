import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Style.deferMerge', () {
    test('returns null when no ContextVariantBuilder is present', () {
      final style = BoxStyler().color(Colors.red);
      final other = BoxStyler().paddingAll(8);

      expect(style.deferMerge(other), isNull);
    });

    test('returns null during active variant resolution', () {
      final deferredResults = <Style<MockSpec<Map<String, dynamic>>>?>[];

      final style = _ProbeStyle(
        variants: [
          VariantStyle<MockSpec<Map<String, dynamic>>>(
            ContextVariantBuilder<_ProbeStyle>((_) => _ProbeStyle(width: 10)),
            _ProbeStyle(),
          ),
        ],
        onDeferChecked: deferredResults.add,
      );

      style.mergeActiveVariants(MockBuildContext(), namedVariants: const {});

      expect(deferredResults, hasLength(1));
      expect(deferredResults.single, isNull);
    });

    test('deferred variants use identity-based keys', () {
      final payload = BoxStyler().color(Colors.red);
      final first = DeferredVariant<BoxSpec>(payload);
      final second = DeferredVariant<BoxSpec>(payload);

      expect(first.key, isNot(second.key));
      expect(first, isNot(equals(second)));
      expect(first.hashCode, isNot(second.hashCode));
    });

    test('cycle detection prevents recursive variant overflow', () {
      late BoxStyler recursiveStyle;
      recursiveStyle = BoxStyler(
        variants: [
          VariantStyle<BoxSpec>(
            ContextVariantBuilder<BoxStyler>((_) => recursiveStyle),
            BoxStyler(),
          ),
        ],
      );

      expect(
        () => recursiveStyle.mergeActiveVariants(
          MockBuildContext(),
          namedVariants: const {},
        ),
        returnsNormally,
      );
    });

    testWidgets(
      'multiple sequential merges after useToken keep deferred variants and last overlap wins',
      (tester) async {
        const colorToken = ColorToken('test.defer.merge.sequence');

        final style = BoxStyler()
            .useToken(colorToken, BoxStyler().color)
            .merge(BoxStyler().paddingAll(8).color(Colors.red))
            .merge(BoxStyler().marginAll(4).color(Colors.blue));

        final deferredCount =
            style.$variants
                ?.where((v) => v.variant is DeferredVariant<BoxSpec>)
                .length ??
            0;
        expect(deferredCount, 2);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MixScope(
              tokens: {colorToken: Colors.green},
              child: Builder(
                builder: (context) {
                  final built = style.build(context);
                  final spec = built.spec;
                  final color = (spec.decoration as BoxDecoration?)?.color;

                  expect(color, Colors.blue);
                  expect(spec.padding, const EdgeInsets.all(8));
                  expect(spec.margin, const EdgeInsets.all(4));

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );
      },
    );
  });
}

class _ProbeStyle extends Style<MockSpec<Map<String, dynamic>>> {
  final double? width;
  final void Function(Style<MockSpec<Map<String, dynamic>>>? deferred)?
  onDeferChecked;

  const _ProbeStyle({
    this.width,
    this.onDeferChecked,
    super.variants = const [],
    super.modifier,
    super.animation,
  });

  @override
  bool get hasBasePayload =>
      width != null || $modifier != null || $animation != null;

  @override
  _ProbeStyle copyWithVariants(
    List<VariantStyle<MockSpec<Map<String, dynamic>>>>? variants,
  ) {
    return _ProbeStyle(
      width: width,
      onDeferChecked: onDeferChecked,
      variants: variants,
      modifier: $modifier,
      animation: $animation,
    );
  }

  @override
  _ProbeStyle merge(covariant _ProbeStyle? other) {
    final deferred = deferMerge(other);
    onDeferChecked?.call(deferred);
    if (deferred != null) return deferred as _ProbeStyle;

    return _ProbeStyle(
      width: other?.width ?? width,
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
      onDeferChecked: onDeferChecked,
    );
  }

  @override
  StyleSpec<MockSpec<Map<String, dynamic>>> resolve(BuildContext context) {
    return StyleSpec(
      spec: MockSpec<Map<String, dynamic>>(resolvedValue: {'width': width}),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  List<Object?> get props => [width, $variants, $modifier, $animation];
}
