import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rendering_pipeline/src/benchmark_case_host.dart';

void main() {
  testWidgets('replaces and disposes benchmark cases under one mounted host', (
    tester,
  ) async {
    final hostKey = GlobalKey<BenchmarkCaseHostState>();
    var disposedCases = 0;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: BenchmarkCaseHost(key: hostKey),
      ),
    );
    final mountedHost = hostKey.currentState;

    mountedHost!.showCase(
      _CaseProbe(label: 'first', onDispose: () => disposedCases++),
    );
    await tester.pump();
    expect(find.text('first'), findsOneWidget);

    mountedHost.showCase(
      _CaseProbe(label: 'second', onDispose: () => disposedCases++),
    );
    await tester.pump();
    expect(hostKey.currentState, same(mountedHost));
    expect(find.text('first'), findsNothing);
    expect(find.text('second'), findsOneWidget);
    expect(disposedCases, 1);

    mountedHost.clearCase();
    await tester.pump();
    expect(find.text('second'), findsNothing);
    expect(disposedCases, 2);
  });
}

class _CaseProbe extends StatefulWidget {
  const _CaseProbe({required this.label, required this.onDispose});

  final String label;
  final VoidCallback onDispose;

  @override
  State<_CaseProbe> createState() => _CaseProbeState();
}

class _CaseProbeState extends State<_CaseProbe> {
  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(widget.label);
}
