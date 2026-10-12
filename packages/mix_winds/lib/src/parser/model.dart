/// Typed Tailwind candidate syntax model.
library;

final class SourceSpan {
  final int start;

  final int end;
  const SourceSpan(this.start, this.end);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceSpan && start == other.start && end == other.end;

  @override
  String toString() => 'SourceSpan($start, $end)';

  @override
  int get hashCode => Object.hash(start, end);
}

final class TailwindCandidate {
  final String raw;

  final List<TailwindVariant> variants;
  final TailwindUtility utility;
  final bool important;
  const TailwindCandidate({
    required this.raw,
    required this.variants,
    required this.utility,
    required this.important,
  });
}

sealed class TailwindUtility {
  const TailwindUtility();

  String get raw;
}

final class TailwindUnresolvedUtility extends TailwindUtility {
  @override
  final String raw;

  final List<String> segments;
  final TailwindModifier? modifier;
  final bool negative;
  const TailwindUnresolvedUtility({
    required this.raw,
    required this.segments,
    this.modifier,
    this.negative = false,
  });
}

final class TailwindStaticUtility extends TailwindUtility {
  @override
  final String raw;

  final String root;
  const TailwindStaticUtility({required this.raw, required this.root});
}

final class TailwindFunctionalUtility extends TailwindUtility {
  @override
  final String raw;

  final String root;
  final TailwindValue value;
  final TailwindModifier? modifier;
  final bool negative;
  const TailwindFunctionalUtility({
    required this.raw,
    required this.root,
    required this.value,
    this.modifier,
    this.negative = false,
  });
}

final class TailwindArbitraryProperty extends TailwindUtility {
  @override
  final String raw;

  final String property;
  final String value;
  final TailwindModifier? modifier;
  const TailwindArbitraryProperty({
    required this.raw,
    required this.property,
    required this.value,
    this.modifier,
  });
}

sealed class TailwindValue {
  const TailwindValue();

  String get raw;
}

final class TailwindNamedValue extends TailwindValue {
  @override
  final String raw;

  const TailwindNamedValue(this.raw);
}

final class TailwindArbitraryValue extends TailwindValue {
  @override
  final String raw;

  final String value;
  final String? typeHint;
  const TailwindArbitraryValue({
    required this.raw,
    required this.value,
    this.typeHint,
  });
}

final class TailwindCssVariableValue extends TailwindValue {
  @override
  final String raw;

  final String variableName;
  const TailwindCssVariableValue({
    required this.raw,
    required this.variableName,
  });
}

sealed class TailwindModifier {
  const TailwindModifier();

  String get raw;
}

final class TailwindNamedModifier extends TailwindModifier {
  @override
  final String raw;

  const TailwindNamedModifier(this.raw);
}

final class TailwindArbitraryModifier extends TailwindModifier {
  @override
  final String raw;

  final String value;
  const TailwindArbitraryModifier({required this.raw, required this.value});
}

final class TailwindCssVariableModifier extends TailwindModifier {
  @override
  final String raw;

  final String variableName;
  const TailwindCssVariableModifier({
    required this.raw,
    required this.variableName,
  });
}

sealed class TailwindVariant {
  const TailwindVariant();

  String get raw;
}

final class TailwindUnresolvedVariant extends TailwindVariant {
  @override
  final String raw;

  final List<String> segments;
  final TailwindModifier? modifier;
  const TailwindUnresolvedVariant({
    required this.raw,
    required this.segments,
    this.modifier,
  });
}

final class TailwindStaticVariant extends TailwindVariant {
  @override
  final String raw;

  final String root;
  final TailwindModifier? modifier;
  const TailwindStaticVariant({
    required this.raw,
    required this.root,
    this.modifier,
  });
}

final class TailwindFunctionalVariant extends TailwindVariant {
  @override
  final String raw;

  final String root;
  final TailwindValue value;
  final TailwindModifier? modifier;
  const TailwindFunctionalVariant({
    required this.raw,
    required this.root,
    required this.value,
    this.modifier,
  });
}

final class TailwindCompoundVariant extends TailwindVariant {
  @override
  final String raw;

  final String root;
  final TailwindVariant variant;
  final TailwindModifier? modifier;
  const TailwindCompoundVariant({
    required this.raw,
    required this.root,
    required this.variant,
    this.modifier,
  });
}

final class TailwindArbitraryVariant extends TailwindVariant {
  @override
  final String raw;

  final String selector;
  final bool relative;
  const TailwindArbitraryVariant({
    required this.raw,
    required this.selector,
    required this.relative,
  });
}
