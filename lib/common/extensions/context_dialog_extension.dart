import 'package:flutter/material.dart';

extension ContextDialogExtension on BuildContext {
  Future<T?> showCustomDialog<T>({
    required Widget Function(BuildContext context) builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = false,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    bool fullscreenDialog = false,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) {
    return showDialog<T>(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      anchorPoint: anchorPoint,
      routeSettings: routeSettings,
      traversalEdgeBehavior: traversalEdgeBehavior,
      useRootNavigator: useRootNavigator,
      context: this,
      builder: builder,
    );
  }

  Future<T?> showErrorDialog<T>({
    required String title,
    required String message,
    VoidCallback? onRetry,
  }) {
    return showDialog<T>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (onRetry != null)
            const SizedBox(
              width: 16,
            ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  Future<T?> showAppDialog<T>({
    String? title,
    String? message,
    List<Widget>? actions,
  }) async {
    return showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title ?? ''),
        content: Text(message ?? ''),
        actions: actions,
      ),
    );
  }

  Future<T?> showBottomSheet<T>({
    required Widget Function(BuildContext) builder,
    double? heightRatio,
  }) {
    return showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * (heightRatio ?? 0.5),
        child: builder(context),
      ),
    );
  }

  void showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            child: const Text('Confirm'),
            onPressed: () {
              onConfirm();
              Navigator.pop(context); // Dismiss dialog after confirming
            },
          ),
        ],
      ),
    );
  }

  void showLoading() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white,),
      ),
    );
  }

  void hideLoading() {
    Navigator.pop(this);
  }
}
