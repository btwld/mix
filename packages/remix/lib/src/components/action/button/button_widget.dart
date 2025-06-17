// part of 'button.dart';

// /// A customizable button component that supports icons, loading states, and styling.
// /// The button integrates with the Mix styling system and follows Remix design patterns.
// ///
// /// Example:
// /// ```dart
// /// RxButton(
// ///   label: 'Click Me',
// ///   leadingIcon: Icons.star,
// ///   onPressed: () {
// ///     print('Button pressed!');
// ///   },
// ///   style: ButtonStyle(
// ///     // Custom styling...
// ///   ),
// /// )
// /// ```
// class RxButton extends StatefulWidget implements Disableable {
//   /// Creates a Remix button.
//   ///
//   /// The [label] and [onPressed] parameters are required.
//   /// Other parameters allow customizing the button's appearance and behavior.
//   RxButton({
//     super.key,
//     required String label,
//     IconData? leadingIcon,
//     this.enabled = true,
//     this.loading = false,
//     this.spinnerWidget,
//     this.enableHapticFeedback = true,
//     required this.onPressed,
//     this.focusNode,
//     this.style = const ButtonStyle(),
//   }) : child = RxLabel(label, icon: leadingIcon);

//   /// Creates a Remix button with only an icon.
//   ///
//   /// This constructor creates a button with just an icon and no label.
//   /// The [icon] parameter is required and will be displayed as the button's content.
//   ///
//   /// Example:
//   /// ```dart
//   /// RxButton.icon(
//   ///   icon: Icons.star,
//   ///   onPressed: () {},
//   /// )
//   /// ```
//   RxButton.icon({
//     super.key,
//     required IconData icon,
//     this.enabled = true,
//     this.loading = false,
//     this.spinnerWidget,
//     this.enableHapticFeedback = true,
//     required this.onPressed,
//     this.focusNode,
//     this.style = const ButtonStyle(),
//   }) : child = Icon(icon);

//   /// Creates a Remix button with a raw child widget.
//   ///
//   /// This constructor allows for custom button content beyond the default layout.
//   /// The [child] parameter must be provided and will be used as the button's content.
//   ///
//   /// Example:
//   /// ```dart
//   /// RxButton.raw(
//   ///   child: Icon(Icons.star),
//   ///   onPressed: () {},
//   /// )
//   /// ```
//   const RxButton.raw({
//     super.key,
//     required this.child,
//     this.enabled = true,
//     this.loading = false,
//     this.spinnerWidget,
//     this.enableHapticFeedback = true,
//     required this.onPressed,
//     this.focusNode,
//     this.style = const ButtonStyle(),
//   });

//   /// Whether the button is enabled.
//   ///
//   /// When false, the button will not respond to user interaction and
//   /// will be visually styled as disabled.
//   @override
//   final bool enabled;

//   /// Whether the button is in a loading state.
//   ///
//   /// When true, the button will display a spinner and become non-interactive.
//   /// The spinner can be customized via [spinnerWidget].
//   final bool loading;

//   /// Callback function called when the button is pressed.
//   ///
//   /// If null, the button will be considered disabled.
//   final VoidCallback? onPressed;

//   /// Optional focus node to control the button's focus behavior.
//   final FocusNode? focusNode;

//   /// Custom widget to display when the button is in loading state.
//   ///
//   /// If not provided, a default spinner from the button's spec will be used.
//   ///
//   /// Example:
//   /// ```dart
//   /// RxButton(
//   ///   label: 'Submit',
//   ///   loading: true,
//   ///   spinnerWidget: CircularProgressIndicator(),
//   ///   onPressed: () {},
//   /// )
//   /// ```
//   final Widget? spinnerWidget;

//   /// The style configuration for the button.
//   ///
//   /// Controls visual properties like colors, padding, typography etc.
//   final ButtonStyle style;

//   /// Whether to provide haptic feedback when the button is pressed.
//   ///
//   /// Defaults to true.
//   final bool enableHapticFeedback;

//   /// The child widget to display inside the button.
//   final Widget child;

//   @override
//   State<RxButton> createState() => _RxButtonState();
// }

// class _RxButtonState extends State<RxButton> with MixControllerMixin {
//   bool get _isEnabled => widget.enabled && !widget.loading;

//   /// Builds the loading overlay that shows a spinner while preserving layout.
//   Widget _buildLoadingOverlay(ButtonSpec spec, Widget child) {
//     final Widget spinner = widget.spinnerWidget ?? spec.spinner();

//     return widget.loading
//         ? Stack(
//             alignment: Alignment.center,
//             children: [spinner, Opacity(opacity: 0.0, child: child)],
//           )
//         : child;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final style = widget.style;
//     final configuration = SpecConfiguration(context, ButtonSpecUtility.self);

//     return NakedButton(
//       onPressed: widget.onPressed,
//       onHoverState: (state) {
//         mixController.hovered = state;
//       },
//       onPressedState: (state) {
//         mixController.pressed = state;
//       },
//       onFocusState: (state) {
//         mixController.focused = state;
//       },
//       onDisabledState: (state) {
//         mixController.disabled = state;
//       },
//       enabled: _isEnabled,
//       enableHapticFeedback: widget.enableHapticFeedback,
//       focusNode: widget.focusNode,
//       child: RemixBuilder(
//         builder: (context) {
//           final spec = ButtonSpec.of(context);

//           return spec.container(
//             child: DefaultTextStyle(
//               style: spec.textStyle,
//               child: IconTheme(
//                 data: spec.icon,
//                 child: widget.loading
//                     ? _buildLoadingOverlay(spec, widget.child)
//                     : widget.child,
//               ),
//             ),
//           );
//         },
//         style: style.makeStyle(configuration).animate(),
//         mixController: mixController,
//       ),
//     );
//   }
// }
