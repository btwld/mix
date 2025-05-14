part of 'icon_button.dart';

class IconButton extends StatelessWidget {
  const IconButton(
    this.icon, {
    super.key,
    this.disabled = false,
    this.loading = false,
    this.spinnerBuilder,
    this.variants = const [],
    required this.onPressed,
    this.style,
  });

  /// {@macro remix.component.disabled}
  final bool disabled;

  /// {@macro remix.component.loading}
  final bool loading;

  /// The icon displayed in the IconButton.
  final IconData? icon;

  /// {@macro remix.component.onPressed}
  final VoidCallback? onPressed;

  /// A builder that returns a [Widget] for the IconButton's spinner.
  ///
  /// This builder creates a widget to display when the IconButton is loading.
  ///
  /// {@macro remix.widget_spec_builder.spinner_builder}
  ///
  /// ```dart
  /// IconButton(
  ///   icon: Icons.add,
  ///   onPressed: () {},
  ///   spinnerBuilder: (spec) => spec(),
  /// );
  /// ```
  final WidgetSpecBuilder<SpinnerSpec>? spinnerBuilder;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.style}
  final IconButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled || loading;

    final style = this.style ?? context.remix.components.iconButton;
    final configuration =
        SpecConfiguration(context, IconButtonSpecUtility.self);

    return Pressable(
      enabled: !isDisabled,
      onPress: disabled || loading ? null : onPressed,
      child: SpecBuilder(
        style: style.makeStyle(configuration).applyVariants(variants),
        builder: (context) {
          final spec = IconButtonSpec.of(context);

          return spec.container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (loading) spec.spinner(),
                if (!loading) spec.icon(icon),
              ],
            ),
          );
        },
      ),
    );
  }
}
