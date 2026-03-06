List<T> castList<T>(Object? value) => (value as List<Object?>).cast();

List<T>? castListOrNull<T>(Object? value) => (value as List<Object?>?)?.cast();
