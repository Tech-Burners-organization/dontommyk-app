import 'package:flutter/services.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  static const int _groupSize = 4;
  static const int _maxDigits = 16;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final truncated = digitsOnly.length > _maxDigits
        ? digitsOnly.substring(0, _maxDigits)
        : digitsOnly;

    final buffer = StringBuffer();
    for (int i = 0; i < truncated.length; i++) {
      buffer.write(truncated[i]);
      final isGroupEnd = (i + 1) % _groupSize == 0;
      if (isGroupEnd && i + 1 != truncated.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
