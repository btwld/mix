part of 'textfield.dart';

class RxTextFieldStyle extends TextFieldSpecUtility {
  RxTextFieldStyle() : super((v) => v);

  factory RxTextFieldStyle._default() {
    return RxTextFieldStyle()
      ..container.color.white()
      ..container.border.all.color.grey.shade300()
      ..container.borderRadius(6)
      ..container.padding.vertical(8)
      ..container.padding.horizontal(12)
      ..hintTextColor.grey.shade500()
      ..style.color.black()
      ..helperText.color.grey.shade500()
      ..helperText.letterSpacing(0.1);
  }

  @override
  RxTextFieldStyle merge(covariant RxTextFieldStyle other) {
    return super.merge(other) as RxTextFieldStyle;
  }
}
