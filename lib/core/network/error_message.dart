import 'dart:async';

import 'package:tommy/core/network/api_exception.dart';

abstract final class ErrorMessage {
  static String from(Object error) {
    return switch (error) {
      ApiException apiException => apiException.message,
      TimeoutException _ => 'Request timed out. Please try again.',
      FormatException _ => 'Invalid data received.',
      _ => 'Something went wrong. Please try again.',
    };
  }
}
