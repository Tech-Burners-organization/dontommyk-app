import 'package:flutter/material.dart';
import 'package:tommy/core/bloc/ui_state.dart';
import 'package:tommy/view/component/custom_loader.dart';
import 'package:tommy/view/component/empty_showcase.dart';

class BlocStateView<T> extends StatelessWidget {
  const BlocStateView({
    required this.state,
    required this.successBuilder,
    this.initialBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.failureBuilder,
    this.onRetry,
    super.key,
  });

  final UiState<T> state;
  final Widget Function(BuildContext context, T data) successBuilder;
  final WidgetBuilder? initialBuilder;
  final WidgetBuilder? loadingBuilder;
  final Widget Function(BuildContext context, String message)? emptyBuilder;
  final Widget Function(BuildContext context, String message)? failureBuilder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      UiInitial<T>() =>
        initialBuilder?.call(context) ?? const SizedBox.shrink(),
      UiLoading<T>() => loadingBuilder?.call(context) ?? const CustomLoader(),
      UiSuccess<T>(:final data) => successBuilder(context, data),
      UiEmpty<T>(:final message) =>
        emptyBuilder?.call(context, message) ?? EmptyShowcase(message: message),
      UiFailure<T>(:final message) =>
        failureBuilder?.call(context, message) ??
            _FailureView(message: message, onRetry: onRetry),
    };
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
