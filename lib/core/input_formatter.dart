import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PriceInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,##0.##");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove commas (,) first
    String cleaned = newValue.text.replaceAll(',', '');

    // Only allow valid decimal numbers
    if (cleaned.isEmpty) return newValue;

    // Allow only one decimal point
    final dotCount = '.'.allMatches(cleaned).length;
    if (dotCount > 1) return oldValue;

    // Make sure it's a valid number
    final number = double.tryParse(cleaned);
    if (number == null) return oldValue;

    // Format using thousand separators
    final parts = cleaned.split('.');
    String formatted = _formatter.format(int.parse(parts[0]));

    if (parts.length > 1) {
      formatted += '.${parts[1]}';
    }

    // Set new cursor position
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
