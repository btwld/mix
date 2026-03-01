import 'dart:collection';

final class FrozenRegistry<T extends Object> {
  final Map<String, T> _idToValue;
  final Map<T, String> _valueToId;

  FrozenRegistry._({
    required Map<String, T> idToValue,
    required Map<T, String> valueToId,
  }) : _idToValue = idToValue,
       _valueToId = valueToId;

  factory FrozenRegistry.fromEntries(Map<String, T> entries) {
    final idToValue = Map<String, T>.unmodifiable(entries);
    final valueToId = <T, String>{};

    for (final entry in entries.entries) {
      valueToId[entry.value] = entry.key;
    }

    return FrozenRegistry._(
      idToValue: idToValue,
      valueToId: Map<T, String>.unmodifiable(valueToId),
    );
  }

  T? resolve(String id) {
    return _idToValue[id];
  }

  String? idOf(T value) {
    return _valueToId[value];
  }

  bool containsId(String id) {
    return _idToValue.containsKey(id);
  }

  bool get isEmpty => _idToValue.isEmpty;

  Map<String, T> get entries => UnmodifiableMapView(_idToValue);
}
