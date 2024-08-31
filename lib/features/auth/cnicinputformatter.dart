import 'package:flutter/services.dart';

class CnicInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('-', '');
    if (text.length > 13) {
      return oldValue;
    }

    StringBuffer newText = StringBuffer();
    int selectionIndex = newValue.selection.end;

    for (int i = 0; i < text.length; i++) {
      if (i == 5 || i == 12) {
        newText.write('-');
        if (i < selectionIndex) {
          selectionIndex++;
        }
      }
      newText.write(text[i]);
    }

    // Adjust the selection index if the user is deleting a hyphen
    if (oldValue.text.length > newValue.text.length &&
        oldValue.text.contains('-') &&
        !newValue.text.contains('-')) {
      selectionIndex--;
    }

    // Ensure the selection index is within the valid range
    if (selectionIndex > newText.length) {
      selectionIndex = newText.length;
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
