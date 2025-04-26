import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../base_cubit/base_cubit.dart';


abstract class BaseTabbarView<C extends BaseCubit> extends StatelessWidget {
  const BaseTabbarView({super.key});

  C createCubit(BuildContext context);
  Widget body(BuildContext context);

  C cubit(BuildContext context) => context.read<C>();
  C cubitWatch(BuildContext context) => context.watch<C>();


  List<Widget>? overlayViews(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: BlocProvider(
        create: (ctx) {
          debugPrint(
              "BaseTabbarView: $runtimeType - ${context.hashCode}");
          return createCubit(ctx)..initContext(ctx);
        },
        child: Builder(
            builder: (context) {
              final cubit = context.watch<C>();
              final overlays = overlayViews(context);
              return Stack(
                children: [
                  BlocBuilder<C, bool>(
                      bloc: cubit,
                      builder: (context, data) {
                        debugPrint("BaseTabbarView reload: $runtimeType");
                        return body(context);
                      }
                  ),
                  if (overlays != null) ...overlays,
                  StreamBuilder<bool?>(
                    stream: cubit.loadingStream,
                    builder: (context, snapshot) {
                      return loadingWidget(snapshot.data ?? false);
                    },
                  ),
                ],
              );
            }
        ),
      ),
    );
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
}


abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

abstract class BaseState<Page extends StatefulWidget, C extends BaseCubit>
    extends State<Page>
    with AutomaticKeepAliveClientMixin<Page>, WidgetsBindingObserver {

  late C cubit;

  void reloadUI() {
    context.watch<C>().reloadUI();
  }

  void onReady() {
    debugPrint("$runtimeType onReady");
  }

  Future dismissKeyboard() => cubit.dismissKeyboard();

  @override
  void initState() {
    super.initState();
    cubit = context.read<C>();
    debugPrint("initState: $runtimeType");
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => onReady());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    debugPrint("Rebuild stateFull: $runtimeType");
    return bodyWidget(context);
  }

  Widget bodyWidget(BuildContext context);

}

abstract class BaseKeepAliveState<Page extends StatefulWidget>
    extends State<Page>
    with AutomaticKeepAliveClientMixin<Page>, WidgetsBindingObserver {

  void onReady() {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => onReady());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context);
}
