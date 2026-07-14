import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

import '../app_controller.dart';
import 'atlas_theme.dart';
import 'common.dart';

class AtlasSourceLanding extends StatefulWidget {
  const AtlasSourceLanding({required this.controller, super.key});

  final AtlasAppController controller;

  @override
  State<AtlasSourceLanding> createState() => _AtlasSourceLandingState();
}

class _AtlasSourceLandingState extends State<AtlasSourceLanding> {
  late final TextEditingController _repository;
  late final TextEditingController _baselineRef;
  late final TextEditingController _currentRef;
  late final TextEditingController _manifest;

  @override
  void initState() {
    super.initState();
    final source = widget.controller.sourceSelection;
    _repository = TextEditingController(text: source.repository);
    _baselineRef = TextEditingController(text: source.baselineRef);
    _currentRef = TextEditingController(text: source.currentRef);
    _manifest = TextEditingController(text: source.manifestPath);
  }

  void _openGitHub() {
    widget.controller.openGitHub(
      repository: _repository.text.trim(),
      currentRef: _currentRef.text.trim(),
      baselineRef: _baselineRef.text.trim(),
      manifestPath: _manifest.text.trim(),
    );
  }

  void _listPullRequests() {
    widget.controller.loadPullRequests(_repository.text.trim());
  }

  Future<void> _openFolder() async {
    final path = await getDirectoryPath(confirmButtonText: 'Open Capture');
    if (path == null || !mounted) return;
    await widget.controller.openLocal(directory: Directory(path));
  }

  @override
  void dispose() {
    _repository.dispose();
    _baselineRef.dispose();
    _currentRef.dispose();
    _manifest.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const .all(40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            const Icon(
              Icons.grid_view_rounded,
              size: 40,
              color: AtlasPalette.accent,
            ),
            const SizedBox(height: 18),
            Text(
              'Open a design-system capture',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: .w700),
              textAlign: .center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Atlas reads committed, hash-verified data. It never compiles or executes the producer repository.',
              style: TextStyle(color: AtlasPalette.textMuted, height: 1.45),
              textAlign: .center,
            ),
            const SizedBox(height: 28),
            AtlasPanel(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    'Public GitHub repository',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const ValueKey('repository-field'),
                    controller: _repository,
                    decoration: const InputDecoration(
                      labelText: 'Repository or URL',
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final fieldWidth = constraints.maxWidth >= 640
                          ? (constraints.maxWidth - 24) / 3
                          : constraints.maxWidth;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: fieldWidth,
                            child: TextField(
                              key: const ValueKey('baseline-ref-field'),
                              controller: _baselineRef,
                              decoration: const InputDecoration(
                                labelText: 'Baseline branch or SHA',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: TextField(
                              key: const ValueKey('current-ref-field'),
                              controller: _currentRef,
                              decoration: const InputDecoration(
                                labelText: 'Current branch, SHA, or PR',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: TextField(
                              key: const ValueKey('manifest-field'),
                              controller: _manifest,
                              decoration: const InputDecoration(
                                labelText: 'Capture manifest',
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Current accepts a branch, SHA, or PR. Fork PRs resolve to '
                    'their head repository; when a baseline has no capture, '
                    'Atlas opens the current capture on its own.',
                    style: TextStyle(
                      color: AtlasPalette.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    spacing: 10,
                    children: [
                      FilledButton.icon(
                        key: const ValueKey('open-github'),
                        onPressed: _openGitHub,
                        icon: const Icon(Icons.cloud_download_outlined),
                        label: const Text('Open repository'),
                      ),
                      OutlinedButton.icon(
                        key: const ValueKey('open-pull-requests'),
                        onPressed: _listPullRequests,
                        icon: const Icon(Icons.call_split),
                        label: const Text('Open PRs'),
                      ),
                    ],
                  ),
                  if (widget.controller.pullRequests.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final pull in widget.controller.pullRequests)
                          ActionChip(
                            key: ValueKey('pull-request-${pull.number}'),
                            label: Text('#${pull.number} ${pull.title}'),
                            onPressed: () {
                              _baselineRef.text = pull.baseRef;
                              _currentRef.text = '#${pull.number}';
                              _openGitHub();
                            },
                          ),
                      ],
                    ),
                  ],
                  if (widget.controller.pullRequestRateLimit
                      case final rateLimit?) ...[
                    const SizedBox(height: 12),
                    _RateLimitReceipt(rateLimit: rateLimit),
                  ],
                  if (widget.controller.pullRequestError case final error?) ...[
                    const SizedBox(height: 12),
                    Text(
                      '$error',
                      style: const TextStyle(
                        color: AtlasPalette.warning,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            AtlasPanel(
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: 4,
                      children: [
                        Text(
                          'Local capture folder',
                          style: TextStyle(fontWeight: .w600),
                        ),
                        Text(
                          'Open capture.json directly before committing producer artifacts.',
                          style: TextStyle(
                            color: AtlasPalette.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    key: const ValueKey('open-folder'),
                    onPressed: () => unawaited(_openFolder()),
                    icon: const Icon(Icons.folder_open_outlined),
                    label: const Text('Choose folder'),
                  ),
                ],
              ),
            ),
            if (widget.controller.loadState == .error) ...[
              const SizedBox(height: 14),
              _LoadError(
                error: widget.controller.loadError,
                onRetry: () => unawaited(widget.controller.retry()),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _RateLimitReceipt extends StatelessWidget {
  const _RateLimitReceipt({required this.rateLimit});

  final AtlasGitHubRateLimit rateLimit;

  @override
  Widget build(BuildContext context) => Row(
    spacing: 6,
    children: [
      const Icon(
        Icons.data_usage_outlined,
        size: 16,
        color: AtlasPalette.textMuted,
      ),
      Expanded(
        child: Text(
          _rateLimitText(rateLimit),
          style: const TextStyle(color: AtlasPalette.textMuted, fontSize: 12),
        ),
      ),
    ],
  );
}

String _rateLimitText(AtlasGitHubRateLimit rateLimit) {
  final quota = switch ((rateLimit.remaining, rateLimit.limit)) {
    (final remaining?, final limit?) => '$remaining/$limit requests remaining',
    (final remaining?, null) => '$remaining requests remaining',
    _ => 'request quota unavailable',
  };
  final reset = rateLimit.resetAt;
  final resetText = reset == null
      ? 'reset time unavailable'
      : 'resets ${_formatUtcMinute(reset)}';

  return 'GitHub API · $quota · $resetText';
}

String _formatUtcMinute(DateTime value) {
  final utc = value.toUtc();
  String twoDigits(int number) => number.toString().padLeft(2, '0');

  return '${utc.year}-${twoDigits(utc.month)}-${twoDigits(utc.day)} '
      '${twoDigits(utc.hour)}:${twoDigits(utc.minute)} UTC';
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final title = switch (error) {
      AtlasCaptureException(:final kind) => switch (kind) {
        AtlasCaptureFailureKind.invalidRequest =>
          'Repository, ref, or manifest path is invalid',
        AtlasCaptureFailureKind.network => 'Could not reach GitHub',
        AtlasCaptureFailureKind.rateLimited => 'GitHub rate limit reached',
        AtlasCaptureFailureKind.integrity => 'Capture integrity check failed',
        AtlasCaptureFailureKind.notFound => 'Capture not found',
        AtlasCaptureFailureKind.sourceRejected =>
          'GitHub rejected the capture request',
        AtlasCaptureFailureKind.malformedJson => 'Capture JSON is malformed',
        AtlasCaptureFailureKind.unsupportedSchema =>
          'Capture schema is unsupported',
        AtlasCaptureFailureKind.unsafePath =>
          'Capture contains an unsafe file path',
        AtlasCaptureFailureKind.invalidCatalog => 'Capture catalog is invalid',
        AtlasCaptureFailureKind.invalidComponent =>
          'Portable component document is invalid',
        AtlasCaptureFailureKind.invalidProtocol =>
          'Mix protocol document is invalid',
      },
      _ => 'Capture could not be opened',
    };

    return AtlasPanel(
      child: Row(
        crossAxisAlignment: .start,
        children: [
          const Icon(Icons.error_outline, color: AtlasPalette.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 5,
              children: [
                Text(title, style: const TextStyle(fontWeight: .w700)),
                Text(
                  error?.toString() ?? 'No error details were provided.',
                  style: const TextStyle(
                    color: AtlasPalette.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
