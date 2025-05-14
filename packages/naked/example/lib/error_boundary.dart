import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that catches errors in its child widget tree and displays them
/// in a user-friendly way to aid debugging.
class ErrorBoundary extends StatefulWidget {
  /// The widget to monitor for errors.
  final Widget child;

  /// Optional name to identify which component is being wrapped.
  final String componentName;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.componentName = 'Component',
  });

  @override
  ErrorBoundaryState createState() => ErrorBoundaryState();
}

class ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;
  final FlutterExceptionHandler? _originalOnError = FlutterError.onError;

  @override
  void initState() {
    super.initState();
    // Set up error handler
    FlutterError.onError = _handleFlutterError;
  }

  @override
  void dispose() {
    // Restore original error handler
    FlutterError.onError = _originalOnError;
    super.dispose();
  }

  void _handleFlutterError(FlutterErrorDetails details) {
    if (mounted) {
      setState(() {
        _error = details.exception;
        _stackTrace = details.stack;
      });
    }

    // Also report to original handler
    if (_originalOnError != null) {
      _originalOnError(details);
    }
    // If there's no original handler, consider re-throwing or logging differently
    // depending on whether you want the app to crash or just log.
    // For now, we just rely on the original handler.
  }

  @override
  Widget build(BuildContext context) {
    // If an error was caught *before* build (e.g., by _handleFlutterError),
    // we might still want to display it, but for now, we prioritize letting errors propagate.
    if (_error != null) {
      return _buildErrorDisplay();
    }

    // Wrap the child in a builder to catch errors during build
    return Builder(
      builder: (context) {
        try {
          return widget.child;
        } catch (error, stackTrace) {
          // Schedule a post-frame callback to update the state
          // This avoids the "setState during build" error
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateErrorState(error, stackTrace);
          });

          // Instead of showing a placeholder and updating state later,
          // we re-throw the error immediately to let it propagate.
          // rethrow;

          // Return a placeholder while waiting for the state update
          return Container(
            color: Colors.red.withValues(alpha: 0.1),
            height: 100,
            width: double.infinity,
            child: const Center(
              child: Text('Error occurred - rebuilding...'),
            ),
          );
        }
      },
    );
  }

  Widget _buildErrorDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700),
              const SizedBox(width: 8),
              Text(
                'Error in ${widget.componentName}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Error: ${_error.toString()}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Stack Trace:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                _stackTrace?.toString() ?? 'No stack trace available',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Component'),
            onPressed: () {
              setState(() {
                _error = null;
                _stackTrace = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _updateErrorState(Object error, StackTrace? stackTrace) {
    if (!mounted) return;
    setState(() {
      _error = error;
      _stackTrace = stackTrace;
    });
  }

  // Method to be called from outside to report errors
  void reportError(Object error, StackTrace stackTrace) {
    _updateErrorState(error, stackTrace);
  }
}

/// A widget that wraps components to catch and display errors with a reset option.
class ErrorCatcher extends StatefulWidget {
  final Widget child;
  final String componentName;

  const ErrorCatcher({
    super.key,
    required this.child,
    required this.componentName,
  });

  @override
  ErrorCatcherState createState() => ErrorCatcherState();
}

class ErrorCatcherState extends State<ErrorCatcher> {
  final GlobalKey<ErrorBoundaryState> _errorBoundaryKey =
      GlobalKey<ErrorBoundaryState>();

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      key: _errorBoundaryKey,
      componentName: widget.componentName,
      child: widget.child,
    );
  }
}
