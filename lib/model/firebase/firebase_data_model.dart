import 'dart:convert';

import 'package:flutter/cupertino.dart';


class FirebaseDataModel {
  String itemId = "";
  String? title;
  String screenId = "";
  Map<String, dynamic> customData = {};

  FirebaseDataModel.fromJson(Map<String, dynamic> json) {
    itemId = json["item_id"] ?? "";
    title = json["title"] ?? json["Title"];
    screenId = json["screen_id"] ?? json["ScreenId"] ?? "";
    final data = json["custom_data"];
    try {
      if (data is String) {
        customData = jsonDecode(data) ?? {};
      } else if (data is Map<String, dynamic>) {
        customData = data;
      }
    } catch(e, s){
      debugPrint(s.toString());
    }
  }
}