// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markdown_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$MarkdownSpec implements Spec<MarkdownSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get container;
  double? get blockSpacing;
  StyleSpec<TextSpec>? get paragraph;
  StyleSpec<TextSpec>? get h1;
  StyleSpec<TextSpec>? get h2;
  StyleSpec<TextSpec>? get h3;
  StyleSpec<TextSpec>? get h4;
  StyleSpec<TextSpec>? get h5;
  StyleSpec<TextSpec>? get h6;
  StyleSpec<TextSpec>? get strong;
  StyleSpec<TextSpec>? get emphasis;
  StyleSpec<TextSpec>? get strikethrough;
  StyleSpec<TextSpec>? get code;
  StyleSpec<TextSpec>? get link;
  StyleSpec<MarkdownAlertSpec>? get alert;

  @override
  Type get type => MarkdownSpec;

  @override
  MarkdownSpec copyWith({
    StyleSpec<BoxSpec>? container,
    double? blockSpacing,
    StyleSpec<TextSpec>? paragraph,
    StyleSpec<TextSpec>? h1,
    StyleSpec<TextSpec>? h2,
    StyleSpec<TextSpec>? h3,
    StyleSpec<TextSpec>? h4,
    StyleSpec<TextSpec>? h5,
    StyleSpec<TextSpec>? h6,
    StyleSpec<TextSpec>? strong,
    StyleSpec<TextSpec>? emphasis,
    StyleSpec<TextSpec>? strikethrough,
    StyleSpec<TextSpec>? code,
    StyleSpec<TextSpec>? link,
    StyleSpec<MarkdownAlertSpec>? alert,
  }) {
    return MarkdownSpec(
      container: container ?? this.container,
      blockSpacing: blockSpacing ?? this.blockSpacing,
      paragraph: paragraph ?? this.paragraph,
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      h4: h4 ?? this.h4,
      h5: h5 ?? this.h5,
      h6: h6 ?? this.h6,
      strong: strong ?? this.strong,
      emphasis: emphasis ?? this.emphasis,
      strikethrough: strikethrough ?? this.strikethrough,
      code: code ?? this.code,
      link: link ?? this.link,
      alert: alert ?? this.alert,
    );
  }

  @override
  MarkdownSpec lerp(MarkdownSpec? other, double t) {
    return MarkdownSpec(
      container: container?.lerp(other?.container, t),
      blockSpacing: MixOps.lerp(blockSpacing, other?.blockSpacing, t),
      paragraph: paragraph?.lerp(other?.paragraph, t),
      h1: h1?.lerp(other?.h1, t),
      h2: h2?.lerp(other?.h2, t),
      h3: h3?.lerp(other?.h3, t),
      h4: h4?.lerp(other?.h4, t),
      h5: h5?.lerp(other?.h5, t),
      h6: h6?.lerp(other?.h6, t),
      strong: strong?.lerp(other?.strong, t),
      emphasis: emphasis?.lerp(other?.emphasis, t),
      strikethrough: strikethrough?.lerp(other?.strikethrough, t),
      code: code?.lerp(other?.code, t),
      link: link?.lerp(other?.link, t),
      alert: alert?.lerp(other?.alert, t),
    );
  }

  @override
  List<Object?> get props => [
    container,
    blockSpacing,
    paragraph,
    h1,
    h2,
    h3,
    h4,
    h5,
    h6,
    strong,
    emphasis,
    strikethrough,
    code,
    link,
    alert,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MarkdownSpec &&
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
      ..add(DoubleProperty('blockSpacing', blockSpacing))
      ..add(DiagnosticsProperty('paragraph', paragraph))
      ..add(DiagnosticsProperty('h1', h1))
      ..add(DiagnosticsProperty('h2', h2))
      ..add(DiagnosticsProperty('h3', h3))
      ..add(DiagnosticsProperty('h4', h4))
      ..add(DiagnosticsProperty('h5', h5))
      ..add(DiagnosticsProperty('h6', h6))
      ..add(DiagnosticsProperty('strong', strong))
      ..add(DiagnosticsProperty('emphasis', emphasis))
      ..add(DiagnosticsProperty('strikethrough', strikethrough))
      ..add(DiagnosticsProperty('code', code))
      ..add(DiagnosticsProperty('link', link))
      ..add(DiagnosticsProperty('alert', alert));
  }
}

@Deprecated(
  'Rename to `_\$MarkdownSpec` and migrate the class declaration to `class MarkdownSpec with _\$MarkdownSpec`. The `_\$MarkdownSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$MarkdownSpecMethods = _$MarkdownSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class MarkdownStyler extends MixStyler<MarkdownStyler, MarkdownSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<double>? $blockSpacing;
  final Prop<StyleSpec<TextSpec>>? $paragraph;
  final Prop<StyleSpec<TextSpec>>? $h1;
  final Prop<StyleSpec<TextSpec>>? $h2;
  final Prop<StyleSpec<TextSpec>>? $h3;
  final Prop<StyleSpec<TextSpec>>? $h4;
  final Prop<StyleSpec<TextSpec>>? $h5;
  final Prop<StyleSpec<TextSpec>>? $h6;
  final Prop<StyleSpec<TextSpec>>? $strong;
  final Prop<StyleSpec<TextSpec>>? $emphasis;
  final Prop<StyleSpec<TextSpec>>? $strikethrough;
  final Prop<StyleSpec<TextSpec>>? $code;
  final Prop<StyleSpec<TextSpec>>? $link;
  final Prop<StyleSpec<MarkdownAlertSpec>>? $alert;

  const MarkdownStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<double>? blockSpacing,
    Prop<StyleSpec<TextSpec>>? paragraph,
    Prop<StyleSpec<TextSpec>>? h1,
    Prop<StyleSpec<TextSpec>>? h2,
    Prop<StyleSpec<TextSpec>>? h3,
    Prop<StyleSpec<TextSpec>>? h4,
    Prop<StyleSpec<TextSpec>>? h5,
    Prop<StyleSpec<TextSpec>>? h6,
    Prop<StyleSpec<TextSpec>>? strong,
    Prop<StyleSpec<TextSpec>>? emphasis,
    Prop<StyleSpec<TextSpec>>? strikethrough,
    Prop<StyleSpec<TextSpec>>? code,
    Prop<StyleSpec<TextSpec>>? link,
    Prop<StyleSpec<MarkdownAlertSpec>>? alert,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $blockSpacing = blockSpacing,
       $paragraph = paragraph,
       $h1 = h1,
       $h2 = h2,
       $h3 = h3,
       $h4 = h4,
       $h5 = h5,
       $h6 = h6,
       $strong = strong,
       $emphasis = emphasis,
       $strikethrough = strikethrough,
       $code = code,
       $link = link,
       $alert = alert;

  MarkdownStyler({
    BoxStyler? container,
    double? blockSpacing,
    TextStyler? paragraph,
    TextStyler? h1,
    TextStyler? h2,
    TextStyler? h3,
    TextStyler? h4,
    TextStyler? h5,
    TextStyler? h6,
    TextStyler? strong,
    TextStyler? emphasis,
    TextStyler? strikethrough,
    TextStyler? code,
    TextStyler? link,
    MarkdownAlertStyler? alert,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<MarkdownSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         blockSpacing: Prop.maybe(blockSpacing),
         paragraph: Prop.maybeMix(paragraph),
         h1: Prop.maybeMix(h1),
         h2: Prop.maybeMix(h2),
         h3: Prop.maybeMix(h3),
         h4: Prop.maybeMix(h4),
         h5: Prop.maybeMix(h5),
         h6: Prop.maybeMix(h6),
         strong: Prop.maybeMix(strong),
         emphasis: Prop.maybeMix(emphasis),
         strikethrough: Prop.maybeMix(strikethrough),
         code: Prop.maybeMix(code),
         link: Prop.maybeMix(link),
         alert: Prop.maybeMix(alert),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory MarkdownStyler.container(BoxStyler value) =>
      MarkdownStyler().container(value);
  factory MarkdownStyler.blockSpacing(double value) =>
      MarkdownStyler().blockSpacing(value);
  factory MarkdownStyler.paragraph(TextStyler value) =>
      MarkdownStyler().paragraph(value);
  factory MarkdownStyler.h1(TextStyler value) => MarkdownStyler().h1(value);
  factory MarkdownStyler.h2(TextStyler value) => MarkdownStyler().h2(value);
  factory MarkdownStyler.h3(TextStyler value) => MarkdownStyler().h3(value);
  factory MarkdownStyler.h4(TextStyler value) => MarkdownStyler().h4(value);
  factory MarkdownStyler.h5(TextStyler value) => MarkdownStyler().h5(value);
  factory MarkdownStyler.h6(TextStyler value) => MarkdownStyler().h6(value);
  factory MarkdownStyler.strong(TextStyler value) =>
      MarkdownStyler().strong(value);
  factory MarkdownStyler.emphasis(TextStyler value) =>
      MarkdownStyler().emphasis(value);
  factory MarkdownStyler.strikethrough(TextStyler value) =>
      MarkdownStyler().strikethrough(value);
  factory MarkdownStyler.code(TextStyler value) => MarkdownStyler().code(value);
  factory MarkdownStyler.link(TextStyler value) => MarkdownStyler().link(value);
  factory MarkdownStyler.alert(MarkdownAlertStyler value) =>
      MarkdownStyler().alert(value);
  factory MarkdownStyler.wrap(WidgetModifierConfig value) =>
      MarkdownStyler().wrap(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'blockSpacing',
    'paragraph',
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'strong',
    'emphasis',
    'strikethrough',
    'code',
    'link',
    'alert',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  MarkdownStyler container(BoxStyler value) {
    return merge(MarkdownStyler(container: value));
  }

  /// Sets the blockSpacing.
  MarkdownStyler blockSpacing(double value) {
    return merge(MarkdownStyler(blockSpacing: value));
  }

  /// Sets the paragraph.
  MarkdownStyler paragraph(TextStyler value) {
    return merge(MarkdownStyler(paragraph: value));
  }

  /// Sets the h1.
  MarkdownStyler h1(TextStyler value) {
    return merge(MarkdownStyler(h1: value));
  }

  /// Sets the h2.
  MarkdownStyler h2(TextStyler value) {
    return merge(MarkdownStyler(h2: value));
  }

  /// Sets the h3.
  MarkdownStyler h3(TextStyler value) {
    return merge(MarkdownStyler(h3: value));
  }

  /// Sets the h4.
  MarkdownStyler h4(TextStyler value) {
    return merge(MarkdownStyler(h4: value));
  }

  /// Sets the h5.
  MarkdownStyler h5(TextStyler value) {
    return merge(MarkdownStyler(h5: value));
  }

  /// Sets the h6.
  MarkdownStyler h6(TextStyler value) {
    return merge(MarkdownStyler(h6: value));
  }

  /// Sets the strong.
  MarkdownStyler strong(TextStyler value) {
    return merge(MarkdownStyler(strong: value));
  }

  /// Sets the emphasis.
  MarkdownStyler emphasis(TextStyler value) {
    return merge(MarkdownStyler(emphasis: value));
  }

  /// Sets the strikethrough.
  MarkdownStyler strikethrough(TextStyler value) {
    return merge(MarkdownStyler(strikethrough: value));
  }

  /// Sets the code.
  MarkdownStyler code(TextStyler value) {
    return merge(MarkdownStyler(code: value));
  }

  /// Sets the link.
  MarkdownStyler link(TextStyler value) {
    return merge(MarkdownStyler(link: value));
  }

  /// Sets the alert.
  MarkdownStyler alert(MarkdownAlertStyler value) {
    return merge(MarkdownStyler(alert: value));
  }

  /// Sets the animation configuration.
  @override
  MarkdownStyler animate(AnimationConfig value) {
    return merge(MarkdownStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  MarkdownStyler variants(List<VariantStyle<MarkdownSpec>> value) {
    return merge(MarkdownStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  MarkdownStyler wrap(WidgetModifierConfig value) {
    return merge(MarkdownStyler(modifier: value));
  }

  /// Sets the widget modifier.
  MarkdownStyler modifier(WidgetModifierConfig value) {
    return merge(MarkdownStyler(modifier: value));
  }

  MixMarkdown call({
    Key? key,
    required String data,
    MarkdownSyntax syntax = const MarkdownSyntax(),
    MarkdownBlockWrapper? wrapBlock,
    MarkdownUnsupportedBuilder? unsupportedBuilder,
  }) {
    return MixMarkdown(
      key: key,
      style: this,
      data: data,
      syntax: syntax,
      wrapBlock: wrapBlock,
      unsupportedBuilder: unsupportedBuilder,
    );
  }

  /// Merges with another [MarkdownStyler].
  @override
  MarkdownStyler merge(MarkdownStyler? other) {
    return MarkdownStyler.create(
      container: MixOps.merge($container, other?.$container),
      blockSpacing: MixOps.merge($blockSpacing, other?.$blockSpacing),
      paragraph: MixOps.merge($paragraph, other?.$paragraph),
      h1: MixOps.merge($h1, other?.$h1),
      h2: MixOps.merge($h2, other?.$h2),
      h3: MixOps.merge($h3, other?.$h3),
      h4: MixOps.merge($h4, other?.$h4),
      h5: MixOps.merge($h5, other?.$h5),
      h6: MixOps.merge($h6, other?.$h6),
      strong: MixOps.merge($strong, other?.$strong),
      emphasis: MixOps.merge($emphasis, other?.$emphasis),
      strikethrough: MixOps.merge($strikethrough, other?.$strikethrough),
      code: MixOps.merge($code, other?.$code),
      link: MixOps.merge($link, other?.$link),
      alert: MixOps.merge($alert, other?.$alert),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<MarkdownSpec>] using [context].
  @override
  StyleSpec<MarkdownSpec> resolve(BuildContext context) {
    final spec = MarkdownSpec(
      container: MixOps.resolve(context, $container),
      blockSpacing: MixOps.resolve(context, $blockSpacing),
      paragraph: MixOps.resolve(context, $paragraph),
      h1: MixOps.resolve(context, $h1),
      h2: MixOps.resolve(context, $h2),
      h3: MixOps.resolve(context, $h3),
      h4: MixOps.resolve(context, $h4),
      h5: MixOps.resolve(context, $h5),
      h6: MixOps.resolve(context, $h6),
      strong: MixOps.resolve(context, $strong),
      emphasis: MixOps.resolve(context, $emphasis),
      strikethrough: MixOps.resolve(context, $strikethrough),
      code: MixOps.resolve(context, $code),
      link: MixOps.resolve(context, $link),
      alert: MixOps.resolve(context, $alert),
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
      ..add(DiagnosticsProperty('blockSpacing', $blockSpacing))
      ..add(DiagnosticsProperty('paragraph', $paragraph))
      ..add(DiagnosticsProperty('h1', $h1))
      ..add(DiagnosticsProperty('h2', $h2))
      ..add(DiagnosticsProperty('h3', $h3))
      ..add(DiagnosticsProperty('h4', $h4))
      ..add(DiagnosticsProperty('h5', $h5))
      ..add(DiagnosticsProperty('h6', $h6))
      ..add(DiagnosticsProperty('strong', $strong))
      ..add(DiagnosticsProperty('emphasis', $emphasis))
      ..add(DiagnosticsProperty('strikethrough', $strikethrough))
      ..add(DiagnosticsProperty('code', $code))
      ..add(DiagnosticsProperty('link', $link))
      ..add(DiagnosticsProperty('alert', $alert));
  }

  @override
  List<Object?> get props => [
    $container,
    $blockSpacing,
    $paragraph,
    $h1,
    $h2,
    $h3,
    $h4,
    $h5,
    $h6,
    $strong,
    $emphasis,
    $strikethrough,
    $code,
    $link,
    $alert,
    $animation,
    $modifier,
    $variants,
  ];
}
