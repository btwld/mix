part of 'avatar.dart';

class RxAvatarStyle extends AvatarSpecUtility<AvatarSpecAttribute> {
  RxAvatarStyle() : super((v) => v);

  factory RxAvatarStyle._default() {
    return RxAvatarStyle()
      ..container.size(50)
      ..container.alignment.center()
      ..container.shape.circle()
      ..container.clipBehavior.antiAlias()
      ..container.color.grey.shade300()
      ..textStyle.fontSize(18)
      ..textStyle.fontWeight.w400()
      ..textStyle.color.black();
  }

  @override
  RxAvatarStyle merge(RxAvatarStyle other) {
    return super.merge(other) as RxAvatarStyle;
  }
}
