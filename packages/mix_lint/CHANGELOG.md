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