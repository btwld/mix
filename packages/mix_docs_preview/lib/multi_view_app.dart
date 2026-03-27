import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'multi_view_stub.dart'
    if (dart.library.js_interop) 'multi_view_web.dart'
    as multi_view;
import 'preview_registry.dart';

/// Multi-view app wrapper that renders previews based on view initialData.
///
/// When embedded in a web page with multi-view enabled, each view receives
/// its own initialData containing the previewId to display.
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
    // ignore: avoid-empty-setstate, no-empty-block
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
            child: _PreviewView(viewId: view.viewId),
          ),
      ],
    );
  }
}

/// Individual preview view widget that renders the appropriate preview
/// based on the initialData passed from JavaScript.
///
/// Uses:
/// - `previewId`: explicit preview lookup.
class _PreviewView extends StatelessWidget {
  final int viewId;

  const _PreviewView({required this.viewId});

  @override
  Widget build(BuildContext context) {
    // Get the initialData passed from JavaScript via addView().
    final initialData = multi_view.getInitialData(viewId);
    // Defensive typing: JS may pass non-string values
    final rawPreviewId = initialData?['previewId'];
    final previewId = rawPreviewId is String
        ? rawPreviewId
        : rawPreviewId?.toString();
    final view = View.of(context);

    return ColoredBox(
      color: const Color(0x00000000),
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: MediaQuery.fromView(
          view: view,
          child: Center(child: PreviewRegistry.build(previewId, context)),
        ),
      ),
    );
  }
}
