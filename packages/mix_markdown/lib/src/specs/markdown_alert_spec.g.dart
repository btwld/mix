// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markdown_alert_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$MarkdownAlertSpec implements Spec<MarkdownAlertSpec>, Diagnosticable {
  StyleSpec<MarkdownAlertTypeSpec>? get note;
  StyleSpec<MarkdownAlertTypeSpec>? get tip;
  StyleSpec<MarkdownAlertTypeSpec>? get important;
  StyleSpec<MarkdownAlertTypeSpec>? get warning;
  StyleSpec<MarkdownAlertTypeSpec>? get caution;

  @override
  Type get type => MarkdownAlertSpec;

  @override
  MarkdownAlertSpec copyWith({
    StyleSpec<MarkdownAlertTypeSpec>? note,
    StyleSpec<MarkdownAlertTypeSpec>? tip,
    StyleSpec<MarkdownAlertTypeSpec>? important,
    StyleSpec<MarkdownAlertTypeSpec>? warning,
    StyleSpec<MarkdownAlertTypeSpec>? caution,
  }) {
    return MarkdownAlertSpec(
      note: note ?? this.note,
      tip: tip ?? this.tip,
      important: important ?? this.important,
      warning: warning ?? this.warning,
      caution: caution ?? this.caution,
    );
  }

  @override
  MarkdownAlertSpec lerp(MarkdownAlertSpec? other, double t) {
    return MarkdownAlertSpec(
      note: note?.lerp(other?.note, t),
      tip: tip?.lerp(other?.tip, t),
      important: important?.lerp(other?.important, t),
      warning: warning?.lerp(other?.warning, t),
      caution: caution?.lerp(other?.caution, t),
    );
  }

  @override
  List<Object?> get props => [note, tip, important, warning, caution];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MarkdownAlertSpec &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('note', note))
      ..add(DiagnosticsProperty('tip', tip))
      ..add(DiagnosticsProperty('important', important))
      ..add(DiagnosticsProperty('warning', warning))
      ..add(DiagnosticsProperty('caution', caution));
  }
}

@Deprecated(
  'Rename to `_\$MarkdownAlertSpec` and migrate the class declaration to `class MarkdownAlertSpec with _\$MarkdownAlertSpec`. The `_\$MarkdownAlertSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$MarkdownAlertSpecMethods = _$MarkdownAlertSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class MarkdownAlertStyler
    extends MixStyler<MarkdownAlertStyler, MarkdownAlertSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<MarkdownAlertTypeSpec>>? $note;
  final Prop<StyleSpec<MarkdownAlertTypeSpec>>? $tip;
  final Prop<StyleSpec<MarkdownAlertTypeSpec>>? $important;
  final Prop<StyleSpec<MarkdownAlertTypeSpec>>? $warning;
  final Prop<StyleSpec<MarkdownAlertTypeSpec>>? $caution;

  const MarkdownAlertStyler.create({
    Prop<StyleSpec<MarkdownAlertTypeSpec>>? note,
    Prop<StyleSpec<MarkdownAlertTypeSpec>>? tip,
    Prop<StyleSpec<MarkdownAlertTypeSpec>>? important,
    Prop<StyleSpec<MarkdownAlertTypeSpec>>? warning,
    Prop<StyleSpec<MarkdownAlertTypeSpec>>? caution,
    super.variants,
    super.modifier,
    super.animation,
  }) : $note = note,
       $tip = tip,
       $important = important,
       $warning = warning,
       $caution = caution;

  MarkdownAlertStyler({
    MarkdownAlertTypeStyler? note,
    MarkdownAlertTypeStyler? tip,
    MarkdownAlertTypeStyler? important,
    MarkdownAlertTypeStyler? warning,
    MarkdownAlertTypeStyler? caution,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<MarkdownAlertSpec>>? variants,
  }) : this.create(
         note: Prop.maybeMix(note),
         tip: Prop.maybeMix(tip),
         important: Prop.maybeMix(important),
         warning: Prop.maybeMix(warning),
         caution: Prop.maybeMix(caution),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory MarkdownAlertStyler.note(MarkdownAlertTypeStyler value) =>
      MarkdownAlertStyler().note(value);
  factory MarkdownAlertStyler.tip(MarkdownAlertTypeStyler value) =>
      MarkdownAlertStyler().tip(value);
  factory MarkdownAlertStyler.important(MarkdownAlertTypeStyler value) =>
      MarkdownAlertStyler().important(value);
  factory MarkdownAlertStyler.warning(MarkdownAlertTypeStyler value) =>
      MarkdownAlertStyler().warning(value);
  factory MarkdownAlertStyler.caution(MarkdownAlertTypeStyler value) =>
      MarkdownAlertStyler().caution(value);
  factory MarkdownAlertStyler.wrap(WidgetModifierConfig value) =>
      MarkdownAlertStyler().wrap(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'note',
    'tip',
    'important',
    'warning',
    'caution',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the note.
  MarkdownAlertStyler note(MarkdownAlertTypeStyler value) {
    return merge(MarkdownAlertStyler(note: value));
  }

  /// Sets the tip.
  MarkdownAlertStyler tip(MarkdownAlertTypeStyler value) {
    return merge(MarkdownAlertStyler(tip: value));
  }

  /// Sets the important.
  MarkdownAlertStyler important(MarkdownAlertTypeStyler value) {
    return merge(MarkdownAlertStyler(important: value));
  }

  /// Sets the warning.
  MarkdownAlertStyler warning(MarkdownAlertTypeStyler value) {
    return merge(MarkdownAlertStyler(warning: value));
  }

  /// Sets the caution.
  MarkdownAlertStyler caution(MarkdownAlertTypeStyler value) {
    return merge(MarkdownAlertStyler(caution: value));
  }

  /// Sets the animation configuration.
  /// [reverse] sets variant exit timing for curve or spring configs.
  @override
  MarkdownAlertStyler animate(
    AnimationConfig value, {
    AnimationConfig? reverse,
  }) {
    final config = reverse == null
        ? value
        : ReversibleAnimationConfig(forward: value, reverse: reverse);

    return merge(MarkdownAlertStyler(animation: config));
  }

  /// Sets the style variants.
  @override
  MarkdownAlertStyler variants(List<VariantStyle<MarkdownAlertSpec>> value) {
    return merge(MarkdownAlertStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  MarkdownAlertStyler wrap(WidgetModifierConfig value) {
    return merge(MarkdownAlertStyler(modifier: value));
  }

  /// Sets the widget modifier.
  MarkdownAlertStyler modifier(WidgetModifierConfig value) {
    return merge(MarkdownAlertStyler(modifier: value));
  }

  /// Merges with another [MarkdownAlertStyler].
  @override
  MarkdownAlertStyler merge(MarkdownAlertStyler? other) {
    return MarkdownAlertStyler.create(
      note: MixOps.merge($note, other?.$note),
      tip: MixOps.merge($tip, other?.$tip),
      important: MixOps.merge($important, other?.$important),
      warning: MixOps.merge($warning, other?.$warning),
      caution: MixOps.merge($caution, other?.$caution),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<MarkdownAlertSpec>] using [context].
  @override
  StyleSpec<MarkdownAlertSpec> resolve(BuildContext context) {
    final spec = MarkdownAlertSpec(
      note: MixOps.resolve(context, $note),
      tip: MixOps.resolve(context, $tip),
      important: MixOps.resolve(context, $important),
      warning: MixOps.resolve(context, $warning),
      caution: MixOps.resolve(context, $caution),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('note', $note))
      ..add(DiagnosticsProperty('tip', $tip))
      ..add(DiagnosticsProperty('important', $important))
      ..add(DiagnosticsProperty('warning', $warning))
      ..add(DiagnosticsProperty('caution', $caution));
  }

  @override
  List<Object?> get props => [
    $note,
    $tip,
    $important,
    $warning,
    $caution,
    $animation,
    $modifier,
    $variants,
  ];
}
