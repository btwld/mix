import 'showcase_view_data_stub.dart'
    if (dart.library.js_interop) 'showcase_view_data_web.dart'
    as platform;

/// Immutable configuration supplied by the JavaScript showcase host.
class ShowcaseViewData {
  const ShowcaseViewData({required this.exampleId});

  static const supportedExampleIds = {'01', '02', '03', '04', '05'};

  final String exampleId;

  factory ShowcaseViewData.forView(int viewId) {
    return ShowcaseViewData.fromMap(platform.readShowcaseInitialData(viewId));
  }

  /// Parses browser-supplied initial data with safe defaults.
  factory ShowcaseViewData.fromMap(Map<String, Object?> data) {
    final requestedId = data['exampleId'];
    final exampleId =
        requestedId is String && supportedExampleIds.contains(requestedId)
        ? requestedId
        : '01';

    return ShowcaseViewData(exampleId: exampleId);
  }
}
