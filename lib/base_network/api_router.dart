import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import '../utils/helper_utils.dart';

enum Method { post, put, patch, get, delete }

String? createQuery(String column, {String? value, String compareOperator = "contains", String operator = "or"}) {
  if (value != null && value.isNotEmpty) {
    final columns = column.split(",");
    if (columns.length == 1) {
      return "[\"${column.trim()}\",\"$compareOperator\",\"$value\"]";
    }
    return "[${columns.map((e) => "[\"${e.trim()}\",\"$compareOperator\",\"$value\"]").join(",\"$operator\",")}]";
  }
  return null;
}

String? joinFilter(List<String?> queries, {String operator = "and"}) {
  queries = queries..removeWhere((e) => e == null || e == "");
  if (queries.isNotEmpty) {
    if (queries.length == 1) {
      return queries.first ?? "";
    }
    return "[${queries.join(",\"$operator\",")}]";
  }
  return null;
}

abstract class ApiRouter {

  final String path;
  final Method method;
  Object? _params;
  final Map<String, List<File>?>? files;
  final bool resizeImage;

  ApiRouter(
      {required this.path,
        this.method = Method.post,
        Object? params,
        this.files,
        this.resizeImage = false}) {
    if (params is Map) {
      Map<String, dynamic>? mapParam = params as Map<String, dynamic>?;
      mapParam?.removeWhere((key, value) => value == null);
      _params = mapParam;
    } else {
      _params = params;
    }

  }

  Object? get params => _params;
  Map<String, dynamic>? get mapParam => params as Map<String, dynamic>?;
  bool get isUpload => files?.isNotEmpty == true;

  String get queryParam {
    Map<String, dynamic>? mapParam = params as Map<String, dynamic>?;
    // mapParam?.removeWhere((key, value) => value == null || value == "");
    if (mapParam != null && mapParam.isNotEmpty) {
      final queryMap = <String, dynamic>{};
      mapParam.forEach((key, value) {
        if (value is List) {
          queryMap[key] = value; // giữ nguyên list
        } else {
          queryMap[key] = value.toString();
        }
      });
      return "?${Uri(queryParameters: queryMap).query}";
    }
    return "";
  }

  String get cacheUrl {
    return encodeBase64String("$path$queryParam");
  }


}