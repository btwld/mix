import 'package:mix/mix.dart';

extension BoxSpecUtilityX<T extends SpecAttribute> on BoxSpecUtility<T> {
  T size(double value) => only(width: value, height: value);
}
