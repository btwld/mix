import 'package:flutter/foundation.dart';

abstract class MixError {
  static FlutterError unsupportedTypeInDto(
    Type type,
    List<String> supportedTypes,
  ) {
    final supportedTypesFormated =
        '${supportedTypes.sublist(0, supportedTypes.length - 1).join(', ')} and ${supportedTypes.last}';

    return FlutterError.fromParts([
      ErrorSummary('Unsupported $type type'),
      ErrorDescription(
        'The toDto() method is not implemented for this $type subclass.',
      ),
      ErrorHint('Only $supportedTypesFormated are currently supported.'),
    ]);
  }

  static FlutterError accessTokenValue(String token, String field) {
    return FlutterError.fromParts([
      ErrorSummary('Invalid access: $token cannot access field $field'),
      ErrorDescription(
        'The $field field cannot be directly accessed through TextStyleRef. '
        'Ensure you are using the appropriate methods or properties provided by TextStyleToken to interact with the style properties.',
      ),
      ErrorHint(
        'Consider using TextStyleToken.resolve() to access the $field. '
        'This method ensures that $token is used within the appropriate context where $field is available.',
      ),
    ]);
  }
}
