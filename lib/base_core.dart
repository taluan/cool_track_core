
import 'dart:io';


import 'package:base_code_flutter/utils/app_util.dart';
import 'package:base_code_flutter/widgets/alert/alert_widget_page.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

export 'package:flutter_screenutil/flutter_screenutil.dart';
export '../base_cubit/base_cubit.dart';
export '../base_network/api_client_request.dart';
export '../base_network/api_router.dart';
export '../base_network/base_response.dart';
export '../base_widget/base_statefull_widget.dart';
export '../base_widget/base_stateless_widget.dart';

import '../base_network/myhttp_overrides.dart';
import 'app_config.dart';
import 'base_network/api_client_request.dart';
import 'generated/l10n.dart';
import 'management/cache_manager.dart';

final packageName = "base_code_flutter";
enum AlertType { inform, error, success, confirm }

final navigatorKey = GlobalKey<NavigatorState>();

final screenUtil = ScreenUtil();
AppUtil get appUtil => AppUtil.instance;
final getIt = GetIt.instance;

ApiClientRequest get apiClient => getIt<ApiClientRequest>();
CacheManager get cacheManager => CacheManager.instance;

abstract mixin class AppCoreObserver {
  Future<int?> showAlert({
    BuildContext? context,
    String? title,
    required String? message,
    String? closeTitle,
    AlertType alertType = AlertType.inform,
  });

  AppConfig? get config;
}

AppCoreConfig get appCoreConfig => AppCoreConfig();
class AppCoreConfig {
  static const AppLocalizationDelegate localizationsDelegate = S.delegate;
  static final AppCoreConfig _instance = AppCoreConfig._internal();
  factory AppCoreConfig() => _instance;
  AppCoreConfig._internal();
  AppCoreObserver? _observer;

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);


    HttpOverrides.global = MyHttpOverrides();
    if (!getIt.isRegistered<ApiClientRequest>()) {
      throw Exception("Please register ApiClientRequest for getit");
    }
  }

  void addObserver(AppCoreObserver ob) {
    _observer = ob;
  }

  Future<int?> showError({
    BuildContext? context,
    String? title,
    required String? message,
    String? closeTitle,
  }) {
    if (_observer != null) {
      return _observer!.showAlert(context: context, title: title, message: message, closeTitle: closeTitle, alertType: AlertType.error);
    } else {
      return AlertWidgetPage.show(context: context ?? navigatorKey.currentContext!, title: title, message: message, closeTitle: closeTitle, alertType: AlertType.error);
    }

  }

  Future<int?> showMessage({
    BuildContext? context,
    String? title,
    required String? message,
    String? closeTitle,
  }) {
    if (_observer != null) {
      return _observer!.showAlert(context: context, title: title, message: message, closeTitle: closeTitle, alertType: AlertType.inform);
    } else {
      return AlertWidgetPage.show(context: context ?? navigatorKey.currentContext!, title: title, message: message, closeTitle: closeTitle, alertType: AlertType.inform);
    }
  }

  AppConfig? get config => _observer?.config;
}