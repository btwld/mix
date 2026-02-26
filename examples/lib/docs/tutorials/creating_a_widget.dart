// ignore_for_file: no-empty-block

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

  const ButtonStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<TextSpec>>? label,
    super.animation,
    super.modifier,
    super.variants,
  }) : $container = container,
       $icon = icon,
       $label = label;

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
    return merge(ButtonStyler(container: .color(value)));
  }

  ButtonStyler textColor(Color value) {
    return merge(ButtonStyler(label: .color(value)));
  }

  ButtonStyler iconColor(Color value) {
    return merge(ButtonStyler(icon: .color(value)));
  }

  ButtonStyler fontSize(double value) {
    return merge(ButtonStyler(label: .fontSize(value)));
  }

  ButtonStyler lineHeight(double value) {
    return merge(ButtonStyler(label: .height(value)));
  }

  ButtonStyler borderWidth(double value) {
    return merge(ButtonStyler(container: .border(.all(.width(value)))));
  }

  ButtonStyler borderColor(Color value) {
    return merge(ButtonStyler(container: .border(.all(.color(value)))));
  }

  ButtonStyler borderRadius(double value) {
    return merge(
      ButtonStyler(container: .borderRadius(BorderRadiusMix.circular(value))),
    );
  }

  ButtonStyler shadow(BoxShadowMix value) {
    return merge(ButtonStyler(container: .shadow(value)));
  }

  ButtonStyler padding({required double x, required double y}) {
    return merge(
      ButtonStyler(
        container: .padding(
          EdgeInsetsGeometryMix.symmetric(horizontal: x, vertical: y),
        ),
      ),
    );
  }

  ButtonStyler scale(double value) {
    return merge(ButtonStyler(container: .scale(value)));
  }

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

  @override
  List<Object?> get props => [$container, $icon, $label];
}

enum ButtonVariant {
  filled,
  outlined,
  elevated,
  link;

  ButtonStyler get _filledStyle => .new()
      .backgroundColor(Colors.blueAccent)
      .textColor(Colors.white)
      .iconColor(Colors.white);

  ButtonStyler get _outlinedStyle => _filledStyle
      .container(
        .color(
          Colors.transparent,
        ).border(.all(.color(Colors.blueAccent).width(1.5))),
      )
      .backgroundColor(Colors.transparent)
      .borderWidth(1.5)
      .borderColor(Colors.blueAccent)
      .textColor(Colors.blueAccent)
      .iconColor(Colors.blueAccent);

  ButtonStyler get style {
    switch (this) {
      case .filled:
        return _filledStyle;
      case .outlined:
        return _outlinedStyle;
      case .elevated:
        return _filledStyle.container(
          .shadow(.color(Colors.blueAccent.shade700).offset(x: 0, y: 5)),
        );
      case .link:
        return _outlinedStyle.container(
          .border(.all(.style(.none))).color(Colors.transparent),
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
    this.variant = .filled,
    this.style,
  });

  final String label;
  final bool disabled;
  final IconData? icon;
  final ButtonVariant variant;
  final VoidCallback? onPressed;
  final ButtonStyler? style;

  ButtonStyler buttonStyle(ButtonStyler? style, ButtonVariant? variant) {
    final container = FlexBoxStyler.borderRadius(.circular(6))
        .padding(.horizontal(8).vertical(12))
        .spacing(8)
        .mainAxisAlignment(.center)
        .crossAxisAlignment(.center)
        .mainAxisSize(.min);

    final label = TextStyler.style(TextStyleMix.fontSize(16).fontWeight(.w500));

    final icon = IconStyler.size(18);

    return ButtonStyler()
        .container(container)
        .label(label)
        .icon(icon)
        .merge(variant?.style)
        .onPressed(
          ButtonStyler()
              .container(.color(Colors.blueAccent.shade400))
              .label(.style(TextStyleMix.color(Colors.white)))
              .icon(.color(Colors.white))
              .scale(0.9),
        )
        .onDisabled(
          ButtonStyler()
              .container(.color(Colors.blueGrey.shade100))
              .label(.style(TextStyleMix.color(Colors.blueGrey.shade700)))
              .icon(.color(Colors.blueGrey.shade700)),
        )
        .merge(style);
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(
      enabled: !disabled,
      onPress: disabled ? null : onPressed,
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

final class FilledButton extends CustomButton {
  const FilledButton({
    super.key,
    required super.label,
    super.disabled = false,
    super.icon,
    required super.onPressed,
    super.style,
  }) : super(variant: .filled);
}

final class OutlinedButton extends CustomButton {
  const OutlinedButton({
    super.key,
    required super.label,
    super.disabled = false,
    super.icon,
    required super.onPressed,
    super.style,
  }) : super(variant: .outlined);
}

final class ElevatedButton extends CustomButton {
  const ElevatedButton({
    super.key,
    required super.label,
    super.disabled = false,
    super.icon,
    required super.onPressed,
    super.style,
  }) : super(variant: .elevated);
}

final class LinkButton extends CustomButton {
  const LinkButton({
    super.key,
    required super.label,
    super.disabled = false,
    super.icon,
    required super.onPressed,
    super.style,
  }) : super(variant: .link);
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
        padding: const .all(16.0),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .stretch,
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
              style: TextStyle(fontSize: 18, fontWeight: .bold),
            ),
            const SizedBox(height: 10),
            FilledButton(
              label: 'Disabled Button',
              disabled: true,
              icon: icon,
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
