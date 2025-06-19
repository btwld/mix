part of 'avatar.dart';

class RxAvatar extends StatelessWidget {
  RxAvatar({
    super.key,
    this.image,
    this.loadingBuilder,
    this.errorBuilder,
    required String label,
    this.variants = const [],
    this.style,
  }) : child = Text(label);

  const RxAvatar.raw({
    super.key,
    this.image,
    this.loadingBuilder,
    this.errorBuilder,
    this.child,
    this.variants = const [],
    this.style,
  });

  /// The image to display in the avatar.
  final ImageProvider<Object>? image;

  /// A builder for the loading widget.
  final ImageLoadingBuilder? loadingBuilder;

  /// A builder for the error widget.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.style}
  final RxAvatarStyle? style;

  final Widget? child;

  RxAvatarStyle get _style =>
      RxAvatarStyle._default().merge(style ?? RxAvatarStyle());

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      style: Style(_style).applyVariants(variants),
      builder: (context) {
        final spec = AvatarSpec.of(context);

        final ContainerWidget = spec.container;
        final ImageWidget = spec.image;

        return DefaultTextStyle(
          style: spec.textStyle,
          child: ContainerWidget(
            child: image != null
                ? ImageWidget(
                    image: image!,
                    loadingBuilder: loadingBuilder,
                    errorBuilder: errorBuilder,
                  )
                : child,
          ),
        );
      },
    );
  }
}
