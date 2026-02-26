/// Events emitted from UI to agent.
///
/// Adopted from Flutter GenUI v0 event contract: tap, change, submit,
/// select, dismiss, scroll_end.
sealed class SchemaEvent {
  final String nodeId;
  final DateTime timestamp;

  SchemaEvent({required this.nodeId}) : timestamp = DateTime.now();
}

final class TapEvent extends SchemaEvent {
  final String? actionId;

  TapEvent({required super.nodeId, this.actionId});

  @override
  String toString() => 'TapEvent(nodeId: $nodeId, actionId: $actionId)';
}

final class ChangeEvent extends SchemaEvent {
  final String field;
  final dynamic value;

  ChangeEvent({required super.nodeId, required this.field, this.value});

  @override
  String toString() =>
      'ChangeEvent(nodeId: $nodeId, field: $field, value: $value)';
}

