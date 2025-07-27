typedef FunctionWithParams<ParamT, ReturnT> =
    ReturnT Function(List<ParamT> params);

/// A utility class that wraps a function with parameters and allows calling it with optional arguments.
///
/// [SpreadFunctionParams] is useful when you have a function that takes a list of parameters, but you want to
/// provide a more convenient way to call it with individual optional arguments. This class spreads the optional
/// arguments into a list and passes it to the wrapped function.
///
/// Example:
/// ```dart
/// int sum(List<int> numbers) => numbers.fold(0, (a, b) => a + b);
/// final sumSpread = SpreadFunctionParams<int, int>(sum);
/// print(sumSpread(1, 2, 3)); // Output: 6
/// ```
class SpreadFunctionParams<ParamT, ReturnT> {
  /// The function with parameters to be wrapped.
  final FunctionWithParams<ParamT, ReturnT> fn;

  /// Creates a new instance of [SpreadFunctionParams] with the given [fn].
  const SpreadFunctionParams(this.fn);

  /// Calls the wrapped function with the provided optional arguments.
  ///
  /// The optional arguments are collected into a list, filtered to remove null values, and passed to the wrapped
  /// function. The result of the wrapped function is returned.
  ReturnT call([
    ParamT? p1,
    ParamT? p2,
    ParamT? p3,
    ParamT? p4,
    ParamT? p5,
    ParamT? p6,
    ParamT? p7,
    ParamT? p8,
    ParamT? p9,
    ParamT? p10,
    ParamT? p11,
    ParamT? p12,
    ParamT? p13,
    ParamT? p14,
    ParamT? p15,
    ParamT? p16,
    ParamT? p17,
    ParamT? p18,
    ParamT? p19,
    ParamT? p20,
  ]) {
    return fn(
      [
        p1,
        p2,
        p3,
        p4,
        p5,
        p6,
        p7,
        p8,
        p9,
        p10,
        p11,
        p12,
        p13,
        p14,
        p15,
        p16,
        p17,
        p18,
        p19,
        p20,
      ].whereType<ParamT>().toList(),
    );
  }
}
