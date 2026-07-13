class AllocationClassCount {
  const AllocationClassCount({
    required this.classId,
    required this.className,
    required this.libraryUri,
    required this.instances,
    required this.bytes,
  });

  final String classId;
  final String className;
  final String libraryUri;
  final int instances;
  final int bytes;
}

class AllocationProfileSummary {
  const AllocationProfileSummary({
    required this.operationCount,
    required this.totalInstances,
    required this.totalBytes,
    required this.classes,
  });

  final int operationCount;
  final int totalInstances;
  final int totalBytes;
  final List<AllocationClassCount> classes;

  Map<String, Object?> toJson() => <String, Object?>{
    'operation_count': operationCount,
    'total_instances': totalInstances,
    'total_bytes': totalBytes,
    'instances_per_operation': totalInstances / operationCount,
    'bytes_per_operation': totalBytes / operationCount,
    'reported_class_count': classes.length,
    'classes': <Map<String, Object?>>[
      for (final entry in classes)
        <String, Object?>{
          'class_id': entry.classId,
          'class_name': entry.className,
          'library_uri': entry.libraryUri,
          'instances': entry.instances,
          'bytes': entry.bytes,
          'instances_per_operation': entry.instances / operationCount,
          'bytes_per_operation': entry.bytes / operationCount,
        },
    ],
  };
}

AllocationProfileSummary summarizeAllocationProfile({
  required Iterable<AllocationClassCount> classes,
  required int operationCount,
  int classLimit = 100,
}) {
  if (operationCount <= 0) {
    throw ArgumentError.value(
      operationCount,
      'operationCount',
      'Must be greater than zero',
    );
  }
  if (classLimit <= 0) {
    throw ArgumentError.value(
      classLimit,
      'classLimit',
      'Must be greater than zero',
    );
  }

  final allocatedClasses =
      classes
          .where((entry) => entry.instances > 0 || entry.bytes > 0)
          .toList(growable: false)
        ..sort((first, second) {
          final byteComparison = second.bytes.compareTo(first.bytes);
          if (byteComparison != 0) return byteComparison;

          final instanceComparison = second.instances.compareTo(
            first.instances,
          );
          if (instanceComparison != 0) return instanceComparison;

          final libraryComparison = first.libraryUri.compareTo(
            second.libraryUri,
          );
          if (libraryComparison != 0) return libraryComparison;

          return first.className.compareTo(second.className);
        });

  return AllocationProfileSummary(
    operationCount: operationCount,
    totalInstances: allocatedClasses.fold(
      0,
      (total, entry) => total + entry.instances,
    ),
    totalBytes: allocatedClasses.fold(0, (total, entry) => total + entry.bytes),
    classes: List<AllocationClassCount>.unmodifiable(
      allocatedClasses.take(classLimit),
    ),
  );
}
