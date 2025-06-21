part of 'avatar.dart';

/// A customizable avatar component that can display an image or a label.
///
/// The [RxAvatar] widget is designed to present a user's avatar with various customization options.
/// It supports displaying an image, a text label, and provides builders for loading and error states.
///
/// ## Example
///
/// ```dart
/// RxAvatar(
///   image: NetworkImage('https://example.com/avatar.png'),
///   label: 'User',
///   variants: [Variant.primary],
///   style: RxAvatarStyle(),
/// )
/// ```
///
class RxAvatar extends StatelessWidget {
  /// Creates a Remix avatar.
  ///
  /// The [label] parameter is required.
  /// Other parameters allow customizing the avatar's appearance.
  RxAvatar({
    super.key,
    this.image,
    this.loadingBuilder,
    this.errorBuilder,
    required String label,
    this.variants = const [],
    this.style,
  }) : child = Text(label);

  /// Creates a Remix avatar with custom content.
  ///
  /// This constructor allows for custom avatar content beyond the default layout.
  /// The [child] parameter must be provided and will be used as the avatar's content.
  ///
  /// Example:
  /// ```dart
  /// RxAvatar.raw(
  ///   child: Icon(Icons.person),
  ///   variants: [Variant.primary],
  ///   style: RxAvatarStyle(),
  /// )
  /// ```
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

  /// The child widget to display inside the avatar.
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
