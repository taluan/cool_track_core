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

String joinFilter(List<String?> queries, {String operator = "and"}) {
  queries = queries..removeWhere((e) => e == null || e == "");
  if (queries.isNotEmpty) {
    if (queries.length == 1) {
      return queries.first ?? "";
    }
    return "[${queries.join(",\"$operator\",")}]";
  }
  return "";
}

abstract class ApiRouter {

  final String path;
  final Method method;
  Map<String, dynamic>? _params;
  final Map<String, List<File>?>? files;
  final bool resizeImage;

  ApiRouter(
      {required this.path,
        this.method = Method.post,
        Map<String, dynamic>? params,
        this.files,
        this.resizeImage = false}) {
    _params = params?..removeWhere((key, value) => value == null);
  }

  Map<String, dynamic>? get params => _params;
  bool get isUpload => files?.isNotEmpty == true;

  String get queryParam {
    if (params != null && params!.isNotEmpty) {
      final queryMap = <String, dynamic>{};
      params!.forEach((key, value) {
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