/// Rejects duplicate top-level IDs in a public chart widget.
void requireUniqueChartIds(Iterable<Object> ids, String kind) {
  final seen = <Object>{};
  for (final id in ids) {
    if (!seen.add(id)) {
      throw ArgumentError.value(id, 'id', 'Duplicate $kind ID');
    }
  }
}
