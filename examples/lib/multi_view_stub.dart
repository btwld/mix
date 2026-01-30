/// Stub implementation for non-web platforms.
///
/// Multi-view mode is only supported on web, so these functions
/// return safe defaults on other platforms.

/// Whether multi-view mode is enabled (always false on non-web).
bool get isMultiViewEnabled => false;

/// Get initial data for a view (always null on non-web).
Map<String, Object?>? getInitialData(int viewId) => null;
