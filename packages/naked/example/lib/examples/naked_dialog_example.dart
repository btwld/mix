import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

class NakedDialogExample extends StatelessWidget {
  const NakedDialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Basic dialog example
          ElevatedButton(
            onPressed: () => _showBasicDialog(context),
            child: const Text('Basic Dialog'),
          ),
          const SizedBox(height: 16),

          // Custom transition example
          ElevatedButton(
            onPressed: () => _showCustomTransitionDialog(context),
            child: const Text('Custom Transition'),
          ),
          const SizedBox(height: 16),

          // Custom color barrier example
          ElevatedButton(
            onPressed: () => _showColoredBarrierDialog(context),
            child: const Text('Colored Barrier'),
          ),
          const SizedBox(height: 16),

          // Non-dismissible example
          ElevatedButton(
            onPressed: () => _showNonDismissibleDialog(context),
            child: const Text('Non-Dismissible Dialog'),
          ),
          const SizedBox(height: 16),

          // Dialog with return value
          ElevatedButton(
            onPressed: () => _showDialogWithResult(context),
            child: const Text('Dialog With Result'),
          ),
        ],
      ),
    );
  }

  // Basic dialog with default settings
  void _showBasicDialog(BuildContext context) {
    showNakedDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Center(
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Basic Dialog',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog with custom transition
  void _showCustomTransitionDialog(BuildContext context) {
    showNakedDialog(
      context: context,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 600),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      builder: (context) => Center(
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Custom Transition Dialog',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog with custom colored barrier
  void _showColoredBarrierDialog(BuildContext context) {
    showNakedDialog(
      context: context,
      barrierColor: Colors.blue.withValues(alpha: 0.5),
      barrierLabel: 'Custom barrier label',
      builder: (context) => Center(
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                spreadRadius: 5,
                blurRadius: 10,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Colored Barrier Dialog',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text('Notice the blue tinted background'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Non-dismissible dialog
  void _showNonDismissibleDialog(BuildContext context) {
    showNakedDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false, // Can't dismiss by tapping outside
      builder: (context) => Center(
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Non-Dismissible Dialog',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text('You must use the button to close this dialog'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog with return value
  Future<void> _showDialogWithResult(BuildContext context) async {
    final result = await showNakedDialog<String>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Center(
        child: Container(
          width: 300,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Dialog With Result',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Select an option:'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Option 1'),
                    child: const Text('Option 1'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Option 2'),
                    child: const Text('Option 2'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You selected: $result')),
      );
    }
  }
}
