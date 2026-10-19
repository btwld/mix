import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../focus_visibility.dart';

/// Rebuilds descendants that read [FocusVisibility] when it changes.
@internal
class FocusVisibilityProvider extends StatefulWidget {
  const FocusVisibilityProvider({super.key, required this.child});

  /// Reads [FocusVisibility.isVisible].
  ///
  /// Inside a [FocusVisibilityProvider], this subscribes to changes. Without
  /// one, callers only see changes on their next rebuild.
  static bool of(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<_FocusVisibilityScope>();

    return FocusVisibility.isVisible;
  }

  final Widget child;

  @override
  State<FocusVisibilityProvider> createState() =>
      _FocusVisibilityProviderState();
}

class _FocusVisibilityProviderState extends State<FocusVisibilityProvider> {
  late final Listenable _listenable;
  late bool _visible;

  @override
  void initState() {
    super.initState();
    _listenable = FocusVisibility.listenable;
    _listenable.addListener(_handleChange);
    _visible = FocusVisibility.isVisible;
  }

  void _handleChange() {
    final visible = FocusVisibility.isVisible;
    if (!mounted || visible == _visible) return;

    setState(() => _visible = visible);
  }

  @override
  void dispose() {
    _listenable.removeListener(_handleChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FocusVisibilityScope(visible: _visible, child: widget.child);
  }
}

class _FocusVisibilityScope extends InheritedWidget {
  const _FocusVisibilityScope({required this.visible, required super.child});

  final bool visible;

  @override
  bool updateShouldNotify(_FocusVisibilityScope oldWidget) {
    return visible != oldWidget.visible;
  }
}
