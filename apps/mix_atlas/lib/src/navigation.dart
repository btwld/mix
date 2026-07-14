import 'package:flutter/material.dart';

import 'app_controller.dart';
import 'models/destination.dart';
import 'ui/atlas_shell.dart';

final class AtlasRouteInformationParser
    extends RouteInformationParser<AtlasDestination> {
  const AtlasRouteInformationParser();

  @override
  Future<AtlasDestination> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final segment = routeInformation.uri.pathSegments.firstOrNull;

    return AtlasDestination.values
            .where((destination) => destination.name == segment)
            .firstOrNull ??
        .catalog;
  }

  @override
  RouteInformation restoreRouteInformation(AtlasDestination configuration) =>
      .new(uri: Uri(path: '/${configuration.name}'));
}

final class AtlasRouterDelegate extends RouterDelegate<AtlasDestination>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AtlasDestination> {
  final AtlasAppController controller;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AtlasRouterDelegate({required this.controller}) {
    controller.addListener(notifyListeners);
  }

  @override
  Future<void> setNewRoutePath(AtlasDestination configuration) async {
    controller.replaceDestination(configuration);
  }

  @override
  Future<bool> popRoute() async => controller.pop();

  @override
  void dispose() {
    controller.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  AtlasDestination get currentConfiguration => controller.destination;

  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    pages: [
      MaterialPage<void>(
        key: const ValueKey('atlas-shell'),
        child: AtlasShell(controller: controller),
      ),
    ],
    onDidRemovePage: (_) {
      controller.pop();
    },
  );
}
