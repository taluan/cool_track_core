
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

import 'helper_utils.dart';

TextInputFormatter currencyTextInputFormatter(
    {bool allowNegative = false, String? maxValue, String? currencyValue = 'VND'}) {
      currencyValue = currencyValue ?? 'VND';
      final locale = currencyToLocale[currencyValue] ?? Intl.getCurrentLocale();
      NumberFormat formatter = NumberFormat.decimalPattern(locale);
      // print("GROUP_SEP: ${formatter.symbols.GROUP_SEP} - DECIMAL_SEP: ${formatter.symbols.DECIMAL_SEP}");
      return CurrencyTextInputFormatter(
            suffix: '',
            decimalDigits: 0,
            maxValue: maxValue,
            allowNegative: allowNegative,
            groupDigits: 3,
            groupSeparator: formatter.symbols.GROUP_SEP,
            decimalSeparator: formatter.symbols.DECIMAL_SEP,
            insertDecimalPoint: true,
            insertDecimalDigits: true,
      );
}

TextInputFormatter numericTextInputFormatter(
    {bool allowNegative = false, String? maxValue}) =>
    NumberTextInputFormatter(
      groupDigits: 3,
      decimalDigits: 0,
      groupSeparator: '.',
      decimalSeparator: ',',
      insertDecimalPoint: false,
      insertDecimalDigits: false,
      maxValue: maxValue,
      allowNegative: allowNegative,
    );

TextInputFormatter decimalTextInputFormatter(
    {bool allowNegative = false, String? maxValue}) =>
    NumberTextInputFormatter(
      decimalDigits: 2,
      decimalSeparator: ',',
      groupDigits: 3,
      groupSeparator: '.',
      insertDecimalPoint: true,
      insertDecimalDigits: true,
      maxValue: maxValue,
      allowNegative: allowNegative,
    );