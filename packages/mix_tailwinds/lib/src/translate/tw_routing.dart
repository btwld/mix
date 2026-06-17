/// Candidate routing decisions for the translator.
library;

import '../parser/model.dart';

enum TwRouteKind { schemaValue, gradient, ignored, unsupported }

final class TwRoute {
  const TwRoute(this.kind, {this.reason});

  final TwRouteKind kind;
  final String? reason;
}

TwRoute routeCandidate(TailwindCandidate candidate) {
  if (_hasIgnoredVariant(candidate.variants)) {
    return const TwRoute(TwRouteKind.ignored, reason: 'unsupported variant');
  }
  if (_hasUnsupportedVariant(candidate.variants)) {
    return const TwRoute(TwRouteKind.unsupported, reason: 'unknown variant');
  }

  final utility = candidate.utility;
  final raw = utility.raw;
  if (utility is TailwindArbitraryProperty) {
    return const TwRoute(TwRouteKind.ignored, reason: 'arbitrary property');
  }
  if (candidate.important) {
    return const TwRoute(TwRouteKind.ignored, reason: 'important modifier');
  }
  if (_isGradientToken(raw)) return const TwRoute(TwRouteKind.gradient);
  if (utility is TailwindUnresolvedUtility) {
    return const TwRoute(TwRouteKind.unsupported);
  }

  return const TwRoute(TwRouteKind.schemaValue);
}

bool _hasIgnoredVariant(List<TailwindVariant> variants) {
  for (final variant in variants) {
    if (variant is TailwindArbitraryVariant) return true;
    if (variant is TailwindFunctionalVariant && variant.root.startsWith('@')) {
      return true;
    }
    if (variant is TailwindCompoundVariant) {
      if (variant.root == 'group' || variant.root == 'peer') return true;
      if (_hasIgnoredVariant([variant.variant])) return true;
    }
  }

  return false;
}

bool _hasUnsupportedVariant(List<TailwindVariant> variants) {
  for (final variant in variants) {
    if (variant is TailwindUnresolvedVariant) return true;
    if (variant is TailwindCompoundVariant &&
        _hasUnsupportedVariant([variant.variant])) {
      return true;
    }
  }

  return false;
}

bool _isGradientToken(String raw) {
  final base = raw.startsWith('-') ? raw.substring(1) : raw;
  return base.startsWith('bg-gradient-') ||
      base.startsWith('bg-linear-') ||
      base.startsWith('from-') ||
      base.startsWith('via-') ||
      base.startsWith('to-');
}
