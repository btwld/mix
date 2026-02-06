import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'demo_registry.dart';
import 'multi_view_stub.dart'
    if (dart.library.js_interop) 'multi_view_web.dart'
    as multi_view;

/// Multi-view app wrapper that renders different demos based on view's initialData.
///
/// When embedded in a web page with multi-view enabled, each view receives
/// its own initialData containing the demoId to display.
///
/// This widget implements the official Flutter multi-view pattern with
/// WidgetsBindingObserver to properly handle dynamic view additions/removals.
class MultiViewApp extends StatefulWidget {
  const MultiViewApp({super.key});

  @override
  State<MultiViewApp> createState() => _MultiViewAppState();
}

class _MultiViewAppState extends State<MultiViewApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Rebuild when views are added or removed.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Build a ViewCollection containing all active views.
    final views = WidgetsBinding.instance.platformDispatcher.views;

    return ViewCollection(
      views: [
        for (final view in views)
          View(
            view: view,
            child: _DemoView(viewId: view.viewId),
          ),
      ],
    );
  }
}

/// Individual demo view widget that renders the appropriate demo
/// based on the initialData passed from JavaScript.
class _DemoView extends StatelessWidget {
  const _DemoView({required this.viewId});

  final int viewId;

  @override
  Widget build(BuildContext context) {
    // Get the initialData passed from JavaScript via addView().
    final initialData = multi_view.getInitialData(viewId);
    // Defensive typing: JS may pass non-string values
    final rawDemoId = initialData?['demoId'];
    final demoId = rawDemoId is String ? rawDemoId : rawDemoId?.toString();
    final view = View.of(context);

    return ColoredBox(
      color: const Color(0xFF1a1a2e),
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: MediaQuery.fromView(
          view: view,
          child: DemoRegistry.build(demoId, context),
        ),
      ),
    );
  }
}
