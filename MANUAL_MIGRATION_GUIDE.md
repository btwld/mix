# Manual Migration Guide: Mix Package Reorganization

This guide provides step-by-step instructions for manually reorganizing the Mix package folder structure.

## Overview

The goal is to reorganize the current folder structure to be cleaner and more intuitive:

- `attributes/` → `properties/` (grouped by painting, layout, typography)
- `specs/` → `widgets/` (grouped by widget type)
- Core files organized into subfolders (providers, extensions, internal)
- Animation files moved to dedicated folder
- Variants moved to dedicated folder

## Step 1: Create New Directory Structure

First, create these new directories:

```bash
mkdir -p packages/mix/lib/src/animation
mkdir -p packages/mix/lib/src/core/providers
mkdir -p packages/mix/lib/src/core/extensions
mkdir -p packages/mix/lib/src/core/internal
mkdir -p packages/mix/lib/src/properties/painting
mkdir -p packages/mix/lib/src/properties/layout
mkdir -p packages/mix/lib/src/properties/typography
mkdir -p packages/mix/lib/src/variants
mkdir -p packages/mix/lib/src/widget_state
mkdir -p packages/mix/lib/src/widgets/box
mkdir -p packages/mix/lib/src/widgets/text
mkdir -p packages/mix/lib/src/widgets/icon
mkdir -p packages/mix/lib/src/widgets/image
mkdir -p packages/mix/lib/src/widgets/flex
mkdir -p packages/mix/lib/src/widgets/flexbox
mkdir -p packages/mix/lib/src/widgets/stack
mkdir -p packages/mix/lib/src/widgets/pressable

# Create corresponding test directories
mkdir -p packages/mix/test/src/animation
mkdir -p packages/mix/test/src/core/providers
mkdir -p packages/mix/test/src/core/extensions
mkdir -p packages/mix/test/src/core/internal
mkdir -p packages/mix/test/src/properties/painting
mkdir -p packages/mix/test/src/properties/layout
mkdir -p packages/mix/test/src/properties/typography
mkdir -p packages/mix/test/src/variants
mkdir -p packages/mix/test/src/widget_state
mkdir -p packages/mix/test/src/widgets/box
mkdir -p packages/mix/test/src/widgets/text
mkdir -p packages/mix/test/src/widgets/icon
mkdir -p packages/mix/test/src/widgets/image
mkdir -p packages/mix/test/src/widgets/flex
mkdir -p packages/mix/test/src/widgets/flexbox
mkdir -p packages/mix/test/src/widgets/stack
mkdir -p packages/mix/test/src/widgets/pressable
```

## Step 2: Move Core Provider Files

### Source Files
```bash
# Move provider files
mv packages/mix/lib/src/core/style_provider.dart packages/mix/lib/src/core/providers/style_provider.dart
mv packages/mix/lib/src/core/resolved_style_provider.dart packages/mix/lib/src/core/providers/resolved_style_provider.dart
mv packages/mix/lib/src/core/widget_state/widget_state_provider.dart packages/mix/lib/src/core/providers/widget_state_provider.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/core/style_provider_test.dart packages/mix/test/src/core/providers/style_provider_test.dart
mv packages/mix/test/src/core/resolved_style_provider_test.dart packages/mix/test/src/core/providers/resolved_style_provider_test.dart
mv packages/mix/test/src/core/widget_state/widget_state_provider_test.dart packages/mix/test/src/core/providers/widget_state_provider_test.dart
```

## Step 3: Move Core Extension Files

### Source Files
```bash
# Move extension files
mv packages/mix/lib/src/helpers/extensions.dart packages/mix/lib/src/core/extensions/extensions.dart
mv packages/mix/lib/src/core/widget_state/widget_state_controller_ext.dart packages/mix/lib/src/core/extensions/widget_state_controller_ext.dart
```

### Test Files
```bash
# Move corresponding test files (if they exist)
# Check if these test files exist first:
[ -f packages/mix/test/src/helpers/extensions_test.dart ] && mv packages/mix/test/src/helpers/extensions_test.dart packages/mix/test/src/core/extensions/extensions_test.dart
[ -f packages/mix/test/src/core/widget_state/widget_state_controller_ext_test.dart ] && mv packages/mix/test/src/core/widget_state/widget_state_controller_ext_test.dart packages/mix/test/src/core/extensions/widget_state_controller_ext_test.dart
```

## Step 4: Move Internal Files

### Source Files
```bash
# Move internal files
mv packages/mix/lib/src/internal/compare_mixin.dart packages/mix/lib/src/core/internal/compare_mixin.dart
mv packages/mix/lib/src/internal/constants.dart packages/mix/lib/src/core/internal/constants.dart
mv packages/mix/lib/src/internal/deep_collection_equality.dart packages/mix/lib/src/core/internal/deep_collection_equality.dart
mv packages/mix/lib/src/internal/diagnostic_properties_builder_ext.dart packages/mix/lib/src/core/internal/diagnostic_properties_builder_ext.dart
mv packages/mix/lib/src/internal/helper_util.dart packages/mix/lib/src/core/internal/helper_util.dart
mv packages/mix/lib/src/internal/internal_extensions.dart packages/mix/lib/src/core/internal/internal_extensions.dart
mv packages/mix/lib/src/internal/mix_error.dart packages/mix/lib/src/core/internal/mix_error.dart
mv packages/mix/lib/src/core/widget_state/internal/mix_hoverable_region.dart packages/mix/lib/src/core/internal/mix_hoverable_region.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/internal/compare_mixin_test.dart packages/mix/test/src/core/internal/compare_mixin_test.dart
mv packages/mix/test/src/internal/constants_test.dart packages/mix/test/src/core/internal/constants_test.dart
mv packages/mix/test/src/internal/deep_collection_equality_test.dart packages/mix/test/src/core/internal/deep_collection_equality_test.dart
mv packages/mix/test/src/internal/diagnostic_properties_builder_ext_test.dart packages/mix/test/src/core/internal/diagnostic_properties_builder_ext_test.dart
mv packages/mix/test/src/internal/helper_util_test.dart packages/mix/test/src/core/internal/helper_util_test.dart
mv packages/mix/test/src/internal/internal_extensions_test.dart packages/mix/test/src/core/internal/internal_extensions_test.dart
mv packages/mix/test/src/internal/mix_error_test.dart packages/mix/test/src/core/internal/mix_error_test.dart
[ -f packages/mix/test/src/core/widget_state/internal/mix_hoverable_region_test.dart ] && mv packages/mix/test/src/core/widget_state/internal/mix_hoverable_region_test.dart packages/mix/test/src/core/internal/mix_hoverable_region_test.dart
```

## Step 5: Move Animation Files

### Source Files
```bash
# Move animation files
mv packages/mix/lib/src/core/animation_config.dart packages/mix/lib/src/animation/animation_config.dart
mv packages/mix/lib/src/core/animation/animation_util.dart packages/mix/lib/src/animation/animation_util.dart
mv packages/mix/lib/src/core/animation/curves.dart packages/mix/lib/src/animation/curves.dart
mv packages/mix/lib/src/core/animation/style_animation_builder.dart packages/mix/lib/src/animation/style_animation_builder.dart
mv packages/mix/lib/src/core/animation/style_animation_driver.dart packages/mix/lib/src/animation/style_animation_driver.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/core/animation_config_test.dart packages/mix/test/src/animation/animation_config_test.dart
mv packages/mix/test/src/core/animation/animation_util_test.dart packages/mix/test/src/animation/animation_util_test.dart
mv packages/mix/test/src/core/animation/curves_test.dart packages/mix/test/src/animation/curves_test.dart
mv packages/mix/test/src/core/animation/style_animation_builder_test.dart packages/mix/test/src/animation/style_animation_builder_test.dart
mv packages/mix/test/src/core/animation/style_animation_driver_test.dart packages/mix/test/src/animation/style_animation_driver_test.dart
```

## Step 6: Move Widget State Files

### Source Files
```bash
# Move widget state files
mv packages/mix/lib/src/core/widget_state/cursor_position.dart packages/mix/lib/src/widget_state/cursor_position.dart
```

### Test Files
```bash
# Move corresponding test files
[ -f packages/mix/test/src/core/widget_state/cursor_position_test.dart ] && mv packages/mix/test/src/core/widget_state/cursor_position_test.dart packages/mix/test/src/widget_state/cursor_position_test.dart
```

## Step 7: Move Attributes to Properties - Painting

### Source Files
```bash
# Move painting-related attribute files
mv packages/mix/lib/src/attributes/border_mix.dart packages/mix/lib/src/properties/painting/border_mix.dart
mv packages/mix/lib/src/attributes/border_util.dart packages/mix/lib/src/properties/painting/border_util.dart
mv packages/mix/lib/src/attributes/border_radius_mix.dart packages/mix/lib/src/properties/painting/border_radius_mix.dart
mv packages/mix/lib/src/attributes/border_radius_util.dart packages/mix/lib/src/properties/painting/border_radius_util.dart
mv packages/mix/lib/src/attributes/shape_border_mix.dart packages/mix/lib/src/properties/painting/shape_border_mix.dart
mv packages/mix/lib/src/attributes/shape_border_util.dart packages/mix/lib/src/properties/painting/shape_border_util.dart
mv packages/mix/lib/src/attributes/color_util.dart packages/mix/lib/src/properties/painting/color_util.dart
mv packages/mix/lib/src/attributes/material_colors_util.dart packages/mix/lib/src/properties/painting/material_colors_util.dart
mv packages/mix/lib/src/attributes/decoration_mix.dart packages/mix/lib/src/properties/painting/decoration_mix.dart
mv packages/mix/lib/src/attributes/decoration_util.dart packages/mix/lib/src/properties/painting/decoration_util.dart
mv packages/mix/lib/src/attributes/decoration_image_mix.dart packages/mix/lib/src/properties/painting/decoration_image_mix.dart
mv packages/mix/lib/src/attributes/decoration_image_util.dart packages/mix/lib/src/properties/painting/decoration_image_util.dart
mv packages/mix/lib/src/attributes/gradient_mix.dart packages/mix/lib/src/properties/painting/gradient_mix.dart
mv packages/mix/lib/src/attributes/gradient_util.dart packages/mix/lib/src/properties/painting/gradient_util.dart
mv packages/mix/lib/src/attributes/shadow_mix.dart packages/mix/lib/src/properties/painting/shadow_mix.dart
mv packages/mix/lib/src/attributes/shadow_util.dart packages/mix/lib/src/properties/painting/shadow_util.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/attributes/border_mix_test.dart packages/mix/test/src/properties/painting/border_mix_test.dart
mv packages/mix/test/src/attributes/border_util_test.dart packages/mix/test/src/properties/painting/border_util_test.dart
mv packages/mix/test/src/attributes/border_radius_mix_test.dart packages/mix/test/src/properties/painting/border_radius_mix_test.dart
mv packages/mix/test/src/attributes/border_radius_util_test.dart packages/mix/test/src/properties/painting/border_radius_util_test.dart
mv packages/mix/test/src/attributes/shape_border_mix_test.dart packages/mix/test/src/properties/painting/shape_border_mix_test.dart
mv packages/mix/test/src/attributes/shape_border_util_test.dart packages/mix/test/src/properties/painting/shape_border_util_test.dart
mv packages/mix/test/src/attributes/color_util_test.dart packages/mix/test/src/properties/painting/color_util_test.dart
mv packages/mix/test/src/attributes/material_colors_util_test.dart packages/mix/test/src/properties/painting/material_colors_util_test.dart
mv packages/mix/test/src/attributes/decoration_mix_test.dart packages/mix/test/src/properties/painting/decoration_mix_test.dart
mv packages/mix/test/src/attributes/decoration_util_test.dart packages/mix/test/src/properties/painting/decoration_util_test.dart
mv packages/mix/test/src/attributes/decoration_image_mix_test.dart packages/mix/test/src/properties/painting/decoration_image_mix_test.dart
mv packages/mix/test/src/attributes/decoration_image_util_test.dart packages/mix/test/src/properties/painting/decoration_image_util_test.dart
mv packages/mix/test/src/attributes/gradient_mix_test.dart packages/mix/test/src/properties/painting/gradient_mix_test.dart
mv packages/mix/test/src/attributes/gradient_util_test.dart packages/mix/test/src/properties/painting/gradient_util_test.dart
mv packages/mix/test/src/attributes/shadow_mix_test.dart packages/mix/test/src/properties/painting/shadow_mix_test.dart
mv packages/mix/test/src/attributes/shadow_util_test.dart packages/mix/test/src/properties/painting/shadow_util_test.dart
```

## Step 8: Move Attributes to Properties - Layout

### Source Files
```bash
# Move layout-related attribute files
mv packages/mix/lib/src/attributes/constraints_mix.dart packages/mix/lib/src/properties/layout/constraints_mix.dart
mv packages/mix/lib/src/attributes/constraints_util.dart packages/mix/lib/src/properties/layout/constraints_util.dart
mv packages/mix/lib/src/attributes/edge_insets_geometry_mix.dart packages/mix/lib/src/properties/layout/edge_insets_geometry_mix.dart
mv packages/mix/lib/src/attributes/edge_insets_geometry_util.dart packages/mix/lib/src/properties/layout/edge_insets_geometry_util.dart
mv packages/mix/lib/src/attributes/scalar_util.dart packages/mix/lib/src/properties/layout/scalar_util.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/attributes/constraints_mix_test.dart packages/mix/test/src/properties/layout/constraints_mix_test.dart
mv packages/mix/test/src/attributes/constraints_util_test.dart packages/mix/test/src/properties/layout/constraints_util_test.dart
mv packages/mix/test/src/attributes/edge_insets_geometry_mix_test.dart packages/mix/test/src/properties/layout/edge_insets_geometry_mix_test.dart
mv packages/mix/test/src/attributes/edge_insets_geometry_util_test.dart packages/mix/test/src/properties/layout/edge_insets_geometry_util_test.dart
mv packages/mix/test/src/attributes/scalar_util_test.dart packages/mix/test/src/properties/layout/scalar_util_test.dart
```

## Step 9: Move Attributes to Properties - Typography

### Source Files
```bash
# Move typography-related attribute files
mv packages/mix/lib/src/attributes/text_style_mix.dart packages/mix/lib/src/properties/typography/text_style_mix.dart
mv packages/mix/lib/src/attributes/text_style_util.dart packages/mix/lib/src/properties/typography/text_style_util.dart
mv packages/mix/lib/src/attributes/strut_style_mix.dart packages/mix/lib/src/properties/typography/strut_style_mix.dart
mv packages/mix/lib/src/attributes/strut_style_util.dart packages/mix/lib/src/properties/typography/strut_style_util.dart
mv packages/mix/lib/src/attributes/text_height_behavior_mix.dart packages/mix/lib/src/properties/typography/text_height_behavior_mix.dart
mv packages/mix/lib/src/attributes/text_height_behavior_util.dart packages/mix/lib/src/properties/typography/text_height_behavior_util.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/attributes/text_style_mix_test.dart packages/mix/test/src/properties/typography/text_style_mix_test.dart
mv packages/mix/test/src/attributes/text_style_util_test.dart packages/mix/test/src/properties/typography/text_style_util_test.dart
mv packages/mix/test/src/attributes/strut_style_mix_test.dart packages/mix/test/src/properties/typography/strut_style_mix_test.dart
mv packages/mix/test/src/attributes/strut_style_util_test.dart packages/mix/test/src/properties/typography/strut_style_util_test.dart
mv packages/mix/test/src/attributes/text_height_behavior_mix_test.dart packages/mix/test/src/properties/typography/text_height_behavior_mix_test.dart
mv packages/mix/test/src/attributes/text_height_behavior_util_test.dart packages/mix/test/src/properties/typography/text_height_behavior_util_test.dart
```

## Step 10: Move Properties Common Files

### Source Files
```bash
# Move spec_util to properties root
mv packages/mix/lib/src/specs/spec_util.dart packages/mix/lib/src/properties/spec_util.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/specs/spec_util_test.dart packages/mix/test/src/properties/spec_util_test.dart
```

## Step 11: Move Specs to Widgets - Box

### Source Files
```bash
# Move box-related files
mv packages/mix/lib/src/specs/box/box_attribute.dart packages/mix/lib/src/widgets/box/box_attribute.dart
mv packages/mix/lib/src/specs/box/box_spec.dart packages/mix/lib/src/widgets/box/box_spec.dart
mv packages/mix/lib/src/specs/box/box_widget.dart packages/mix/lib/src/widgets/box/box_widget.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/specs/box/box_attribute_test.dart packages/mix/test/src/widgets/box/box_attribute_test.dart
mv packages/mix/test/src/specs/box/box_spec_test.dart packages/mix/test/src/widgets/box/box_spec_test.dart
mv packages/mix/test/src/specs/box/box_widget_test.dart packages/mix/test/src/widgets/box/box_widget_test.dart
```

## Step 12: Move Specs to Widgets - Text

### Source Files
```bash
# Move text-related files
mv packages/mix/lib/src/specs/text/text_attribute.dart packages/mix/lib/src/widgets/text/text_attribute.dart
mv packages/mix/lib/src/specs/text/text_spec.dart packages/mix/lib/src/widgets/text/text_spec.dart
mv packages/mix/lib/src/specs/text/text_widget.dart packages/mix/lib/src/widgets/text/text_widget.dart
mv packages/mix/lib/src/specs/text/text_directives_util.dart packages/mix/lib/src/widgets/text/text_directives_util.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/specs/text/text_attribute_test.dart packages/mix/test/src/widgets/text/text_attribute_test.dart
mv packages/mix/test/src/specs/text/text_spec_test.dart packages/mix/test/src/widgets/text/text_spec_test.dart
mv packages/mix/test/src/specs/text/text_widget_test.dart packages/mix/test/src/widgets/text/text_widget_test.dart
mv packages/mix/test/src/specs/text/text_directives_util_test.dart packages/mix/test/src/widgets/text/text_directives_util_test.dart
```

## Step 13: Move Specs to Widgets - Icon

### Source Files
```bash
# Move icon-related files
mv packages/mix/lib/src/specs/icon/icon_attribute.dart packages/mix/lib/src/widgets/icon/icon_attribute.dart
mv packages/mix/lib/src/specs/icon/icon_spec.dart packages/mix/lib/src/widgets/icon/icon_spec.dart
mv packages/mix/lib/src/specs/icon/icon_widget.dart packages/mix/lib/src/widgets/icon/icon_widget.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/specs/icon/icon_attribute_test.dart packages/mix/test/src/widgets/icon/icon_attribute_test.dart
mv packages/mix/test/src/specs/icon/icon_spec_test.dart packages/mix/test/src/widgets/icon/icon_spec_test.dart
mv packages/mix/test/src/specs/icon/icon_widget_test.dart packages/mix/test/src/widgets/icon/icon_widget_test.dart
```

## Step 14: Move Specs to Widgets - Image

### Source Files
```bash
# Move image-related files
mv packages/mix/lib/src/specs/image/image_attribute.dart packages/mix/lib/src/widgets/image/image_attribute.dart
mv packages/mix/lib/src/specs/image/image_spec.dart packages/mix/lib/src/widgets/image/image_spec.dart
mv packages/mix/lib/src/specs/image/image_widget.dart packages/mix/lib/src/widgets/image/image_widget.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/specs/image/image_attribute_test.dart packages/mix/test/src/widgets/image/image_attribute_test.dart
mv packages/mix/test/src/specs/image/image_spec_test.dart packages/mix/test/src/widgets/image/image_spec_test.dart
mv packages/mix/test/src/specs/image/image_widget_test.dart packages/mix/test/src/widgets/image/image_widget_test.dart
```

## Step 15: Move Specs to Widgets - Flex

### Source Files
```bash
# Move flex-related files
mv packages/mix/lib/src/specs/flex/flex_attribute.dart packages/mix/lib/src/widgets/flex/flex_attribute.dart
mv packages/mix/lib/src/specs/flex/flex_spec.dart packages/mix/lib/src/widgets/flex/flex_spec.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/specs/flex/flex_attribute_test.dart packages/mix/test/src/widgets/flex/flex_attribute_test.dart
mv packages/mix/test/src/specs/flex/flex_spec_test.dart packages/mix/test/src/widgets/flex/flex_spec_test.dart
```

## Step 16: Move Specs to Widgets - Flexbox

### Source Files
```bash
# Move flexbox-related files
mv packages/mix/lib/src/specs/flexbox/flexbox_spec.dart packages/mix/lib/src/widgets/flexbox/flexbox_spec.dart
mv packages/mix/lib/src/specs/flexbox/flexbox_widget.dart packages/mix/lib/src/widgets/flexbox/flexbox_widget.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/specs/flexbox/flexbox_spec_test.dart packages/mix/test/src/widgets/flexbox/flexbox_spec_test.dart
mv packages/mix/test/src/specs/flexbox/flexbox_widget_test.dart packages/mix/test/src/widgets/flexbox/flexbox_widget_test.dart
```

## Step 17: Move Specs to Widgets - Stack

### Source Files
```bash
# Move stack-related files
mv packages/mix/lib/src/specs/stack/stack_attribute.dart packages/mix/lib/src/widgets/stack/stack_attribute.dart
mv packages/mix/lib/src/specs/stack/stack_spec.dart packages/mix/lib/src/widgets/stack/stack_spec.dart
mv packages/mix/lib/src/specs/stack/stack_box_spec.dart packages/mix/lib/src/widgets/stack/stack_box_spec.dart
mv packages/mix/lib/src/specs/stack/stack_widget.dart packages/mix/lib/src/widgets/stack/stack_widget.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/specs/stack/stack_attribute_test.dart packages/mix/test/src/widgets/stack/stack_attribute_test.dart
mv packages/mix/test/src/specs/stack/stack_spec_test.dart packages/mix/test/src/widgets/stack/stack_spec_test.dart
mv packages/mix/test/src/specs/stack/stack_box_spec_test.dart packages/mix/test/src/widgets/stack/stack_box_spec_test.dart
mv packages/mix/test/src/specs/stack/stack_widget_test.dart packages/mix/test/src/widgets/stack/stack_widget_test.dart
```

## Step 18: Move Variant Files

### Source Files
```bash
# Move variant files
mv packages/mix/lib/src/core/variant.dart packages/mix/lib/src/variants/variant.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/core/variant_test.dart packages/mix/test/src/variants/variant_test.dart
```

## Step 19: Move Pressable Widget

### Source Files
```bash
# Move pressable widget
mv packages/mix/lib/src/widgets/pressable_widget.dart packages/mix/lib/src/widgets/pressable/pressable_widget.dart
```

### Test Files
```bash
# Move corresponding test files
mv packages/mix/test/src/widgets/pressable_widget_test.dart packages/mix/test/src/widgets/pressable/pressable_widget_test.dart
```

## Step 20: Clean Up Empty Directories

After moving all files, remove the now-empty directories:

```bash
# Remove empty source directories
rmdir packages/mix/lib/src/attributes
rmdir packages/mix/lib/src/specs/box
rmdir packages/mix/lib/src/specs/text
rmdir packages/mix/lib/src/specs/icon
rmdir packages/mix/lib/src/specs/image
rmdir packages/mix/lib/src/specs/flex
rmdir packages/mix/lib/src/specs/flexbox
rmdir packages/mix/lib/src/specs/stack
rmdir packages/mix/lib/src/specs
rmdir packages/mix/lib/src/internal
rmdir packages/mix/lib/src/helpers
rmdir packages/mix/lib/src/core/animation
rmdir packages/mix/lib/src/core/widget_state/internal
rmdir packages/mix/lib/src/core/widget_state

# Remove empty test directories
rmdir packages/mix/test/src/attributes
rmdir packages/mix/test/src/specs/box
rmdir packages/mix/test/src/specs/text
rmdir packages/mix/test/src/specs/icon
rmdir packages/mix/test/src/specs/image
rmdir packages/mix/test/src/specs/flex
rmdir packages/mix/test/src/specs/flexbox
rmdir packages/mix/test/src/specs/stack
rmdir packages/mix/test/src/specs
rmdir packages/mix/test/src/internal
rmdir packages/mix/test/src/helpers
rmdir packages/mix/test/src/core/animation
rmdir packages/mix/test/src/core/widget_state
```

## Step 21: Update Import Statements

After moving all files, you'll need to update import statements throughout the codebase. Here are the key patterns to search and replace:

### Common Import Updates Needed:

1. **Attributes to Properties:**
   - `../attributes/` → `../properties/painting/`, `../properties/layout/`, or `../properties/typography/`
   - `'src/attributes/` → `'src/properties/painting/`, `'src/properties/layout/`, or `'src/properties/typography/`

2. **Specs to Widgets:**
   - `../specs/` → `../widgets/`
   - `'src/specs/` → `'src/widgets/`

3. **Core Reorganization:**
   - `../internal/` → `../core/internal/`
   - `../helpers/extensions.dart` → `../core/extensions/extensions.dart`
   - `../core/animation/` → `../animation/`
   - `../core/variant.dart` → `../variants/variant.dart`

4. **Provider Updates:**
   - `../core/style_provider.dart` → `../core/providers/style_provider.dart`
   - `../core/resolved_style_provider.dart` → `../core/providers/resolved_style_provider.dart`
   - `../core/widget_state/widget_state_provider.dart` → `../core/providers/widget_state_provider.dart`

## Step 22: Update Main Barrel Export File

Update `packages/mix/lib/mix.dart` to reflect the new file locations. Replace the old export paths with the new ones according to the file moves above.

## Step 23: Verification

After completing all moves and import updates:

1. Run `melos run analyze` to check for any import errors
2. Run `melos run test:flutter` to ensure all tests still pass
3. Fix any remaining import issues that are flagged

## Final Directory Structure

After completion, your directory structure should look like:

```
packages/mix/lib/src/
├── animation/
├── core/
│   ├── extensions/
│   ├── internal/
│   └── providers/
├── modifiers/
├── properties/
│   ├── layout/
│   ├── painting/
│   └── typography/
├── theme/
├── variants/
├── widget_state/
└── widgets/
    ├── box/
    ├── flex/
    ├── flexbox/
    ├── icon/
    ├── image/
    ├── pressable/
    ├── stack/
    └── text/
```

This reorganization provides a much cleaner and more intuitive folder structure for the Mix package.