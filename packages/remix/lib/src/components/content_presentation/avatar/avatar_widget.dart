part of 'avatar.dart';

class Avatar extends StatelessWidget {
  Avatar({
    super.key,
    this.image,
    required String fallbackLabel,
    this.onError,
    this.style = const AvatarStyle(),
  }) : fallback = Text(fallbackLabel);

  const Avatar.raw({
    super.key,
    this.image,
    required this.fallback,
    this.onError,
    this.style = const AvatarStyle(),
  });

  /// The image to display in the avatar.
  final ImageProvider<Object>? image;

  final void Function(Object, StackTrace?)? onError;

  /// A builder for the fallback widget.
  ///
  /// This builder creates a widget to display when the image
  /// fails to load or isn't provided. While commonly used for initials,
  /// it can render any widget, offering versatile fallback options.
  ///
  /// {@macro remix.widget_spec_builder.text_spec}
  ///
  /// ```dart
  /// Avatar(
  ///   fallbackBuilder: (spec) => spec(
  ///     'LF',
  ///   ),
  /// );
  /// ```
  final Widget fallback;

  /// {@macro remix.component.style}
  final AvatarStyle style;

  @override
  Widget build(BuildContext context) {
    final configuration = SpecConfiguration(context, AvatarSpecUtility.self);

    return SpecBuilder(
      style: style.makeStyle(configuration),
      builder: (context) {
        final spec = AvatarSpec.of(context);

        final ContainerWidget = spec.container;
        final ImageWidget = spec.image;
        final StackWidget = spec.stack;

        return NakedAvatar(
          image: image,
          imageWidgetBuilder: (context, child) => ContainerWidget(
            child: DefaultTextStyle(
              style: spec.fallbackTextStyle,
              child: StackWidget(
                children: [
                  fallback,
                  if (image != null)
                    ImageWidget(
                      image: image!,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    ),
                ],
              ),
            ),
          ),
          onError: onError,
        );
      },
    );
  }
}
