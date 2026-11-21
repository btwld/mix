import 'package:flutter/foundation.dart';

import 'tw_compilation.dart';

enum TwLayoutDimensionProperty { width, height, minWidth, minHeight }

@immutable
final class TwLayoutDimensionDeclaration {
  final TwLayoutDimensionProperty property;

  final TwDimensionIntent intent;
  const TwLayoutDimensionDeclaration({
    required this.property,
    required this.intent,
  });
}

enum TwLayoutGapAxis { all, horizontal, vertical }

@immutable
final class TwLayoutFlexContainerDeclaration {
  final bool establishesContainer;

  final bool establishesBaseFlex;
  final TwFlexAxis? axis;
  final TwLayoutGapAxis? gapAxis;
  final double? gap;
  final bool explicitItems;
  const TwLayoutFlexContainerDeclaration({
    this.establishesContainer = true,
    this.establishesBaseFlex = false,
    this.axis,
    this.gapAxis,
    this.gap,
    this.explicitItems = false,
  }) : assert((gapAxis == null) == (gap == null));
}

@immutable
final class TwLayoutFlexItemDeclaration {
  final TwFlexBasis? basis;

  final bool? explicitBasis;
  final int basisPriority;
  final double? grow;
  final int growPriority;
  final TwSelfAlignment? selfAlignment;
  final TwFlexBehavior? behavior;
  final int behaviorPriority;
  const TwLayoutFlexItemDeclaration({
    this.basis,
    this.explicitBasis,
    this.basisPriority = 0,
    this.grow,
    this.growPriority = 0,
    this.selfAlignment,
    this.behavior,
    this.behaviorPriority = 0,
  }) : assert((basis == null) == (explicitBasis == null));
}

enum TwLayoutInsetKind { margin, padding, border }

enum TwLayoutInsetSides { all, horizontal, vertical, left, top, right, bottom }

@immutable
final class TwLayoutInsetDeclaration {
  final TwLayoutInsetKind kind;

  final TwLayoutInsetSides sides;
  final double value;
  const TwLayoutInsetDeclaration({
    required this.kind,
    required this.sides,
    required this.value,
  });
}

enum TwLayoutLogicalInsetSides { start, end, left, right }

@immutable
final class TwLayoutLogicalInsetDeclaration {
  final TwLayoutLogicalInsetSides sides;

  final double value;
  const TwLayoutLogicalInsetDeclaration({
    required this.sides,
    required this.value,
  });
}

/// The compiler-owned semantic projection consumed by [TwLayoutPlanBuilder].
///
/// The translator resolves syntax, configuration, routing, and variants before
/// creating this value. Inputs are supplied in canonical utility order, so the
/// builder only applies typed declarations and never interprets class tokens.
@immutable
final class TwLayoutUtilityInput {
  final double breakpointMinWidth;

  final TwLayoutDimensionDeclaration? dimension;
  final TwLayoutFlexContainerDeclaration? flexContainer;
  final TwLayoutFlexItemDeclaration? flexItem;
  final TwLayoutInsetDeclaration? inset;
  final TwLayoutLogicalInsetDeclaration? iconLogicalMargin;
  const TwLayoutUtilityInput({
    this.breakpointMinWidth = 0,
    this.dimension,
    this.flexContainer,
    this.flexItem,
    this.inset,
    this.iconLogicalMargin,
  }) : assert(breakpointMinWidth >= 0);
}

@immutable
final class TwResponsiveEntry<T> {
  final double minWidth;

  final T value;
  const TwResponsiveEntry({required this.minWidth, required this.value})
    : assert(minWidth >= 0);
}

/// An immutable mobile-first value selected with an explicit viewport width.
///
/// No `BuildContext` or constraints are consulted here. Widget consumers retain
/// the current MediaQuery-first behavior by passing the already-selected width.
@immutable
final class TwResponsiveValue<T> {
  final List<TwResponsiveEntry<T>> entries;

  const TwResponsiveValue.empty() : entries = const [];

  TwResponsiveValue(Iterable<TwResponsiveEntry<T>> entries)
    : entries = List.unmodifiable(_normalizeEntries(entries));

  static List<TwResponsiveEntry<T>> _normalizeEntries<T>(
    Iterable<TwResponsiveEntry<T>> source,
  ) {
    final lastByWidth = <double, TwResponsiveEntry<T>>{};
    for (final entry in source) {
      lastByWidth[entry.minWidth] = entry;
    }
    final normalized = lastByWidth.values.toList()
      ..sort((left, right) => left.minWidth.compareTo(right.minWidth));

    return normalized;
  }

  bool get isEmpty => entries.isEmpty;

  bool get isNotEmpty => entries.isNotEmpty;

  T? select(double width) {
    if (width.isNaN) return null;

    T? selected;
    for (final entry in entries) {
      if (entry.minWidth > width) break;
      selected = entry.value;
    }

    return selected;
  }
}

enum TwDimensionKind { auto, fixed, fraction, full, screen }

@immutable
final class TwDimensionIntent {
  final TwDimensionKind kind;

  /// Pixels for [TwDimensionKind.fixed] or a factor for
  /// [TwDimensionKind.fraction].
  final double? value;
  const TwDimensionIntent._(this.kind, {this.value});

  const TwDimensionIntent.auto() : this._(.auto);
  const TwDimensionIntent.fixed(double pixels) : this._(.fixed, value: pixels);
  const TwDimensionIntent.fraction(double factor)
    : this._(.fraction, value: factor);
  const TwDimensionIntent.full() : this._(.full);
  const TwDimensionIntent.screen() : this._(.screen);

  @override
  bool operator ==(Object other) =>
      other is TwDimensionIntent && kind == other.kind && value == other.value;

  @override
  int get hashCode => Object.hash(kind, value);
}

@immutable
final class TwDimensionPlan {
  final TwResponsiveValue<TwDimensionIntent> width;

  final TwResponsiveValue<TwDimensionIntent> height;
  final TwResponsiveValue<TwDimensionIntent> minWidth;
  final TwResponsiveValue<TwDimensionIntent> minHeight;
  const TwDimensionPlan({
    this.width = const TwResponsiveValue.empty(),
    this.height = const TwResponsiveValue.empty(),
    this.minWidth = const TwResponsiveValue.empty(),
    this.minHeight = const TwResponsiveValue.empty(),
  });

  bool get requiresWidgetRuntime =>
      _containsDimensionKind(width, const {
        .fixed,
        .fraction,
        .full,
        .screen,
      }) ||
      _containsDimensionKind(height, const {.fraction, .full, .screen}) ||
      _containsDimensionKind(minWidth, const {.screen}) ||
      _containsDimensionKind(minHeight, const {.screen});
}

bool _containsDimensionKind(
  TwResponsiveValue<TwDimensionIntent> value,
  Set<TwDimensionKind> kinds,
) => value.entries.any((entry) => kinds.contains(entry.value.kind));

enum TwFlexAxis { horizontal, vertical }

/// Widget behavior needed to reproduce Tailwind's implicit cross-axis policy.
enum TwImplicitCrossAxisPolicy { none, stretchWhenBoundedStartWhenUnbounded }

enum TwSelfAlignment { start, center, end }

enum TwFlexBasisKind { unspecified, auto, zero, fixed }

@immutable
final class TwFlexBasis {
  static const unspecified = TwFlexBasis._(.unspecified);

  static const auto = TwFlexBasis._(.auto);
  static const zero = TwFlexBasis._(.zero, pixels: 0);
  final TwFlexBasisKind kind;

  final double? pixels;

  const TwFlexBasis._(this.kind, {this.pixels});

  const TwFlexBasis.fixed(double pixels) : this._(.fixed, pixels: pixels);

  @override
  bool operator ==(Object other) =>
      other is TwFlexBasis && kind == other.kind && pixels == other.pixels;

  @override
  int get hashCode => Object.hash(kind, pixels);
}

enum TwFlexFitIntent { tight, loose }

/// The existing Flutter parent-data behavior associated with a flex utility.
@immutable
final class TwFlexBehavior {
  final int flex;

  final TwFlexFitIntent fit;
  const TwFlexBehavior({required this.flex, required this.fit});

  @override
  bool operator ==(Object other) =>
      other is TwFlexBehavior && flex == other.flex && fit == other.fit;

  @override
  int get hashCode => Object.hash(flex, fit);
}

@immutable
final class TwResolvedFlexContainer {
  final TwFlexAxis axis;

  final double? mainGap;
  final double? crossGap;
  final TwImplicitCrossAxisPolicy implicitCrossAxisPolicy;
  const TwResolvedFlexContainer({
    required this.axis,
    required this.mainGap,
    required this.crossGap,
    required this.implicitCrossAxisPolicy,
  });
}

@immutable
final class TwFlexContainerPlan {
  final bool isFlexContainer;

  /// Whether a base `flex`, `inline-flex`, `flex-row`, or `flex-col` utility
  /// establishes the horizontal fallback used by current widget behavior.
  final bool hasBaseFlex;

  final TwResponsiveValue<TwFlexAxis> axis;
  final TwResponsiveValue<double> gap;
  final TwResponsiveValue<double> gapX;
  final TwResponsiveValue<double> gapY;
  final TwResponsiveValue<bool> explicitItems;
  const TwFlexContainerPlan({
    this.isFlexContainer = false,
    this.hasBaseFlex = false,
    this.axis = const TwResponsiveValue.empty(),
    this.gap = const TwResponsiveValue.empty(),
    this.gapX = const TwResponsiveValue.empty(),
    this.gapY = const TwResponsiveValue.empty(),
    this.explicitItems = const TwResponsiveValue.empty(),
  });

  Set<double> get _responsiveBoundaries => {
    0,
    ...axis.entries.map((entry) => entry.minWidth),
    ...explicitItems.entries.map((entry) => entry.minWidth),
  };

  bool get requiresWidgetRuntime =>
      gapX.isNotEmpty ||
      gapY.isNotEmpty ||
      (isFlexContainer &&
          _responsiveBoundaries.any(
            (width) => resolve(width).implicitCrossAxisPolicy != .none,
          ));

  TwFlexContainerPlan asFlexTarget() {
    if (isFlexContainer) return this;

    return TwFlexContainerPlan(
      isFlexContainer: true,
      hasBaseFlex: hasBaseFlex,
      axis: axis,
      gap: gap,
      gapX: gapX,
      gapY: gapY,
      explicitItems: explicitItems,
    );
  }

  TwResolvedFlexContainer resolve(double width) {
    final resolvedAxis =
        axis.select(width) ?? (hasBaseFlex ? .horizontal : .vertical);
    final baseGap = gap.select(width);
    final horizontalGap = gapX.select(width);
    final verticalGap = gapY.select(width);
    final hasExplicitItems = explicitItems.select(width) ?? false;

    return TwResolvedFlexContainer(
      axis: resolvedAxis,
      mainGap: resolvedAxis == .horizontal
          ? (horizontalGap ?? baseGap)
          : (verticalGap ?? baseGap),
      crossGap: resolvedAxis == .horizontal ? verticalGap : horizontalGap,
      implicitCrossAxisPolicy: resolvedAxis == .vertical && !hasExplicitItems
          ? .stretchWhenBoundedStartWhenUnbounded
          : .none,
    );
  }
}

@immutable
final class TwResolvedFlexItem {
  final TwFlexBasis basis;
  final bool hasExplicitBasis;

  final double? grow;
  final TwSelfAlignment? selfAlignment;
  final TwFlexBehavior? behavior;
  const TwResolvedFlexItem({
    required this.basis,
    required this.hasExplicitBasis,
    this.grow,
    this.selfAlignment,
    this.behavior,
  });

  double? get zeroBasisGrow =>
      basis.kind == .zero && (grow ?? 0) > 0 ? grow : null;
}

@immutable
final class TwFlexItemPlan {
  final TwResponsiveValue<TwFlexBasis> basis;
  final TwResponsiveValue<bool> explicitBasis;

  final TwResponsiveValue<double> grow;
  final TwResponsiveValue<TwSelfAlignment> selfAlignment;
  final TwResponsiveValue<TwFlexBehavior> behavior;
  const TwFlexItemPlan({
    this.basis = const TwResponsiveValue.empty(),
    this.explicitBasis = const TwResponsiveValue.empty(),
    this.grow = const TwResponsiveValue.empty(),
    this.selfAlignment = const TwResponsiveValue.empty(),
    this.behavior = const TwResponsiveValue.empty(),
  });

  bool get isEmpty =>
      basis.isEmpty &&
      explicitBasis.isEmpty &&
      grow.isEmpty &&
      selfAlignment.isEmpty &&
      behavior.isEmpty;

  bool get requiresWidgetRuntime =>
      basis.entries.any((entry) => entry.value.kind != .auto) ||
      selfAlignment.isNotEmpty ||
      behavior.isNotEmpty;

  TwResolvedFlexItem resolve(double width) => .new(
    basis: basis.select(width) ?? .unspecified,
    hasExplicitBasis: explicitBasis.select(width) ?? false,
    grow: grow.select(width),
    selfAlignment: selfAlignment.select(width),
    behavior: behavior.select(width),
  );
}

@immutable
final class TwInsets {
  final double left;

  final double top;
  final double right;
  final double bottom;
  const TwInsets({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
  });

  double mainExtent(TwFlexAxis axis) =>
      axis == .horizontal ? left + right : top + bottom;

  TwInsets withSides({
    required double value,
    required bool left,
    required bool top,
    required bool right,
    required bool bottom,
  }) => .new(
    left: left ? value : this.left,
    top: top ? value : this.top,
    right: right ? value : this.right,
    bottom: bottom ? value : this.bottom,
  );

  @override
  bool operator ==(Object other) =>
      other is TwInsets &&
      left == other.left &&
      top == other.top &&
      right == other.right &&
      bottom == other.bottom;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);
}

@immutable
final class TwLogicalInsets {
  final double start;

  final double end;
  final double left;
  final double right;
  const TwLogicalInsets({
    this.start = 0,
    this.end = 0,
    this.left = 0,
    this.right = 0,
  });

  TwLogicalInsets withSides({
    required double value,
    required bool start,
    required bool end,
    required bool left,
    required bool right,
  }) => .new(
    start: start ? value : this.start,
    end: end ? value : this.end,
    left: left ? value : this.left,
    right: right ? value : this.right,
  );

  @override
  bool operator ==(Object other) =>
      other is TwLogicalInsets &&
      start == other.start &&
      end == other.end &&
      left == other.left &&
      right == other.right;

  @override
  int get hashCode => Object.hash(start, end, left, right);
}

/// Concrete package-internal implementation of the public [TwLayoutPlan] view.
///
/// This type is intentionally not exported from `mix_winds.dart`.
@immutable
final class TwCompiledLayoutPlan implements TwLayoutPlan {
  final TwDimensionPlan dimensions;

  final TwFlexContainerPlan flexContainer;
  final TwFlexItemPlan flexItem;
  final TwResponsiveValue<TwInsets> externalMargin;
  final TwResponsiveValue<TwLogicalInsets> iconLogicalMargin;

  /// Auxiliary style-derived insets used only when [flexItem] resolves to a
  /// positive zero-basis grower. These do not independently make the public
  /// plan non-empty because padding and border remain protocol-portable styles.
  final TwResponsiveValue<TwInsets> padding;
  final TwResponsiveValue<TwInsets> border;

  const TwCompiledLayoutPlan({
    this.dimensions = const TwDimensionPlan(),
    this.flexContainer = const TwFlexContainerPlan(),
    this.flexItem = const TwFlexItemPlan(),
    this.externalMargin = const TwResponsiveValue.empty(),
    this.iconLogicalMargin = const TwResponsiveValue.empty(),
    this.padding = const TwResponsiveValue.empty(),
    this.border = const TwResponsiveValue.empty(),
  });

  double zeroBasisOuterExtent(
    TwFlexAxis axis, {
    required double marginWidth,
    required double styleWidth,
  }) =>
      (externalMargin.select(marginWidth)?.mainExtent(axis) ?? 0) +
      (padding.select(styleWidth)?.mainExtent(axis) ?? 0) +
      (border.select(styleWidth)?.mainExtent(axis) ?? 0);

  @override
  bool get isEmpty =>
      !dimensions.requiresWidgetRuntime &&
      !flexContainer.requiresWidgetRuntime &&
      !flexItem.requiresWidgetRuntime &&
      !_hasNonZeroInsets(externalMargin) &&
      !_hasNonZeroLogicalInsets(iconLogicalMargin);
}

bool _hasNonZeroInsets(TwResponsiveValue<TwInsets> value) =>
    value.entries.any((entry) => entry.value != const TwInsets());

bool _hasNonZeroLogicalInsets(TwResponsiveValue<TwLogicalInsets> value) =>
    value.entries.any((entry) => entry.value != const TwLogicalInsets());

/// Builds immutable semantic layout data from already-routed compiler inputs.
final class TwLayoutPlanBuilder {
  final _ResponsiveDeclarationBuilder<TwDimensionIntent> _width =
      _ResponsiveDeclarationBuilder();

  final _ResponsiveDeclarationBuilder<TwDimensionIntent> _height =
      _ResponsiveDeclarationBuilder();
  final _ResponsiveDeclarationBuilder<TwDimensionIntent> _minWidth =
      _ResponsiveDeclarationBuilder();
  final _ResponsiveDeclarationBuilder<TwDimensionIntent> _minHeight =
      _ResponsiveDeclarationBuilder();
  final _ResponsiveDeclarationBuilder<TwFlexAxis> _axis =
      _ResponsiveDeclarationBuilder();
  final _ResponsiveDeclarationBuilder<double> _gap =
      _ResponsiveDeclarationBuilder();
  final _ResponsiveDeclarationBuilder<double> _gapX =
      _ResponsiveDeclarationBuilder();
  final _ResponsiveDeclarationBuilder<double> _gapY =
      _ResponsiveDeclarationBuilder();
  final _ResponsiveDeclarationBuilder<bool> _explicitItems =
      _ResponsiveDeclarationBuilder();
  final _ResponsiveDeclarationBuilder<TwFlexBasis> _basis =
      _ResponsiveDeclarationBuilder();
  final _ResponsiveDeclarationBuilder<bool> _explicitBasis =
      _ResponsiveDeclarationBuilder();

  final _ResponsiveDeclarationBuilder<double> _grow =
      _ResponsiveDeclarationBuilder();
  final _ResponsiveDeclarationBuilder<TwSelfAlignment> _selfAlignment =
      _ResponsiveDeclarationBuilder();
  final _ResponsiveDeclarationBuilder<TwFlexBehavior> _behavior =
      _ResponsiveDeclarationBuilder();
  final _margin = _insetsBuilder();

  final _padding = _insetsBuilder(mergeInStyleOrder: true);
  final _border = _insetsBuilder(mergeInStyleOrder: true);
  final _CumulativeInsetsBuilder<TwLogicalInsets, TwLayoutLogicalInsetSides>
  _iconMargin = _CumulativeInsetsBuilder(
    empty: const TwLogicalInsets(),
    apply: _applyLogicalInsets,
  );
  var _isFlexContainer = false;

  var _hasBaseFlex = false;
  var _nextOrder = 0;
  TwLayoutPlanBuilder();

  void _addDimension(
    TwLayoutDimensionDeclaration declaration,
    double minWidth,
    int order,
  ) {
    final target = switch (declaration.property) {
      .width => _width,
      .height => _height,
      .minWidth => _minWidth,
      .minHeight => _minHeight,
    };
    target.add(declaration.intent, minWidth: minWidth, order: order);
  }

  void _addFlexContainer(
    TwLayoutFlexContainerDeclaration declaration,
    double minWidth,
    int order,
  ) {
    if (declaration.establishesContainer) _isFlexContainer = true;
    if (declaration.establishesBaseFlex) _hasBaseFlex = true;
    if (declaration.axis case final axis?) {
      _axis.add(axis, minWidth: minWidth, order: order);
    }
    if (declaration.explicitItems) {
      _explicitItems.add(true, minWidth: minWidth, order: order);
    }
    if (declaration.gap case final gap?) {
      final target = switch (declaration.gapAxis!) {
        .all => _gap,
        .horizontal => _gapX,
        .vertical => _gapY,
      };
      target.add(gap, minWidth: minWidth, order: order);
    }
  }

  void _addFlexItem(
    TwLayoutFlexItemDeclaration declaration,
    double minWidth,
    int order,
  ) {
    if (declaration.basis case final basis?) {
      _basis.add(
        basis,
        minWidth: minWidth,
        order: order,
        priority: declaration.basisPriority,
      );
      _explicitBasis.add(
        declaration.explicitBasis!,
        minWidth: minWidth,
        order: order,
        priority: declaration.basisPriority,
      );
    }
    if (declaration.grow case final grow?) {
      _grow.add(
        grow,
        minWidth: minWidth,
        order: order,
        priority: declaration.growPriority,
      );
    }
    if (declaration.selfAlignment case final alignment?) {
      _selfAlignment.add(alignment, minWidth: minWidth, order: order);
    }
    if (declaration.behavior case final behavior?) {
      _behavior.add(
        behavior,
        minWidth: minWidth,
        order: order,
        priority: declaration.behaviorPriority,
      );
    }
  }

  void _addInset(
    TwLayoutInsetDeclaration declaration,
    double minWidth,
    int order,
    int styleGroupOrder,
  ) {
    final target = switch (declaration.kind) {
      .margin => _margin,
      .padding => _padding,
      .border => _border,
    };
    target.add(
      declaration.value,
      sides: declaration.sides,
      minWidth: minWidth,
      order: order,
      styleGroupOrder: styleGroupOrder,
    );
  }

  void _addIconLogicalMargin(
    TwLayoutLogicalInsetDeclaration declaration,
    double minWidth,
    int order,
  ) {
    _iconMargin.add(
      declaration.value,
      sides: declaration.sides,
      minWidth: minWidth,
      order: order,
    );
  }

  /// [styleGroupOrder] follows the emitted Styler's base and variant merge
  /// order. It applies to padding and borders; external margins retain their
  /// widget-owned, mobile-first cascade.
  void add(TwLayoutUtilityInput input, {int styleGroupOrder = 0}) {
    final order = _nextOrder++;
    final minWidth = input.breakpointMinWidth;
    if (input.dimension case final declaration?) {
      _addDimension(declaration, minWidth, order);
    }
    if (input.flexContainer case final declaration?) {
      _addFlexContainer(declaration, minWidth, order);
    }
    if (input.flexItem case final declaration?) {
      _addFlexItem(declaration, minWidth, order);
    }
    if (input.inset case final declaration?) {
      _addInset(declaration, minWidth, order, styleGroupOrder);
    }
    if (input.iconLogicalMargin case final declaration?) {
      _addIconLogicalMargin(declaration, minWidth, order);
    }
  }

  TwCompiledLayoutPlan build() {
    final margins = _margin.build();
    final paddings = _padding.build();
    final borders = _border.build();

    return TwCompiledLayoutPlan(
      dimensions: TwDimensionPlan(
        width: _width.build(),
        height: _height.build(),
        minWidth: _minWidth.build(),
        minHeight: _minHeight.build(),
      ),
      flexContainer: TwFlexContainerPlan(
        isFlexContainer: _isFlexContainer,
        hasBaseFlex: _hasBaseFlex,
        axis: _axis.build(),
        gap: _gap.build(),
        gapX: _gapX.build(),
        gapY: _gapY.build(),
        explicitItems: _explicitItems.build(),
      ),
      flexItem: TwFlexItemPlan(
        basis: _basis.build(),
        explicitBasis: _explicitBasis.build(),
        grow: _grow.build(),
        selfAlignment: _selfAlignment.build(),
        behavior: _behavior.build(),
      ),
      externalMargin: margins,
      iconLogicalMargin: _iconMargin.build(),
      padding: paddings,
      border: borders,
    );
  }
}

final class _ResponsiveDeclaration<T> {
  final T value;

  final double minWidth;
  final int priority;
  final int order;
  const _ResponsiveDeclaration({
    required this.value,
    required this.minWidth,
    required this.priority,
    required this.order,
  });
}

final class _ResponsiveDeclarationBuilder<T> {
  final _declarations = <_ResponsiveDeclaration<T>>[];

  void add(
    T value, {
    required double minWidth,
    required int order,
    int priority = 0,
  }) {
    _declarations.add(
      _ResponsiveDeclaration(
        value: value,
        minWidth: minWidth,
        priority: priority,
        order: order,
      ),
    );
  }

  TwResponsiveValue<T> build() {
    if (_declarations.isEmpty) return const TwResponsiveValue.empty();
    final winners = <double, _ResponsiveDeclaration<T>>{};
    for (final declaration in _declarations) {
      final current = winners[declaration.minWidth];
      if (current == null ||
          declaration.priority > current.priority ||
          (declaration.priority == current.priority &&
              declaration.order > current.order)) {
        winners[declaration.minWidth] = declaration;
      }
    }

    return TwResponsiveValue(
      winners.values.map(
        (declaration) => TwResponsiveEntry(
          minWidth: declaration.minWidth,
          value: declaration.value,
        ),
      ),
    );
  }
}

final class _CumulativeInsetsDeclaration<S> {
  final double value;
  final S sides;
  final double minWidth;
  final int order;
  final int styleGroupOrder;
  const _CumulativeInsetsDeclaration({
    required this.value,
    required this.sides,
    required this.minWidth,
    required this.order,
    required this.styleGroupOrder,
  });
}

/// Builds a responsive value whose breakpoints accumulate rather than replace.
///
/// Every declaration active at a breakpoint is re-applied from [empty] in merge
/// order, because a newly active breakpoint may precede another already active
/// Styler variant. [apply] writes one declaration's sides onto the value under
/// construction, which is what makes the two side vocabularies share this
/// algorithm.
final class _CumulativeInsetsBuilder<V, S> {
  final V empty;

  final V Function(V current, double value, S sides) apply;
  final bool mergeInStyleOrder;

  final _declarations = <_CumulativeInsetsDeclaration<S>>[];

  _CumulativeInsetsBuilder({
    required this.empty,
    required this.apply,
    this.mergeInStyleOrder = false,
  });

  void add(
    double value, {
    required S sides,
    required double minWidth,
    required int order,
    int styleGroupOrder = 0,
  }) {
    _declarations.add(
      _CumulativeInsetsDeclaration(
        value: value,
        sides: sides,
        minWidth: minWidth,
        order: order,
        styleGroupOrder: styleGroupOrder,
      ),
    );
  }

  TwResponsiveValue<V> build() {
    if (_declarations.isEmpty) return const TwResponsiveValue.empty();
    final declarations = _declarations.toList()
      ..sort((left, right) {
        final group = mergeInStyleOrder
            ? left.styleGroupOrder.compareTo(right.styleGroupOrder)
            : left.minWidth.compareTo(right.minWidth);

        return group != 0 ? group : left.order.compareTo(right.order);
      });
    final widths = _declarations.map((entry) => entry.minWidth).toSet().toList()
      ..sort();
    final entries = <TwResponsiveEntry<V>>[];
    for (final width in widths) {
      var current = empty;
      for (final declaration in declarations) {
        if (declaration.minWidth > width) continue;
        current = apply(current, declaration.value, declaration.sides);
      }
      entries.add(TwResponsiveEntry(minWidth: width, value: current));
    }

    return TwResponsiveValue(entries);
  }
}

TwInsets _applyInsets(
  TwInsets current,
  double value,
  TwLayoutInsetSides sides,
) {
  final horizontal = sides == .all || sides == .horizontal;
  final vertical = sides == .all || sides == .vertical;

  return current.withSides(
    value: value,
    left: horizontal || sides == .left,
    top: vertical || sides == .top,
    right: horizontal || sides == .right,
    bottom: vertical || sides == .bottom,
  );
}

TwLogicalInsets _applyLogicalInsets(
  TwLogicalInsets current,
  double value,
  TwLayoutLogicalInsetSides sides,
) => current.withSides(
  value: value,
  start: sides == .start,
  end: sides == .end,
  left: sides == .left,
  right: sides == .right,
);

_CumulativeInsetsBuilder<TwInsets, TwLayoutInsetSides> _insetsBuilder({
  bool mergeInStyleOrder = false,
}) => .new(
  empty: const TwInsets(),
  apply: _applyInsets,
  mergeInStyleOrder: mergeInStyleOrder,
);
