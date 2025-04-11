import 'dart:async';

import 'package:flutter/material.dart';

import '../../base_core.dart';
import '../../generated/l10n.dart';

class AlertWidgetPage extends StatelessWidget {
  final String title;
  final String message;
  final String? closeTitle;
  final String? okTitle;
  final AlertType alertType;

  const AlertWidgetPage({super.key,
    required this.title,
    required this.message,
    this.closeTitle,
    this.okTitle,
    required this.alertType,
  });


  static bool _isShowing = false;
  static Completer<int?>? _completer;
  static Future<int?> show({
    required BuildContext context,
    String? title,
    required String? message,
    String? closeTitle,
    String? okTitle,
    AlertType alertType = AlertType.inform,
  }) async {
    if (message == null || message.isEmpty) {
      return null;
    }

    if (_isShowing) {
      debugPrint("Alert is already showing, skipping...");
      return null;
    }

    _isShowing = true;
    _completer = Completer<int?>();

    try {
      final int? result = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertWidgetPage(
              title: title ?? "Thông báo",
              message: message,
              closeTitle: closeTitle,
              okTitle: okTitle,
              alertType: alertType,
            ),
          );
        },
      );

      _completer?.complete(result);
      debugPrint("Dismiss alert");
    } catch (e) {
      debugPrint("Error showing alert: $e");
      _completer?.complete(null);
    } finally {
      _isShowing = false;
      _completer = null;
    }

    return _completer?.future;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (okTitle != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(1),
            child: Text(okTitle!),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(0),
          child: Text(closeTitle ?? S.current.close),
        ),
      ],
    );
  }
}