import 'package:flutter/material.dart';

class SlideFromBottomRoute extends PageRouteBuilder {
  final Widget? page;

  SlideFromBottomRoute({ this.page }) :
        super(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return page!;
      },
          transitionDuration: const Duration(milliseconds: 500),
          barrierColor: Colors.transparent,
          settings: RouteSettings(
            name: page.runtimeType.toString(),
          ),
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: const Offset(0.0, 0.0),
              ).animate(animation),
              child: child,
            );
          }
      );
}

class SlideFromTopRoute extends PageRouteBuilder {
  final Widget? page;

  SlideFromTopRoute({ this.page }) :
        super(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return page!;
      },
          transitionDuration: const Duration(milliseconds: 500),
          barrierColor: Colors.transparent,
          settings: RouteSettings(
            name: page.runtimeType.toString(),
          ),
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: const Offset(0.0, 0.0),
              ).animate(animation),
              child: child,
            );
          }
      );
}

class OpacityRoute extends PageRouteBuilder {
  final Widget? page;
  final Duration duration;

  OpacityRoute({ this.page, this.duration =  const Duration(milliseconds: 600)}) :
        super(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return page!;
      },
          transitionDuration: duration,
          barrierColor: Colors.transparent,
          settings: RouteSettings(
            name: page.runtimeType.toString(),
          ),
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return FadeTransition(
              opacity:animation,
              child: child,
            );
          }
      );
}


class RotationRoute extends PageRouteBuilder {
  final Widget? page;
  RotationRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page!,
    transitionDuration: const Duration(seconds: 1),
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.linear,
            ),
          ),
          child: child,
        ),
  );
}

class ScaleRotateRoute extends PageRouteBuilder {
  final Widget? page;
  ScaleRotateRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page!,
    transitionDuration: const Duration(seconds: 1),
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: RotationTransition(
            turns: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.linear,
              ),
            ),
            child: child,
          ),
        ),
  );
}

class ScaleRoute extends PageRouteBuilder {
  final Widget? page;
  ScaleRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page!,
    transitionDuration: const Duration(seconds: 1),
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        ),
  );
}

class BottomPopupRoute extends PageRoute<void> {
  BottomPopupRoute({
    required this.builder,
    this.backgroundColor = Colors.black38,
    super.settings,
  })  : super(fullscreenDialog: true);

  final WidgetBuilder builder;
  final Color backgroundColor;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => backgroundColor;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    // return result;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: const Offset(0.0, 0.0),
      ).animate(animation),
      child: result,
    );
  }
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    required this.builder,
    RouteSettings? settings,
  })  : super(settings: settings, fullscreenDialog: true);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;//Colors.black38;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return result;
  }
}