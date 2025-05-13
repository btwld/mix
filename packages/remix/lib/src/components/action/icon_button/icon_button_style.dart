part of 'icon_button.dart';

class IconButtonStyle extends SpecStyle<IconButtonSpecUtility> {
  const IconButtonStyle();

  @override
  Style makeStyle(SpecConfiguration<IconButtonSpecUtility> spec) {
    final $ = spec.utilities;

    final iconStyle = [
      $.icon.chain
        ..size(16)
        ..color.white(),
    ];

    final spinnerStyle = [
      $.spinner.chain
        ..strokeWidth(0.9)
        ..size(15)
        ..color.white(),
    ];

    final containerStyle = [
      $.container.chain
        ..borderRadius(6)
        ..color.black()
        ..padding.vertical(8)
        ..padding.horizontal(8),
      spec.on.disabled($.container.color.grey.shade400()),
    ];

    return Style.create([...iconStyle, ...containerStyle, ...spinnerStyle]);
  }
}

class IconButtonDarkStyle extends IconButtonStyle {
  const IconButtonDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<IconButtonSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([
      super.makeStyle(spec).call(),
      $.container.color.white(),
      $.icon.color.black(),
      $.spinner.color.black(),
    ]);
  }
}
