import 'package:flutter_test/flutter_test.dart';
import 'package:rendering_pipeline/src/allocation_profile_summary.dart';

void main() {
  test('summarizes positive allocation counts in descending byte order', () {
    final summary = summarizeAllocationProfile(
      operationCount: 10,
      classLimit: 2,
      classes: const <AllocationClassCount>[
        AllocationClassCount(
          classId: 'classes/1',
          className: 'SmallSpec',
          libraryUri: 'package:mix/small.dart',
          instances: 20,
          bytes: 160,
        ),
        AllocationClassCount(
          classId: 'classes/2',
          className: 'LargeSpec',
          libraryUri: 'package:mix/large.dart',
          instances: 10,
          bytes: 800,
        ),
        AllocationClassCount(
          classId: 'classes/3',
          className: 'MediumSpec',
          libraryUri: 'package:mix/medium.dart',
          instances: 30,
          bytes: 480,
        ),
        AllocationClassCount(
          classId: 'classes/4',
          className: 'Ignored',
          libraryUri: 'dart:core',
          instances: 0,
          bytes: 0,
        ),
      ],
    );

    expect(summary.totalInstances, 60);
    expect(summary.totalBytes, 1440);
    expect(summary.classes.map((entry) => entry.className), <String>[
      'LargeSpec',
      'MediumSpec',
    ]);
    expect(summary.toJson(), <String, Object?>{
      'operation_count': 10,
      'total_instances': 60,
      'total_bytes': 1440,
      'instances_per_operation': 6.0,
      'bytes_per_operation': 144.0,
      'reported_class_count': 2,
      'classes': <Map<String, Object?>>[
        <String, Object?>{
          'class_id': 'classes/2',
          'class_name': 'LargeSpec',
          'library_uri': 'package:mix/large.dart',
          'instances': 10,
          'bytes': 800,
          'instances_per_operation': 1.0,
          'bytes_per_operation': 80.0,
        },
        <String, Object?>{
          'class_id': 'classes/3',
          'class_name': 'MediumSpec',
          'library_uri': 'package:mix/medium.dart',
          'instances': 30,
          'bytes': 480,
          'instances_per_operation': 3.0,
          'bytes_per_operation': 48.0,
        },
      ],
    });
  });

  test('rejects invalid operation counts and class limits', () {
    expect(
      () => summarizeAllocationProfile(classes: const [], operationCount: 0),
      throwsArgumentError,
    );
    expect(
      () => summarizeAllocationProfile(
        classes: const [],
        operationCount: 1,
        classLimit: 0,
      ),
      throwsArgumentError,
    );
  });
}
