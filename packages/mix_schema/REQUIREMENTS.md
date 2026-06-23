# mix_schema Requirements

`mix_schema` is the Ack-backed contract between JSON style payload producers and
representable Mix runtime stylers. It validates and decodes inbound payloads,
encodes representable runtime stylers, and exports JSON Schema. It is not a
general serializer for every Mix object.

The canonical wire format is documented in
[`WIRE_CONTRACT.md`](WIRE_CONTRACT.md). That file replaces the old R-1..R-12
governance matrix; tests should assert behavior and public contract output
rather than requirement traceability.

Unsupported runtime values fail encode explicitly instead of being dropped.
