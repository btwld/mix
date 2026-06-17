/// Target inference helpers shared by parser facade and widgets.
library;

import '../parser/candidate_parser.dart';
import '../parser/data/parser_registry.g.dart';
import '../parser/diagnostics.dart';
import '../parser/model.dart';
import 'tw_routing.dart';

enum TwTarget { box, flexBox, text }

final _parser = TailwindCandidateParser(
  registry: defaultTailwindParserRegistry,
);
final _whitespaceRegex = RegExp(r'\s+');

bool hasBoxUtilities(
  String classNames, {
  required Map<String, double> breakpoints,
}) {
  for (final candidate in _parseCandidates(classNames)) {
    final route = routeCandidate(candidate, breakpoints: breakpoints);
    if (route.kind == TwRouteKind.ignored ||
        route.kind == TwRouteKind.unsupported) {
      continue;
    }
    if (isBoxStylingCandidate(candidate)) return true;
  }

  return false;
}

bool wantsFlex(Set<String> tokens, {required Map<String, double> breakpoints}) {
  for (final token in tokens) {
    final candidate = _parseCandidate(token);
    if (candidate == null) continue;

    final route = routeCandidate(candidate, breakpoints: breakpoints);
    if (route.kind == TwRouteKind.ignored ||
        route.kind == TwRouteKind.unsupported) {
      continue;
    }
    if (isFlexContainerCandidate(candidate)) return true;
  }

  return false;
}

Iterable<TailwindCandidate> _parseCandidates(String classNames) sync* {
  final trimmed = classNames.trim();
  if (trimmed.isEmpty) return;
  for (final token in trimmed.split(_whitespaceRegex)) {
    final candidate = _parseCandidate(token);
    if (candidate != null) yield candidate;
  }
}

TailwindCandidate? _parseCandidate(String token) {
  final parsed = _parser.parseCandidate(token);
  return switch (parsed) {
    TailwindParseSuccess(:final candidate) => candidate,
    TailwindParseFailure() => null,
  };
}
