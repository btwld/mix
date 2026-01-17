import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/foundation.dart';

/// Web implementation for multi-view mode support.
///
/// These functions provide access to Flutter's multi-view APIs
/// that are only available on web.

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
Map<String, Object?>? getInitialData(int viewId) {
  try {
    final jsData = ui_web.views.getInitialData(viewId);
    if (jsData == null) return null;

    // Convert JSObject to Map
    return _jsObjectToMap(jsData);
  } catch (e) {
    debugPrint('getInitialData failed for viewId $viewId: $e');
    return null;
  }
}

/// Convert a JSAny to a Dart Map.
Map<String, Object?>? _jsObjectToMap(JSAny? jsAny) {
  if (jsAny == null) return null;

  final result = <String, Object?>{};

  // Get keys using Object.keys()
  final jsObject = jsAny as JSObject;
  final keys = _getObjectKeys(jsObject);

  for (final key in keys) {
    final value = _getProperty(jsObject, key);
    result[key] = _jsToValue(value);
  }

  return result;
}

/// Convert a JSAny value to a Dart value.
Object? _jsToValue(JSAny? jsValue) {
  if (jsValue == null) return null;
  if (jsValue.isA<JSString>()) return (jsValue as JSString).toDart;
  if (jsValue.isA<JSNumber>()) return (jsValue as JSNumber).toDartDouble;
  if (jsValue.isA<JSBoolean>()) return (jsValue as JSBoolean).toDart;
  if (jsValue.isA<JSArray>()) {
    return (jsValue as JSArray).toDart.map(_jsToValue).toList();
  }
  if (jsValue.isA<JSObject>()) return _jsObjectToMap(jsValue);
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
