/// Typed Tailwind candidate syntax model.
library;

final class SourceSpan {
  const SourceSpan(this.start, this.end);

  final int start;
  final int end;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceSpan && start == other.start && end == other.end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'SourceSpan($start, $end)';
}

final class TailwindCandidate {
  const TailwindCandidate({
    required this.raw,
    required this.variants,
    required this.utility,
    required this.important,
    required this.span,
  });

  final String raw;
  final List<TailwindVariant> variants;
  final TailwindUtility utility;
  final bool important;
  final SourceSpan span;
}

sealed class TailwindUtility {
  const TailwindUtility();

  String get raw;
}

final class TailwindUnresolvedUtility extends TailwindUtility {
  const TailwindUnresolvedUtility({
    required this.raw,
    required this.segments,
    this.modifier,
    this.negative = false,
  });

  @override
  final String raw;
  final List<String> segments;
  final TailwindModifier? modifier;
  final bool negative;
}

final class TailwindStaticUtility extends TailwindUtility {
  const TailwindStaticUtility({required this.raw, required this.root});

  @override
  final String raw;
  final String root;
}

final class TailwindFunctionalUtility extends TailwindUtility {
  const TailwindFunctionalUtility({
    required this.raw,
    required this.root,
    required this.value,
    this.modifier,
    this.negative = false,
  });

  @override
  final String raw;
  final String root;
  final TailwindValue value;
  final TailwindModifier? modifier;
  final bool negative;
}

final class TailwindArbitraryProperty extends TailwindUtility {
  const TailwindArbitraryProperty({
    required this.raw,
    required this.property,
    required this.value,
    this.modifier,
  });

  @override
  final String raw;
  final String property;
  final String value;
  final TailwindModifier? modifier;
}

sealed class TailwindValue {
  const TailwindValue();

  String get raw;
}

final class TailwindNamedValue extends TailwindValue {
  const TailwindNamedValue(this.raw);

  @override
  final String raw;
}

final class TailwindArbitraryValue extends TailwindValue {
  const TailwindArbitraryValue({
    required this.raw,
    required this.value,
    this.typeHint,
  });

  @override
  final String raw;
  final String value;
  final String? typeHint;
}

final class TailwindCssVariableValue extends TailwindValue {
  const TailwindCssVariableValue({
    required this.raw,
    required this.variableName,
  });

  @override
  final String raw;
  final String variableName;
}

sealed class TailwindModifier {
  const TailwindModifier();

  String get raw;
}

final class TailwindNamedModifier extends TailwindModifier {
  const TailwindNamedModifier(this.raw);

  @override
  final String raw;
}

final class TailwindArbitraryModifier extends TailwindModifier {
  const TailwindArbitraryModifier({required this.raw, required this.value});

  @override
  final String raw;
  final String value;
}

final class TailwindCssVariableModifier extends TailwindModifier {
  const TailwindCssVariableModifier({
    required this.raw,
    required this.variableName,
  });

  @override
  final String raw;
  final String variableName;
}

sealed class TailwindVariant {
  const TailwindVariant();

  String get raw;
}

final class TailwindUnresolvedVariant extends TailwindVariant {
  const TailwindUnresolvedVariant({
    required this.raw,
    required this.segments,
    this.modifier,
  });

  @override
  final String raw;
  final List<String> segments;
  final TailwindModifier? modifier;
}

final class TailwindStaticVariant extends TailwindVariant {
  const TailwindStaticVariant({
    required this.raw,
    required this.root,
    this.modifier,
  });

  @override
  final String raw;
  final String root;
  final TailwindModifier? modifier;
}

final class TailwindFunctionalVariant extends TailwindVariant {
  const TailwindFunctionalVariant({
    required this.raw,
    required this.root,
    required this.value,
    this.modifier,
  });

  @override
  final String raw;
  final String root;
  final TailwindValue value;
  final TailwindModifier? modifier;
}

final class TailwindCompoundVariant extends TailwindVariant {
  const TailwindCompoundVariant({
    required this.raw,
    required this.root,
    required this.variant,
    this.modifier,
  });

  @override
  final String raw;
  final String root;
  final TailwindVariant variant;
  final TailwindModifier? modifier;
}

final class TailwindArbitraryVariant extends TailwindVariant {
  const TailwindArbitraryVariant({
    required this.raw,
    required this.selector,
    required this.relative,
  });

  @override
  final String raw;
  final String selector;
  final bool relative;
}
