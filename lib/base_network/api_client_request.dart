
import 'package:connectivity/connectivity.dart';

import 'api_router.dart';
import 'base_response.dart';

abstract class ApiHandleService {
  Future<Map<String, String>> requestHeaders();
  ApiRouter get refreshTokenApi;
  bool get isLoggedIn;
  bool onRefreshTokenCompleted(Map<String, dynamic> json);
  ///
  /// Xử lý khi token expired sau khi đã refresh token
  ///
  Future<void> processExpiredToken();
  String? errorMessage(int statusCode, int errorCode);
}

abstract class ApiClientRequest {
  String get msg_mang_ko_on_dinh => "Kết nối mạng không ổn định. Vui lòng thử lại!";
  String get msg_server_error => "Có lỗi kết nối máy chủ, vui lòng thử lại";
  String get msg_api_notfound => "Api không tồn tại";
  String get msg_network_notfound => "Không tìm thấy kết nối mạng";
  String get msg_token_expired => "Token expired";


  int retryCount = 0;
  bool shouldRefreshToken = false;
  // final timeOut = const Duration(seconds: 45);

  Future<bool> isConnectedNetWork() async {
    final connectivityStatus = await Connectivity().checkConnectivity();
    return connectivityStatus != ConnectivityResult.none;
  }

  ///
  /// define root api url
  ///
  String get rootUrl;

  Future<ServerResponse<T>> request<T>(
      {required ApiRouter router,
        required T Function(Map<String, dynamic> json)? target,
        bool isCache = false, Function(T? data)? cacheDataCallback});

  Future<ServerResponseArray<T>> requestArray<T>(
      {required ApiRouter router,
        required T Function(Map<String, dynamic> json)? target,
        bool isCache = false, Function(List<T>? datas)? cacheDataCallback});


}