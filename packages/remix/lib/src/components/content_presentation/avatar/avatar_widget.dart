part of 'avatar.dart';

/// A customizable avatar component that can display an image or a label.
///
/// The [RxAvatar] widget is designed to present a user's avatar with various customization options.
/// It supports displaying background and foreground images, a text label, and provides builders for loading and error states.
///
/// ## Example
///
/// ```dart
/// RxAvatar(
///   backgroundImage: NetworkImage('https://example.com/avatar.png'),
///   foregroundImage: NetworkImage('https://example.com/badge.png'),
///   label: 'User',
///   variants: [Variant.primary],
///   style: RxAvatarStyle(),
/// )
/// ```
///
class RxAvatar extends StatelessWidget {
  /// Creates a Remix avatar.
  ///
  /// The [label] parameter is optional. If provided, it will be displayed as text content.
  /// Other parameters allow customizing the avatar's appearance including background and foreground images.
  factory RxAvatar({
    Key? key,
    ImageProvider? backgroundImage,
    ImageProvider? foregroundImage,
    ImageErrorListener? onBackgroundImageError,
    ImageErrorListener? onForegroundImageError,
    List<Variant> variants = const [],
    RxAvatarStyle? style,
    String? label,
  }) {
    return RxAvatar.raw(
      key: key,
      backgroundImage: backgroundImage,
      foregroundImage: foregroundImage,
      onBackgroundImageError: onBackgroundImageError,
      onForegroundImageError: onForegroundImageError,
      variants: variants,
      style: style,
      child: label != null ? Text(label) : null,
    );
  }

  /// Creates a Remix avatar with custom content.
  ///
  /// This constructor allows for custom avatar content beyond the default layout.
  /// The [child] parameter is optional and will be used as the avatar's content.
  ///
  /// Example:
  /// ```dart
  /// RxAvatar.raw(
  ///   backgroundImage: NetworkImage('https://example.com/avatar.png'),
  ///   foregroundImage: NetworkImage('https://example.com/badge.png'),
  ///   child: Icon(Icons.person),
  ///   variants: [Variant.primary],
  ///   style: RxAvatarStyle(),
  /// )
  /// ```
  const RxAvatar.raw({
    super.key,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.child,
    this.variants = const [],
    this.style,
  })  : assert(backgroundImage != null || onBackgroundImageError == null),
        assert(foregroundImage != null || onForegroundImageError == null);

  /// The background image to display in the avatar.
  ///
  /// This image will be displayed behind the avatar's content (child or label).
  /// If provided, it will be used as the background decoration of the avatar container.
  /// The image will be fitted to cover the entire avatar area.
  final ImageProvider? backgroundImage;

  /// The foreground image to display in the avatar.
  ///
  /// This image will be displayed in front of the avatar's content (child or label).
  /// If provided, it will be used as the foreground decoration of the avatar container.
  /// The image will be fitted to cover the entire avatar area.
  final ImageProvider? foregroundImage;

  /// Callback function called when the background image fails to load.
  ///
  /// This callback is triggered when there's an error loading the [backgroundImage].
  /// It receives the exception and stack trace information about the error.
  final ImageErrorListener? onBackgroundImageError;

  /// Callback function called when the foreground image fails to load.
  ///
  /// This callback is triggered when there's an error loading the [foregroundImage].
  /// It receives the exception and stack trace information about the error.
  final ImageErrorListener? onForegroundImageError;

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

        final ContainerWidget = spec.container.copyWith();

        return IconTheme(
          data: spec.icon,
          child: DefaultTextStyle(
            style: spec.textStyle,
            child: ContainerWidget(
              child: Container(
                alignment: Alignment.center,
                decoration: backgroundImage != null
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: backgroundImage!,
                          onError: onBackgroundImageError,
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
                foregroundDecoration: foregroundImage != null
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: foregroundImage!,
                          onError: onForegroundImageError,
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
