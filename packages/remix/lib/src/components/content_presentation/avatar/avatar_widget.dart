part of 'avatar.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.image,
    required this.fallbackBuilder,
    this.variants = const [],
    this.style,
  });

  /// The image to display in the avatar.
  final ImageProvider<Object>? image;

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
  final WidgetSpecBuilder<TextSpec> fallbackBuilder;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.style}
  final AvatarStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? context.remix.components.avatar;

    final configuration = SpecConfiguration(context, AvatarSpecUtility.self);

    return SpecBuilder(
      style: style.makeStyle(configuration).applyVariants(variants),
      builder: (context) {
        final spec = AvatarSpec.of(context);

        final ContainerWidget = spec.container;
        final ImageWidget = spec.image;
        final StackWidget = spec.stack;

        return ContainerWidget(
          child: StackWidget(
            children: [
              fallbackBuilder(spec.fallback),
              if (image != null)
                ImageWidget(
                  image: image!,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
            ],
          ),
        );
      },
    );
  }
}
