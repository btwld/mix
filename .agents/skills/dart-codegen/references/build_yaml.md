# build.yaml Complete Schema

## Top-level keys
`builders`, `targets`, `post_process_builders`, `global_options`, `additional_public_assets`.

## builders entry
```yaml
builders:
  my_builder:                      # key used as `pkg_name|my_builder`
    import: "package:pkg/builder.dart"   # required
    builder_factories: ["myBuilder"]     # required — top-level fn returning Builder
    build_extensions: {".dart": [".g.dart"]}  # required
    auto_apply: dependents                # none | dependents | all_packages | root_package
    build_to: cache                       # cache | source
    required_inputs: [".g.dart"]          # phase-ordering: waits for these to be produced
    runs_before: ["other_pkg|other_builder"]   # targeted ordering
    applies_builders: ["source_gen|combining_builder"]  # auto-activate companions
    is_optional: false                    # only runs if output is consumed
    defaults:
      generate_for: {include: [...], exclude: [...]}
      options: {}
      dev_options: {}
      release_options: {}
```

`required_inputs` places all builders producing those extensions in an earlier phase. Cannot require an extension you produce.

## targets entry
```yaml
targets:
  $default:                      # the package's own target
    builders:
      json_serializable:
        enabled: true
        generate_for:
          include: [lib/models/**.dart]
          exclude: [lib/models/internal.dart]
        options:
          explicit_to_json: true
        dev_options: {}
        release_options: {}
    sources:
      include: ["lib/**", "bin/**"]
      exclude: ["**/*.g.dart"]
    dependencies: []
    auto_apply_builders: true
```

## Options precedence (low → high)
builder defaults → builder defaults-by-mode → target config → target-by-mode → global_options → global_options-by-mode

## Capture groups in build_extensions
`{{}}` = unnamed capture. `{{name}}` = named. `^` prefix = anchored at path start.

```yaml
# Unnamed: redirect all .g.dart to lib/generated/
source_gen|combining_builder:
  options:
    build_extensions:
      '^lib/{{}}.dart': 'lib/generated/{{}}.g.dart'

# Named: map dir + file separately
build_extensions:
  '{{dir}}/{{file}}.dart': ['{{dir}}/generated/{{file}}.api.dart']
```

## global_options (root package only)
```yaml
global_options:
  freezed:freezed:
    runs_before:
      - json_serializable|json_serializable
```
This adds an ordering edge between third-party builders that don't know about each other. Appended to existing `runs_before`.

## post_process_builders
Run in a single phase after all regular builders. Can only read primary input. Only cache outputs. Cannot feed other builders.

## Skeleton for a typical SharedPartBuilder
```yaml
builders:
  my_gen:
    import: "package:my_gen/builder.dart"
    builder_factories: ["myGen"]
    build_extensions: {".dart": [".my_gen.g.part"]}
    auto_apply: dependents
    build_to: cache
    applies_builders: ["source_gen|combining_builder"]
```

## Skeleton for aggregating builder (injectable-style)
```yaml
builders:
  # Phase 1: per-file scrape
  scraper:
    import: "package:di/builder.dart"
    builder_factories: ["scraperBuilder"]
    build_extensions: {".dart": [".di.json"]}
    auto_apply: dependents
    build_to: cache
  # Phase 2: aggregate
  config:
    import: "package:di/builder.dart"
    builder_factories: ["configBuilder"]
    build_extensions: {"$lib$": ["di.config.dart"]}
    auto_apply: root_package
    build_to: source
    required_inputs: [".di.json"]
```
