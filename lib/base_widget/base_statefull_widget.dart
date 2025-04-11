import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../base_cubit/base_cubit.dart';



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
