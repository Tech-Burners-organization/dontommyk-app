import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:path/path.dart' as path;
import 'package:tommy/view/component/custom_snacbar.dart';

abstract final class OtherHelper {
  static final emailRegexp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$",
  );

  static String? validator(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? phoneValidator(dynamic value) {
    if (value == null || (value is String && value.trim().isEmpty)) {
      return 'Phone number required';
    }
    if (value is PhoneNumber && value.number.trim().isEmpty) {
      return 'Phone number required';
    }
    return null;
  }

  static String formatDate(String isoDate) {
    return _formatDate(isoDate, 'MMM dd, yyyy');
  }

  static String formatDateTime(String isoDate) {
    return _formatDate(isoDate, 'MMM dd, yyyy · hh:mm a');
  }

  static String _formatDate(String isoDate, String pattern) {
    try {
      return DateFormat(pattern).format(DateTime.parse(isoDate).toLocal());
    } on FormatException {
      return '';
    }
  }

  static String timeString(String unit, int count, String locale) {
    final suffix = count == 1 ? unit : '${unit}s';
    return '$count $suffix ago';
  }

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (!emailRegexp.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  static String? confirmPasswordValidator(
    String? value,
    TextEditingController passwordController,
  ) {
    if (value == null || value.isEmpty) return 'This field is required';
    if (value != passwordController.text) return 'The password does not match';
    return null;
  }

  static Future<void> dateOfBirthPicker(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final now = DateTime.now();
    final maxDate = DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: maxDate,
      firstDate: DateTime(1900),
      lastDate: maxDate,
    );
    if (picked != null) {
      controller.text = DateFormat('MM-dd-yyyy').format(picked);
    }
  }

  static Future<String> datePicker(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked == null) return '';

    final formattedDate = DateFormat('MM-dd-yyyy').format(picked);
    controller.text = formattedDate;
    return formattedDate;
  }

  static Future<List<String?>> pickMultipleImage(
    BuildContext context, {
    required int imageLimit,
  }) async {
    log('Image limit: $imageLimit');
    try {
      final images = await ImagePicker().pickMultiImage(
        imageQuality: 50,
        limit: imageLimit,
      );
      return images.map((file) => file.path).toList();
    } catch (error) {
      if (kDebugMode) debugPrint('Image pick error: $error');
      if (!context.mounted) return [];
      showAppSnackBar(
        context,
        message: "Couldn't load the selected image(s). Please try another.",
        isSuccess: false,
      );
      return [];
    }
  }

  static Future<String?> openGallery(BuildContext context) {
    return _pickImage(context, ImageSource.gallery);
  }

  static Future<String?> openCamera(BuildContext context) {
    return _pickImage(context, ImageSource.camera);
  }

  static Future<String?> _pickImage(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 50,
      );
      return image?.path;
    } catch (error) {
      if (kDebugMode) debugPrint('Image pick error: $error');
      if (context.mounted) {
        showAppSnackBar(
          context,
          message: "Couldn't load the image. Please try again.",
          isSuccess: false,
        );
      }
      return null;
    }
  }

  static Future<String> openTimePicker(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null || !context.mounted) return '';
    return picked.format(context);
  }

  static double scaleText(BuildContext context, double baseFontSize) {
    final size = MediaQuery.sizeOf(context);
    final scaleFactor =
        (size.height < size.width ? size.height : size.width) / 390;
    return baseFontSize * scaleFactor.clamp(0.8, 1.3);
  }

  static String getFileNameFromPath(String filePath) => path.basename(filePath);
}
