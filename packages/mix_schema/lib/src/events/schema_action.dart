/// Actions sent from agent to UI.
///
/// The 12 whitelisted actions from Flutter GenUI Actions v0 with their
/// risk classifications (Low/Medium/High). Risk levels map directly to
/// trust enforcement — Medium/High risk actions require propose-before-execute.
///
/// Unknown actions are silently ignored per the whitelist contract.

/// Risk classification for actions.
enum ActionRisk { low, medium, high }

/// Base for all schema actions.
sealed class SchemaAction {
  final String type;
  final ActionRisk risk;

  const SchemaAction({required this.type, required this.risk});
}

// --- Low Risk Actions ---

final class NavigateAction extends SchemaAction {
  final String to;
  final Map<String, dynamic>? params;

  const NavigateAction({required this.to, this.params})
      : super(type: 'navigate', risk: ActionRisk.low);
}

final class SetStateAction extends SchemaAction {
  final String path;
  final dynamic value;

  const SetStateAction({required this.path, required this.value})
      : super(type: 'setState', risk: ActionRisk.low);
}

final class ShowSnackbarAction extends SchemaAction {
  final String message;

  const ShowSnackbarAction({required this.message})
      : super(type: 'showSnackbar', risk: ActionRisk.low);
}

final class DismissAction extends SchemaAction {
  const DismissAction() : super(type: 'dismiss', risk: ActionRisk.low);
}

final class RefreshAction extends SchemaAction {
  final String? screenId;

  const RefreshAction({this.screenId})
      : super(type: 'refresh', risk: ActionRisk.low);
}

final class LogEventAction extends SchemaAction {
  final String name;
  final Map<String, dynamic>? params;

  const LogEventAction({required this.name, this.params})
      : super(type: 'logEvent', risk: ActionRisk.low);
}

// --- Medium Risk Actions ---

final class ShowDialogAction extends SchemaAction {
  final String title;
  final String body;

  const ShowDialogAction({required this.title, required this.body})
      : super(type: 'showDialog', risk: ActionRisk.medium);
}

final class ResetStateAction extends SchemaAction {
  final List<String>? paths;

  const ResetStateAction({this.paths})
      : super(type: 'resetState', risk: ActionRisk.medium);
}

final class EmitEventAction extends SchemaAction {
  final String name;
  final Map<String, dynamic>? params;

  const EmitEventAction({required this.name, this.params})
      : super(type: 'emitEvent', risk: ActionRisk.medium);
}

// --- High Risk Actions ---

final class OpenUrlAction extends SchemaAction {
  final String url;
  final bool external;

  const OpenUrlAction({required this.url, this.external = false})
      : super(type: 'openUrl', risk: ActionRisk.high);
}

final class RequestAction extends SchemaAction {
  final String method;
  final String url;
  final Map<String, dynamic>? headers;
  final dynamic body;

  const RequestAction({
    required this.method,
    required this.url,
    this.headers,
    this.body,
  }) : super(type: 'request', risk: ActionRisk.high);
}

final class SequenceAction extends SchemaAction {
  final List<SchemaAction> steps;

  const SequenceAction({required this.steps})
      : super(type: 'sequence', risk: ActionRisk.high);
}

final class ConditionalAction extends SchemaAction {
  final String condition;
  final SchemaAction then;
  final SchemaAction? elseAction;

  const ConditionalAction({
    required this.condition,
    required this.then,
    this.elseAction,
  }) : super(type: 'conditional', risk: ActionRisk.low);
}
