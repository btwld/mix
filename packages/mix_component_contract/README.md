# mix_component_contract

Pure Dart models and strict parsers for the portable Mix component documents
identified by `mix_atlas/component/v1` and `mix_atlas/component/v2`.

The package deliberately has no Flutter, Mix, or `mix_protocol` dependency.
Consumers provide JSON bytes and receive an immutable
`PortableComponentDocument` or a structured `ArtifactLoadException`.

The v1 Button fixture is a ported copy of the self-authored `remix_capture`
fixture. The static v2 fixture is materialized from that package's in-memory
fixture builder. Tests and production use no live dependency on the remix
repository.
