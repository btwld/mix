import 'dart:ui' show FlutterView;

import 'package:flutter/widgets.dart';

/// Renders one widget tree for every Flutter view attached by the web host.
///
/// The browser owns the lifecycle of the views through `addView` and
/// `removeView`. Flutter reports those changes through [didChangeMetrics].
class ShowcaseMultiViewApp extends StatefulWidget {
  const ShowcaseMultiViewApp({super.key, required this.viewBuilder});

  final WidgetBuilder viewBuilder;

  @override
  State<ShowcaseMultiViewApp> createState() => _ShowcaseMultiViewAppState();
}

class _ShowcaseMultiViewAppState extends State<ShowcaseMultiViewApp>
    with WidgetsBindingObserver {
  Map<int, Widget> _views = const {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _views = _collectViews();
  }

  @override
  void didUpdateWidget(ShowcaseMultiViewApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    _views = const {};
    _updateViews();
  }

  @override
  void didChangeMetrics() {
    _updateViews();
  }

  Map<int, Widget> _collectViews() {
    return {
      for (final view in WidgetsBinding.instance.platformDispatcher.views)
        view.viewId: _views[view.viewId] ?? _createViewWidget(view),
    };
  }

  void _updateViews() {
    final nextViews = _collectViews();
    if (_sameViewIds(_views, nextViews)) return;
    setState(() => _views = nextViews);
  }

  Widget _createViewWidget(FlutterView view) {
    return View(
      key: ValueKey(view.viewId),
      view: view,
      child: Builder(builder: widget.viewBuilder),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewCollection(views: _views.values.toList(growable: false));
  }
}

bool _sameViewIds(Map<int, Widget> left, Map<int, Widget> right) {
  if (left.length != right.length) return false;
  return left.keys.every(right.containsKey);
}
