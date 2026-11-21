// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markdown_alert_type_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$MarkdownAlertTypeSpec
    implements Spec<MarkdownAlertTypeSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get container;
  StyleSpec<FlexBoxSpec>? get header;
  StyleSpec<IconSpec>? get icon;
  StyleSpec<TextSpec>? get title;
  String? get label;

  @override
  Type get type => MarkdownAlertTypeSpec;

  @override
  MarkdownAlertTypeSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<FlexBoxSpec>? header,
    StyleSpec<IconSpec>? icon,
    StyleSpec<TextSpec>? title,
    String? label,
  }) {
    return MarkdownAlertTypeSpec(
      container: container ?? this.container,
      header: header ?? this.header,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      label: label ?? this.label,
    );
  }

  @override
  MarkdownAlertTypeSpec lerp(MarkdownAlertTypeSpec? other, double t) {
    return MarkdownAlertTypeSpec(
      container: container?.lerp(other?.container, t),
      header: header?.lerp(other?.header, t),
      icon: icon?.lerp(other?.icon, t),
      title: title?.lerp(other?.title, t),
      label: MixOps.lerpSnap(label, other?.label, t),
    );
  }

  @override
  List<Object?> get props => [container, header, icon, title, label];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MarkdownAlertTypeSpec &&
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
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('header', header))
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('title', title))
      ..add(StringProperty('label', label));
  }
}

@Deprecated(
  'Rename to `_\$MarkdownAlertTypeSpec` and migrate the class declaration to `class MarkdownAlertTypeSpec with _\$MarkdownAlertTypeSpec`. The `_\$MarkdownAlertTypeSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$MarkdownAlertTypeSpecMethods = _$MarkdownAlertTypeSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class MarkdownAlertTypeStyler
    extends MixStyler<MarkdownAlertTypeStyler, MarkdownAlertTypeSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<FlexBoxSpec>>? $header;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<StyleSpec<TextSpec>>? $title;
  final Prop<String>? $label;

  const MarkdownAlertTypeStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<FlexBoxSpec>>? header,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<TextSpec>>? title,
    Prop<String>? label,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $header = header,
       $icon = icon,
       $title = title,
       $label = label;

  MarkdownAlertTypeStyler({
    BoxStyler? container,
    FlexBoxStyler? header,
    IconStyler? icon,
    TextStyler? title,
    String? label,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<MarkdownAlertTypeSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         header: Prop.maybeMix(header),
         icon: Prop.maybeMix(icon),
         title: Prop.maybeMix(title),
         label: Prop.maybe(label),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory MarkdownAlertTypeStyler.container(BoxStyler value) =>
      MarkdownAlertTypeStyler().container(value);
  factory MarkdownAlertTypeStyler.header(FlexBoxStyler value) =>
      MarkdownAlertTypeStyler().header(value);
  factory MarkdownAlertTypeStyler.icon(IconStyler value) =>
      MarkdownAlertTypeStyler().icon(value);
  factory MarkdownAlertTypeStyler.title(TextStyler value) =>
      MarkdownAlertTypeStyler().title(value);
  factory MarkdownAlertTypeStyler.label(String value) =>
      MarkdownAlertTypeStyler().label(value);
  factory MarkdownAlertTypeStyler.wrap(WidgetModifierConfig value) =>
      MarkdownAlertTypeStyler().wrap(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'header',
    'icon',
    'title',
    'label',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  MarkdownAlertTypeStyler container(BoxStyler value) {
    return merge(MarkdownAlertTypeStyler(container: value));
  }

  /// Sets the header.
  MarkdownAlertTypeStyler header(FlexBoxStyler value) {
    return merge(MarkdownAlertTypeStyler(header: value));
  }

  /// Sets the icon.
  MarkdownAlertTypeStyler icon(IconStyler value) {
    return merge(MarkdownAlertTypeStyler(icon: value));
  }

  /// Sets the title.
  MarkdownAlertTypeStyler title(TextStyler value) {
    return merge(MarkdownAlertTypeStyler(title: value));
  }

  /// Sets the label.
  MarkdownAlertTypeStyler label(String value) {
    return merge(MarkdownAlertTypeStyler(label: value));
  }

  /// Sets the animation configuration.
  @override
  MarkdownAlertTypeStyler animate(AnimationConfig value) {
    return merge(MarkdownAlertTypeStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  MarkdownAlertTypeStyler variants(
    List<VariantStyle<MarkdownAlertTypeSpec>> value,
  ) {
    return merge(MarkdownAlertTypeStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  MarkdownAlertTypeStyler wrap(WidgetModifierConfig value) {
    return merge(MarkdownAlertTypeStyler(modifier: value));
  }

  /// Sets the widget modifier.
  MarkdownAlertTypeStyler modifier(WidgetModifierConfig value) {
    return merge(MarkdownAlertTypeStyler(modifier: value));
  }

  /// Merges with another [MarkdownAlertTypeStyler].
  @override
  MarkdownAlertTypeStyler merge(MarkdownAlertTypeStyler? other) {
    return MarkdownAlertTypeStyler.create(
      container: MixOps.merge($container, other?.$container),
      header: MixOps.merge($header, other?.$header),
      icon: MixOps.merge($icon, other?.$icon),
      title: MixOps.merge($title, other?.$title),
      label: MixOps.merge($label, other?.$label),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<MarkdownAlertTypeSpec>] using [context].
  @override
  StyleSpec<MarkdownAlertTypeSpec> resolve(BuildContext context) {
    final spec = MarkdownAlertTypeSpec(
      container: MixOps.resolve(context, $container),
      header: MixOps.resolve(context, $header),
      icon: MixOps.resolve(context, $icon),
      title: MixOps.resolve(context, $title),
      label: MixOps.resolve(context, $label),
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
      ..add(DiagnosticsProperty('container', $container))
      ..add(DiagnosticsProperty('header', $header))
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('title', $title))
      ..add(DiagnosticsProperty('label', $label));
  }

  @override
  List<Object?> get props => [
    $container,
    $header,
    $icon,
    $title,
    $label,
    $animation,
    $modifier,
    $variants,
  ];
}
