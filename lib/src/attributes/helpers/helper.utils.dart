import '../../mixer/mix_factory.dart';
import '../nested_attribute.dart';

class HelperUtility {
  const HelperUtility._();

  static NestedMixAttribute apply(List<Mix> mixes) {
    return NestedMixAttribute(Mix.combineAll(mixes));
  }
}

typedef FunctionWithListParam<T, R> = R Function(List<T> params);

class WrapFunction<T, R> {
  const WrapFunction(this.fn);

  final FunctionWithListParam<T, R> fn;

  // ignore: long-parameter-list
  R call([
    T? p1,
    T? p2,
    T? p3,
    T? p4,
    T? p5,
    T? p6,
    T? p7,
    T? p8,
    T? p9,
    T? p10,
    T? p11,
    T? p12,
  ]) {
    final params = <T>[];
    if (p1 != null) params.add(p1);
    if (p2 != null) params.add(p2);
    if (p3 != null) params.add(p3);
    if (p4 != null) params.add(p4);
    if (p5 != null) params.add(p5);
    if (p6 != null) params.add(p6);
    if (p7 != null) params.add(p7);
    if (p8 != null) params.add(p8);
    if (p9 != null) params.add(p9);
    if (p10 != null) params.add(p10);
    if (p11 != null) params.add(p11);
    if (p12 != null) params.add(p12);

    return fn(params);
  }
}
