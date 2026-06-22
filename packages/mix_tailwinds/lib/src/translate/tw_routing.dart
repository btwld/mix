/// Candidate routing decisions for the translator.
library;

import '../parser/model.dart';

enum TwRouteKind { schemaValue, gradient, widgetLayer, ignored, unsupported }

final class TwRoute {
  const TwRoute(this.kind, {this.reason});

  final TwRouteKind kind;
  final String? reason;
}

TwRoute routeCandidate(
  TailwindCandidate candidate, {
  required Map<String, double> breakpoints,
}) {
  if (candidate.important) {
    return const TwRoute(TwRouteKind.ignored, reason: 'important modifier');
  }

  final variantRoute = _routeVariants(
    candidate.variants,
    breakpoints: breakpoints,
  );
  if (variantRoute != null) {
    return variantRoute;
  }

  final utility = candidate.utility;
  if (utility is TailwindArbitraryProperty) {
    return const TwRoute(TwRouteKind.ignored, reason: 'arbitrary property');
  }
  if (isGradientUtility(utility)) return const TwRoute(TwRouteKind.gradient);
  if (isWidgetLayerUtility(utility)) {
    return const TwRoute(TwRouteKind.widgetLayer);
  }
  if (utility is TailwindUnresolvedUtility) {
    return const TwRoute(TwRouteKind.unsupported);
  }

  return const TwRoute(TwRouteKind.schemaValue);
}

TwRoute? _routeVariants(
  List<TailwindVariant> variants, {
  required Map<String, double> breakpoints,
}) {
  for (final variant in variants) {
    final route = _routeVariant(variant, breakpoints: breakpoints);
    if (route != null) return route;
  }

  return null;
}

TwRoute? _routeVariant(
  TailwindVariant variant, {
  required Map<String, double> breakpoints,
}) {
  if (variant is TailwindArbitraryVariant) {
    return const TwRoute(TwRouteKind.ignored, reason: 'arbitrary variant');
  }

  if (variant is TailwindFunctionalVariant) {
    if (variant.root.startsWith('@')) {
      return const TwRoute(TwRouteKind.ignored, reason: 'container variant');
    }
    return TwRoute(
      TwRouteKind.unsupported,
      reason: 'unsupported variant ${variant.raw}',
    );
  }

  if (variant is TailwindCompoundVariant) {
    if (variant.root == 'group' || variant.root == 'peer') {
      return const TwRoute(TwRouteKind.ignored, reason: 'context variant');
    }
    if (runtimeVariantFor(variant, breakpoints: breakpoints) != null) {
      return null;
    }
    return TwRoute(
      TwRouteKind.unsupported,
      reason: 'unsupported variant ${variant.raw}',
    );
  }

  if (variant is TailwindStaticVariant) {
    if (runtimeVariantFor(variant, breakpoints: breakpoints) != null) {
      return null;
    }
    return TwRoute(
      TwRouteKind.unsupported,
      reason: 'unsupported variant ${variant.raw}',
    );
  }

  if (variant is TailwindUnresolvedVariant) {
    return TwRoute(
      TwRouteKind.unsupported,
      reason: 'unknown variant ${variant.raw}',
    );
  }

  return null;
}

enum TwRuntimeVariantKind {
  hover,
  focus,
  pressed,
  disabled,
  enabled,
  dark,
  light,
  breakpoint,
  notHover,
}

final class TwRuntimeVariant {
  const TwRuntimeVariant(this.kind, this.key, {this.breakpoint});

  const TwRuntimeVariant.breakpoint(String key, double breakpoint)
    : this(TwRuntimeVariantKind.breakpoint, key, breakpoint: breakpoint);

  final TwRuntimeVariantKind kind;
  final String key;
  final double? breakpoint;
}

TwRuntimeVariant? runtimeVariantFor(
  TailwindVariant variant, {
  required Map<String, double> breakpoints,
}) {
  if (variant is TailwindStaticVariant) {
    final breakpoint = breakpoints[variant.root];
    if (breakpoint != null) {
      return TwRuntimeVariant.breakpoint(variant.root, breakpoint);
    }

    return switch (variant.root) {
      'hover' => const TwRuntimeVariant(TwRuntimeVariantKind.hover, 'hover'),
      'focus' || 'focus-visible' => const TwRuntimeVariant(
        TwRuntimeVariantKind.focus,
        'focus',
      ),
      'active' || 'pressed' => const TwRuntimeVariant(
        TwRuntimeVariantKind.pressed,
        'pressed',
      ),
      'disabled' => const TwRuntimeVariant(
        TwRuntimeVariantKind.disabled,
        'disabled',
      ),
      'enabled' => const TwRuntimeVariant(
        TwRuntimeVariantKind.enabled,
        'enabled',
      ),
      'dark' || 'theme-midnight' => const TwRuntimeVariant(
        TwRuntimeVariantKind.dark,
        'dark',
      ),
      'light' => const TwRuntimeVariant(TwRuntimeVariantKind.light, 'light'),
      _ => null,
    };
  }

  if (variant is TailwindCompoundVariant && variant.root == 'not') {
    final child = variant.variant;
    if (child is TailwindStaticVariant && child.root == 'hover') {
      return const TwRuntimeVariant(TwRuntimeVariantKind.notHover, 'not-hover');
    }
  }

  return null;
}

bool isGradientUtility(TailwindUtility utility) {
  final raw = utility.raw;
  final base = raw.startsWith('-') ? raw.substring(1) : raw;
  final root = tailwindUtilityRoot(utility);
  return base.startsWith('bg-gradient-') ||
      base.startsWith('bg-linear-') ||
      root == 'bg-linear' ||
      root == 'from' ||
      root == 'via' ||
      root == 'to';
}

bool isWidgetLayerUtility(TailwindUtility utility) {
  final raw = utility.raw;
  final root = tailwindUtilityRoot(utility);
  final valueKey = tailwindValueKey(tailwindUtilityValue(utility));

  if (transitionTriggerTokens.contains(raw) ||
      raw == 'transition-none' ||
      _easeTokens.contains(raw) ||
      root == 'duration' ||
      root == 'delay') {
    return true;
  }

  if (_flexItemTokens.contains(raw) ||
      raw.startsWith('self-') ||
      root == 'basis' ||
      root == 'self' ||
      root == 'grow' ||
      root == 'shrink') {
    return true;
  }

  if (root == 'gap-x' || root == 'gap-y') return true;

  if (sizingRoots.contains(root)) {
    return valueKey == 'full' ||
        valueKey == 'screen' ||
        valueKey == 'auto' ||
        valueKey?.contains('/') == true;
  }

  return raw == 'block';
}

bool isBoxStylingCandidate(TailwindCandidate candidate) {
  final utility = candidate.utility;
  if (isGradientUtility(utility)) return true;

  final raw = utility.raw;
  final root = tailwindUtilityRoot(utility);
  return raw == 'overflow-hidden' ||
      raw == 'overflow-clip' ||
      raw == 'overflow-visible' ||
      _boxStylingRoots.contains(root) ||
      root.startsWith('border') ||
      root.startsWith('rounded');
}

bool isFlexContainerCandidate(TailwindCandidate candidate) {
  final raw = candidate.utility.raw;
  final root = tailwindUtilityRoot(candidate.utility);
  return raw == 'flex' ||
      raw == 'inline-flex' ||
      raw == 'flex-row' ||
      raw == 'flex-col' ||
      raw.startsWith('items-') ||
      raw.startsWith('justify-') ||
      root == 'gap' ||
      root == 'gap-x' ||
      root == 'gap-y';
}

String tailwindUtilityRoot(TailwindUtility utility) {
  return switch (utility) {
    TailwindStaticUtility(:final root) => root,
    TailwindFunctionalUtility(:final root) => root,
    TailwindUnresolvedUtility(:final segments) =>
      segments.isEmpty ? utility.raw : segments.first,
    TailwindArbitraryProperty(:final property) => property,
  };
}

TailwindValue? tailwindUtilityValue(TailwindUtility utility) {
  return switch (utility) {
    TailwindFunctionalUtility(:final value) => value,
    _ => null,
  };
}

TailwindModifier? tailwindUtilityModifier(TailwindUtility utility) {
  return switch (utility) {
    TailwindFunctionalUtility(:final modifier) => modifier,
    TailwindUnresolvedUtility(:final modifier) => modifier,
    TailwindArbitraryProperty(:final modifier) => modifier,
    _ => null,
  };
}

bool tailwindUtilityNegative(TailwindUtility utility) {
  return switch (utility) {
    TailwindFunctionalUtility(:final negative) => negative,
    TailwindUnresolvedUtility(:final negative) => negative,
    _ => false,
  };
}

String? tailwindValueKey(TailwindValue? value) {
  return value is TailwindNamedValue ? value.raw : null;
}

const transitionTriggerTokens = {
  'transition',
  'transition-all',
  'transition-colors',
  'transition-opacity',
  'transition-shadow',
  'transition-transform',
};

const _easeTokens = {'ease-linear', 'ease-in', 'ease-out', 'ease-in-out'};

const _flexItemTokens = {
  'flex-1',
  'flex-auto',
  'flex-initial',
  'flex-none',
  'flex-shrink',
  'flex-shrink-0',
  'shrink',
  'shrink-0',
  'grow',
  'grow-0',
};

const sizingRoots = {'w', 'h', 'min-w', 'min-h', 'max-w', 'max-h'};

const _boxStylingRoots = {
  'p',
  'px',
  'py',
  'pt',
  'pr',
  'pb',
  'pl',
  'm',
  'mx',
  'my',
  'mt',
  'mr',
  'mb',
  'ml',
  'w',
  'h',
  'min-w',
  'min-h',
  'max-w',
  'max-h',
  'bg',
  'opacity',
  'blur',
  'shadow',
  'scale',
  'rotate',
  'translate-x',
  'translate-y',
};
