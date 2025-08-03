import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

/// Decorator that aligns its child within the available space.
///
/// Wraps the child in an [Align] widget with the specified alignment and size factors.
final class AlignWidgetDecorator extends WidgetDecorator<AlignWidgetDecorator>
    with Diagnosticable {
  final AlignmentGeometry? alignment;
  final double? widthFactor;
  final double? heightFactor;

  const AlignWidgetDecorator({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  @override
  AlignWidgetDecorator copyWith({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return AlignWidgetDecorator(
      alignment: alignment ?? this.alignment,
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
    );
  }

  @override
  AlignWidgetDecorator lerp(AlignWidgetDecorator? other, double t) {
    if (other == null) return this;

    return AlignWidgetDecorator(
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      widthFactor: MixHelpers.lerpDouble(widthFactor, other.widthFactor, t),
      heightFactor: MixHelpers.lerpDouble(heightFactor, other.heightFactor, t),
    );
  }

  @override
  List<Object?> get props => [alignment, widthFactor, heightFactor];

  @override
  Widget build(Widget child) {
    return Align(
      alignment: alignment ?? Alignment.center,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

final class AlignWidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, AlignWidgetDecoratorMix> {
  const AlignWidgetDecoratorUtility(super.builder);
  T call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return builder(
      AlignWidgetDecoratorMix(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }
}

class AlignWidgetDecoratorMix
    extends WidgetDecoratorMix<AlignWidgetDecorator> {
  final Prop<AlignmentGeometry>? alignment;
  final Prop<double>? widthFactor;
  final Prop<double>? heightFactor;

  const AlignWidgetDecoratorMix.raw({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  AlignWidgetDecoratorMix({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) : this.raw(
         alignment: Prop.maybe(alignment),
         widthFactor: Prop.maybe(widthFactor),
         heightFactor: Prop.maybe(heightFactor),
       );

  @override
  AlignWidgetDecorator resolve(BuildContext context) {
    return AlignWidgetDecorator(
      alignment: MixHelpers.resolve(context, alignment),
      widthFactor: MixHelpers.resolve(context, widthFactor),
      heightFactor: MixHelpers.resolve(context, heightFactor),
    );
  }

  @override
  AlignWidgetDecoratorMix merge(AlignWidgetDecoratorMix? other) {
    if (other == null) return this;

    return AlignWidgetDecoratorMix.raw(
      alignment: alignment.tryMerge(other.alignment),
      widthFactor: widthFactor.tryMerge(other.widthFactor),
      heightFactor: heightFactor.tryMerge(other.heightFactor),
    );
  }

  @override
  List<Object?> get props => [alignment, widthFactor, heightFactor];
}
