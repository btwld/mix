import '../models/chart_config.dart';

/// Formats a data value for tooltips and screen readers.
///
/// Whole numbers drop the decimal point (1088, not 1088.0) and floating-point
/// noise is removed (0.3, not 0.30000000000000004). No locale grouping is
/// applied; pass a formatter for currency, units or grouping.
String formatChartValue(double value) {
  if (!value.isFinite) return '$value';
  if (value == value.roundToDouble() && value.abs() < 1e15) {
    return value.toInt().toString();
  }
  final text = value.toStringAsPrecision(12);
  final exponent = text.indexOf('e');
  if (exponent < 0) return text.replaceFirst(RegExp(r'\.?0+$'), '');

  return text.substring(0, exponent).replaceFirst(RegExp(r'\.?0+$'), '') +
      text.substring(exponent);
}

/// Resolves how a chart writes data values in tooltips, value labels and its
/// semantics summary.
///
/// A chart's own [valueFormatter] wins. Otherwise the value axis formatter is
/// reused when it returns text, since axis formatters may blank labels they
/// want hidden, and [formatChartValue] covers the rest.
ChartAxisLabelFormatter resolveChartValueFormatter({
  required ChartAxisLabelFormatter? valueFormatter,
  required ChartAxisLabelFormatter? axisFormatter,
}) {
  if (valueFormatter != null) return valueFormatter;
  if (axisFormatter == null) return formatChartValue;

  return (value) {
    final text = axisFormatter(value);

    return text.trim().isEmpty ? formatChartValue(value) : text;
  };
}
