import 'package:flutter/material.dart';

void showAppSnackBar(
  BuildContext context, {
  required String message,
  bool isSuccess = true,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isSuccess
            ? const Color(0xFF15803D)
            : Theme.of(context).colorScheme.error,
      ),
    );
}

@Deprecated('Use showAppSnackBar instead.')
void customSnackBar(
  BuildContext context, {
  required String message,
  bool isSuccess = true,
}) {
  showAppSnackBar(context, message: message, isSuccess: isSuccess);
}
