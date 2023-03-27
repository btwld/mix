import 'package:flutter/material.dart';

import '../../../attributes/common/common.descriptor.dart';
import '../box.decorator.dart';

/// @nodoc
enum ClipDecoratorType {
  triangle,
  rect,
  rounded,
  oval,
}

/// ## Widget
/// - (All)
/// ## Utilities
/// - [ClipDecoratorUtility](ClipDecoratorUtility-class.html)
///
/// {@category Decorators}
class ClipDecorator extends BoxDecorator<ClipDecorator> {
  final BorderRadius? borderRadius;
  final ClipDecoratorType clipType;

  const ClipDecorator(
    this.clipType, {
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  @override
  ClipDecorator merge(ClipDecorator other) {
    return other;
  }

  @override
  Widget build(BuildContext context, Widget child) {
    final commonProps = CommonDescriptor.fromContext(context);

    if (clipType == ClipDecoratorType.triangle) {
      return ClipPath(
        key: key,
        clipper: TriangleClipper(),
        child: child,
      );
    }

    if (clipType == ClipDecoratorType.rect) {
      return ClipRect(
        key: key,
        child: child,
      );
    }

    if (clipType == ClipDecoratorType.rounded) {
      if (commonProps.animated) {
        return AnimatedClipRRect(
          key: key,
          duration: commonProps.animationDuration,
          curve: commonProps.animationCurve,
          borderRadius: borderRadius ?? BorderRadius.circular(0),
          child: child,
        );
      } else {
        return ClipRRect(
          key: key,
          borderRadius: borderRadius,
          child: child,
        );
      }
    }

    if (clipType == ClipDecoratorType.oval) {
      return ClipOval(
        key: key,
        child: child,
      );
    }

    throw Exception('Unknown clip type: $clipType');
  }
}

/// @nodoc
class AnimatedClipRRect extends StatelessWidget {
  const AnimatedClipRRect({
    required this.duration,
    this.curve = Curves.linear,
    required this.borderRadius,
    required this.child,
    Key? key,
  }) : super(key: key);

  final Duration duration;
  final Curve curve;
  final BorderRadius borderRadius;
  final Widget child;

  static Widget _builder(
    BuildContext context,
    BorderRadius radius,
    Widget? child,
  ) {
    return ClipRRect(borderRadius: radius, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<BorderRadius>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: BorderRadius.zero, end: borderRadius),
      builder: _builder,
      child: child,
    );
  }
}

/// @nodoc
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
