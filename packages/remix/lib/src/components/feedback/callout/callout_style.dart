// ignore_for_file: camel_case_types

part of 'callout.dart';

class CalloutStyle extends SpecStyle<CalloutSpecUtility> {
  const CalloutStyle();

  @override
  Style makeStyle(SpecConfiguration<CalloutSpecUtility> spec) {
    final $ = spec.utilities;

    final flexContainerStyle = [
      $.container.chain
        ..borderRadius(6)
        ..color.white()
        ..padding(12)
        ..border.all.color.black12()
        ..flex.mainAxisSize.min()
        ..flex.gap(8)
        ..flex.direction.horizontal(),
    ];

    final iconStyle = [$.icon.color.black(), $.icon.size(16)];

    final textStyle = [
      $.text.chain
        ..style.color.black()
        ..style.fontSize(14)
        ..style.fontWeight.w500(),
    ];

    return Style.create([...flexContainerStyle, ...iconStyle, ...textStyle]);
  }
}

class CalloutDarkStyle extends CalloutStyle {
  const CalloutDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<CalloutSpecUtility> spec) {
    final $ = spec.utilities;
    final flexContainerStyle = [
      $.container.chain
        ..color.black()
        ..border.all.color.white30(),
    ];

    final textStyle = [$.text.style.color.white()];

    final iconStyle = [$.icon.color.white()];

    return Style.create([
      super.makeStyle(spec).call(),
      ...flexContainerStyle,
      ...textStyle,
      ...iconStyle,
    ]);
  }
}
