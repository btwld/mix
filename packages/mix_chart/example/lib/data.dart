import 'package:mix_chart/mix_chart.dart';

const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

String weekdayLabel(double value) {
  final index = value.round();
  return index >= 0 && index < weekdays.length ? weekdays[index] : '';
}

String monthLabel(double value) {
  final index = value.round();
  return index >= 0 && index < months.length ? months[index] : '';
}

String compactCurrency(double value) => '\$${value.toStringAsFixed(0)}k';

List<ChartPoint> _points(String prefix, List<double?> values) => [
  for (var index = 0; index < values.length; index++)
    ChartPoint(id: '$prefix-$index', x: index.toDouble(), y: values[index]),
];

List<LineSeries> revenueSeries({bool includeComparison = true}) => [
  LineSeries(
    id: 'revenue',
    label: 'Revenue',
    points: _points('revenue', [18, 24, 22, 34, 31, 42, 48]),
  ),
  if (includeComparison)
    LineSeries(
      id: 'plan',
      label: 'Plan',
      points: _points('plan', [16, 20, 25, 28, 34, 37, 41]),
    ),
];

List<LineSeries> stepSeries() => [
  LineSeries(
    id: 'inventory',
    label: 'Inventory',
    points: _points('inventory', [32, 27, 27, null, 19, 25, 22]),
    style: .curve(LineCurve.stepAfter).marker(.show(true).radius(3.5)),
  ),
];

List<BarGroup> groupedRevenue() {
  const actual = [32.0, 41.0, 37.0, 52.0, 48.0, 59.0];
  const plan = [29.0, 36.0, 40.0, 45.0, 50.0, 54.0];
  return [
    for (var index = 0; index < months.length; index++)
      BarGroup(
        id: months[index].toLowerCase(),
        label: months[index],
        bars: [
          BarValue(id: 'actual', label: 'Actual', toY: actual[index]),
          BarValue(id: 'plan', label: 'Plan', toY: plan[index]),
        ],
      ),
  ];
}

List<BarGroup> stackedRevenue() {
  const product = [21.0, 28.0, 25.0, 34.0, 31.0, 38.0];
  const services = [11.0, 13.0, 12.0, 18.0, 17.0, 21.0];
  return [
    for (var index = 0; index < months.length; index++)
      BarGroup(
        id: months[index].toLowerCase(),
        label: months[index],
        bars: [
          BarValue(
            id: 'revenue',
            label: 'Revenue',
            toY: product[index] + services[index],
            segments: [
              BarSegment(
                id: 'product',
                label: 'Product',
                fromY: 0,
                toY: product[index],
              ),
              BarSegment(
                id: 'services',
                label: 'Services',
                fromY: product[index],
                toY: product[index] + services[index],
              ),
            ],
          ),
        ],
      ),
  ];
}

List<BarGroup> floatingChanges() {
  const starts = [12.0, 18.0, 14.0, 22.0, 17.0, 25.0];
  const ends = [18.0, 14.0, 22.0, 17.0, 25.0, 31.0];
  return [
    for (var index = 0; index < months.length; index++)
      BarGroup(
        id: months[index].toLowerCase(),
        label: months[index],
        bars: [
          BarValue(
            id: 'change',
            label: 'Change',
            fromY: starts[index],
            toY: ends[index],
          ),
        ],
      ),
  ];
}

List<PieSlice> channelSlices() => [
  PieSlice(id: 'mobile', label: 'Mobile', value: 46),
  PieSlice(id: 'desktop', label: 'Desktop', value: 31),
  PieSlice(id: 'tablet', label: 'Tablet', value: 15),
  PieSlice(id: 'other', label: 'Other', value: 8),
];

List<PieSlice> productSlices() => [
  PieSlice(id: 'core', label: 'Core', value: 54),
  PieSlice(id: 'teams', label: 'Teams', value: 27),
  PieSlice(id: 'enterprise', label: 'Enterprise', value: 19),
];
