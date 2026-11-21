import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

Map<String, Object?> readShowcaseInitialData(int viewId) {
  final value = ui_web.views.getInitialData(viewId)?.dartify();
  if (value is! Map) return const {};

  return {
    for (final entry in value.entries)
      if (entry.key is String) entry.key as String: entry.value,
  };
}
