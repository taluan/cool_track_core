
//Success Function return data
import 'package:flutter/cupertino.dart';

import '../utils/helper_utils.dart';

typedef SuccessHandler<T> = Function(T? data);
//Error Function return Error code and message
typedef ErrorHandler = Function(int, String?);

List<T> listJsonToListObject<T>(
    List<dynamic>? listItem, T Function(Map<String, dynamic>) instance) {
  if (listItem == null) {
    return [];
  }
  return listItem.map((e) => instance(e)).toList();
}

abstract class BaseServerResponse<T> {
  late final bool success;
  late final int errorCode;
  late final String? message;
  late final T? data;
  bool get isSuccess => success;

  BaseServerResponse({this.success = false, this.errorCode = 0, required this.message, this.data});

  Future<bool> onCompleted({required SuccessHandler<T> success, ErrorHandler? error}) async {
    if (isSuccess) {
      await success(data);
      if (data is bool) {
        return data as bool;
      }
      return true;
    } else if (error != null) {
      await error(errorCode, message);
    }
    return false;
  }

  Future<void> onError(ErrorHandler error) async {
    await error(errorCode, message);
  }
}

class ServerResponse<T> extends BaseServerResponse<T> {

  ServerResponse(
      {super.success = false, super.errorCode = 0, required super.message, super.data});

  factory ServerResponse.parseJson(json, T Function(Map<String, dynamic>)? instance) {
    try {
      final success = json["Success"] ?? false;
      final errorCode = json["ErrorCode"] ?? 0;
      final msg = json["UserMessage"] ?? json["DevMessage"];
      final data = json['Data'];
      if (instance != null && data != null) {
        if (data is Map<String, dynamic>) {
          return ServerResponse(
              success: success,
              errorCode: errorCode,
              message: msg,
              data: (data.isNotEmpty ? instance(data) : null));
        } else {
          return ServerResponse(
              success: success,
              errorCode: errorCode,
              message: msg ?? "Kiểu dữ liệu không đúng: ${data.toString()}",
              data: null);
        }
      } else {
        return ServerResponse(
            success: false,
            errorCode: errorCode, message: msg, data: data);
      }
    } catch (e, s) {
      debugPrint(s.toString());
      return ServerResponse(
          success: false,
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


class ServerResponseArray<T> extends BaseServerResponse<List<T>> {

  List<T> get datas => data ?? [];
  final PaginationModel? pagination;

  ServerResponseArray(
      {super.success = false, super.errorCode = 0,
        required super.message,
        super.data = const [], this.pagination});

  factory ServerResponseArray.parseJson(
      json, T Function(Map<String, dynamic>)? instance) {

    final success = json["Success"] ?? true;
    final errorCode = json["ErrorCode"] ?? 0;
    final msg = json["UserMessage"] ?? json["DevMessage"];
    final data = json['Data'];
    try {
      if (instance != null) {
        if (data != null && data is List<dynamic>) {
          final datas = listJsonToListObject(
              data, instance); //target.arrayFromJson(result);
          return ServerResponseArray(
              success: success,
              errorCode: errorCode,  message: msg, data: datas, pagination: json["pagination"] != null ? PaginationModel.fromJson(json["pagination"]) : null);
        } else if (data is Map<String, dynamic>) {
          final items = data["items"];
          return ServerResponseArray(
              success: success,
              errorCode: errorCode,
            message: msg,
            data: (items is List<dynamic>
                ? listJsonToListObject(items, instance)
                : listJsonToListObject([], instance)), pagination: json["pagination"] != null ? PaginationModel.fromJson(json["pagination"]) : null
          );
        } else {
          return ServerResponseArray(
            success: success,
            errorCode: errorCode,
            message: msg,
            data: listJsonToListObject([], instance),
          );
        }
      } else {
        return ServerResponseArray(
            success: success,
            errorCode: errorCode,
          message: msg,
          data: data is List<dynamic> ? data : data["Items"],
            pagination: json["pagination"] != null ? PaginationModel.fromJson(json["pagination"]) : null
        );
      }
    } catch (e, s) {
      debugPrint(s.toString());
      return ServerResponseArray(
          errorCode: 500, message: "Parse object ${instance.runtimeType} error: ${e.toString()}", data: []);
    }
  }
}