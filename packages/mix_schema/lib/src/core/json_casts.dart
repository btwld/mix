List<T> castList<T>(Object? value) => (value as List<Object?>).cast();

List<T>? castListOrNull<T>(Object? value) => (value as List<Object?>?)?.cast();

/// Coerces a JSON `num` (int or double) to `double`. Use after decoding
/// fields whose schema is `Ack.number()` and whose Dart target is `double`.
double castDouble(Object? value) => (value! as num).toDouble();

double? castDoubleOrNull(Object? value) => (value as num?)?.toDouble();
