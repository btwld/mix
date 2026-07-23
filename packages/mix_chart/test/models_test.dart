import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  group('selection keys', () {
    test('compare by their complete hierarchical identity', () {
      expect(
        const LinePointKey(seriesId: 'series', pointId: 'point'),
        const LinePointKey(seriesId: 'series', pointId: 'point'),
      );
      expect(
        const LinePointKey(seriesId: 'first', pointId: 'shared'),
        isNot(const LinePointKey(seriesId: 'second', pointId: 'shared')),
      );
      expect(
        const BarSelectionKey.bar(groupId: 'group', barId: 'bar'),
        isNot(
          const BarSelectionKey.segment(
            groupId: 'group',
            barId: 'bar',
            segmentId: 'bar',
          ),
        ),
      );
    });
  });

  group('line data', () {
    test('accepts a null y value as a gap', () {
      final point = ChartPoint(id: 'gap', x: 1, y: null);

      expect(point.y, isNull);
    });

    test('rejects non-finite coordinates', () {
      expect(
        () => ChartPoint(id: 'x', x: double.nan, y: 1),
        throwsArgumentError,
      );
      expect(
        () => ChartPoint(id: 'y', x: 1, y: double.infinity),
        throwsArgumentError,
      );
    });

    test('requires labels and unique point identifiers', () {
      final point = ChartPoint(id: 'duplicate', x: 0, y: 1);

      expect(
        () => LineSeries(id: 'series', label: ' ', points: [point]),
        throwsArgumentError,
      );
      expect(
        () =>
            LineSeries(id: 'series', label: 'Revenue', points: [point, point]),
        throwsArgumentError,
      );
    });

    test('copies the point list into an unmodifiable view', () {
      final source = [ChartPoint(id: 1, x: 0, y: 1)];
      final series = LineSeries(id: 'series', label: 'Revenue', points: source);

      source.add(ChartPoint(id: 2, x: 1, y: 2));
      expect(series.points, hasLength(1));
      expect(
        () => series.points.add(ChartPoint(id: 3, x: 2, y: 3)),
        throwsUnsupportedError,
      );
    });
  });

  group('bar data', () {
    test('accepts floating and descending bars', () {
      final bar = BarValue(id: 'bar', label: 'Change', fromY: 8, toY: -2);

      expect(bar.fromY, 8);
      expect(bar.toY, -2);
    });

    test('rejects non-finite values and duplicate child identifiers', () {
      expect(
        () => BarValue(id: 'bar', label: 'Value', toY: double.nan),
        throwsArgumentError,
      );

      final segment = BarSegment(
        id: 'duplicate',
        label: 'Segment',
        fromY: 0,
        toY: 1,
      );
      expect(
        () => BarValue(
          id: 'bar',
          label: 'Value',
          toY: 2,
          segments: [segment, segment],
        ),
        throwsArgumentError,
      );
    });

    test('exposes unmodifiable bars and segments', () {
      final segment = BarSegment(
        id: 'segment',
        label: 'Segment',
        fromY: 0,
        toY: 1,
      );
      final bar = BarValue(
        id: 'bar',
        label: 'Value',
        toY: 1,
        segments: [segment],
      );
      final group = BarGroup(id: 'group', label: 'Category', bars: [bar]);

      expect(() => bar.segments.clear(), throwsUnsupportedError);
      expect(() => group.bars.clear(), throwsUnsupportedError);
    });
  });

  group('pie data', () {
    test('requires a label and finite non-negative value', () {
      expect(
        () => PieSlice(id: 'slice', label: '', value: 1),
        throwsArgumentError,
      );
      expect(
        () => PieSlice(id: 'slice', label: 'Slice', value: -1),
        throwsArgumentError,
      );
      expect(
        () => PieSlice(id: 'slice', label: 'Slice', value: double.infinity),
        throwsArgumentError,
      );
    });
  });

  group('configuration', () {
    test('validates numeric axes', () {
      expect(() => ChartAxis.numeric(min: 1, max: 1), throwsArgumentError);
      expect(() => ChartAxis.numeric(interval: 0), throwsArgumentError);
      expect(() => ChartAxis.numeric(min: double.nan), throwsArgumentError);
    });

    test('validates viewport scale bounds', () {
      expect(() => ChartViewport(minScale: 0.5), throwsArgumentError);
      expect(
        () => ChartViewport(minScale: 2, maxScale: 1),
        throwsArgumentError,
      );
    });
  });
}
