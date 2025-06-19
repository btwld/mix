/// Flags to indicate external code entities (classes, extensions, etc.) to generate.
class GeneratedSpecComponents {
  static const int none = 0x00;
  static const int utility = 0x01;
  static const int attribute = 0x02;
  static const int resolvableExtension = 0x04;
  static const int tween = 0x08;

  static const int all = utility | attribute | resolvableExtension | tween;

  static const skipUtility = all & ~utility;
  static const skipAttribute = all & ~attribute;
  static const skipResolvableExtension = all & ~resolvableExtension;
  static const skipTween = all & ~tween;

  const GeneratedSpecComponents._();
}

/// Flags indicating methods to generate within the Spec class.
class GeneratedSpecMethods {
  static const int none = 0x00;
  static const int copyWith = 0x01;
  static const int equals = 0x02;
  static const int lerp = 0x04;

  static const int all = copyWith | equals | lerp;

  static const skipCopyWith = all & ~copyWith;
  static const skipEquals = all & ~equals;
  static const skipLerp = all & ~lerp;

  const GeneratedSpecMethods._();
}

class GeneratedUtilityMethods {
  static const int none = 0x00;
  static const int callMethod = 0x01;

  static const int all = callMethod;

  static const skipCallMethod = all & ~callMethod;

  const GeneratedUtilityMethods._();
}

/// Flags specifying resolvable (DTO) generation options.
class GeneratedPropertyComponents {
  static const int none = 0x00;
  static const int utility = 0x01;
  static const int resolvableExtension = 0x02;

  static const skipUtility = all & ~utility;
  static const skipResolvableExtension = all & ~resolvableExtension;

  /// Combines all available components.
  static const int all = utility | resolvableExtension;

  const GeneratedPropertyComponents._();
}
