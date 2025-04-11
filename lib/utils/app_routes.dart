import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_route_builder.dart';

mixin AppRoutes {
  static dynamic push(BuildContext context, Widget page) async {
    return Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => page,
        settings: RouteSettings(name: page.runtimeType.toString())));
  }

  static dynamic pushReplacement(BuildContext context, Widget page, [Completer? resultCompleter]) async {
    return Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => page,
        settings: RouteSettings(
          name: page.runtimeType.toString(),
        ),
      ),
      result: resultCompleter?.future
    );
  }


  static dynamic pushAndRemoveUntil(BuildContext context, Widget page) async {
    return Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => page,
          settings: RouteSettings(
            name: page.runtimeType.toString(),
          ),), (route) => false);
  }

  static dynamic pushAndRemoveUntilFirst(BuildContext context, Widget page) async {
    return Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => page,
          settings: RouteSettings(
            name: page.runtimeType.toString(),
          ),), (route) => route.isFirst);
  }

  static dynamic popUntilFirst(BuildContext context) async {
    return Navigator.popUntil(
        context, (route) => route.isFirst);
  }

  static dynamic pushOpacity(BuildContext context, Widget page,
      {Duration duration = const Duration(milliseconds: 300)}) async {
    return Navigator.of(context)
        .push(OpacityRoute(page: page, duration: duration));
  }

  static dynamic showPopup(BuildContext context, Widget page) async {
    return Navigator.of(context)
        .push(TransparentRoute(builder: (context) => page, settings: RouteSettings(
      name: page.runtimeType.toString(),
    ),));
  }

  static dynamic showBottomPopup(BuildContext context, Widget page, {Color backgroundColor = Colors.black38}) async {
    return Navigator.of(context)
        .push(BottomPopupRoute(builder: (context) => page, backgroundColor: backgroundColor, settings: RouteSettings(
      name: page.runtimeType.toString(),
    ),));
  }

  static dynamic showBottomSheet(BuildContext context, Widget page) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder( // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        isScrollControlled: true,
        clipBehavior: Clip.hardEdge,
        useSafeArea: true,
        builder: (_) => page);
  }


  static dynamic showDialogPopup(BuildContext context, Widget dialog,
      {bool dismissible = true}) async {
    return showDialog(
        context: context,
        barrierDismissible: dismissible,
        routeSettings: RouteSettings(
          name: dialog.runtimeType.toString(),
        ),
        builder: (context) {
          return PopScope(
            canPop: dismissible,
            child: dialog,
          );
        });
  }
}
