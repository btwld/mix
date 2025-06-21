part of 'toast.dart';

class ToastStyle extends SpecStyle<ToastSpecUtility> {
  const ToastStyle();

  @override
  Style makeStyle(SpecConfiguration<ToastSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = $.container
      ..borderRadius(6)
      ..color.white()
      ..border.all.color.black12()
      ..padding.all(16)
      ..margin.all(20)
      ..constraints.minWidth(300)
      ..flex.direction.horizontal()
      ..flex.mainAxisAlignment.start()
      ..flex.mainAxisSize.min()
      ..flex.gap(16);

    final titleSubtitleContainerStyle = $.titleSubtitleContainer.flex
      ..direction.vertical()
      ..crossAxisAlignment.start()
      ..gap(4)
      ..mainAxisSize.min();

    final titleStyle = $.title
      ..style.bold()
      ..style.fontSize(14);

    final subtitleStyle = $.subtitle
      ..style.fontSize(13)
      ..style.color.black54();

    return Style.create([
      containerStyle,
      titleSubtitleContainerStyle,
      titleStyle,
      subtitleStyle,
    ]);
  }
}

class ToastDarkStyle extends ToastStyle {
  const ToastDarkStyle();
  @override
  Style makeStyle(
    covariant SpecConfiguration<ToastSpecUtility<SpecAttribute>> spec,
  ) {
    final $ = spec.utilities;

    return Style.create([
      super.makeStyle(spec),
      $
        ..container.color.black()
        ..container.border.color.white30()
        ..subtitle.color.white70()
        ..title.color.white(),
    ]);
  }
}
