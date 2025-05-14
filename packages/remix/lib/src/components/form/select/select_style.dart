part of 'select.dart';

class SelectStyle extends SpecStyle<SelectSpecUtility> {
  const SelectStyle();

  @override
  Style makeStyle(SpecConfiguration<SelectSpecUtility> spec) {
    final $ = spec.utilities;

    final positionStyle = [
      $.position.targetAnchor.bottomCenter(),
      $.position.followerAnchor.topCenter(),
      $.position.offset(0, 4),
    ];

    final buttonStyle = [
      $.button.container.chain
        ..flex.mainAxisAlignment.spaceBetween()
        ..color.white()
        ..padding.all(10)
        ..border.color.black12()
        ..borderRadius(6),
      $.button.icon.chain
        ..size(20)
        ..color.black45(),
      $.button.label.chain
        ..style.fontSize(14)
        ..style.color.black(),
      spec.on.disabled(
        $.button.container.color(Colors.black.withOpacity(0.05)),
      ),
    ];

    final menuStyle = [
      $.menu.container.chain
        ..borderRadius(6)
        ..shadow.color(Colors.black.withOpacity(0.07))
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
      $.menu.wrap.transform.scale(1.5),
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
    ];

    return Style.create([
      ...itemStyle,
      ...buttonStyle,
      ...menuStyle,
      ...positionStyle,
    ]).animate(
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
    );
  }
}

class SelectDarkStyle extends SelectStyle {
  const SelectDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<SelectSpecUtility> spec) {
    final $ = spec.utilities;

    final buttonStyle = $.button.chain
      ..container.color.black()
      ..container.border.color.white12()
      ..icon.color.white54()
      ..label.style.color.white();

    final menuStyle = $.menu.container.chain
      ..color.black()
      ..border.all.color.white12();

    final itemStyle = $.item.text.style.color.white();

    return Style.create([
      super.makeStyle(spec).call(),
      buttonStyle,
      menuStyle,
      itemStyle,
      spec.on.hover($.item.container.color.white12()),
      spec.on.disabled($.button.container.color.white10()),
    ]).animate(
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
    );
  }
}
