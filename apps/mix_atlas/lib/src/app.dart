import 'package:flutter/material.dart';

import 'app_controller.dart';
import 'data/capture_gateway.dart';
import 'navigation.dart';
import 'ui/atlas_theme.dart';

class AtlasApp extends StatefulWidget {
  const AtlasApp({required this.controller, super.key});

  AtlasApp.production({super.key})
    : controller = AtlasAppController(gateway: DefaultAtlasCaptureGateway());

  final AtlasAppController controller;

  @override
  State<AtlasApp> createState() => _AtlasAppState();
}

class _AtlasAppState extends State<AtlasApp> {
  late final AtlasRouterDelegate _router = AtlasRouterDelegate(
    controller: widget.controller,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routeInformationParser: const AtlasRouteInformationParser(),
    routerDelegate: _router,
    title: 'Mix Atlas',
    theme: atlasTheme(),
    debugShowCheckedModeBanner: false,
  );
}
