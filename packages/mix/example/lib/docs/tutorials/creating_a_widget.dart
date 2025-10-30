import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

// Button Spec Definition

class ButtonSpec extends Spec<ButtonSpec> {
  final StyleSpec<FlexBoxSpec>? container;
  final StyleSpec<IconSpec>? icon;
  final StyleSpec<TextSpec>? label;

  const ButtonSpec({this.container, this.icon, this.label});

  @override
  ButtonSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<IconSpec>? icon,
    StyleSpec<TextSpec>? label,
  }) {
    return ButtonSpec(
      container: container ?? this.container,
      icon: icon ?? this.icon,
      label: label ?? this.label,
    );
  }

  @override
  ButtonSpec lerp(covariant ButtonSpec? other, double t) {
    return ButtonSpec(
      container: container?.lerp(other?.container, t),
      icon: icon?.lerp(other?.icon, t),
      label: label?.lerp(other?.label, t),
    );
  }

  @override
  List<Object?> get props => [container, icon, label];
}

// Button Style

class ButtonStyler extends Style<ButtonSpec>
    with WidgetStateVariantMixin<ButtonStyler, ButtonSpec> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<StyleSpec<TextSpec>>? $label;

  ButtonStyler({
    FlexBoxStyler? container,
    IconStyler? icon,
    TextStyler? label,
    super.animation,
    super.modifier,
    super.variants,
  }) : $container = Prop.maybeMix(container),
       $icon = Prop.maybeMix(icon),
       $label = Prop.maybeMix(label);

  // Component Token
  ButtonStyler container(FlexBoxStyler value) {
    return merge(ButtonStyler(container: value));
  }

  ButtonStyler icon(IconStyler value) {
    return merge(ButtonStyler(icon: value));
  }

  ButtonStyler label(TextStyler value) {
    return merge(ButtonStyler(label: value));
  }

  ButtonStyler backgroundColor(Color value) {
    return merge(ButtonStyler(container: FlexBoxStyler().color(value)));
  }

  ButtonStyler textColor(Color value) {
    return merge(ButtonStyler(label: TextStyler().color(value)));
  }

  ButtonStyler iconColor(Color value) {
    return merge(ButtonStyler(icon: IconStyler().color(value)));
  }

  ButtonStyler fontSize(double value) {
    return merge(ButtonStyler(label: TextStyler().fontSize(value)));
  }

  ButtonStyler lineHeight(double value) {
    return merge(ButtonStyler(label: TextStyler().height(value)));
  }

  ButtonStyler borderWidth(double value) {
    return merge(
      ButtonStyler(container: FlexBoxStyler().borderAll(width: value)),
    );
  }

  ButtonStyler borderColor(Color value) {
    return merge(
      ButtonStyler(container: FlexBoxStyler().borderAll(color: value)),
    );
  }

  ButtonStyler borderRadius(double value) {
    return merge(ButtonStyler(container: FlexBoxStyler().borderRounded(value)));
  }

  ButtonStyler shadow(BoxShadowMix value) {
    return merge(ButtonStyler(container: FlexBoxStyler().shadow(value)));
  }

  ButtonStyler padding({required double x, required double y}) {
    return merge(
      ButtonStyler(container: FlexBoxStyler().paddingX(x).paddingY(y)),
    );
  }

  ButtonStyler scale(double value) {
    return merge(ButtonStyler(container: FlexBoxStyler().scale(value)));
  }

  ButtonStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<TextSpec>>? label,
    super.animation,
    super.modifier,
    super.variants,
  }) : $container = container,
       $icon = icon,
       $label = label;

  @override
  ButtonStyler merge(covariant ButtonStyler? other) {
    return ButtonStyler.create(
      container: MixOps.merge($container, other?.$container),
      icon: MixOps.merge($icon, other?.$icon),
      label: MixOps.merge($label, other?.$label),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      variants: MixOps.mergeVariants($variants, other?.$variants),
    );
  }

  @override
  List<Object?> get props => [$container, $icon, $label];

  @override
  StyleSpec<ButtonSpec> resolve(BuildContext context) {
    final container = MixOps.resolve(context, $container);
    final icon = MixOps.resolve(context, $icon);
    final label = MixOps.resolve(context, $label);

    return StyleSpec(
      spec: ButtonSpec(container: container, icon: icon, label: label),
    );
  }

  @override
  ButtonStyler variant(Variant variant, ButtonStyler style) {
    return merge(ButtonStyler(variants: [VariantStyle(variant, style)]));
  }
}

enum ButtonVariant {
  filled,
  outlined,
  elevated,
  link;

  ButtonStyler get _filledStyle => ButtonStyler()
      .backgroundColor(Colors.blueAccent)
      .textColor(Colors.white)
      .iconColor(Colors.white);

  ButtonStyler get _outlinedStyle => _filledStyle
      .container(
        FlexBoxStyler()
            .color(Colors.transparent)
            .borderAll(width: 1.5, color: Colors.blueAccent),
      )
      .backgroundColor(Colors.transparent)
      .borderWidth(1.5)
      .borderColor(Colors.blueAccent)
      .textColor(Colors.blueAccent)
      .iconColor(Colors.blueAccent);

  ButtonStyler get style {
    switch (this) {
      case ButtonVariant.filled:
        return _filledStyle;
      case ButtonVariant.outlined:
        return _outlinedStyle;
      case ButtonVariant.elevated:
        return _filledStyle.container(
          FlexBoxStyler().shadow(
            BoxShadowMix().color(Colors.blueAccent.shade700).offset(x: 0, y: 5),
          ),
        );
      case ButtonVariant.link:
        return _outlinedStyle.container(
          FlexBoxStyler()
              .borderAll(style: BorderStyle.none)
              .color(Colors.transparent),
        );
    }
  }
}

// Button Widget
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.disabled = false,
    this.icon,
    required this.onPressed,
    this.variant = ButtonVariant.filled,
    this.style,
  });

  final String label;
  final bool disabled;
  final IconData? icon;
  final ButtonVariant variant;
  final VoidCallback? onPressed;
  final ButtonStyler? style;

  ButtonStyler buttonStyle(ButtonStyler? style, ButtonVariant? variant) {
    final container = FlexBoxStyler()
        .borderRounded(6)
        .paddingX(8)
        .paddingY(12)
        .spacing(8)
        .mainAxisAlignment(MainAxisAlignment.center)
        .crossAxisAlignment(CrossAxisAlignment.center)
        .mainAxisSize(MainAxisSize.min);

    final label = TextStyler().style(
      TextStyleMix().fontSize(16).fontWeight(FontWeight.w500),
    );

    final icon = IconStyler().size(18);

    return ButtonStyler()
        .container(container)
        .label(label)
        .icon(icon)
        .merge(variant?.style)
        .onPressed(
          ButtonStyler()
              .container(FlexBoxStyler().color(Colors.blueAccent.shade400))
              .label(TextStyler().style(TextStyleMix().color(Colors.white)))
              .icon(IconStyler().color(Colors.white))
              .scale(0.9),
        )
        .onDisabled(
          ButtonStyler()
              .container(FlexBoxStyler().color(Colors.blueGrey.shade100))
              .label(
                TextStyler().style(
                  TextStyleMix().color(Colors.blueGrey.shade700),
                ),
              )
              .icon(IconStyler().color(Colors.blueGrey.shade700)),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPress: disabled ? null : onPressed,
      enabled: !disabled,
      child: StyleBuilder(
        style: buttonStyle(style, variant),
        builder: (context, spec) {
          return FlexBox(
            styleSpec: spec.container,
            children: [
              if (icon != null) StyledIcon(icon: icon, styleSpec: spec.icon),
              if (label.isNotEmpty) StyledText(label, styleSpec: spec.label),
            ],
          );
        },
      ),
    );
  }
}

// // Filled Style
// Style get _filledStyle => Style(
//   _container.color.ref(_mdPrimary),
//   _label.style.color.ref(_mdOnPrimary),
//   _icon.color.ref(_mdOnPrimary),
// );

// // Elevated Style
// Style get _elevatedStyle => Style(
//   _filledStyle(),
//   _container.shadow.offset(0, 5),
//   _container.shadow.color.ref(_mdPrimary),
//   _container.shadow.color.darken(20),
// );

// // Outlined Style
// Style get _outlinedStyle => Style(
//   _container.color.transparent(),
//   _container.border.width(1.5),
//   _container.border.color.ref(_mdPrimary),
//   _label.style.color.ref(_mdPrimary),
//   _icon.color.ref(_mdPrimary),
// );

// // Link Style
// Style get _linkStyle => Style(
//   _outlinedStyle(),
//   _container.border.style.none(),
//   _container.color(Colors.transparent),
// );

// // State Styles
// Style get _onDisabled => Style(
//   _container.color.desaturate(100),
//   _label.style.color.desaturate(100),
//   _icon.color.desaturate(100),
//   $with.opacity(0.5),
// );

// Style get _onHover => Style(
//   _container.color.brighten(10),
//   _label.style.color.brighten(10),
//   _icon.color.brighten(10),
// );

// Style get _onPress => Style(
//   _container.color.darken(10),
//   _icon.color.darken(10),
//   _label.style.color.darken(10),
//   $with.scale(0.9),
// );

// Complete Button Style

// Convenience Variant Widgets
final class FilledButton extends CustomButton {
  const FilledButton({
    super.key,
    required super.label,
    super.disabled = false,
    super.icon,
    required super.onPressed,
    super.style,
  }) : super(variant: ButtonVariant.filled);
}

final class OutlinedButton extends CustomButton {
  const OutlinedButton({
    super.key,
    required super.label,
    super.disabled = false,
    super.icon,
    required super.onPressed,
    super.style,
  }) : super(variant: ButtonVariant.outlined);
}

final class ElevatedButton extends CustomButton {
  const ElevatedButton({
    super.key,
    required super.label,
    super.disabled = false,
    super.icon,
    required super.onPressed,
    super.style,
  }) : super(variant: ButtonVariant.elevated);
}

final class LinkButton extends CustomButton {
  const LinkButton({
    super.key,
    required super.label,
    super.disabled = false,
    super.icon,
    required super.onPressed,
    super.style,
  }) : super(variant: ButtonVariant.link);
}

// Example App
class CreatingAWidgetExample extends StatelessWidget {
  const CreatingAWidgetExample({super.key});

  @override
  Widget build(BuildContext context) {
    final icon = Icons.favorite;

    return Scaffold(
      appBar: AppBar(title: const Text('Creating a Widget Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(label: 'Filled Button', icon: icon, onPressed: () {}),
            const SizedBox(height: 10),
            OutlinedButton(
              label: 'Outlined Button',
              icon: icon,
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              label: 'Elevated Button',
              icon: icon,
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            LinkButton(label: 'Link Button', icon: icon, onPressed: () {}),
            const SizedBox(height: 20),
            const Text(
              'Disabled State:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FilledButton(
              label: 'Disabled Button',
              icon: icon,
              disabled: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: const CreatingAWidgetExample()));
}
