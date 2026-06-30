final class MixSchemaLimits {
  const MixSchemaLimits({
    this.maxDepth = 32,
    this.maxListLength = 256,
    this.maxStringLength = 4096,
    this.maxVariantsPerStyler = 64,
    this.maxModifiersPerStyler = 64,
  });

  final int maxDepth;
  final int maxListLength;
  final int maxStringLength;
  final int maxVariantsPerStyler;
  final int maxModifiersPerStyler;

  Map<String, Object?> toJson() => {
    'maxDepth': maxDepth,
    'maxListLength': maxListLength,
    'maxStringLength': maxStringLength,
    'maxVariantsPerStyler': maxVariantsPerStyler,
    'maxModifiersPerStyler': maxModifiersPerStyler,
  };
}
