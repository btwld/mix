# Documentation Quality Checklist

Use this checklist for docs PRs in Mix.

## Scope

- Keep scope focused: fix correctness first, then consistency.
- Avoid full-site rewrites unless the change explicitly requires it.

## Accuracy

- Verify APIs against current source code in `packages/mix/lib/src/`.
- Ensure code snippets are valid for current Mix 2.0 and Flutter/Dart constraints.
- Remove or clearly mark deprecated patterns.

## Structure

- Keep one Diataxis type per page (tutorial, how-to, reference, or explanation).
- Use clear section headings and consistent terminology.
- Ensure heading levels are hierarchical and semantic.

## Frontmatter

- Every docs page under `website/src/content/documentation/` must include:
  - `title`
  - `description`
- Align frontmatter title and in-page H1 (or rely on framework-rendered title, not both).

## Examples

- Prefer complete, copyable snippets for primary examples.
- Keep syntax consistent with current docs conventions.
- If a pattern has prerequisites (for example `Pressable` for widget-state variants), state it near the example.

## Accessibility and Discoverability

- Provide descriptive alt text for images.
- Use descriptive link text and avoid “click here”.
- Keep page descriptions concise and specific.

## Verification

- Run docs checks:
  - `pnpm -C website run check:previews`
  - `pnpm -C website run check:frontmatter`
- Build website:
  - `pnpm -C website build`
