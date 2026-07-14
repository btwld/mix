import 'package:flutter/material.dart';

import 'atlas_theme.dart';

class AtlasPanel extends StatelessWidget {
  const AtlasPanel({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AtlasPalette.surface,
      border: .all(color: AtlasPalette.border),
      borderRadius: .circular(12),
    ),
    child: Padding(padding: padding, child: child),
  );
}

class AtlasBadge extends StatelessWidget {
  const AtlasBadge(
    this.label, {
    this.warning = false,
    this.success = false,
    super.key,
  });

  final String label;
  final bool warning;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final background = warning
        ? AtlasPalette.warningSoft
        : success
        ? const Color(0xFFE7F7EF)
        : AtlasPalette.surfaceMuted;
    final foreground = warning
        ? AtlasPalette.warning
        : success
        ? AtlasPalette.success
        : AtlasPalette.textMuted;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: .circular(999),
      ),
      child: Padding(
        padding: const .symmetric(vertical: 5, horizontal: 9),
        child: Text(
          label,
          style: TextStyle(color: foreground, fontSize: 11, fontWeight: .w600),
        ),
      ),
    );
  }
}

class AtlasEmptyState extends StatelessWidget {
  const AtlasEmptyState({
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 460),
      child: Padding(
        padding: const .all(32),
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(icon, size: 36, color: AtlasPalette.textMuted),
            const SizedBox(height: 14),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: AtlasPalette.textMuted),
              textAlign: .center,
            ),
          ],
        ),
      ),
    ),
  );
}

String shortCommit(String value) =>
    value.length > 8 ? value.substring(0, 8) : value;
