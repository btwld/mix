# mix_protocol Requirements

`mix_protocol` is the versioned wire contract between JSON producers and
representable Mix runtime styles or token themes. It strictly decodes inbound
documents, canonically encodes supported runtime values, provides bounded
lenient style recovery, and exports JSON Schema. It is not a general serializer
for every Mix object or a widget-tree protocol.

The public boundary is the fixed `mixProtocol` façade. Ack is a private codec
engine, and JSON Schema is a generated artifact rather than a second source of
semantic truth. V1 has no public codec registry or custom styler branches.

The canonical wire format is documented in
[`WIRE_CONTRACT.md`](WIRE_CONTRACT.md). That file replaces the old R-1..R-12
governance matrix; tests should assert behavior and public contract output
rather than requirement traceability.

Unsupported runtime values fail encode explicitly instead of being dropped.
