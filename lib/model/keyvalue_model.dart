

import 'package:base_code_flutter/utils/helper_utils.dart';

abstract class KeyValueObject {
  late String id;
  late String title;
  late String value;
  late String key;

  KeyValueObject(
      {this.id = "", this.title = "", this.value = "", this.key = "",}) {
    if (key.isEmpty && id.isNotEmpty) {
      key = id;
    } else if (key.isEmpty && value.isNotEmpty){
      key = value;
    }
  }

  int get intValue {
    return parseInt(value);
  }

  int get intId {
    return parseInt(id);
  }

  String get name => title;
  String get titleDisplay => title;

  String get hashKey {
    if (id.isNotEmpty) {
      return id;
    } else if (key.isNotEmpty || value.isNotEmpty) {
      return "${key}_$value";
    }
    return title;
  }

  @override
  String toString() {
    return title;
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          (other is KeyValueObject && other.hashKey == hashKey);


  @override
  int get hashCode => id.hashCode;
}

class KeyValueModel extends KeyValueObject {

  int count = 0;
  String? thumbnail;

  KeyValueModel(
      {super.id, super.title, super.value, super.key, this.count = 0, this.thumbnail});

  KeyValueModel.fromJson(Map<String, dynamic> json) {
    id = parseString(json["id"]);
    value = parseString(json["value"]);
    title = json["title"] ??  json["name"] ?? value;
    key = json["key"] ?? json["code"] ?? json["id"] ?? title;
    thumbnail = json['thumbnail'] ?? json['icon'];
    count = parseInt(json['count']);
  }


}