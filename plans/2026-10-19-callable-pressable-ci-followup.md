# Callable pressable builders: CI compatibility follow-up

- PR: [#1088](https://github.com/btwld/mix/pull/1088)
- Input revision: `0d78eef32f81869c7dceb27c2adaf71a4abe9407`
- Upstream revision used by CI: `e179a08863db917c83228400b1a9cc41130ea7c6`
- Failed check: [repository analysis/test job](https://github.com/btwld/mix/actions/runs/39050531155/job/117448017883)

## Cause and fix

The October 17 local checks passed with analyzer 10.2.0. GitHub tested the PR
merged with newer `main`, whose dependency ranges permit analyzer 14.x.
The contract test read `ClassDeclaration.name` and `.members`; those getters
were removed in the newer analyzer. CI reported four compilation errors and
stopped during analysis, before running the tests.

Reproduced the same four errors locally with a temporary analyzer 14.5.0
override. Replaced AST traversal with resolved library/class element lookups.
The existing assertions for types, named/required parameters and constant
defaults remain unchanged, as do terminal-call and generation checks. Removed
an unnecessary services import reported in the parameter test.

The fix changes tests only. Runtime APIs, dependency constraints, generator
implementation and CI configuration are unchanged. Temporary dependency
overrides were restored after validation.

## Validation

- Analyzer 14.5.0: targeted analysis passed; all three contract tests passed.
- Analyzer 10.2.0: targeted analysis passed; all 383 generator tests passed.
- Independent review found no loss of coverage or runtime/API drift.
- `melos run gen:build`: passed with no generated diffs.
- `melos run ci`: passed, including 3,023 core tests, 383 generator tests and
  129 showcase tests, plus all other dependent suites.
- `melos run format:check` and `git diff --check`: passed.
- `melos run analyze`: schema and Dart analysis passed. DCM still reports the
  same four baseline findings in unchanged files: member ordering and a sealed
  switch wildcard in `style_animation_builder.dart:81,90`, and argument ordering
  in `decoration_style_mixin.dart:273,359`. Full analysis remains non-green;
  no new DCM findings were reported.

## Remaining delivery work

Push this fix and record, then confirm the new GitHub checks pass against the
current merge revision. The PR remains open and ready for the maintainer's
review/merge decision; this task does not merge it.

After release, migrate the published showcase/Snacks and separate website docs
using the existing [31-site release audit](../guides/pressable-builders-release-audit.md),
and update the skills' version gates. These remain release follow-ups.
