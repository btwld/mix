## 0.1.4

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