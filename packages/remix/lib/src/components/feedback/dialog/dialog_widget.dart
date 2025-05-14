part of 'dialog.dart';

class Dialog extends StatelessWidget {
  Dialog({
    super.key,
    required String title,
    required String description,
    this.actions,
    this.content,
    this.style,
    this.variants = const [],
  })  : titleBuilder = ((spec) => spec(title)),
        descriptionBuilder = ((spec) => spec(description));

  const Dialog.builders({
    super.key,
    this.titleBuilder,
    this.descriptionBuilder,
    this.actions,
    this.content,
    this.style,
    this.variants = const [],
  });

  /// A builder that returns a [Widget] for the dialog's title.
  ///
  /// This builder is used to create a custom title widget for the dialog.
  /// If null, the default title will be used.
  final WidgetSpecBuilder<TextSpec>? titleBuilder;

  /// A builder that returns a [Widget] for the dialog's description.
  ///
  final WidgetSpecBuilder<TextSpec>? descriptionBuilder;

  /// The content widget to be displayed in the dialog.
  ///
  /// This widget is placed below the title and description, and above the actions.
  /// If null, no additional content will be displayed.
  /// Use this to add custom widgets or more complex content to your dialog.
  ///
  /// Example:
  /// ```dart
  /// Dialog(
  ///   title: 'Confirmation',
  ///   description: 'Are you sure you want to proceed?',
  ///   content: Image.asset('assets/warning_icon.png'),
  ///   actions: [
  ///     Button(onPressed: () {}, child: Text('Cancel')),
  ///     Button(onPressed: () {}, child: Text('Confirm')),
  ///   ],
  /// )
  /// ```
  final Widget? content;

  /// A list of widgets to display as actions in the dialog.
  ///
  /// Typically, these are buttons that allow the user to confirm, cancel,
  /// or take other actions related to the dialog's content.
  /// If null, no actions will be displayed.
  final List<Widget>? actions;

  /// {@macro remix.component.style}
  final DialogStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? context.remix.components.dialog;

    final configuration = SpecConfiguration(context, DialogSpecUtility.self);

    return SpecBuilder(
      style: style.makeStyle(configuration).applyVariants(variants),
      builder: (context) {
        final spec = DialogSpec.of(context);

        return spec.container(
          direction: Axis.vertical,
          children: [
            if (titleBuilder != null) titleBuilder!(spec.title),
            if (descriptionBuilder != null)
              descriptionBuilder!(spec.description),
            content ?? const SizedBox.shrink(),
            if (actions != null)
              spec.actionsContainer(
                direction: Axis.horizontal,
                children: actions!,
              ),
          ],
        );
      },
    );
  }
}
