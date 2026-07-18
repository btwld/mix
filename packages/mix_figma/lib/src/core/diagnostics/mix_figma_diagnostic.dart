import '../json_map.dart';

/// Severity for a structured bridge diagnostic.
enum MixFigmaDiagnosticSeverity { info, warning, error }

/// One path-addressed mapping or transport diagnostic.
final class MixFigmaDiagnostic {
  final String code;

  final MixFigmaDiagnosticSeverity severity;

  final String path;
  final String message;
  const MixFigmaDiagnostic({
    required this.code,
    required this.severity,
    required this.path,
    required this.message,
  });

  factory MixFigmaDiagnostic.fromJson(JsonMap json) => MixFigmaDiagnostic(
    code: jsonString(json['code'], path: '/code'),
    severity: MixFigmaDiagnosticSeverity.values.byName(
      jsonString(json['severity'], path: '/severity'),
    ),
    path: json['path'] is String ? json['path']! as String : '',
    message: jsonString(json['message'], path: '/message'),
  );

  JsonMap toJson() => {
    'code': code,
    'severity': severity.name,
    'path': path,
    'message': message,
  };
}
