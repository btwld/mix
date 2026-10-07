## Unreleased

 - **BREAKING**: Renamed every rule. Plugin rules are already scoped by the
   plugin name, as in `// ignore: mix_lint/<rule>`, so the `mix_` prefix is
   gone, and each name now describes the problem it reports. The two
   inline-token rules are now one rule, `inline_token_definition`. See the
   migration table below.
 - **BREAKING**: `missing_create_constructor` and
   `token_reference_outside_mix` are now warnings, on by default. The other
   rules are lints, off until you enable them.
 - **FEAT**: Add `unnecessary_styler_constructor`, with a quick fix: it turns
   `.onHovered(BoxStyler().color(...))` into `.onHovered(.color(...))`.
 - **FEAT**: `long_styler_chain` reads its limit from `max_calls` in a
   top-level `mix_lint:` section of `analysis_options.yaml` and from files it
   includes. The default stays 15.
 - **FIX**: Add `lib/main.dart`, the entry point the analysis server loads.
   2.0.0 did not load without it.
 - **FIX**: Remove false positives in `token_reference_outside_mix`,
   `variants_without_base_style`, `base_style_after_variant`,
   `inline_token_definition`, and `unnecessary_type_name`, found by running
   the rules on Mix itself.
 - **FIX**: `token_reference_outside_mix` also catches references passed to
   Flutter APIs through dot shorthands, such as
   `Padding(padding: .all($space()))`.
 - **CHORE**: Require `analysis_server_plugin` ^0.3.23 and `analyzer`
   ^14.4.0 (Dart 3.12 or later). Plugins that a project enables together
   resolve in one package, so they must accept the same analyzer version.

### Migrate from 2.0.0

| 2.0.0 name | New name |
|---|---|
| `mix_avoid_defining_tokens_within_scope` | `inline_token_definition` |
| `mix_avoid_defining_tokens_within_style` | `inline_token_definition` |
| `mix_avoid_empty_variants` | `variants_without_base_style` |
| `mix_avoid_token_ref_outside_mix` | `token_reference_outside_mix` |
| `mix_max_number_of_attributes_per_style` | `long_styler_chain` |
| `mix_mixable_styler_has_create` | `missing_create_constructor` |
| `mix_prefer_dot_shorthands` | `unnecessary_type_name` |
| `mix_variants_last` | `base_style_after_variant` |

Update each old name in these places:

 1. `diagnostics:` entries under `plugins: mix_lint:` in
    `analysis_options.yaml`. The analyzer ignores unknown names there, so an
    old name silently stops working.
 2. `// ignore: mix_lint/<rule>` and `// ignore_for_file: mix_lint/<rule>`
    comments.

To find them, search for the old prefixes:

```sh
grep -rnE "mix_(avoid|max|mixable|prefer|variants)_" --include='*.dart' --include='*.yaml' .
```

## 2.0.0

 - **BREAKING**: Rebuilt `mix_lint` on top of the `analysis_server_plugin` API,
   replacing the previous `custom_lint` implementation. The plugin now runs
   directly in the analysis server; remove any `custom_lint` analyzer plugin
   wiring and enable `mix_lint` per the updated README (#871).
 - **FEAT**: Add the `mix_avoid_token_ref_outside_mix` rule, flagging token
   references resolved outside of a `Mix` context (#939).
 - **FEAT**: Ship the Mix 2.0 rule set: `mix_avoid_empty_variants`,
   `mix_variants_last`, `mix_max_number_of_attributes_per_style`,
   `mix_avoid_defining_tokens_within_style`,
   `mix_avoid_defining_tokens_within_scope`, `mix_mixable_styler_has_create`,
   and `mix_prefer_dot_shorthands` (with an automated fix).

## 1.7.0

 - No changes in this release.

## 0.1.3

 - **CHORE**: Update min version compatibility (#572)

## 0.1.2

 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).

## 0.1.1

 - **FEAT**: Improvements for the "extract attributes" assist (#387).
 - **FEAT**: implement quick fix for mix_attributes_ordering rule (#381).
 - **FEAT**: ColorSwatchToken and other token improvements (#378).

## 0.1.0+1

 - **REFACTOR**: bump flutter version to 3.19.0 (#365).

## 0.1.0

- Initial version.
- Introduces lint rules for:
  - (mix_attributes_ordering) Ordering attributes in `Style` constructor;
  - (mix_avoid_empty_variants) Avoiding empty variants;
  - (mix_avoid_variant_inside_context_variant) use of variant inside `ContextVariant`;
  - (mix_avoid_defining_tokens_or_variants_within_style) Preventing `Variant` and `MixToken` instantiation inside `Style` constructors;
  - (mix_avoid_defining_tokens_within_theme_data) Avoiding `Token` creation inside `MixThemeData`;
  - (mix_max_number_of_attributes_per_style) Limiting the number of attributes per `Style`;