import 'package:base_code_flutter/utils/app_const.dart';
import 'package:base_code_flutter/utils/helper_utils.dart';

import 'chat_model.dart';

class MessageModel {
  String firstPersonName = "";
  String? avatar;
  String secondPersonName = "";
  DateTime? lastMessageAt;
  String lastMessage = "";
  String messageType = "";
  String chatsId = "";
  String status = "";
  String statusName = "";
  String customerId = "";
  String _avatarName = "";

  String get avatarName => _avatarName;

  String getInitials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      // Nếu chỉ có 1 từ: lấy 2 ký tự đầu
      return parts[0].substring(0, 2).toUpperCase();
    }

    final first = parts.first.substring(0, 1);
    final last = parts.last.substring(0, 1);
    return (first + last).toUpperCase();
  }

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
    secondPersonName = json['second_person_name'] ?? '';
    lastMessageAt = convertStringUtcToLocalDate(json['last_message_at']);
    lastMessage = json['last_message'] ?? '';
    messageType = json['message_type'] ?? '';
    status = json['status'] ?? '';
    statusName = json['status_name'] ?? '';
    chatsId = json['chats_id'] ?? '';
    customerId = json['customer_id'] ?? '';
    _avatarName = getInitials(firstPersonName);
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
