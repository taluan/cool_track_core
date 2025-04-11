import 'package:flutter/cupertino.dart';

import 'helper_utils.dart';

enum NumberTextFormatType { decimal, integer, currency }

class NumberTextEditingController extends TextEditingController {
  NumberTextEditingController._({
    num? value,
    this.formatType,
  }) {
    number = value;
  }

  factory NumberTextEditingController.decimal({num? value}) {
    return NumberTextEditingController._(
      value: value,
      formatType: NumberTextFormatType.decimal,
    );
  }

  factory NumberTextEditingController.integer({num? value}) {
    return NumberTextEditingController._(
      value: value,
      formatType: NumberTextFormatType.integer,
    );
  }

  factory NumberTextEditingController.currency({num? value}) {
    return NumberTextEditingController._(
      value: value,
      formatType: NumberTextFormatType.currency,
    );
  }

  NumberTextFormatType? formatType;
  num? _number;

  num? get number => _number;

  /// Sets the underlying number value
  set number(num? number) {
    _number = number;
    String text = _formatText(number);
    super.value = value.copyWith(
      text: text,
      selection: const TextSelection.collapsed(offset: -1),
      composing: TextRange.empty,
    );
  }

  @override
  set value(TextEditingValue newValue) {
    _number = _parseNumber(newValue);
    super.value = newValue;
  }

  String _formatText(num? number) {
    if (number == null) {
      return '';
    }
    if (formatType == NumberTextFormatType.decimal) {
      return formatNumber(value: number, minDigits: 2);
    }
    if (formatType == NumberTextFormatType.integer) {
      return formatNumber(value: number, minDigits: 0);
    }
    if (formatType == NumberTextFormatType.currency) {
      return formatNumber(value: number, minDigits: 0, showCurrency: false);
    }
    return '';
  }

  num? _parseNumber(TextEditingValue newValue) {
    String text = newValue.text.trim();
    switch (formatType) {
      case NumberTextFormatType.decimal:
      case NumberTextFormatType.integer:
        text = text.replaceAll('.', '').replaceAll(',', '.');
        break;
      case NumberTextFormatType.currency:
        text = text
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .replaceAll(RegExp(r'[^0-9.,]'), '');
        break;
      default:
        break;
    }
    return num.tryParse(text);
  }
}
