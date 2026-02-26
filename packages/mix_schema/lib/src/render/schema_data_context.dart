import 'package:flutter/widgets.dart';

/// Scoped data context for data binding resolution.
///
/// Supports dot-path and JSON Pointer lookups with parent chaining
/// (used by RepeatHandler for scoped iteration data).
final class SchemaDataContext {
  final SchemaDataContext? parent;
  final Map<String, dynamic> scope;

  const SchemaDataContext({this.parent, this.scope = const {}});

  factory SchemaDataContext.root([Map<String, dynamic>? seed]) {
    return SchemaDataContext(scope: seed ?? const {});
  }

  SchemaDataContext child({
    required String alias,
    required dynamic item,
    required int index,
  }) {
    return SchemaDataContext(
      parent: this,
      scope: {alias: item, 'index': index, r'$index': index},
    );
  }

  T? lookup<T>(String path) {
    if (path.isEmpty) return null;

    final value = path.startsWith('/')
        ? _lookupJsonPointer(path)
        : _lookupDotPath(path);

    return value is T ? value : null;
  }

  dynamic _lookupDotPath(String path) {
    final segments = path.split('.');
    dynamic current = _resolveRoot(segments.first);
    if (current == null) return parent?._lookupDotPath(path);

    for (final seg in segments.skip(1)) {
      current = _readSegment(current, seg);
      if (current == null) return null;
    }
    return current;
  }

  dynamic _lookupJsonPointer(String path) {
    final segments = path
        .split('/')
        .skip(1)
        .map((s) => s.replaceAll('~1', '/').replaceAll('~0', '~'))
        .toList();
    if (segments.isEmpty) return null;

    dynamic current = _resolveRoot(segments.first);
    if (current == null) return parent?._lookupJsonPointer(path);

    for (final seg in segments.skip(1)) {
      current = _readSegment(current, seg);
      if (current == null) return null;
    }
    return current;
  }

  dynamic _resolveRoot(String key) =>
      scope.containsKey(key) ? scope[key] : _readSegment(scope, key);

  dynamic _readSegment(dynamic current, String segment) {
    final indexMatch = RegExp(r'^(.+)\[(\d+)\]$').firstMatch(segment);
    if (indexMatch != null) {
      final listKey = indexMatch.group(1)!;
      final index = int.parse(indexMatch.group(2)!);
      final list = switch (current) {
        Map<String, dynamic> map => map[listKey],
        _ => null,
      };
      if (list is List && index >= 0 && index < list.length) {
        return list[index];
      }
      return null;
    }

    return switch (current) {
      Map<String, dynamic> map => map[segment],
      List list => _readListIndex(list, segment),
      _ => null,
    };
  }

  dynamic _readListIndex(List list, String segment) {
    final i = int.tryParse(segment);
    if (i != null && i >= 0 && i < list.length) return list[i];
    return null;
  }
}

/// Closed transform registry.
///
/// Only transforms registered here can be applied. Maps to Mix's
/// Directive<T> system conceptually.
typedef SchemaTransformFn = dynamic Function(
  dynamic value,
  BuildContext context,
);

final class SchemaTransforms {
  final Map<String, SchemaTransformFn> _registry;
  const SchemaTransforms(this._registry);

  dynamic apply(String key, dynamic value, BuildContext context) {
    return _registry[key]?.call(value, context);
  }

  static final closed = SchemaTransforms({
    'string': (value, _) => value?.toString(),
    'int': (value, _) => switch (value) {
          int v => v,
          num v => v.toInt(),
          _ => int.tryParse('$value'),
        },
    'double': (value, _) => switch (value) {
          num v => v.toDouble(),
          _ => double.tryParse('$value'),
        },
    'bool': (value, _) => switch (value) {
          bool v => v,
          'true' || '1' => true,
          'false' || '0' => false,
          _ => null,
        },
  });
}
