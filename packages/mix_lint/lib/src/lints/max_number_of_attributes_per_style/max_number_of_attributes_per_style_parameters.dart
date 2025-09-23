class MaxNumberOfAttributesPerStyleParameters {
  final int maxNumber;

  static const _defaultMaxNumber = 15;

  const MaxNumberOfAttributesPerStyleParameters({required this.maxNumber});

  factory MaxNumberOfAttributesPerStyleParameters.fromJson(
    Map<String, Object?> json,
  ) =>
      MaxNumberOfAttributesPerStyleParameters(
        maxNumber: json['max_number'] as int? ?? _defaultMaxNumber,
      );
}
