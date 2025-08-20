class ChatActionModel {
  String? senderId;
  Map<String, dynamic>? data;
  int? action;

  ChatActionModel.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
    data = json['data'];
    action = json['action'];
  }
}