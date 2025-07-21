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

final class ResetModifierUtility<T extends SpecAttribute<Object?>>
    extends MixUtility<T, ResetModifierAttribute> {
  const ResetModifierUtility(super.builder);
  T call() {
    return builder(const ResetModifierAttribute());
  }
}

class ResetModifierAttribute extends ModifierAttribute<ResetModifierSpec>
    with Diagnosticable {
  const ResetModifierAttribute();

  @override
  ResetModifierSpec resolve(BuildContext context) {
    return const ResetModifierSpec();
  }

  @override
  ResetModifierAttribute merge(ResetModifierAttribute? other) {
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
