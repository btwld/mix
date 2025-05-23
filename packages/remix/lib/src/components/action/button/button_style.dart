part of 'button.dart';

class RxButtonStyle extends SpecStyle<ButtonSpecUtility> {
  const RxButtonStyle();

  @override
  Style makeStyle(SpecConfiguration<ButtonSpecUtility> spec) {
    final $ = spec.utilities;

    final iconStyle = [$.icon.size(18), $.icon.color.white()];

    final labelStyle = [
      $.textStyle.fontSize(14),
      $.textStyle.height(1.5),
      $.textStyle.color.white(),
      $.textStyle.fontWeight.w500(),
    ];

    final spinnerStyle = [
      $.spinner.chain
        ..strokeWidth(0.9)
        ..size(15)
        ..color.white(),
    ];

    final flexboxStyle = [
      $.container.chain
        ..borderRadius(6)
        ..color.black()
        ..padding.vertical(8)
        ..padding.horizontal(12),
      spec.on.disabled($.container.color.grey.shade400()),
    ];

    final darkStyle = Style(
      $on.dark($.container.color.black(), $.textStyle.color.white()),
    );

    return Style.create([
      ...flexboxStyle,
      ...iconStyle,
      ...labelStyle,
      ...spinnerStyle,
      darkStyle(),
    ]);
  }
}

class RxIconButtonStyle extends RxButtonStyle {
  const RxIconButtonStyle();

  @override
  Style makeStyle(SpecConfiguration<ButtonSpecUtility> spec) {
    final $ = spec.utilities;
    final flexboxStyle = [
      $.container.chain
        ..borderRadius(6)
        ..color.black()
        ..padding(8),
      spec.on.disabled($.container.color.grey.shade400()),
    ];

    final iconStyle = [$.icon.size(18), $.icon.color.white()];

    final darkStyle = Style(
      $on.dark($.container.color.white(), $.textStyle.color.black()),
    );

    return Style.create([
      super.makeStyle(spec).call(),
      ...flexboxStyle,
      ...iconStyle,
      darkStyle(),
    ]);
  }
}
