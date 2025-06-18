import 'dart:ui';

import 'package:base_code_flutter/utils/app_const.dart';
import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/material.dart';

import 'chat_model.dart';

class MessageModel {
  String firstPersonName = "";
  String? avatar;
  String? secondPersonName;
  DateTime? lastMessageAt;
  String lastMessage = "";
  String messageType = "";
  String chatsId = "";
  String status = "";
  String statusName = "";
  String customerId = "";
  String _avatarName = "";
  int unreadCount = 0;

  bool get isRead => unreadCount == 0;

  String get avatarName => _avatarName;

  String get lastTimeFormat {
    if (lastMessageAt != null) {
      final now = DateTime.now();
      if (lastMessageAt!.compareDateTo(now) == 0) {
        return lastMessageAt?.formatString(dateFormat: AppConst.timeFormat) ?? "";
      } else if (lastMessageAt!.compareDateTo(now.subtract(const Duration(days: 1))) == 0) {
        return "Hôm qua";
      }
      return lastMessageAt?.formatString(dateFormat: AppConst.dateTimeFormat) ?? "";
    }
    return "";
  }


  MessageModel();

  MessageModel.fromJson(Map<String, dynamic> json) {
    firstPersonName = json['first_person_name'] ?? '';
    avatar = json['avatar'];
    secondPersonName = json['second_person_name'];
    lastMessageAt = convertStringUtcToLocalDate(json['last_message_at']);
    lastMessage = json['last_message'] ?? '';
    messageType = json['message_type'] ?? '';
    status = json['status'] ?? '';
    statusName = json['status_name'] ?? '';
    chatsId = json['chats_id'] ?? '';
    customerId = json['customer_id'] ?? '';
    unreadCount = parseInt(json["UnreadCount"] ?? json["unread_count"]);
    _avatarName = getInitialsAvatarName(firstPersonName);
    if (messageType == MessageType.file || messageType == MessageType.image) {
      lastMessage = messageType;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_person_name'] = firstPersonName;
    data['second_person_name'] = secondPersonName;
    data['last_message_at'] = lastMessageAt;
    data['last_message'] = lastMessage;
    data['status_name'] = statusName;
    data['chats_id'] = chatsId;
    return data;
  }
}

mixin MessageStatus {
  static const String chuaXuLy = "ChuaXuLy";
  static const String dangXuLy = "DangXuLy";
  static const String daDong = "DaDong";

  static Color getColorFromStatus(String? status) {
    if (status == daDong) {
      return Colors.grey;
    } else if (status == dangXuLy) {
      return const Color(0xffff8400);
    }
    return const Color(0xffe0e0e0);

  }
}