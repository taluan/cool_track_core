import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../base_core.dart';


abstract class BaseCubit extends Cubit<bool> {
  late BuildContext context;
  final BehaviorSubject<bool?> _bsLoading = BehaviorSubject();

  BaseCubit() : super(false) {
    debugPrint('Khoi tao cubit: $runtimeType');
  }

  void initContext(BuildContext context) {
    this.context = context;
    debugPrint('initContext cubit: $runtimeType - ${context.hashCode}');
    initCubit();
  }

  void initCubit() {}

  Stream<bool?> get loadingStream => _bsLoading.stream;
  bool get isLoading => _bsLoading.valueOrNull ?? false;

  void reloadUI() {
    emit(!state);
  }

  Future dismissKeyboard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void showLoading([bool condition = true]) {
    if (!isClosed && !isLoading && condition) {
      _bsLoading.sink.add(true);
    }
  }

  void hideLoading() {
    if (!isClosed && isLoading) {
      _bsLoading.sink.add(false);
    }
  }
  Future errorHandlerAndBack(int code, String msg) async {
    await errorHandler(code, msg, enableBack: true);
  }

  Future errorHandler(int code, String msg, {bool enableBack = false}) async {
    if (isClosed) return;
    hideLoading();
    await showError(message: msg, enableBack: enableBack);
  }

  Future showError({required String? message, bool enableBack = false}) async {
    await AppCoreConfig().showError(context: context, message: message);
    if (enableBack && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void dispose() {}


  @override
  Future<void> close() {
    debugPrint('close cubit: $runtimeType');
    _bsLoading.close();
    dispose();
    return super.close();
  }
}

class EmptyCubit extends BaseCubit {

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void initCubit() {
    // TODO: implement initCubit
  }

}