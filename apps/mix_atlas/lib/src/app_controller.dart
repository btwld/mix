import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

import 'data/capture_gateway.dart';
import 'models/destination.dart';
import 'models/review_context.dart';

enum AtlasLoadState { empty, loading, ready, error }

final class AtlasSourceSelection {
  const AtlasSourceSelection({
    required this.repository,
    required this.baselineRef,
    required this.currentRef,
    required this.manifestPath,
  });

  static const productionDefault = AtlasSourceSelection(
    repository: String.fromEnvironment(
      'MIX_ATLAS_DEFAULT_REPOSITORY',
      defaultValue: 'tilucasoli/hero_ui',
    ),
    baselineRef: String.fromEnvironment(
      'MIX_ATLAS_DEFAULT_BASELINE_REF',
      defaultValue: 'main',
    ),
    currentRef: String.fromEnvironment(
      'MIX_ATLAS_DEFAULT_CURRENT_REF',
      defaultValue: '#21',
    ),
    manifestPath: String.fromEnvironment(
      'MIX_ATLAS_DEFAULT_MANIFEST',
      defaultValue: 'atlas/hero_ui/capture.json',
    ),
  );

  final String repository;
  final String baselineRef;
  final String currentRef;
  final String manifestPath;
}

final class AtlasAppController extends ChangeNotifier {
  AtlasLoadState loadState = .empty;

  AtlasCapture? baseline;
  AtlasCapture? current;
  AtlasCaptureIndex? baselineIndex;
  AtlasCaptureIndex? currentIndex;

  AtlasReviewContext? reviewContext;
  Object? baselineLoadError;
  Object? loadError;
  List<AtlasGitHubPullRequest> pullRequests = const [];
  AtlasGitHubRateLimit? pullRequestRateLimit;
  Object? pullRequestError;
  AtlasSourceSelection _sourceSelection;
  final AtlasCaptureGateway _gateway;
  final List<AtlasDestination> _history = [AtlasDestination.catalog];
  int _loadGeneration = 0;
  int _pullRequestGeneration = 0;
  Future<void> Function()? _lastLoad;
  AtlasAppController({
    required AtlasCaptureGateway gateway,
    AtlasSourceSelection sourceSelection =
        AtlasSourceSelection.productionDefault,
  }) : _sourceSelection = sourceSelection,
       _gateway = gateway;

  AtlasSourceSelection get sourceSelection => _sourceSelection;

  Future<void> _openLocal(Directory directory, String manifestPath) async {
    final generation = ++_loadGeneration;
    _beginLoad();
    try {
      final capture = await _gateway.loadLocal(
        directory: directory,
        manifestPath: manifestPath,
      );
      if (generation != _loadGeneration) return;
      _setReady(
        baselineCapture: capture,
        currentCapture: capture,
        repository: directory.absolute.path,
        baselineRef: 'local',
        currentRef: 'local',
      );
    } on Object catch (error) {
      if (generation == _loadGeneration) _setError(error);
    }
  }

  Future<void> _openGitHub({
    required String repository,
    required String currentRef,
    required String baselineRef,
    required String manifestPath,
  }) async {
    final generation = ++_loadGeneration;
    _beginLoad();
    try {
      final beforeFuture = _captureResult(
        _gateway.loadGitHub(
          repository: repository,
          ref: baselineRef,
          manifestPath: manifestPath,
        ),
      );
      final afterFuture = currentRef == baselineRef
          ? beforeFuture
          : _captureResult(
              _gateway.loadGitHub(
                repository: repository,
                ref: currentRef,
                manifestPath: manifestPath,
              ),
            );
      final captures = await Future.wait([beforeFuture, afterFuture]);
      if (generation != _loadGeneration) return;
      final currentResult = captures[1];
      if (currentResult.error case final error?) throw error;
      _setReady(
        baselineCapture: captures[0].capture,
        currentCapture: currentResult.capture!,
        repository: repository,
        baselineRef: baselineRef,
        currentRef: currentRef,
        baselineError: captures[0].error,
      );
    } on Object catch (error) {
      if (generation == _loadGeneration) _setError(error);
    }
  }

  void _beginLoad() {
    loadState = .loading;
    baselineLoadError = null;
    loadError = null;
    notifyListeners();
  }

  void _setReady({
    required AtlasCapture? baselineCapture,
    required AtlasCapture currentCapture,
    required String repository,
    required String baselineRef,
    required String currentRef,
    Object? baselineError,
  }) {
    baseline = baselineCapture;
    current = currentCapture;
    baselineIndex = baselineCapture == null
        ? null
        : AtlasCaptureIndex.build(baselineCapture);
    currentIndex = AtlasCaptureIndex.build(currentCapture);
    final component = currentCapture.componentDocuments.firstOrNull;
    reviewContext = AtlasReviewContext(
      repository: repository,
      baselineRef: baselineRef,
      currentRef: currentRef,
      componentId: component?.id,
      recipeId: component?.recipes.firstOrNull?.id,
      stateId: component?.states.keys.firstOrNull,
      themeId: currentCapture.manifest.themes.firstOrNull?.id,
      slotId: component?.slots.keys.firstOrNull,
    );
    loadState = .ready;
    baselineLoadError = baselineError;
    loadError = null;
    _history
      ..clear()
      ..add(.catalog);
    notifyListeners();
  }

  Future<_CaptureLoadResult> _captureResult(
    Future<AtlasCapture> capture,
  ) async {
    try {
      return _CaptureLoadResult(capture: await capture);
    } on Object catch (error) {
      return _CaptureLoadResult(error: error);
    }
  }

  void _setError(Object error) {
    loadState = .error;
    loadError = error;
    notifyListeners();
  }

  AtlasDestination get destination => _history.last;

  bool get canPop => _history.length > 1;

  bool get hasCompatibleComparison {
    final before = baseline;
    final after = current;
    if (before == null || after == null) {
      return false;
    }

    return AtlasCaptureCompatibility.evaluate(before, after).isCompatible;
  }

  bool get hasChanges {
    final before = baseline;
    final after = current;
    if (before == null || after == null || !hasCompatibleComparison) {
      return false;
    }
    if (before.receipt.resolvedCommit != after.receipt.resolvedCommit) {
      return true;
    }
    if (before.files.length != after.files.length) return true;

    return before.files.entries.any((entry) {
      final other = after.files[entry.key];

      return other == null || !listEquals(entry.value, other);
    });
  }

  Future<void> openLocal({
    required Directory directory,
    String manifestPath = 'capture.json',
  }) {
    Future<void> action() => _openLocal(directory, manifestPath);
    _lastLoad = action;

    return action();
  }

  Future<void> openGitHub({
    required String repository,
    required String currentRef,
    String baselineRef = 'main',
    String manifestPath = 'atlas/fortal/capture.json',
  }) {
    final selection = AtlasSourceSelection(
      repository: repository.trim(),
      baselineRef: baselineRef.trim(),
      currentRef: currentRef.trim(),
      manifestPath: manifestPath.trim(),
    );
    _sourceSelection = selection;
    Future<void> action() => _openGitHub(
      repository: selection.repository,
      currentRef: selection.currentRef,
      baselineRef: selection.baselineRef,
      manifestPath: selection.manifestPath,
    );
    _lastLoad = action;

    return action();
  }

  Future<void> loadPullRequests(String repository) async {
    final generation = ++_pullRequestGeneration;
    pullRequests = const [];
    pullRequestRateLimit = null;
    pullRequestError = null;
    notifyListeners();
    try {
      final result = await _gateway.listOpenPullRequests(repository);
      if (generation != _pullRequestGeneration) return;
      pullRequests = result.pullRequests;
      pullRequestRateLimit = result.rateLimit;
    } on Object catch (error) {
      if (generation != _pullRequestGeneration) return;
      pullRequestError = error;
    }
    notifyListeners();
  }

  Future<void> retry() => _lastLoad?.call() ?? Future.value();

  void showSourceSelection() {
    _loadGeneration += 1;
    _pullRequestGeneration += 1;
    loadState = .empty;
    baseline = null;
    current = null;
    baselineIndex = null;
    currentIndex = null;
    reviewContext = null;
    baselineLoadError = null;
    loadError = null;
    pullRequests = const [];
    pullRequestRateLimit = null;
    pullRequestError = null;
    _lastLoad = null;
    _history
      ..clear()
      ..add(.catalog);
    notifyListeners();
  }

  void navigate(AtlasDestination next) {
    if (destination == next) return;
    _history.add(next);
    notifyListeners();
  }

  bool pop() {
    if (!canPop) return false;
    _history.removeLast();
    notifyListeners();

    return true;
  }

  void replaceDestination(AtlasDestination next) {
    if (_history.length == 1 && destination == next) return;
    _history
      ..clear()
      ..add(next);
    notifyListeners();
  }

  void selectComponent(String componentId) {
    final component = current?.componentDocuments
        .where((component) => component.id == componentId)
        .firstOrNull;
    reviewContext = reviewContext?.copyWith(
      componentId: componentId,
      recipeId: component?.recipes.firstOrNull?.id,
      stateId: component?.states.keys.firstOrNull,
      slotId: component?.slots.keys.firstOrNull,
      clearEvidence: true,
    );
    notifyListeners();
  }

  void selectCell({required String recipeId, required String stateId}) {
    reviewContext = reviewContext?.copyWith(
      recipeId: recipeId,
      stateId: stateId,
      clearEvidence: true,
    );
    notifyListeners();
  }

  void selectTheme(String themeId) {
    reviewContext = reviewContext?.copyWith(themeId: themeId);
    notifyListeners();
  }

  void selectSlot(String slotId) {
    reviewContext = reviewContext?.copyWith(
      slotId: slotId,
      clearEvidence: true,
    );
    notifyListeners();
  }

  void selectProperty(AtlasPropertyEvidence evidence) {
    reviewContext = reviewContext?.copyWith(
      slotId: evidence.slotId,
      property: evidence.property,
      tokenKind: evidence.tokenKind,
      tokenName: evidence.tokenName,
    );
    notifyListeners();
  }

  void selectToken({required String kind, required String name}) {
    reviewContext = reviewContext?.copyWith(tokenKind: kind, tokenName: name);
    notifyListeners();
  }
}

final class _CaptureLoadResult {
  final AtlasCapture? capture;
  final Object? error;

  const _CaptureLoadResult({this.capture, this.error});
}
