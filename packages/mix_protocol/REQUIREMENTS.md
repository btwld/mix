# mix_protocol Requirements

`mix_protocol` is the versioned wire contract between JSON producers and
representable Mix runtime styles or token themes. It strictly decodes inbound
documents, canonically encodes supported runtime values, provides bounded
lenient style recovery, and exports JSON Schema. It is not a general serializer
for every Mix object or a widget-tree protocol.

The shared `mixProtocol` façade remains the fixed core-only vocabulary. Packages
may expose immutable `MixProtocolVocabulary` values and consumers may compose
them explicitly with `MixProtocol.compose`. Composition is deterministic and
has no runtime registry, import side effects, or mutable global state.

Contributed discriminators are namespaced and wire-major-versioned
(`<vocabulary>.v<major>.<branch>`). Construction rejects invalid identifiers,
duplicate vocabulary ids, duplicate discriminators, and duplicate runtime
types. Contributed runtime types are concrete and mutually disjoint. Branch
construction also rejects invalid, reserved, or duplicate wire fields. Exported
style schema declares the non-core composition in
`x-mix-protocol-vocabularies`.

Ack remains a private codec engine behind `package:mix_protocol/authoring.dart`,
and JSON Schema is a generated artifact rather than a second source of semantic
truth. The field model owns schema-export semantics and inventory metadata.

The canonical wire format is documented in
[`WIRE_CONTRACT.md`](WIRE_CONTRACT.md). That file replaces the old R-1..R-12
governance matrix; tests should assert behavior and public contract output
rather than requirement traceability.

Unsupported runtime values fail encode explicitly instead of being dropped.
