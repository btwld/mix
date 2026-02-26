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

final class SubmitEvent extends SchemaEvent {
  final Map<String, dynamic> formData;

  SubmitEvent({required super.nodeId, required this.formData});

  @override
  String toString() => 'SubmitEvent(nodeId: $nodeId, formData: $formData)';
}

final class SelectEvent extends SchemaEvent {
  final List<dynamic> selected;

  SelectEvent({required super.nodeId, required this.selected});

  @override
  String toString() => 'SelectEvent(nodeId: $nodeId, selected: $selected)';
}

final class DismissEvent extends SchemaEvent {
  final String? reason;

  DismissEvent({required super.nodeId, this.reason});

  @override
  String toString() => 'DismissEvent(nodeId: $nodeId, reason: $reason)';
}

final class ScrollEndEvent extends SchemaEvent {
  ScrollEndEvent({required super.nodeId});

  @override
  String toString() => 'ScrollEndEvent(nodeId: $nodeId)';
}
