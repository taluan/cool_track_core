
//Success Function return data
import 'package:flutter/cupertino.dart';

import '../utils/helper_utils.dart';

typedef SuccessHandler<T> = Function(T? data);
//Error Function return Error code and message
typedef ErrorHandler = Function(int code, String msg);

class ServerResponse<T> {
  final int code;
  final int errorCode;
  final String message;
  final T? data;
  Future<bool> onCompleted({required SuccessHandler<T> success, ErrorHandler? error}) async {
    if (code >= 200 && code < 300) {
      await success(data);
      if (data is bool) {
        return data as bool;
      }
      return true;
    } else if (error != null) {
      await error(code, message);
    }
    return false;
  }

  ServerResponse(
      {required this.code, this.errorCode = 0, required this.message, this.data});

  factory ServerResponse.parseJson(json, T Function(Map<String, dynamic>)? instance) {
    try {
      var code = json["statusCode"] ?? json["status_code"] ?? json["error_code"] ?? 0;
      var errorCode = json["errorCode"] ?? 0;
      var msg = json["error_message"] ?? json["errorMessage"] ?? json["message"] ?? "";
      var data = json['data'];
      if (instance != null && data != null) {
        if (data is Map<String, dynamic>) {
          return ServerResponse(
              code: code,
              errorCode: errorCode,
              message: msg,
              data: (data.isNotEmpty ? instance(data) : null));
        } else {
          return ServerResponse(
              code: 500,
              errorCode: errorCode,
              message: "Kiểu dữ liệu không đúng: ${data.toString()}",
              data: null);
        }
      } else {
        return ServerResponse(
            code: code,
            errorCode: errorCode, message: msg, data: data);
      }
    } catch (e, s) {
      debugPrint(s.toString());
      return ServerResponse(
          code: 500,
          message:
          "Parse object ${instance?.runtimeType} error: ${e.toString()}",
          data: null);
    }

  }
}

class PaginationModel {
  int totalRows = 0;
  int pageIndex = 0;
  int pageSize = 0;
  int totalPage = 0;

  PaginationModel();

  PaginationModel.fromJson(Map<String, dynamic> json) {
    totalRows = parseInt(json['totalRows']);
    pageIndex = parseInt(json['pageIndex']);
    pageSize = parseInt(json['pageSize']);
    totalPage = parseInt(json['totalPage']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalRows'] = totalRows;
    data['pageIndex'] = pageIndex;
    data['pageSize'] = pageSize;
    data['totalPage'] = totalPage;
    return data;
  }
}


class ServerResponseArray<T> {
  final int code;
  final int errorCode;
  final String message;
  final List<T> datas;
  final PaginationModel? pagination;

  Future<bool> onCompleted(
      {required Function(List<T>) success, ErrorHandler? error}) async {
    if (code >= 200 && code < 300) {
      await success(datas);
      return true;
    } else if (error != null) {
      await error(code, message);
    }
    return false;
  }

  ServerResponseArray(
      {required this.code, this.errorCode = 0,
        required this.message,
        this.datas = const [], this.pagination});

  factory ServerResponseArray.parseJson(
      json, T Function(Map<String, dynamic>)? instance) {
    var code = json["statusCode"] ?? json["status_code"] ?? json["error_code"] ?? 0;
    var errorCode = json["errorCode"] ?? 0;
    var msg = json["errorMessage"] ?? json["message"] ?? "";
    final data = json['data'];
    try {
      if (instance != null) {
        if (data != null && data is List<dynamic>) {
          final datas = listJsonToListObject(
              data, instance); //target.arrayFromJson(result);
          return ServerResponseArray(
              code: code,
              errorCode: errorCode,  message: msg, datas: datas, pagination: json["pagination"] != null ? PaginationModel.fromJson(json["pagination"]) : null);
        } else if (data is Map<String, dynamic>) {
          final items = data["items"];
          return ServerResponseArray(
            code: code,
              errorCode: errorCode,
            message: msg,
            datas: (items is List<dynamic>
                ? listJsonToListObject(items, instance)
                : listJsonToListObject([], instance)), pagination: json["pagination"] != null ? PaginationModel.fromJson(json["pagination"]) : null
          );
        } else {
          return ServerResponseArray(
            code: code,
            errorCode: errorCode,
            message: msg,
            datas: listJsonToListObject([], instance),
          );
        }
      } else {
        return ServerResponseArray(
          code: code,
            errorCode: errorCode,
          message: msg,
          datas: data is List<dynamic> ? data : data["Items"],
            pagination: json["pagination"] != null ? PaginationModel.fromJson(json["pagination"]) : null
        );
      }
    } catch (e, s) {
      debugPrint(s.toString());
      return ServerResponseArray(
          code: 500, message: "Parse object ${instance.runtimeType} error: ${e.toString()}", datas: []);
    }
  }
}