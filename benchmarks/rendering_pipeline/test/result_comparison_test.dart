import 'package:flutter_test/flutter_test.dart';
import 'package:rendering_pipeline/src/result_comparison.dart';

void main() {
  test('reports Mix-minus-Flutter deltas and ratios', () {
    final report = compareBenchmarkDocuments(<Map<String, Object?>>[
      <String, Object?>{
        'metadata': <String, Object?>{'kind': 'micro'},
        'results': <Map<String, Object?>>[
          <String, Object?>{
            'scenario': 'S2',
            'track': 'isolation',
            'action': 'toggle',
            'implementation': 'flutter',
            'metrics': <String, Object?>{'median_us': 10},
          },
          <String, Object?>{
            'scenario': 'S2',
            'track': 'isolation',
            'action': 'toggle',
            'implementation': 'mix',
            'metrics': <String, Object?>{'median_us': 15},
          },
        ],
      },
    ]);

    final comparison = (report['comparisons']! as List).single as Map;
    final metric = (comparison['metrics']! as Map)['median_us'] as Map;
    expect(metric['absolute_delta_mix_minus_flutter'], 5);
    expect(metric['mix_over_flutter_ratio'], 1.5);
  });

  test('averages independent runs before comparing', () {
    Map<String, Object?> document(double flutter, double mix) {
      return <String, Object?>{
        'metadata': <String, Object?>{'kind': 'profile'},
        'results': <Map<String, Object?>>[
          <String, Object?>{
            'scenario': 'S4',
            'track': 'isolation',
            'action': 'animated',
            'implementation': 'flutter',
            'metrics': <String, Object?>{'p99_ms': flutter},
          },
          <String, Object?>{
            'scenario': 'S4',
            'track': 'isolation',
            'action': 'animated',
            'implementation': 'mix',
            'metrics': <String, Object?>{'p99_ms': mix},
          },
        ],
      };
    }

    final report = compareBenchmarkDocuments(<Map<String, Object?>>[
      document(8, 10),
      document(12, 14),
    ]);
    final comparison = (report['comparisons']! as List).single as Map;
    final metric = (comparison['metrics']! as Map)['p99_ms'] as Map;

    expect(comparison['flutter_run_count'], 2);
    expect(comparison['mix_run_count'], 2);
    expect(metric['flutter'], 10);
    expect(metric['mix'], 12);
    expect(metric['absolute_delta_mix_minus_flutter'], 2);
    expect(metric['mix_over_flutter_ratio'], 1.2);
  });

  test('does not combine results from different Mix revisions', () {
    Map<String, Object?> document(String mixSha) {
      return <String, Object?>{
        'metadata': <String, Object?>{
          'kind': 'micro',
          'implementation_label': 'candidate',
          'mix_sha': mixSha,
        },
        'results': <Map<String, Object?>>[
          <String, Object?>{
            'scenario': 'S0',
            'track': 'isolation',
            'action': 'rebuild',
            'implementation': 'flutter',
            'metrics': <String, Object?>{'median_us': 10},
          },
          <String, Object?>{
            'scenario': 'S0',
            'track': 'isolation',
            'action': 'rebuild',
            'implementation': 'mix',
            'metrics': <String, Object?>{'median_us': 12},
          },
        ],
      };
    }

    final report = compareBenchmarkDocuments(<Map<String, Object?>>[
      document('abc'),
      document('def'),
    ]);
    final comparisons = report['comparisons']! as List;

    expect(comparisons, hasLength(2));
    expect(
      comparisons.map((dynamic value) => (value as Map)['mix_sha']),
      containsAll(<String>['abc', 'def']),
    );
  });
}
