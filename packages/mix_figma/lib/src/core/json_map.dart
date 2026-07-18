/// A JSON object with string keys.
typedef JsonMap = Map<String, Object?>;

JsonMap jsonObject(Object? value, {required String path}) {
  if (value is! Map) {
    throw FormatException('Expected an object at $path.');
  }

  if (value.keys.any((key) => key is! String)) {
    throw FormatException('Expected string keys at $path.');
  }

  return value.cast();
}

List<Object?> jsonList(Object? value, {required String path}) {
  if (value is! List) {
    throw FormatException('Expected a list at $path.');
  }

  return value.cast();
}

String jsonString(Object? value, {required String path}) {
  if (value is! String || value.isEmpty) {
    throw FormatException('Expected a non-empty string at $path.');
  }

  return value;
}
