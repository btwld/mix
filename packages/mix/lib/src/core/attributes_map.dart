// ignore_for_file: prefer_collection_literals

import 'dart:collection';

import '../internal/deep_collection_equality.dart';
import 'attribute.dart';

// @nodoc
class AttributeMap<T extends Attribute> {
  final LinkedHashMap<Object, T>? _map;

  const AttributeMap._(this._map);

  const AttributeMap.empty() : _map = null;

  factory AttributeMap(Iterable<T> attributes) {
    return AttributeMap._(_mergeMap(attributes));
  }

  static LinkedHashMap<Object, Attr> _mergeMap<Attr extends Attribute>(
    Iterable<Attr> attributes,
  ) {
    final map = LinkedHashMap<Object, Attr>();
    for (final attribute in attributes) {
      final type = attribute.mergeKey;

      // If there is no saved attribute, just add it
      final savedAttribute = map[type];
      if (savedAttribute == null) {
        map[type] = attribute;
      } else {
        // If there is a saved attribute, merge it with the new one
        map[type] = savedAttribute.merge(attribute) as Attr;
      }
    }

    return map;
  }

  int get length => _map?.length ?? 0;

  bool get isEmpty => _map?.isEmpty ?? true;

  bool get isNotEmpty => _map?.isNotEmpty ?? false;

  List<T> get values => _map?.values.toList() ?? [];

  bool containsType(T attribute) =>
      _map?.containsKey(attribute.runtimeType) ?? false;

  bool containsValue(T attribute) => _map?.containsValue(attribute) ?? false;

  Attr? attributeOfType<Attr extends Attribute>() => _map?[Attr] as Attr?;

  Iterable<Attr> whereType<Attr extends T>() => _map?.values.whereType() ?? [];

  AttributeMap<T> merge(AttributeMap<T>? other) {
    return other == null ? this : AttributeMap([...values, ...other.values]);
  }

  Map<Object, T> toMap() => _map?.cast() ?? {};
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AttributeMap<T>) return false;

    const deepEquality = DeepCollectionEquality();

    return deepEquality.equals(values, other.values);
  }

  @override
  int get hashCode => const DeepCollectionEquality().hash(values);
}
