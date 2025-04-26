
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/app_const.dart';
import '../base_core.dart';


Map<String, String> currencyToLocale = {
  'VND': 'vi_VN',
  'AUD': 'en_AU',
  'SGD': 'en_SG',
  'JPY': 'ja_JP',
  'KRW': 'ko_KR',
  'CNY': 'zh_CN',
  'THB': 'th_TH',
  'LAK': 'lo_LA',
  'KHR': 'km_KH',
  'MYR': 'ms_MY',
  'USD': 'en_US',
  'GBP': 'en_GB',
  'EUR': 'de_DE',
};

extension DateTimeEx on DateTime {

  String? get toUtcString => toUtc().toIso8601String();

  String? formatString({String dateFormat = AppConst.dateFormat}) {
    try {
      return DateFormat(dateFormat).format(this);
    } catch (e) {}
    return null;
  }

  int compareDateTo(DateTime other) {
    if (year != other.year) {
      return year < other.year ? -1 : 1;
    } else if (month != other.month) {
      return month < other.month ? -1 : 1;
    } else if (day != other.day) {
      return (day < other.day) ? -1 : 1;
    }
    return 0;
  }

  int compareDateWithHMTo(DateTime other) {
    if (year != other.year) {
      return year < other.year ? -1 : 1;
    } else if (month != other.month) {
      return month < other.month ? -1 : 1;
    } else if (day != other.day) {
      return (day < other.day) ? -1 : 1;
    } else if (hour != other.hour) {
      return hour < other.hour ? -1 : 1;
    } else if (minute != other.minute) {
      return minute < other.minute ? -1 : 1;
    }

    return 0;
  }

  bool isEqualDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension ContextEX on BuildContext {
  // Size get screenSize => MediaQuery.of(this).size;

  double? get iconSize => IconTheme.of(this).size;

  double get paddingBottom => screenUtil.bottomBarHeight >= 18 ? 18 : screenUtil.bottomBarHeight;

  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  InputDecorationTheme get inputDecorationTheme => theme.inputDecorationTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  bool get isTablet => screenUtil.screenWidth > 600;

  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }

}

int parseInt(dynamic value, {bool removeFormat = false}) {
  try {
    if (value is int) {
      return value;
    } else if (value == null) {
      return 0;
    } else {
      if (removeFormat) {
        return int.tryParse(
            value.toString().replaceAll(".", "").replaceAll(",", ".").trim()) ?? 0;
      } else {
        return num.tryParse(value.toString())?.toInt() ?? 0;
      }

    }
  } catch(_){
    return 0;
  }
}


double parseDouble(dynamic value, {bool removeFormat = false, String? currencyValue = 'VND'}) {
  try {
    if (value is double) {
      return value;
    } else if (value == null) {
      return 0.0;
    } else {
      if (removeFormat) {
        currencyValue = currencyValue ?? 'VND';
        final locale = currencyToLocale[currencyValue] ?? Intl.getCurrentLocale();
        NumberFormat formatter = NumberFormat.decimalPattern(locale);
        return formatter.parse(value) as double? ?? 0.0;
      } else {
        return num.tryParse(value.toString().replaceAll(",", ".").trim())
            ?.toDouble() ??
            0.0;
      }
    }
  } catch(_) {
    return 0.0;
  }
}

String parseString(dynamic value) {
  if (value is String) {
    return value;
  } else if (value == null) {
    return "";
  } else {
    return value.toString();
  }
}

bool parseBoolean(dynamic value, {bool defaultValue = false}) {
  if (value != null) {
    if (value is bool) {
      return value;
    }
    return value.toString().toLowerCase() == '1' || value.toString().toLowerCase() == 'true';
  }
  return defaultValue;
}

String convertDateToString(DateTime? dateTime, String dateFormat, {String defaultValue = ""}) {
  try {
    if (dateTime != null) {
      return dateTime.formatString(dateFormat: dateFormat) ?? defaultValue;
    }
  } catch (e) {}
  return defaultValue;
}

String convertStringUtcToStringLocal(String? utcString, {String dateFormat = AppConst.dateFormat, String defaultValue = ""}) {
  try {
    if (utcString != null) {
      final localDate = convertStringUtcToLocalDate(utcString);
      if (localDate != null) {
        return localDate.formatString(dateFormat: dateFormat) ?? defaultValue;
      }
    }
  } catch (e) {}
  return defaultValue;
}

DateTime? convertStringToDate(String? dateString, String dateFormat) {
  if (dateString != null && dateString.isNotEmpty) {
    try {
      var string = dateString;
      if (dateFormat.length > string.length) {
        string = dateString.substring(0, dateFormat.length);
      }
      return DateFormat(dateFormat).parse(string);
    } catch (e) {
      return DateFormat(AppConst.dateFormat).parse(dateString);
    }
  } else {
    return null;
  }
}

DateTime? convertStringUtcToLocalDate(String? utcString) {
  if (utcString != null && utcString.isNotEmpty) {
    try {
      return DateTime.parse(utcString).toLocal();
    } catch (_) {
      return null;
    }
  } else {
    return null;
  }
}


DateTime getFirstDateOfCurrentWeek() {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  int currentWeekday = today.weekday;
  DateTime firstDateOfWeek = today.subtract(Duration(days: currentWeekday - 1));
  return firstDateOfWeek;
}

DateTime getLastDateOfCurrentWeek() {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day + (DateTime.sunday - now.weekday) + 1);
  DateTime lastDateOfWeek = today.subtract(const Duration(milliseconds: 1));
  return lastDateOfWeek;
}

DateTime getLastDateOfCurrentMonth() {
  DateTime now = DateTime.now();
  DateTime firstDayOfNextMonth = (now.month < 12)
      ? DateTime(now.year, now.month + 1, 1)
      : DateTime(now.year + 1, 1, 1);
  DateTime lastDayOfCurrentMonth = firstDayOfNextMonth.subtract(const Duration(milliseconds: 1));
  return lastDayOfCurrentMonth;
}

String encodeBase64String(String str) {
  return base64.encode(utf8.encode(str)); // dXNlcm5hbWU6cGFzc3dvcmQ=
}

String decodeBase64String(String encoded) {
  return utf8.decode(base64.decode(encoded));
}

String capitalizeFirstLetter(String? text) {
  if (text == null) {
    return "";
  }

  if (text.length <= 1) {
    return text.toUpperCase();
  }

  try {
    // Split string into multiple words
    final List<String> words = text.trim().split(' ');

    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    // Join/Merge all words back to one String
    return capitalizedWords.join(' ');
    // ignore: empty_catches
  } catch (e) {}
  return text;
}

double sizeForRatio(double size) {
  return screenUtil.scaleWidth * size;
}

//get size scale for fontsize max 1.8 ration
double sizeForScale(double size, {double maxRatio = 1.8}) {
  double ratio = screenUtil.scaleWidth;
  if (ratio > maxRatio) {
    ratio = maxRatio;
  }
  return ratio * size;
}

double getAspectRatioFixHeight(
    double height, double width, double crossAxisSpacing, int crossAxisCount) {
  var width0 =
      (width - ((crossAxisCount - 1) * crossAxisSpacing)) / crossAxisCount;
  return width0 / height;
}

String formatNumber(
    {required dynamic value,
      int minDigits = 0,
      int maxDigits = 2,
      bool showCurrency = false}) {
  try {
    var currencyValue = '₫';
    if (value == null) return '';
    NumberFormat formatter = NumberFormat();
    formatter.minimumFractionDigits = minDigits;
    formatter.maximumFractionDigits = maxDigits;
    if (value is num) {
      return formatter.format(value) + (showCurrency ? currencyValue : '');
    } else {
      return formatter.format(num.tryParse(value.toString())) +
          (showCurrency ? currencyValue : '');
    }
  } catch (e) {
    return '';
  }
}

String formatNumberWithLocale({
  required dynamic value,
  int minDigits = 0,
  int maxDigits = 2,
  bool showCurrency = false,
  String? locale = 'vi-VN',
}) {
  try {
    var currencyValue = ' VND';
    if (value == null) return '';
    NumberFormat formatter = NumberFormat.decimalPattern(locale);
    formatter.minimumFractionDigits = minDigits;
    formatter.maximumFractionDigits = maxDigits;
    if (value is num) {
      return formatter.format(value) + (showCurrency ? currencyValue : '');
    } else {
      return formatter.format(num.tryParse(value.toString())) +
          (showCurrency ? currencyValue : '');
    }
  } catch (e) {
    return '';
  }
}

String formatCurrency({
  required dynamic value,
  int minDigits = 0,
  int maxDigits = 2,
  bool showCurrency = false,
  String? currencyValue = 'VND',
}) {
  try {
    if (value == null) return '';
    currencyValue = currencyValue ?? 'VND';
    final locale = currencyToLocale[currencyValue] ?? Intl.getCurrentLocale();
    NumberFormat formatter = NumberFormat.decimalPattern(locale);
    formatter.minimumFractionDigits = minDigits;
    formatter.maximumFractionDigits = maxDigits;
    if (value is num) {
      return formatter.format(value) + (showCurrency ? ' $currencyValue' : '');
    } else {
      return formatter.format(num.tryParse(value.toString())) +
          (showCurrency ? ' $currencyValue' : '');
    }
  } catch (e) {
    return '';
  }
}