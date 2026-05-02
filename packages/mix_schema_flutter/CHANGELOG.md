# Changelog

## 1.0.0-draft

Initial Flutter runtime bindings for the Mix JSON Schema (v1.0 Draft).

- `HostResolver` abstract + `AllowlistHostResolver` reference impl matching §Security Considerations guidance.
- `RuntimeParser.toWidget(WidgetNode)` foundation — wires Box, FlexBox, RowBox, ColumnBox, StyledText. Per-prop styler dispatch lands incrementally.
- `RuntimeSerializer` placeholder — inverse expansion follows the validator's semantic stage maturation.
- Re-exports the full `mix_schema` API so consumers depend on this package alone.
