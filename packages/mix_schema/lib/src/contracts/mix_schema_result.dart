import 'mix_schema_error.dart';

sealed class MixSchemaResult<T> {
  const MixSchemaResult();

  bool get isOk => this is MixSchemaSuccess<T>;
  bool get isFail => this is MixSchemaFailure<T>;

  T? get valueOrNull {
    final self = this;
    if (self is MixSchemaSuccess<T>) return self.value;

    return null;
  }

  List<MixSchemaError> get errorsOrEmpty {
    final self = this;
    if (self is MixSchemaFailure<T>) return self.errors;

    return const [];
  }
}

final class MixSchemaSuccess<T> extends MixSchemaResult<T> {
  final T value;

  const MixSchemaSuccess(this.value);
}

final class MixSchemaFailure<T> extends MixSchemaResult<T> {
  final List<MixSchemaError> errors;

  MixSchemaFailure(List<MixSchemaError> errors)
    : errors = List.unmodifiable([...errors]..sort()) {
    if (errors.isEmpty) {
      throw StateError('MixSchemaFailure requires at least one error.');
    }
  }

  Map<String, Object?> toJson() {
    return {
      'ok': false,
      'errors': errors.map((error) => error.toJson()).toList(),
    };
  }
}
