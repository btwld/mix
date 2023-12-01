import 'package:flutter/material.dart';

import '../../attributes/scalars/scalar_util.dart';
import '../../core/attribute.dart';
import 'stack_attribute.dart';

const stack = StackSpecUtility.selfBuilder;

class StackSpecUtility<T extends StyleAttribute>
    extends MixUtility<T, StackMixAttribute> {
  static const selfBuilder = StackSpecUtility(MixUtility.selfBuilder);

  const StackSpecUtility(super.builder);

  T _only({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
  }) {
    final stack = StackMixAttribute(
      alignment: alignment,
      fit: fit,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
    );

    return builder(stack);
  }

  AlignmentUtility<T> get alignment {
    return AlignmentUtility((alignment) => _only(alignment: alignment));
  }

  StackFitUtility<T> get fit {
    return StackFitUtility((fit) => _only(fit: fit));
  }

  TextDirectionUtility<T> get textDirection {
    return TextDirectionUtility(
      (textDirection) => _only(textDirection: textDirection),
    );
  }

  ClipUtility<T> get clipBehavior {
    return ClipUtility((clipBehavior) => _only(clipBehavior: clipBehavior));
  }

  T call({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
  }) {
    return _only(
      alignment: alignment,
      fit: fit,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
    );
  }
}
