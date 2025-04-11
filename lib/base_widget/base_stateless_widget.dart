import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../base_cubit/base_cubit.dart';
import '../widgets/appbar/appbar_default.dart';

mixin BaseStateContent<C extends BaseCubit> on StatelessWidget {
  late BuildContext context;

  Widget body(BuildContext context);

  Color? get backgroundColor => null;

  bool? get resizeToAvoidBottomInset => false;

  bool get enableBackButton => true;

  bool get extendBodyBehindAppBar => false;

  Widget? get bottomSheet => null;

  Widget? get floatingButton => null;

  Widget? get bottomBarView => null;

  List<Widget>? get overlayViews => null;

  void dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void onClickedBack(BuildContext context) {
    Navigator.of(context).maybePop();
  }

  void popNavigator([dynamic obj]) {
    Navigator.of(context).maybePop(obj);
  }

  /// Action widget (ex: search,...)
  List<Widget>? actionButton(BuildContext context) => null;

  void onBackAction(BuildContext context) {
    Navigator.of(context).maybePop();
  }

  //Override this method to custom loading widget
  Widget loadingWidget(bool isShow) {
    return isShow
        ? Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          )
        : const SizedBox();
  }

  PreferredSizeWidget? customAppBar(BuildContext context) => null;
}

// ignore: must_be_immutable
abstract class BaseStatelessWidget<C extends BaseCubit> extends StatelessWidget
    with BaseStateContent<C> {
  final String? title;
  final C Function()? createCubit;
  C? _cubit;

  BaseStatelessWidget({super.key, this.title, this.createCubit});

  C Function()? get initCubit => null;

  C get cubit {
    // debugPrint("cubit: ${_cubit?.hashCode}");
    if (_cubit != null && _cubit?.isClosed != true) return _cubit!;
    _cubit = createCubit?.call() ?? initCubit?.call() ?? EmptyCubit() as C;
    return _cubit!;
  }

  void reloadUI() {
    cubit.reloadUI();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build: $runtimeType - ${context.hashCode}");
    this.context = context;
    return KeyboardDismisser(
      child: BlocProvider(
        create: (ctx) {
          // debugPrint(
          //     "create bloc provider: $runtimeType - ${context.hashCode}");
          return cubit..initContext(ctx);
        },
        child: appBuilderWidget(context),
      ),
    );
  }

  Widget Function(BuildContext) get appBuilderWidget => (context) {
        return AppBaseWidget<C>(
          backgroundColor: backgroundColor,
          appBarBuilder: _createAppBar,
          bodyBuilder: (ctx) => body(ctx),
          loadingBuilder: (isLoading) => loadingWidget(isLoading),
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          overlayViewsBuilder: () => overlayViews,
          floatingButtonBuilder: () => floatingButton,
          bottomBarViewBuilder: () => bottomBarView,
          bottomSheetBuilder: () => bottomSheet,
        );
      };

  String? get appBarTitle => title;

  PreferredSizeWidget? _createAppBar(BuildContext context) {
    PreferredSizeWidget? custom = customAppBar(context);
    if (custom != null) {
      return custom;
    }
    if (appBarTitle == null) {
      return null;
    }
    List<Widget> actions = actionButton(context) ?? [];
    actions.add(const SizedBox(
      width: 12,
    ));
    return AppbarDefault(
      context: context,
      title: appBarTitle,
      elevation: appBarElevation,
      enableBackButton: enableBackButton,
      onBackAction: () {
        onBackAction(context);
      },
      bottomAppBar: bottomAppBar,
      actions: actions,
    );
  }

  double get appBarElevation => 1.0;

  PreferredSizeWidget? get bottomAppBar => null;
}

class AppBaseWidget<C extends BaseCubit> extends StatelessWidget {
  final PreferredSizeWidget? Function(BuildContext context) appBarBuilder;
  final Widget Function(BuildContext context) bodyBuilder;
  final Widget Function(bool isShow) loadingBuilder;
  final Widget? Function() floatingButtonBuilder;
  final Widget? Function() bottomBarViewBuilder;
  final Widget? Function() bottomSheetBuilder;
  final List<Widget>? Function() overlayViewsBuilder;
  final bool extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;
  final Color? backgroundColor;
  const AppBaseWidget(
      {super.key,
      required this.backgroundColor,
      required this.appBarBuilder,
      required this.bodyBuilder,
      required this.loadingBuilder,
      required this.overlayViewsBuilder,
      required this.floatingButtonBuilder,
      required this.bottomBarViewBuilder,
      required this.bottomSheetBuilder,
      this.extendBodyBehindAppBar = false,
      this.resizeToAvoidBottomInset});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<C>();
    return BlocBuilder<C, bool>(
      bloc: cubit,
      builder: (context, data) {
        debugPrint("ReloadUI: $data");
        final overlays = overlayViewsBuilder();
        return Scaffold(
          appBar: appBarBuilder(context),
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          backgroundColor: backgroundColor,
          body: Stack(
            children: [
              bodyBuilder(context),
              if (overlays != null) ...overlays,
              StreamBuilder<bool?>(
                stream: cubit.loadingStream,
                builder: (context, snapshot) {
                  return loadingBuilder(snapshot.data ?? false);
                },
              ),
            ],
          ),
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          floatingActionButton: floatingButtonBuilder(),
          bottomNavigationBar: bottomBarViewBuilder(),
          bottomSheet: bottomSheetBuilder(),
        );
      },
    );
  }
}
