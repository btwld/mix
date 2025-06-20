// ignore_for_file: camel_case_types

part of 'segmented_control.dart';

class SegmentedControlStyle extends SpecStyle<SegmentedControlSpecUtility> {
  const SegmentedControlStyle();

  @override
  Style makeStyle(SpecConfiguration<SegmentedControlSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = [
      $.container
        ..wrap.intrinsicHeight()
        ..padding.all(4)
        ..borderRadius.all(8)
        ..color(Colors.black.withValues(alpha: 0.07)),
    ];

    final dividerStyle = [
      $.divider
        ..width(1)
        ..margin.vertical(4)
        ..color.black26(),
      $.showDivider.off(),
    ];

    final flexStyle = $.flex
      ..row()
      ..mainAxisSize.min();

    final itemStyle = [
      $.item.label
        ..style.color(Colors.black.withValues(alpha: 0.6))
        ..style.fontSize(14),
      $.item.icon
        ..size(20)
        ..color(Colors.black.withValues(alpha: 0.6)),
      $.item.container
        ..padding.vertical(6)
        ..padding.horizontal(12)
        ..borderRadius.all(6),
      spec.on.selected(
        $.item.container
          ..color.white()
          ..shadow.color(Colors.black.withValues(alpha: 0.1))
          ..shadow.offset(0, 2)
          ..shadow.spreadRadius(1)
          ..shadow.blurRadius(4),
        $.item
          ..icon.color(Colors.black.withValues(alpha: 1))
          ..label.style.color(Colors.black.withValues(alpha: 1)),
      ),
    ];

    return Style.create([
      ...containerStyle,
      ...dividerStyle,
      flexStyle,
      ...itemStyle,
    ]);
  }
}

class SegmentedControlDarkStyle extends SegmentedControlStyle {
  const SegmentedControlDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<SegmentedControlSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([
      super.makeStyle(spec),
      $.container.color.white12(),
      $.item.label.style.color.white38(),
      spec.on.selected(
        $.item.container.color.black(),
        $.item.label.style.color.white(),
      ),
    ]);
  }
}
