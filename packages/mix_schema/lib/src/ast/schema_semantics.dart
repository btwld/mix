/// Accessibility semantics model for AST nodes.
///
/// Covers base, interactive, ordering/relations, and live region semantics
/// as specified in freeze §5.4.
final class SchemaSemantics {
  // Base
  final String? role; // "button", "heading", "img", "list", etc.
  final String? label;
  final String? hint;
  final String? value;
  final bool? enabled;

  // Interactive
  final bool? selected;
  final bool? checked;
  final bool? expanded;

  // Ordering / relations
  final int? focusOrder;
  final String? labelledBy; // nodeId
  final String? describedBy; // nodeId

  // Live regions
  final String? liveRegionMode; // "polite" | "assertive"
  final bool? liveRegionAtomic;
  final String? liveRegionRelevant; // "additions" | "removals" | "text" | "all"
  final bool? liveRegionBusy;

  const SchemaSemantics({
    this.role,
    this.label,
    this.hint,
    this.value,
    this.enabled,
    this.selected,
    this.checked,
    this.expanded,
    this.focusOrder,
    this.labelledBy,
    this.describedBy,
    this.liveRegionMode,
    this.liveRegionAtomic,
    this.liveRegionRelevant,
    this.liveRegionBusy,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchemaSemantics &&
          role == other.role &&
          label == other.label &&
          hint == other.hint &&
          value == other.value &&
          enabled == other.enabled &&
          selected == other.selected &&
          checked == other.checked &&
          expanded == other.expanded &&
          focusOrder == other.focusOrder &&
          labelledBy == other.labelledBy &&
          describedBy == other.describedBy &&
          liveRegionMode == other.liveRegionMode &&
          liveRegionAtomic == other.liveRegionAtomic &&
          liveRegionRelevant == other.liveRegionRelevant &&
          liveRegionBusy == other.liveRegionBusy;

  @override
  int get hashCode => Object.hash(
        role,
        label,
        hint,
        value,
        enabled,
        selected,
        checked,
        expanded,
        focusOrder,
        labelledBy,
        describedBy,
        liveRegionMode,
        liveRegionAtomic,
        liveRegionRelevant,
        liveRegionBusy,
      );

  @override
  String toString() => 'SchemaSemantics(role: $role, label: $label)';
}
