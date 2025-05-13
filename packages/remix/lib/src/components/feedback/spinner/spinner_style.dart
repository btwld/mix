// ignore_for_file: avoid-unnecessary-call

part of 'spinner.dart';

class SpinnerStyle extends SpecStyle<SpinnerSpecUtility> {
  static const solid = Variant('spinner.solid');
  static const dotted = Variant('spinner.dotted');
  const SpinnerStyle();

  @override
  Style makeStyle(SpecConfiguration<SpinnerSpecUtility> spec) {
    final $ = spec.utilities;

    final spinnerStyle = [
      $.chain
        ..size(24)
        ..strokeWidth(1.5)
        ..color.black()
        ..style.dotted(),
    ];

    final solidVariant = $.style.solid();

    final dottedVariant = $.style.dotted();

    return Style.create([
      ...spinnerStyle,
      solid(solidVariant),
      dotted(dottedVariant),
    ]);
  }
}

class SpinnerDarkStyle extends SpinnerStyle {
  const SpinnerDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<SpinnerSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([super.makeStyle(spec).call(), $.color.white()]);
  }
}
