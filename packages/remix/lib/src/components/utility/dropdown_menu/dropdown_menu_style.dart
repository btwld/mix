part of 'dropdown_menu.dart';

class DropdownMenuStyle extends SpecStyle<DropdownMenuSpecUtility> {
  static const itemLabel = Variant('item.label');

  const DropdownMenuStyle();

  @override
  Style makeStyle(SpecConfiguration<DropdownMenuSpecUtility> spec) {
    final $ = spec.utilities;

    final menuStyle = [
      $.menu.container.chain
        ..borderRadius(6)
        ..shadow.color.black.withOpacity(0.07)
        ..shadow.blurRadius(5)
        ..color.white()
        ..border.color.black12()
        ..padding.all(4)
        ..box.wrap.intrinsicWidth()
        ..box.wrap.transform.scale(0.95)
        ..box.wrap.opacity(0)
        ..box.wrap.padding.top(0)
        ..flex.mainAxisSize.min()
        ..flex.crossAxisAlignment.start(),
      $.menu.autoWidth.off(),
      spec.on.selected(
        $.menu.container.chain
          ..box.wrap.transform.scale(1)
          ..box.wrap.opacity(1)
          ..box.wrap.padding.top(4),
      ),
    ];

    final itemStyle = [
      $.item.container.chain
        ..borderRadius(6)
        ..padding.vertical(8)
        ..padding.horizontal(6)
        ..width.infinity()
        ..flex.gap(6),
      $.item.text.chain
        ..style.color.black()
        ..style.fontSize(14),
      $.item.icon.size(20),
      spec.on.hover($.item.container.color.black12()),
      itemLabel(
        $.item.container.borderRadius.all(0),
        $.item.text.style.bold(),
        spec.on.hover($.item.container.color.transparent()),
      ),
    ];

    return Style.create([...menuStyle, ...itemStyle]).animate(
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }
}

class DropdownMenuDarkStyle extends DropdownMenuStyle {
  const DropdownMenuDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<DropdownMenuSpecUtility> spec) {
    final $ = spec.utilities;

    final menuStyle = $.menu.container.chain
      ..color.black()
      ..border.all.color.white12();

    final itemStyle = $.item.text.style.color.white();

    return Style.create([
      super.makeStyle(spec).call(),
      menuStyle,
      itemStyle,
      spec.on.hover($.item.container.color.white12()),
    ]);
  }
}
