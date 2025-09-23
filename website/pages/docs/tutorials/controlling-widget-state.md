# Controlling Widget State

In this tutorial, we'll explore how to use the `MixWidgetStateController` to manage the state of a custom pressable widget called CustomPressable. We'll cover how to create the CustomPressable widget, handle press and long press gestures, and update the widget state using the `MixWidgetStateController`.

## Creating the CustomPressable Widget

First, let's create the CustomPressable widget that extends StatefulWidget:

```dart
class CustomPressable extends StatefulWidget {
  const CustomPressable({super.key, this.style, this.onPressed, this.label});

  final Style? style
  final VoidCallback? onPressed;
  final String? label;

  @override
  _CustomPressableState createState() => _CustomPressableState();
}

class _CustomPressableState extends State<CustomPressable> {
  late final MixWidgetStateController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MixWidgetStateController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We'll build the widget tree here
  }
}
```

In the _CustomPressableState class, we create an instance of `MixWidgetStateController` called `_controller` in the initState method. We also make sure to dispose of the `_controller` in the dispose method to avoid memory leaks.

## Building the Widget Tree

Next, let's build the widget tree inside the build method of _CustomPressableState:

```dart
@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      onPressed?.call();
    },
    child: FocusableActionDetector(
      onShowFocusHighlight: (hasFocus) {
        // Update focus state
      },
      onShowHoverHighlight: (isHovered) {
        // Update hover state
      },
      child: SpecBuilder(
        style: widget.style,
        controller: _controller,
        builder: (context) {
          final BoxWidget = BoxSpec.of(context);
          final TextWidget = TextSpec.of(context);
          return BoxWidget(
            child: TextWidget(widget.label),
          );
        },
      ),
    ),
  );
}
```

We use the `SpecBuilder` to build the widget tree, passing the `_controller` to manage the widget state. Inside the builder function of SpecBuilder, we have a GestureDetector to handle press and long press gestures, and a FocusableActionDetector to handle focus and hover interactions.

## Handling Press and Long Press Gestures

Let's implement the logic to handle press and long press gestures:

```dart
onTap: () {
  onPressed?.call();
  _controller.pressed = true;
  // Reset the pressed state after a short delay
  Future.delayed(const Duration(milliseconds: 100), () {
    _controller.pressed = false;
  });
},
```

When a tap gesture occurs, we set the pressed property of the _controller to true. After a short delay of 100 milliseconds, we reset the pressed state to false using Future.delayed.

Similarly, when a long press gesture occurs, we set the longPressed property of the _controller to true and reset it to false after a short delay.

## Updating Focus and Hover States

Let's update the focus and hover states using the onShowFocusHighlight and onShowHoverHighlight callbacks:

```dart
onShowFocusHighlight: (hasFocus) => _controller.focused = hasFocus,
onShowHoverHighlight: (isHovered) => _controller.hovered = isHovered,
```

When the focus state changes, we update the focused property of the _controller accordingly. Similarly, when the hover state changes, we update the hovered property of the `_controller`.

## Using the CustomPressable Widget

Now that we have created the CustomPressable widget and implemented the necessary logic, we can use it in our app:

```dart
final style = Style(
  $box.width(200),
  $box.height(100),
  $box.color(Colors.blue),
  $on.press(
    $box.color(Colors.darkBlue),
  ),
  $on.hover(
    $box.color(Colors.lightBlue),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomPressable(
            style: style,
            label: 'Press Me',
            onPressed: () {
              print('Button pressed');
            },
          ),
        ),
      ),
    );
  }
}
```
