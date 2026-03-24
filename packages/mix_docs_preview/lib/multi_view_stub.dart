/// Stub implementation for non-web platforms.
///
/// Multi-view mode is only supported on web, so these functions
/// return safe defaults on other platforms.
library;

/// Whether multi-view mode is enabled (always false on non-web).
bool get isMultiViewEnabled => false;

/// Get initial data for a view (always null on non-web).
// ignore: avoid-unused-parameters
Map<String, Object?>? getInitialData(int viewId, {int? maxDepth}) => null;
