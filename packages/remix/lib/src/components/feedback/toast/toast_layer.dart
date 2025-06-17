part of 'toast.dart';

class ToastLayer extends StatefulWidget {
  const ToastLayer({super.key, required this.child});

  final Widget child;

  @override
  ToastLayerState createState() => ToastLayerState();
}

abstract class ToastActions {
  bool get isShowing;
  void close();
}

class ToastLayerState extends State<ToastLayer> implements ToastActions {
  ToastEntry? currentToast;
  ToastEntry? previousToast;
  Timer? _timer;

  void _addEntry(ToastEntry entry) {
    _timer?.cancel();
    _timer = null;
    setState(() {
      previousToast = currentToast;
      currentToast = entry;
    });
    if (entry.showDuration > Duration.zero) {
      _timer = Timer(entry.showDuration, () => close());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  bool get isShowing => currentToast != null;

  @override
  void close() {
    _timer?.cancel();
    _timer = null;

    if (mounted) {
      setState(() {
        previousToast = currentToast;
        currentToast = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final toast = currentToast;
    final alignment = currentToast?.alignment ?? Alignment.bottomCenter;

    final toastWidget = KeyedSubtree(
      key: ValueKey(toast.hashCode),
      child: Align(
        alignment: alignment,
        child: toast?.builder(context, this) ?? const SizedBox(),
      ),
    );

    return Stack(
      children: [
        widget.child,
        AnimatedSwitcher(
          duration:
              toast?.animationDuration ?? const Duration(milliseconds: 500),
          reverseDuration: toast?.reverseAnimationDuration ??
              const Duration(milliseconds: 200),
          switchInCurve: toast?.animationCurve ??
              SpringCurve.durationBased(
                duration: const Duration(milliseconds: 500),
                bounce: 0.2,
              ),
          switchOutCurve: toast?.reverseAnimationCurve ?? Curves.decelerate,
          transitionBuilder: (child, animation) {
            if (identical(child, toastWidget)) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(alignment.x, alignment.y) * 0.5,
                  end: Offset.zero,
                ).animate(animation),
                child: ScaleTransition(
                  scale: animation.drive(Tween(begin: 0.8, end: 1)),
                  child: child,
                ),
              );
            }

            return ScaleTransition(
              scale: animation.drive(Tween(begin: 0.8, end: 1)),
              alignment: previousToast?.alignment ?? Alignment.bottomCenter,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: toastWidget,
        ),
      ],
    );
  }
}

void showToast({
  required BuildContext context,
  required ToastEntry entry,
  bool useRootToastLayer = false,
}) {
  final toastState = useRootToastLayer
      ? context.findRootAncestorStateOfType<ToastLayerState>()
      : context.findAncestorStateOfType<ToastLayerState>();

  if (toastState == null) {
    throw FlutterError.fromParts([
      ErrorSummary('No ToastLayer found in the widget tree.'),
      ErrorDescription('ToastLayer is required to show toasts.'),
      ErrorHint(
        'Make sure to wrap your app with Scaffold or use a ToastLayer.',
      ),
      ErrorHint('Example with Scaffold:\n'
          'Scaffold(\n'
          '  body: YourAppContent(),\n'
          '  // The Scaffold widget includes built-in support for showing toasts\n'
          ')'),
      ErrorHint(
        'Example with ToastLayer:\n'
        'ToastLayer(\n'
        '  child: RemixApp(\n'
        '    // Your app content\n'
        '  ),\n'
        ')',
      ),
    ]);
  }

  toastState._addEntry(entry);
}

void closeToast(BuildContext context) {
  final toastState = context.findAncestorStateOfType<ToastLayerState>();
  toastState?.close();
}

class ToastEntry {
  final Widget Function(BuildContext context, ToastActions) builder;
  final Duration showDuration;
  final Alignment alignment;
  final Duration animationDuration;
  final Duration reverseAnimationDuration;
  final Curve? animationCurve;
  final Curve? reverseAnimationCurve;

  const ToastEntry({
    required this.builder,
    this.showDuration = const Duration(seconds: 4),
    this.alignment = Alignment.bottomCenter,
    this.animationDuration = const Duration(milliseconds: 500),
    this.reverseAnimationDuration = const Duration(milliseconds: 200),
    this.animationCurve,
    this.reverseAnimationCurve,
  });

  List<Object?> get props => [
        builder,
        showDuration,
        alignment,
        animationDuration,
        reverseAnimationDuration,
        animationCurve,
        reverseAnimationCurve,
      ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToastEntry &&
          runtimeType == other.runtimeType &&
          listEquals(props, other.props);

  @override
  int get hashCode => Object.hashAll(props);
}
