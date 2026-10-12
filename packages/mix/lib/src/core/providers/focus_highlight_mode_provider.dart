import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Provides the current Flutter focus-highlight mode to descendants.
@internal
class FocusHighlightModeProvider extends StatefulWidget {
  const FocusHighlightModeProvider({super.key, required this.child});

  /// Reads the current focus-highlight mode.
  ///
  /// Without a provider scope, this falls back to
  /// [FocusManager.highlightMode] without subscribing to changes. Callers only
  /// receive reactive modality updates inside a [FocusHighlightModeProvider].
  static FocusHighlightMode of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<_FocusHighlightModeScope>()
            ?.mode ??
        FocusManager.instance.highlightMode;
  }

  final Widget child;

  @override
  State<FocusHighlightModeProvider> createState() =>
      _FocusHighlightModeProviderState();
}

class _FocusHighlightModeProviderState
    extends State<FocusHighlightModeProvider> {
  late FocusHighlightMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = FocusManager.instance.highlightMode;
    FocusManager.instance.addHighlightModeListener(_handleModeChange);
  }

  void _handleModeChange(FocusHighlightMode mode) {
    if (!mounted || mode == _mode) return;

    setState(() => _mode = mode);
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(_handleModeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FocusHighlightModeScope(mode: _mode, child: widget.child);
  }
}

class _FocusHighlightModeScope extends InheritedWidget {
  const _FocusHighlightModeScope({required this.mode, required super.child});

  final FocusHighlightMode mode;

  @override
  bool updateShouldNotify(_FocusHighlightModeScope oldWidget) {
    return mode != oldWidget.mode;
  }
}
