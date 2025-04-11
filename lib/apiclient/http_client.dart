import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base_code_flutter/base_network/app_exception.dart';
import 'package:base_code_flutter/flavor/flavor.dart';
import 'package:base_code_flutter/management/cache_manager.dart';
import 'package:base_code_flutter/model/log_api_model.dart';
import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart';

import '../base_core.dart';

class HttpClient extends ApiClientRequest {

  final ApiHandleService _handleService;
  HttpClient._(this._handleService);
  static HttpClient? _instance;

  factory HttpClient(ApiHandleService handleService) {
    return _instance ??= HttpClient._(handleService);
  }
  bool _refreshTokenLoading = false;
  DateTime _refreshTokenTime = DateTime.now().subtract(const Duration(seconds: 30));


  @override
  String get rootUrl => "${AppFlavor.rootUrl}/";

  @override
  Future<ServerResponse<T>> request<T>({required ApiRouter router, required T Function(Map<String, dynamic> json)? target, bool isCache = false, Function(T? data)? cacheDataCallback}) async {
    try {
      bool newData = false;
      //load cache data
      if (cacheDataCallback != null) {
        cacheManager.getCacheResponse<T>(router.cacheUrl, target).then((value) {
          if (!newData && value?.data != null) { //chỉ callback cache data khi chưa có response data mới từ api
            cacheDataCallback(value?.data);
          }
        });
      }

      final response = await _request(router);
      if (response.statusCode == 404) {
        return ServerResponse(code: 404, message: msg_api_notfound);
      } else if (response.statusCode == 503) {
        return ServerResponse(code: 503, message: '503 Service Temporarily Unavailable');
      } else if (response.statusCode == 504) {
        return ServerResponse(code: 504, message: '504 Gateway Timeout ERROR');
      } else if (response.statusCode == 401 ) {
        //unauthorized token
        if (_handleService.isLoggedIn) {
          if (_refreshTokenLoading) { //nếu đang refesh token thì request lại sau 3 giây
            await Future.delayed(const Duration(seconds: 3));
            return request(router: router, target: target, isCache: isCache);
          } else {
            bool refreshSuccess = await _refreshToken();
            if (refreshSuccess) {
              // if refresh token success call request again
              return await request(router: router, target: target, isCache: isCache);
            }
          }
          await _handleService.processExpiredToken();
          return ServerResponse(code: 401, message: "");
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300 && response.body.isNotEmpty) {
        Map<String, dynamic>? json = jsonDecode(response.body);
        final serverResponse = ServerResponse.parseJson(json, target);
        if (isCache) {
          cacheManager.cacheData(response.body, router.cacheUrl);
        }
        newData = true;
        retryCount = 0;
        return serverResponse;
      } else {
        if (response.body.isNotEmpty) {
          Map<String, dynamic>? json = jsonDecode(response.body);
          final statusCode = json?['status_code'] ?? json?['statusCode'] ?? response.statusCode;
          final errorCode = json?['error_code'] ?? json?['errorCode'] ?? 0;
          final msg = _handleService.errorMessage(statusCode, errorCode) ?? json?["Message"] ?? json?["error_message"] ?? json?["errorMessage"] ?? json?["message"] ?? msg_server_error;
          return ServerResponse(code: response.statusCode, message: msg);
        } else {
          return ServerResponse(code: response.statusCode, message: "${response.reasonPhrase ?? msg_server_error}: ${response.reasonPhrase ?? msg_server_error}");
        }
      }
    } catch (e, s) {
      debugPrint(s.toString());
      debugPrint(e.toString());
      if (e is SocketException) {
        retryCount++;
        if (retryCount <= 2) {
          return Future.delayed(const Duration(seconds: 3)).then((value) =>
              request(router: router, target: target, isCache: isCache));
        } else {
          return ServerResponse(code: 500, message: e.message);
        }
      }
      return ServerResponse(code: 500, message: e.toString());
    }
  }

  @override
  Future<ServerResponseArray<T>> requestArray<T>({required ApiRouter router, required T Function(Map<String, dynamic> json)? target, bool isCache = false, Function(List<T>? datas)? cacheDataCallback}) async {
    try {
      bool newData = false;
      //load cache data
      if (cacheDataCallback != null) {
        cacheManager.getCacheResponseArray<T>(router.cacheUrl, target).then((value) {
          if (!newData && value?.datas != null && value?.datas.isNotEmpty == true) {
            cacheDataCallback(value?.datas);
          }
        });
      }

      final response = await _request(router);
      if (response.statusCode == 404) {
        return ServerResponseArray(code: 404, message: msg_api_notfound);
      } else if (response.statusCode == 503) {
        return ServerResponseArray(code: 503, message: '503 Service Temporarily Unavailable');
      } else if (response.statusCode == 504) {
        return ServerResponseArray(code: 504, message: '504 Gateway Timeout ERROR');
      } else if (response.statusCode == 401 ) {
        //token expired
        //unauthorized token
        if (_handleService.isLoggedIn) {
          if (_refreshTokenLoading) { //nếu đang refesh token thì request lại sau 3 giây
            await Future.delayed(const Duration(seconds: 3));
            return requestArray(router: router, target: target, isCache: isCache);
          } else {
            bool refreshSuccess = await _refreshToken();
            if (refreshSuccess) {
              // if refresh token success call request again
              return await requestArray(
                  router: router, target: target, isCache: isCache);
            }
          }
          await _handleService.processExpiredToken();
          return ServerResponseArray(code: 401, message: "");
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300 && response.body.isNotEmpty) {
        Map<String, dynamic>? json = jsonDecode(response.body);
        final serverResponse = ServerResponseArray.parseJson(json, target);
        if (isCache) {
          cacheManager.cacheData(response.body, router.cacheUrl);
        }
        newData = true;
        retryCount = 0;
        return serverResponse;
      } else {
        if (response.body.isNotEmpty) {
          Map<String, dynamic>? json = jsonDecode(response.body);
          final statusCode = json?['status_code'] ?? json?['statusCode'] ?? response.statusCode;
          final errorCode = json?['error_code'] ?? json?['errorCode'] ?? 0;
          final msg = _handleService.errorMessage(statusCode, errorCode) ?? json?["Message"] ?? json?["error_message"] ?? json?["errorMessage"] ?? json?["message"] ?? msg_server_error;
          return ServerResponseArray(code: response.statusCode, message: msg);
        } else {
          return ServerResponseArray(code: response.statusCode, message: "${response.reasonPhrase ?? msg_server_error}: ${response.reasonPhrase ?? msg_server_error}");
        }
      }
    } catch (e, s) {
      debugPrint(s.toString());
      if (e is SocketException) {
        retryCount++;
        if (retryCount <= 2) {
          return Future.delayed(const Duration(seconds: 3)).then((value) =>
              requestArray(router: router, target: target, isCache: isCache));
        } else {
          return ServerResponseArray(code: 500, message: e.message);
        }
      }
      return ServerResponseArray(code: 500, message: e.toString());
    }
  }


  ///
  /// implement refresh token
  ///
  Future<bool> _refreshToken() async {
    final inSeconds = DateTime.now().difference(_refreshTokenTime).inSeconds;
    debugPrint("refreshToken inSeconds: $inSeconds");
    if (inSeconds < 30) {
      return false;
    }
    try {
      _refreshTokenLoading = true;
      final response = await _request(_handleService.refreshTokenApi);
      _refreshTokenLoading = false;
      _refreshTokenTime = DateTime.now();
      if (response.statusCode == 200) {
        Map<String, dynamic>? json = jsonDecode(response.body);
        if (json != null) {
          return _handleService.onRefreshTokenCompleted(json);
        }
      }

    } catch(e) {
      return false;
    }
    return false;
  }


  Future<Response> _request(ApiRouter api) async {
    final connectivityStatus = await isConnectedNetWork();
    if (!connectivityStatus) {
      throw AppException(msg_network_notfound);
    }
    if (api.isUpload) { //xử lý upload file
      return _upload(api);
    }
    final client = Client();
    final url = api.path.startsWith("http") ? api.path : rootUrl + api.path;
    final method = api.method;
    final params = api.params;
    debugPrint("URL = ${method.name}: $url");
    debugPrint("params: $params");
    final headers = await _handleService.requestHeaders();
    debugPrint("header: $headers");
    LogApiModel logApiModel = LogApiModel(params: jsonEncode(params), header: jsonEncode(headers));
    logApiModel.url = "${method.name} $url";
    MemoryCached.instance.addApiLog(logApiModel);
    //log response =============================================================================
    Response response;
    try {
      switch (method) {
        case Method.post: {
          response = await client
              .post(Uri.parse(url),
              headers: headers, body: jsonEncode(params));
          break;
        }
        case Method.put: {
          response = await client
              .put(Uri.parse(url),
              headers: headers, body: jsonEncode(params));
          break;
        }
        case Method.delete: {
          final request = url + api.queryParam;
          response = await client
              .delete(Uri.parse(request), headers: headers);
          break;
        }
        default: { //default request with method get
          final request = url + api.queryParam;
          debugPrint("URL = ${method.name}: $request");
          response = await client
              .get(Uri.parse(request), headers: headers);
          break;
        }
      }
      debugPrint("status code: ${response.statusCode} - ${method.name}: ${api.path}");
      debugPrint("response: ${response.body}");

      logApiModel.statusCode = response.statusCode;
      if (response.body.isEmpty) {
        logApiModel.response = response.reasonPhrase ?? response.body;
      } else {
        logApiModel.response = response.body.toString();
      }
      return response;
    } catch (e, s) {
      logApiModel.response = e.toString();
      debugPrint("error: ${s.toString()}");
      debugPrint("error: ${e.toString()}");
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<Response> _upload(ApiRouter api) async {
    LogApiModel logApiModel = LogApiModel();
    try {
      final url = api.path.startsWith("http") ? api.path : rootUrl + api.path;
      logApiModel.url = "${api.method.name} $url";
      final request = MultipartRequest(api.method.name.toUpperCase(), Uri.parse(url));
      final uploadFiles = api.files;
      if (uploadFiles != null && uploadFiles.isNotEmpty) {
        for (var key in uploadFiles.keys) {
          final files = uploadFiles[key];
          if (files != null) {
            for (var file in files) {
              var fileUpload = file;
              if (api.resizeImage) {
                ImageProperties properties = await FlutterNativeImage.getImageProperties(file.path);
                final width = (properties.width ?? 0);
                final height = (properties.height ?? 0);
                int maxWidth = 1000;
                if (width > maxWidth) {
                  fileUpload = await FlutterNativeImage.compressImage(file.path,
                      quality: 90,
                      targetWidth: maxWidth,
                      targetHeight: (height * maxWidth / width).round());
                }
              }
              request.files.add(MultipartFile(
                  key, fileUpload.readAsBytes().asStream(), fileUpload.lengthSync(),
                  filename: fileUpload.path.split("/").last));
            }
          }
        }
      }

      //add header
      final headers = await _handleService.requestHeaders();
      headers.forEach((key, value) {
        request.headers[key] = value;
      });

      //add params
      final params = api.params;
      if (params != null) {
        params.forEach((key, value) {
          if (value != null) {
            request.fields[key] = value.toString();
          }
        });
      }

      //add log ======================================
      logApiModel.params = jsonEncode(params);
      logApiModel.header = jsonEncode(request.headers);
      MemoryCached.instance.addApiLog(logApiModel);

      debugPrint("URL ${api.method.name}: $url");
      debugPrint("params: $params");
      debugPrint("upload files: ${request.files}");
      debugPrint("header upload: ${request.headers}");
      //log response =============================================================================
      var streamedResponse = await request.send();
      var response = await Response.fromStream(streamedResponse);
      debugPrint("status code: ${response.statusCode} - ${api.method.name}: ${api.path}");
      debugPrint("response upload: ${response.body}");
      logApiModel.statusCode = response.statusCode;
      if (response.body.isEmpty) {
        logApiModel.response = response.reasonPhrase ?? response.body;
      } else {
        logApiModel.response = response.body.toString();
      }
      return response;
    } catch (e, s) {
      logApiModel.response = e.toString();
      debugPrint("error: ${s.toString()}");
      debugPrint("error: ${e.toString()}");
      rethrow;
    }
  }

}