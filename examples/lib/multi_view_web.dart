import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/foundation.dart';

/// Web implementation for multi-view mode support.
///
/// These functions provide access to Flutter's multi-view APIs
/// that are only available on web.

/// Maximum recursion depth for JS→Dart object conversion.
/// Configurable to handle different data structures.
const int kDefaultMaxConversionDepth = 10;

/// Error thrown when JS→Dart conversion exceeds depth limit.
///
/// This error is thrown instead of silently returning null when the
/// conversion depth exceeds [maxDepth]. This allows callers to distinguish
/// between null values and conversion failures.
class JsConversionDepthError implements Exception {
  /// The depth at which the error occurred.
  final int depth;

  /// The maximum allowed depth.
  final int maxDepth;

  /// Creates a new [JsConversionDepthError].
  JsConversionDepthError(this.depth, this.maxDepth);

  @override
  String toString() =>
      'JsConversionDepthError: Exceeded max depth $maxDepth at depth $depth';
}

/// Check if the app was initialized with multi-view enabled.
///
/// This is set by JavaScript via:
/// ```javascript
/// engineInitializer.initializeEngine({ multiViewEnabled: true });
/// ```
bool get isMultiViewEnabled {
  try {
    // Check if we have multiple views or if multi-view was explicitly enabled
    // In multi-view mode, Flutter doesn't auto-create a default view
    return _isMultiViewModeFromJS;
  } catch (e) {
    debugPrint('isMultiViewEnabled check failed: $e');
    return false;
  }
}

/// Get the initial data passed to a view via addView().
///
/// JavaScript can pass data when adding views:
/// ```javascript
/// app.addView({
///   hostElement: container,
///   initialData: { demoId: 'box-basic' }
/// });
/// ```
///
/// [maxDepth] controls the maximum recursion depth for nested objects.
/// Defaults to [kDefaultMaxConversionDepth] (10).
///
/// Throws [JsConversionDepthError] if the object structure exceeds [maxDepth].
/// Returns null only for null input or non-depth-related conversion failures.
Map<String, Object?>? getInitialData(int viewId, {int? maxDepth}) {
  try {
    final jsData = ui_web.views.getInitialData(viewId);
    if (jsData == null) return null;

    return _jsObjectToMap(
      jsData,
      maxDepth: maxDepth ?? kDefaultMaxConversionDepth,
    );
  } on JsConversionDepthError {
    // Re-throw depth errors for caller to handle
    rethrow;
  } catch (e) {
    debugPrint('getInitialData failed for viewId $viewId: $e');
    return null;
  }
}

/// Convert a JSAny to a Dart Map.
///
/// [maxDepth] - Maximum recursion depth (default: [kDefaultMaxConversionDepth])
///
/// Throws [JsConversionDepthError] if recursion exceeds maxDepth.
/// Returns null only for null input.
Map<String, Object?>? _jsObjectToMap(
  JSAny? jsAny, {
  int depth = 0,
  int maxDepth = kDefaultMaxConversionDepth,
}) {
  if (jsAny == null) return null;
  if (depth > maxDepth) {
    debugPrint('_jsObjectToMap: Max depth $maxDepth exceeded at depth $depth');
    throw JsConversionDepthError(depth, maxDepth);
  }

  final result = <String, Object?>{};

  // Get keys using Object.keys()
  final jsObject = jsAny as JSObject;
  final keys = _getObjectKeys(jsObject);

  for (final key in keys) {
    final value = _getProperty(jsObject, key);
    result[key] = _jsToValue(value, depth: depth + 1, maxDepth: maxDepth);
  }

  return result;
}

/// Convert a JSAny value to a Dart value.
///
/// Throws [JsConversionDepthError] if recursion exceeds maxDepth.
Object? _jsToValue(
  JSAny? jsValue, {
  int depth = 0,
  int maxDepth = kDefaultMaxConversionDepth,
}) {
  if (jsValue == null) return null;
  if (depth > maxDepth) {
    throw JsConversionDepthError(depth, maxDepth);
  }
  if (jsValue.isA<JSString>()) return (jsValue as JSString).toDart;
  if (jsValue.isA<JSNumber>()) return (jsValue as JSNumber).toDartDouble;
  if (jsValue.isA<JSBoolean>()) return (jsValue as JSBoolean).toDart;
  if (jsValue.isA<JSArray>()) {
    return (jsValue as JSArray)
        .toDart
        .map((value) => _jsToValue(value, depth: depth + 1, maxDepth: maxDepth))
        .toList();
  }
  if (jsValue.isA<JSObject>()) {
    return _jsObjectToMap(jsValue, depth: depth + 1, maxDepth: maxDepth);
  }
  return jsValue.toString();
}

@JS('Object.keys')
external JSArray<JSString> _objectKeys(JSObject obj);

List<String> _getObjectKeys(JSObject obj) {
  return _objectKeys(obj).toDart.map((s) => s.toDart).toList();
}

@JS('Reflect.get')
external JSAny? _reflectGet(JSObject target, JSString key);

JSAny? _getProperty(JSObject obj, String key) {
  return _reflectGet(obj, key.toJS);
}

/// Check from JS if multi-view mode was enabled.
@JS('window.__FLUTTER_MULTI_VIEW_ENABLED__')
external bool? get _multiViewEnabledFlag;

bool get _isMultiViewModeFromJS {
  try {
    return _multiViewEnabledFlag ?? false;
  } catch (e) {
    debugPrint('_isMultiViewModeFromJS check failed: $e');
    return false;
  }
}
