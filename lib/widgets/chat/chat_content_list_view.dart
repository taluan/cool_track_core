import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/material.dart';

import '../../model/message/chat_model.dart';
import 'chat_item_view.dart';

class ChatContentListView extends StatelessWidget {
  final List<ChatModel> datas;
  final String? senderId;
  final ScrollController? scrollController;
  const ChatContentListView({super.key, required this.datas, this.senderId, this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (datas.isEmpty) {
      return const SizedBox();
    }
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      reverse: true,
      separatorBuilder: (_, __) => const SizedBox(height: 10,),
      itemCount: datas.length, itemBuilder: (context, index) {
      final chat = datas[index];
      return Column(
        spacing: 5,
        children: [
          if (index == datas.length - 1 || chat.sentAt?.compareDateTo(datas[index + 1].sentAt ?? DateTime.now()) != 0)
            Text(chat.formatDateGroup, style: const TextStyle(color: Colors.grey, fontSize: 12),),
          ChatItemView(chat: chat, isSender: chat.senderId == senderId, seen: chat.seen,)
        ],
      );
    },);
  }
}
