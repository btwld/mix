# Callable pressable builders: release migration audit

The source API introduced in PR #1088 makes **compose → `.pressable()` → call**
the default for interactive surfaces owned by a Mix styler. It covers Box, Text,
Icon, Image, FlexBox, StackBox, WrapBox, and GridBox. Released constructors remain
supported; direct `Pressable` remains appropriate for arbitrary widget trees.

## Release boundary

This API is unreleased and absent from Mix 2.2.1. The hosted showcase deliberately
resolves published Mix (`mix: ^2.2.0`) in the **Examples / Published Mix** CI job,
without Melos overrides. Consequently all 31 runtime call sites below retain
published-compatible constructors for this revision. This includes getting-started
and core examples, as well as standalone DartPad Snacks. The source-only runnable
example in `packages/mix/example` demonstrates the new convention now.

After the release containing callable builders:

1. Raise hosted showcase and DartPad dependencies to that release.
2. Migrate each applicable surface using the mapping below; preserve content,
   hit areas, keys, state scopes, and interaction options. Do not split a compound
   button into separately pressable icon/text pieces.
3. Check pointer, keyboard, focus, semantics and golden tests after migrations.
   `onPress: null` does not imply `enabled: false`. Icon and Text builders do not
   add padding automatically. Keep nested editable controls' focus boundaries.
4. Update the separate `btwld/mix-docs` website: getting started, Pressable API,
   styler composition, reuse, Icon/Image content parameters and accessibility.
5. Update version gates in repository and installed skills to the released version.

`@MixWidget` factories still return styles. Callable builders are not supported
as annotated style factories in this revision.

## Showcase migration map

The inventory is 22 `PressableBox` and 9 `Pressable` call sites (27 Snack calls
and four onboarding/core/gallery/copy-card calls). Source line numbers refer to
the audit baseline before documentation comments were added; migration snippets
are schematic and preserve the indicated native content parameter.


The `Target` column names the callable builder that would be appropriate after the revised API is released. The `Current` column is intentionally kept unchanged for the hosted Snacks until release. `Caveat` records interaction, semantics, hit-area, or nested-control behavior that must survive migration.

| ID / source | Current interaction and style carrier | Post-release target | Caveat / verification |
| --- | --- | --- | --- |
| getting-started:79 | `Pressable`, unstyled; child is the styled `button(...)` helper; toggles `_saved`. | Keep `Pressable` in hosted example, or use `BoxStyler().pressable()` only in a version-gated/local example. | This is the onboarding hosted example; do not make it depend on unreleased Mix. Preserve the full button helper hit area and stateful label. |
| core/pressable:24 | `PressableBox`, `BoxStyler`, state-dependent color, `semanticsLabel`, `onPress`. | `BoxStyler().color(...).pressable()(semanticsLabel: ..., onPress: ..., child: ...)`. | Canonical API demonstration; keep semantics label and style identity. A local Mix example can show the new call while hosted code remains compatible until release. |
| snacks/gallery:101 | `PressableBox`, inline `BoxStyler`, `onPress`; selected chip. | `BoxStyler()...pressable()(onPress: onPress, child: ...)`. | Gallery chips have no explicit label; review whether the selected text supplies adequate semantics before changing anything. |
| snacks/widgets/demo_card:85 | `PressableBox`, inline `BoxStyler`, tooltip-wrapped copy action, dynamic `semanticsLabel`, key. | Box builder with `key`, `semanticsLabel`, and `onPress`. | Preserve tooltip child, key, async copy callback, and label changes. This is used to copy DartPad snippets, so keep it compatible with the published Mix version. |
| snacks/bell_toggle:91 | `PressableBox`, `bellSurface` Box style, key, state toggle and animation trigger; FlexBox child containing animated Icon/Text. | `bellSurface.pressable()(key: ..., onPress: ..., child: bellRow(...))`. | One outer hit area owns press/hover variants; do not make icon or label independently pressable. Preserve trigger increment after state change. |
| snacks/border_glow:235 | `PressableBox`, dynamic Box ring style, key, semantic label, one `_toggle`; Stack/Flex nested visual layers. | `glowRingStyle(...).pressable()(key: ..., semanticsLabel: ..., onPress: ..., child: glowCard(...))`. | Comment explicitly says one pressable owns hover/press; preserve a single controller/state scope and card hit area. |
| snacks/branched_menu:95 | `Pressable`, unstyled outer section heading; styled `TextStyler` child. | `branchHeadingStyle(...).pressable()(_tree[s].$1, onPress: ...)` only if the Text builder is desired; otherwise retain `Pressable`. | Section heading is a separate hit target from each nested item. Preserve IgnorePointer/ExcludeFocus/ExcludeSemantics for collapsed branches. |
| snacks/branched_menu:116 | `PressableBox`, dynamic Box item style, styled Text label. | `branchItemStyle(...).pressable()(onPress: ..., child: branchLabelStyle(...)(...))`. | Nested item targets must remain individually keyboard/focusable and must not inherit the section heading action. |
| snacks/call_chip:79 | `Pressable`, no direct style; child is `callSurface` StackBox styler with animated progress overlay and inset label. | `callSurface.pressable()(key: ..., onPress: ..., children: [...])`. | StackBox builder must preserve its `children` list, keyed progress subtree, and all overlay geometry. Keep callback `_run` disabled/phase behavior unchanged. |
| snacks/dodge_field:78 | `PressableBox`, dynamic Box button style inside outer `MouseRegion`; child label. | `dodgeButton.pressable()(onPress: ..., child: dodgeLabel(...))`. | Outer MouseRegion uses local pointer position to move the button; migration must not change the button's bounds or introduce another pointer detector. |
| snacks/folder_float:109 | `PressableBox`, dynamic Box front style inside StackBox; notes are sibling visual layers. | `folderFront.pressable()(onPress: ..., child: folderLabel(...))`. | Preserve front-layer z-order and single folder hit area; note layers are not controls. |
| snacks/fuse_button:129 | `PressableBox`, Box style, key, `_press`; child CustomPaint with two IgnorePointer/ExcludeSemantics faces. | `fuseButton.pressable()(key: ..., onPress: ..., child: CustomPaint(...))`. | Preserve CustomPaint key/painter, face visibility, and exclusion state. The inner faces must never become separate interaction targets. |
| snacks/glide_select:165 | `PressableBox`, static Box item style inside MouseRegion; dynamic selection callback; styled Text child. | `selectItem.pressable()(onPress: ..., child: selectLabel(...))`. | MouseRegion hover and Pressable hover are separate signals; keep both. Each menu item is a distinct target. |
| snacks/glide_select:191 | `PressableBox`, Box trigger style, key, `_toggle`, nested TapRegion/CompositedTransformTarget. | `selectTrigger.pressable()(key: ..., onPress: ..., child: selectRow(...))`. | Preserve anchor link, TapRegion group, trigger key, and one trigger hit area; menu items remain separate. |
| snacks/hold_button:95 | `PressableBox`, Box style, key, release reset callback; AnimatedBuilder with StackBox fill and label. | `holdButton.pressable()(key: ..., onPress: ..., child: AnimatedBuilder(...))`. | Hold gesture is implemented by sibling Listener/MouseRegion callbacks around the Pressable. Do not replace with a builder that changes pointer ownership or long-press semantics. |
| snacks/jelly_radio:64 | `PressableBox`, dynamic Box option style in Flex row; one callback per label. | `radioOptionStyle(...).pressable()(onPress: ..., child: radioLabelStyle(...)(...))`. | Each option is an independent target; preserve row sizing, selected-state style, and keyboard activation per option. |
| snacks/lattice_loader:100 | `Pressable`, unstyled; `onPress` is null while running, child Flex row with 3x3 cells and labels. | Keep `Pressable` for hosted Snack; a post-release FlexBox builder would be `loaderRow.pressable()(children: [...], onPress: ...)` only if the row style is intentionally made pressable. | `onPress: null` currently differs from `enabled: false`; verify semantics/cursor behavior before any migration. Do not imply disabled semantics accidentally. |
| snacks/peek_rating:88 | `PressableBox`, dynamic Box star hit style, per-star callback, nested MouseRegion and Icon. | `ratingStarStyle(...).pressable()(onPress: ..., child: MouseRegion(...))`. | Preserve five independent targets and MouseRegion hover preview; do not let the builder swallow star hover updates. |
| snacks/prompt_bar:128 | `PressableBox` inside outer `Semantics(button: true, label: ...)`, dynamic Box button style, icon child; callback null when invalid, `_stop` while busy. | Keep outer Semantics and use Box builder with `onPress`, or retain constructor until docs define duplicate-role policy. | High-risk semantics case: Pressable defaults to button semantics, so outer Semantics may merge/duplicate role and label. Add an explicit semantics test before changing; preserve disabled/send/stop transitions. |
| snacks/pulse_heart:86 | `PressableBox`, Box style, key, toggle and animation trigger; Flex row with animated Icon/Text. | `heartButton.pressable()(key: ..., onPress: ..., child: heartRow(...))`. | Preserve one target and increment trigger after state update. Consider adding an accessible label in a separate docs follow-up; do not change semantics in this revision. |
| snacks/refine_frame:80 | `Pressable`, unstyled; child StackBox preview and badge. | `refineFrame.pressable()(key: ..., onPress: ..., children: [...])` after release. | StackBox builder must preserve both preview and inset badge layers; key identifies the whole preview target. |
| snacks/rubber_segment:107 | `PressableBox`, static Box segment option style inside Expanded/Flex row; per-segment callback, dynamic Text label. | `segmentOption.pressable()(onPress: ..., child: segmentLabelStyle(...)(...))`. | Expanded must remain outside the Pressable so each target fills its allocated segment; preserve selected guard and stretch trigger. |
| snacks/scrub_field:108 | `PressableBox`, dynamic Box style inside outer horizontal `GestureDetector`; `onPress` null while editing; child becomes a focused TextField while editing. | Keep constructor for hosted Snack; post-release Box builder must preserve conditional `TextField` child and outer drag detector. | Nested editable control is a keyboard/focus boundary. Test that TextField receives input and outer Pressable does not activate while editing. Do not add a nested role/semantics wrapper. |
| snacks/spring_check:112 | `Pressable`, key, `excludeFromSemantics: true`, `_toggle`; outer Semantics owns checked/onTap role; Flex/Stack visuals. | Keep `Pressable` or use `checkRow.pressable()(children: [...], excludeFromSemantics: true, ...)` under the existing Semantics. | The outer Semantics is authoritative checkbox semantics. Any default button semantics would be a regression. |
| snacks/squish_switch:117 | `Pressable`, key, `excludeFromSemantics: true`, outer Semantics owns toggled/onTap; Stack visual track/thumb. | Keep `Pressable` or use `track.pressable()(children: [...], excludeFromSemantics: true, ...)`. | Preserve switch semantics and one track hit area; do not expose the inner thumb as a separate button. |
| snacks/status_mark:70 | `Pressable`, key, unstyled; child Flex row with animated CustomPaint and text. | `statusRow.pressable()(key: ..., onPress: ..., children: [...])` only after intentional style ownership review. | Current Pressable is intentionally unstyled; ensure FlexBox builder's style does not alter layout or animation bounds. |
| snacks/swipe_row:103 | Restore `PressableBox`, dynamic Box style, inside IgnorePointer/ExcludeSemantics conditional wrapper. | `swipeRestore.pressable()(onPress: ..., child: ...)`. | Preserve conditional hit/semantics exclusion and reset state. Restore is a separate target from delete. |
| snacks/swipe_row:123 | Delete `PressableBox`, dynamic Box style inside swipe card StackBox and drag Listener/GestureDetector sibling. | `swipeDelete.pressable()(onPress: ..., child: ...)`. | Preserve delete target layering and drag gesture arena; the child Listener/GestureDetector must remain outside the Pressable. |
| snacks/swipe_toast:147 | `PressableBox`, static Box button style; toast column; drag Listener/GestureDetector is a sibling under conditional reveal. | `toastButton.pressable()(onPress: ..., child: toastLabel(...))`. | Keep toast button independent from reveal drag target and preserve conditional IgnorePointer/ExcludeSemantics on the revealed content. |
| snacks/thought_line:115 | `Pressable`, key, unstyled; child `thoughtStage` Box style with nested Flex rows, icons, and reveal animation. | `thoughtStage.pressable()(key: ..., onPress: ..., child: ...)` only after verifying Box style is intended to own the full stage. | Preserve one stage target and animation layout; no nested controls. Hosted Snack remains constructor-based until release. |
| snacks/warm_tooltip:127 | `PressableBox`, static Box tooltip button style, Icon child; repeated per action in Flex row. | `tooltipButton.pressable()(onPress: ..., child: tooltipIcon(...))`. | Preserve one target per action and hover-driven bubble sibling; consider adding labels in separate accessibility work because icon-only buttons currently rely on surrounding context. |
