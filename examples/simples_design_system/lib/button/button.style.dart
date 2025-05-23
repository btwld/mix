part of 'button.dart';

enum ButtonTypeVariant {
  primary(Variant('primary')),
  secondary(Variant('secondary')),
  destructive(Variant('destructive'));

  const ButtonTypeVariant(this.value);

  final Variant value;
}

enum ButtonSizeVariant {
  sm(Variant('sm')),
  md(Variant('md')),
  lg(Variant('lg'));

  const ButtonSizeVariant(this.value);

  final Variant value;

  String get name => value.name;
}

final _sm = ButtonSizeVariant.sm.value;
final _md = ButtonSizeVariant.md.value;
final _lg = ButtonSizeVariant.lg.value;

final _primary = ButtonTypeVariant.primary.value;
final _secondary = ButtonTypeVariant.secondary.value;
final _destructive = ButtonTypeVariant.destructive.value;

class SimpleButtonStyle extends ButtonStyle {
  const SimpleButtonStyle();

  @override
  Style makeStyle(SpecConfiguration<ButtonSpecUtility> spec) {
    final b = spec.utilities;

    final container = Style(
      b.container.chain
        ..flex.mainAxisSize.min()
        ..flex.gap(8)
        ..borderRadius.all(8),
      _sm(
        b.container.chain
          ..padding.horizontal(12)
          ..padding.vertical(8),
      ),
      _md(
        b.container.chain
          ..padding.horizontal(16)
          ..padding.vertical(10),
      ),
      _lg(
        b.container.chain
          ..padding.horizontal(32)
          ..padding.vertical(12),
      ),
    );

    final label = Style(
      b.chain
        ..label.fontSize(14)
        ..label.fontWeight(FontWeight.w500),
    );

    final icon = Style(
      b.icon.chain..size(16),
    );

    final color = Style(
      _primary(
        b.container.color.blueAccent(),
        b.icon.color.white(),
        b.label.color.white(),
        $on.hover(
          b.container.color.blueAccent.shade700(),
        ),
      ),
      _secondary(
        b.container.color.grey.shade200(),
        b.icon.color.black(),
        b.label.color.black(),
        $on.hover(
          b.container.color.grey.shade300(),
        ),
      ),
      _destructive(
        b.container.color.redAccent.shade400(),
        b.icon.color.white(),
        b.label.color.white(),
        $on.hover(
          b.container.color.redAccent.shade700(),
        ),
      ),
      b.container.wrap.opacity(1),
      $on.disabled(
        b.container.wrap.opacity(0.5),
      ),
    );

    return Style(
      container(),
      label(),
      icon(),
      color(),
    ).animate(
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }
}
