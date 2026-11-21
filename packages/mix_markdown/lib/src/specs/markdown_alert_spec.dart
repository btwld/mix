import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import 'markdown_alert_type.dart';
import 'markdown_alert_type_spec.dart';

part 'markdown_alert_spec.g.dart';

/// Resolved presentation for GitHub alerts, one slot per [MarkdownAlertType].
@MixableSpec()
@immutable
final class MarkdownAlertSpec with _$MarkdownAlertSpec {
  /// `> [!NOTE]` alerts.
  @override
  final StyleSpec<MarkdownAlertTypeSpec>? note;

  /// `> [!TIP]` alerts.
  @override
  final StyleSpec<MarkdownAlertTypeSpec>? tip;

  /// `> [!IMPORTANT]` alerts.
  @override
  final StyleSpec<MarkdownAlertTypeSpec>? important;

  /// `> [!WARNING]` alerts.
  @override
  final StyleSpec<MarkdownAlertTypeSpec>? warning;

  /// `> [!CAUTION]` alerts.
  @override
  final StyleSpec<MarkdownAlertTypeSpec>? caution;

  const MarkdownAlertSpec({
    this.note,
    this.tip,
    this.important,
    this.warning,
    this.caution,
  });
}
