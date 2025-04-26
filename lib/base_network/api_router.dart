import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import '../utils/helper_utils.dart';

enum Method { post, put, get, delete }

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