// ignore_for_file: avoid-unnecessary-call

part of 'spinner.dart';

class RxSpinnerStyle extends SpinnerSpecUtility<SpinnerSpecAttribute> {
  RxSpinnerStyle() : super((v) => v);

  factory RxSpinnerStyle._default() {
    return RxSpinnerStyle()
      ..color.black()
      ..style.solid()
      ..size.call(24)
      ..strokeWidth.call(1.5);
  }

  @override
  RxSpinnerStyle merge(RxSpinnerStyle other) {
    return super.merge(other) as RxSpinnerStyle;
  }
}

class SpinnerStyle extends SpecStyle<SpinnerSpecUtility> {
  static const solid = Variant('spinner.solid');
  static const dotted = Variant('spinner.dotted');
  const SpinnerStyle();

  @override
  Style makeStyle(SpecConfiguration<SpinnerSpecUtility> spec) {
    final $ = spec.utilities;

    final spinnerStyle = [
      $
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

    return Style.create([super.makeStyle(spec), $.color.white()]);
  }
}
