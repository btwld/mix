import 'package:flutter/material.dart';

import 'scenarios/card_grid.dart';

void main() {
  runApp(const RenderingPipelineBenchmark());
}

class RenderingPipelineBenchmark extends StatefulWidget {
  const RenderingPipelineBenchmark({super.key});

  @override
  State<RenderingPipelineBenchmark> createState() =>
      _RenderingPipelineBenchmarkState();
}

class _RenderingPipelineBenchmarkState
    extends State<RenderingPipelineBenchmark> {
  late final List<ProductCardData> _cards = createBenchmarkCards();
  late final BenchmarkControllerSet _controllers = BenchmarkControllerSet(
    _cards,
  );

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BenchmarkApp(
      implementation: BenchmarkImplementation.mix,
      track: BenchmarkTrack.idiomatic,
      cards: _cards,
      controllers: _controllers,
      animated: true,
    );
  }
}
