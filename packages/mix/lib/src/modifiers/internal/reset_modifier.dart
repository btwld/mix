// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/attribute.dart';
import '../../core/modifier.dart';
import '../../core/utility.dart';

final class ResetModifierSpec extends Modifier<ResetModifierSpec>
    with Diagnosticable {
  const ResetModifierSpec();

  @override
  ResetModifierSpec copyWith() {
    return const ResetModifierSpec();
  }

  @override
  ResetModifierSpec lerp(ResetModifierSpec? other, double t) {
    if (other == null) return this;

    return const ResetModifierSpec();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }

  @override
  List<Object?> get props => [];

  @override
  Widget build(Widget child) {
    return child;
  }
}

final class ResetModifierSpecUtility<T extends SpecUtility<Object?>>
    extends MixUtility<T, ResetModifierSpecAttribute> {
  const ResetModifierSpecUtility(super.builder);
  T call() {
    return builder(const ResetModifierSpecAttribute());
  }
}

class ResetModifierSpecAttribute
    extends ModifierSpecAttribute<ResetModifierSpec>
    with Diagnosticable {
  const ResetModifierSpecAttribute();

  @override
  ResetModifierSpec resolve(BuildContext context) {
    return const ResetModifierSpec();
  }

  @override
  ResetModifierSpecAttribute merge(ResetModifierSpecAttribute? other) {
    if (other == null) return this;

    return other;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }

  @override
  List<Object?> get props => [];
}

class ResetModifierSpecTween extends Tween<ResetModifierSpec?> {
  ResetModifierSpecTween({super.begin, super.end});

  @override
  ResetModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ResetModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
