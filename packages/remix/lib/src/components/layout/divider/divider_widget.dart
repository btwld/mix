part of 'divider.dart';


/// A divider is a thin line that groups content in lists and layouts.
///
/// Dividers help to organize content by visually separating it into groups.
///
/// This example shows how to use a [RxDivider] in a list of items.
///
/// ```dart
/// Column(
///   children: const <Widget>[
///     Text('Item 1'),
///     RxDivider(),
///     Text('Item 2'),
///     RxDivider(),
///     Text('Item 3'),
///   ],
/// )
/// ```
/// 

class RxDivider extends StatelessWidget {
  const RxDivider({super.key, this.style, this.variants = const []});

  /// {@macro remix.component.style}
  final RxDividerStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  RxDividerStyle get _style =>
      RxDividerStyle._default().merge(style ?? RxDividerStyle());

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      style: Style(_style).applyVariants(variants),
      builder: (context) {
        final spec = DividerSpec.of(context);

        return spec.container();
      },
    );
  }
}
