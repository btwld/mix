List<T>? castListOrNull<T>(Object? value) => (value as List<Object?>?)?.cast();
