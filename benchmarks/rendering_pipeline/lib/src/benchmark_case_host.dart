import 'package:flutter/widgets.dart';

/// Keeps one root mounted while benchmark cases are replaced by manual frames.
class BenchmarkCaseHost extends StatefulWidget {
  const BenchmarkCaseHost({super.key});

  @override
  State<BenchmarkCaseHost> createState() => BenchmarkCaseHostState();
}

class BenchmarkCaseHostState extends State<BenchmarkCaseHost> {
  Widget _case = const SizedBox.shrink();

  void showCase(Widget child) {
    setState(() {
      // A fresh key prevents framework state from leaking between cases whose
      // root widgets have the same runtime type.
      _case = KeyedSubtree(key: UniqueKey(), child: child);
    });
  }

  void clearCase() {
    setState(() {
      _case = const SizedBox.shrink();
    });
  }

  @override
  Widget build(BuildContext context) => _case;
}
