import 'package:flutter/material.dart';

import 'custom_snack_bar.dart';
import 'top_snack_bar.dart';

mixin AppSnackBar {
  static void showSuccess(BuildContext context, {required String message, Duration displayDuration = const Duration(milliseconds: 3000)}) {
    showTopSnackBar(Overlay.of(context), CustomSnackBar.success(
      message: message,
      messagePadding: const EdgeInsets.symmetric(horizontal: 12),
      // textStyle: AppConfig.primaryTextStyle,
      backgroundColor: const Color(0xffEAF6ED),
      border: Border.all(color: Colors.green),
    ));
  }

  static void showError(BuildContext context, {required String message, Duration displayDuration = const Duration(milliseconds: 3000)}) {
    showTopSnackBar(Overlay.of(context), CustomSnackBar.error(
      message: message,
      messagePadding: const EdgeInsets.symmetric(horizontal: 12),
      // textStyle: AppConfig.primaryTextStyle,
      backgroundColor: const Color(0xFFF8C4C4),
      border: Border.all(color: Colors.redAccent),
    ));
  }

  static void showWarning(BuildContext context, {required String message, Duration displayDuration = const Duration(milliseconds: 3000)}) {
    showTopSnackBar(Overlay.of(context), CustomSnackBar.error(
      message: message,
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
      messagePadding: const EdgeInsets.symmetric(horizontal: 12),
      // textStyle: AppConfig.primaryTextStyle,
      backgroundColor: const Color(0xFFF3E3C4),
      border: Border.all(color: Colors.orange),
    ));
  }

  static void showInfo(BuildContext context, {required String message, Duration displayDuration = const Duration(milliseconds: 3000)}) {
    showTopSnackBar(Overlay.of(context), CustomSnackBar.info(
      message: message,
      messagePadding: const EdgeInsets.symmetric(horizontal: 12),
      // textStyle: Theme.of(context).textTheme.bodyMedium,
      backgroundColor: Colors.white,
      border: Border.all(color: Theme.of(context).colorScheme.primary),
    ), displayDuration: displayDuration);
  }
}
