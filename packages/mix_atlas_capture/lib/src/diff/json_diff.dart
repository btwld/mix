import 'dart:collection';
import 'dart:convert';

/// How one canonical declared JSON location changed.
enum AtlasJsonChangeKind { added, removed, changed }

/// One exact JSON Pointer change between two declared documents.
final class AtlasJsonChange {
  final AtlasJsonChangeKind kind;

  final String jsonPointer;
  final Object? baselineValue;
  final Object? currentValue;
  const AtlasJsonChange({
    required this.kind,
    required this.jsonPointer,
    this.baselineValue,
    this.currentValue,
  });

  Map<String, Object?> toJson() => {
    'kind': kind.name,
    'pointer': jsonPointer,
    if (kind != .added) 'baseline': baselineValue,
    if (kind != .removed) 'current': currentValue,
  };
}

/// Deterministic structural diff for JSON-safe declared capture data.
abstract final class AtlasJsonDiffer {
  static List<AtlasJsonChange> compare(Object? baseline, Object? current) {
    final changes = <AtlasJsonChange>[];
    _compare(baseline, current, '', changes);

    return List.unmodifiable(changes);
  }

  static void _compare(
    Object? baseline,
    Object? current,
    String pointer,
    List<AtlasJsonChange> changes,
  ) {
    if (baseline is Map && current is Map) {
      final before = baseline.cast<String, Object?>();
      final after = current.cast<String, Object?>();
      final keys = {...before.keys, ...after.keys}.toList()..sort();
      for (final key in keys) {
        final childPointer = '$pointer/${_escape(key)}';
        if (!before.containsKey(key)) {
          changes.add(
            AtlasJsonChange(
              kind: .added,
              jsonPointer: childPointer,
              currentValue: _canonical(after[key]),
            ),
          );
        } else if (!after.containsKey(key)) {
          changes.add(
            AtlasJsonChange(
              kind: .removed,
              jsonPointer: childPointer,
              baselineValue: _canonical(before[key]),
            ),
          );
        } else {
          _compare(before[key], after[key], childPointer, changes);
        }
      }

      return;
    }
    if (baseline is List && current is List) {
      final commonLength = baseline.length < current.length
          ? baseline.length
          : current.length;
      for (var index = 0; index < commonLength; index += 1) {
        _compare(baseline[index], current[index], '$pointer/$index', changes);
      }
      for (var index = commonLength; index < baseline.length; index += 1) {
        changes.add(
          AtlasJsonChange(
            kind: .removed,
            jsonPointer: '$pointer/$index',
            baselineValue: _canonical(baseline[index]),
          ),
        );
      }
      for (var index = commonLength; index < current.length; index += 1) {
        changes.add(
          AtlasJsonChange(
            kind: .added,
            jsonPointer: '$pointer/$index',
            currentValue: _canonical(current[index]),
          ),
        );
      }

      return;
    }
    if (!_jsonEquals(baseline, current)) {
      changes.add(
        AtlasJsonChange(
          kind: .changed,
          jsonPointer: pointer,
          baselineValue: _canonical(baseline),
          currentValue: _canonical(current),
        ),
      );
    }
  }
}

Object? _canonical(Object? value) {
  if (value is Map) {
    final map = value.cast<String, Object?>();
    final keys = map.keys.toList()..sort();

    return UnmodifiableMapView({
      for (final key in keys) key: _canonical(map[key]),
    });
  }
  if (value is List) return List.unmodifiable(value.map(_canonical));

  return value;
}

bool _jsonEquals(Object? left, Object? right) =>
    jsonEncode(_canonical(left)) == jsonEncode(_canonical(right));

String _escape(String value) =>
    value.replaceAll('~', '~0').replaceAll('/', '~1');
