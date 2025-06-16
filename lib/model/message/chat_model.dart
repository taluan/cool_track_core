
import 'dart:convert';

import 'package:base_code_flutter/utils/helper_utils.dart';

mixin MessageType {
  static const String text = "text";
  static const String image = "image";
  static const String file = "file";
}

class ChatModel {
  String content = "";
  String messagesId = "";
  String senderId = "";
  String chatsId = "";
  DateTime? sentAt;
  String? messageType;
  bool seen = false;
  String? avatar;
  String userFullName = "";
  FileChatModel? file;

  String get sentTime {
    if (sentAt != null) {
      return sentAt?.formatString(dateFormat: "HH:mm") ?? "";
    }
    return "";
  }

  String get formatDateGroup {
    if (sentAt != null) {
      final now = DateTime.now();
      if (sentAt!.compareDateTo(now) == 0) {
        return "Hôm nay";
      } else if (sentAt!.compareDateTo(now.subtract(const Duration(days: 1))) == 0) {
        return "Hôm qua";
      }
      return sentAt?.formatString() ?? "";
    }
    return "";
  }

  ChatModel({this.content = "", this.messageType, this.sentAt, this.senderId = ""});

  ChatModel.fromJson(Map<String, dynamic> json) {
    content = json['content'] ?? '';
    messagesId = json['messages_id'] ?? '';
    senderId = json['sender_id'] ?? '';
    chatsId = json['chats_id'] ?? '';
    sentAt = convertStringUtcToLocalDate(json['sent_at']);
    messageType = json['message_type'];
    seen = parseBoolean(json['seen']);
    avatar = json['avatar'];
    userFullName = json['user_full_name'] ?? '';
    if (messageType == MessageType.file || messageType == MessageType.image) {
      try {
        file = FileChatModel.fromJson(jsonDecode(content));
      } catch(_) {
        file = FileChatModel(path: content, name: content);
      }

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['messages_id'] = messagesId;
    data['sender_id'] = senderId;
    data['chats_id'] = chatsId;
    data['sent_at'] = sentAt;
    data['message_type'] = messageType;
    data['seen'] = seen;
    data['avatar'] = avatar;
    data['user_full_name'] = userFullName;
    return data;
  }
}

class FileChatModel {
  String path = "";
  String name = "";

  FileChatModel({this.path = "", this.name = ""});

  FileChatModel.fromJson(Map<String, dynamic> json) {
    path = json['path'] ?? '';
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    data['name'] = name;
    return data;
  }

  String? get toJsonString {
    return jsonEncode(toJson());
  }
}
