// Guards behavior that existing code relies on when it builds a style:
// overrides and implementers of `mergeActiveVariants`, and the spec instance
// that `build` returns.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/core/internal/variant_activation.dart';

const _primary = NamedVariant('primary');
const _curve = CurveAnimationConfig.linear(Duration(milliseconds: 100));

/// A style from another library: it implements [Style] and forwards variant
/// resolution, so it has none of the private members of [Style].
class _DelegatingStyle implements Style<BoxSpec> {
  _DelegatingStyle(this._inner);

  final BoxStyler _inner;

  @override
  List<VariantStyle<BoxSpec>>? get $variants => _inner.$variants;
  @override
  AnimationConfig? get $animation => _inner.$animation;
  @override
  WidgetModifierConfig? get $modifier => _inner.$modifier;
  @override
  Style<BoxSpec> mergeActiveVariants(
    BuildContext context, {
    required Set<NamedVariant> namedVariants,
  }) => _inner.mergeActiveVariants(context, namedVariants: namedVariants);
  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) => _inner.resolve(context);
  @override
  Style<BoxSpec> merge(covariant Style<BoxSpec>? other) =>
      _inner.merge(other as BoxStyler?);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Replaces variant merging entirely.
class _CenteredStyler extends BoxStyler {
  @override
  Style<BoxSpec> mergeActiveVariants(
    BuildContext context, {
    required Set<NamedVariant> namedVariants,
  }) => BoxStyler().alignment(Alignment.center);
}

/// A spec subclass that inherits the default `copyWith`, which returns a
/// plain [StyleSpec].
class _TaggedSpec extends StyleSpec<BoxSpec> {
  const _TaggedSpec({required super.spec, super.animation});
}

/// A cached spec whose `copyWith` returns itself.
class _SharedSpec extends StyleSpec<BoxSpec> {
  const _SharedSpec({required super.spec, super.animation});

  @override
  StyleSpec<BoxSpec> copyWith({
    BoxSpec? spec,
    AnimationConfig? animation,
    List<WidgetModifier>? widgetModifiers,
  }) => this;
}

/// Resolves to a fixed spec and carries one always-active named variant.
class _FixedStyle extends Style<BoxSpec> {
  _FixedStyle(this._spec, {bool withVariant = true})
    : super(
        variants: withVariant
            ? [VariantStyle(_primary, _FixedStyle(_spec, withVariant: false))]
            : null,
        modifier: null,
        animation: _curve,
      );

  final StyleSpec<BoxSpec> _spec;

  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) => _spec;
  @override
  _FixedStyle merge(covariant Style<BoxSpec>? other) => this;
  @override
  List<Object?> get props => [_spec];
}

Future<T> _inContext<T>(
  WidgetTester tester,
  T Function(BuildContext context) body,
) async {
  late T result;
  await tester.pumpWidget(
    Builder(
      builder: (context) {
        result = body(context);

        return const SizedBox.shrink();
      },
    ),
  );

  return result;
}

void main() {
  testWidgets('a style that implements Style works as a variant value', (
    tester,
  ) async {
    final style = BoxStyler(
      variants: [
        VariantStyle(_primary, _DelegatingStyle(BoxStyler().color(Colors.red))),
      ],
    );

    final spec = await _inContext(
      tester,
      (context) => style.build(context, namedVariants: {_primary}),
    );

    expect((spec.spec.decoration as BoxDecoration).color, Colors.red);
  });

  testWidgets('build honors an override of mergeActiveVariants', (
    tester,
  ) async {
    final spec = await _inContext(
      tester,
      (context) => _CenteredStyler().build(context),
    );

    expect(spec.spec.alignment, Alignment.center);
  });

  testWidgets('a nested override of mergeActiveVariants is honored', (
    tester,
  ) async {
    final style = BoxStyler(
      variants: [VariantStyle(_primary, _CenteredStyler())],
    );

    final spec = await _inContext(
      tester,
      (context) => style.build(context, namedVariants: {_primary}),
    );

    expect(spec.spec.alignment, Alignment.center);
  });

  testWidgets('build keeps a spec subclass that cannot be copied', (
    tester,
  ) async {
    final style = _FixedStyle(_TaggedSpec(spec: BoxSpec(), animation: _curve));

    final spec = await _inContext(
      tester,
      (context) => style.build(context, namedVariants: {_primary}),
    );

    expect(spec, isA<_TaggedSpec>());
    expect(readVariantActivation(spec), isNull);
  });

  testWidgets('build never records on a spec that copies to itself', (
    tester,
  ) async {
    final shared = _SharedSpec(spec: BoxSpec(), animation: _curve);
    final style = _FixedStyle(shared);

    final spec = await _inContext(
      tester,
      (context) => style.build(context, namedVariants: {_primary}),
    );

    expect(spec, same(shared));
    expect(readVariantActivation(shared), isNull);
  });

  testWidgets('build records variant identity only for animated specs', (
    tester,
  ) async {
    final plain = BoxStyler().onDark(BoxStyler().color(Colors.red));
    final animated = BoxStyler().onDark(
      BoxStyler().color(Colors.red).animate(_curve),
    );

    late StyleSpec<BoxSpec> plainSpec;
    late StyleSpec<BoxSpec> animatedSpec;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(platformBrightness: Brightness.dark),
        child: Builder(
          builder: (context) {
            plainSpec = plain.build(context);
            animatedSpec = animated.build(context);

            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect((plainSpec.spec.decoration as BoxDecoration).color, Colors.red);
    expect(readVariantActivation(plainSpec), isNull);
    expect(readVariantActivation(animatedSpec)?.animationOwner, isNotNull);
  });

  testWidgets('a style built inside a variant builder records separately', (
    tester,
  ) async {
    final inner = BoxStyler().onDark(BoxStyler().animate(_curve));
    late StyleSpec<BoxSpec> innerSpec;
    final outer = BoxStyler().animate(_curve).onBuilder((context) {
      innerSpec = inner.build(context);

      return BoxStyler().color(Colors.red);
    });

    late StyleSpec<BoxSpec> outerSpec;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(platformBrightness: Brightness.dark),
        child: Builder(
          builder: (context) {
            outerSpec = outer.build(context);

            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(readVariantActivation(innerSpec)?.active, hasLength(1));
    expect(readVariantActivation(outerSpec)?.active, hasLength(1));
    expect(
      readVariantActivation(outerSpec)?.active,
      isNot(equals(readVariantActivation(innerSpec)?.active)),
    );
  });
}
