import 'package:base_code_flutter/utils/helper_utils.dart';

import '../base_network/base_response.dart';

class PageDataModel<T> {
  int count = 0;
  List<T> items = [];
  PageDataModel.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic> json)? target) {
    count = parseInt(json['Count']);
    if (target != null && json['PageData'] is List) {
      items = listJsonToListObject(json['PageData'], target);
    }
  }
}