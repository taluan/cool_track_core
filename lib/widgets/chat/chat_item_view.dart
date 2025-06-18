import 'package:base_code_flutter/base_core.dart';
import 'package:base_code_flutter/utils/app_routes.dart';
import 'package:base_code_flutter/widgets/photos/widget_photo_viewer.dart';
import 'package:base_code_flutter/widgets/widget_network_image.dart';
import 'package:flutter/material.dart';

import '../../model/message/chat_model.dart';
import '../../pages/webview/webview_page.dart';

class ChatItemView extends StatelessWidget {
  final ChatModel chat;
  final bool isSender;
  final bool seen;
  const ChatItemView({super.key, required this.chat, this.isSender = true, this.seen = false});


  @override
  Widget build(BuildContext context) {
    const receiverColor = Color(0xffe5e5ea);
    const senderColor = Color(0xff3fb1fb);
    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          color: isSender ? senderColor : receiverColor,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(maxWidth: screenUtil.screenWidth * .8),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            chatContent(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                Text(chat.sentTime, style: TextStyle(color: isSender ? Colors.white70 : Colors.black54, fontSize: 10.5),),
                if (isSender)
                  Image.asset("assets/images/seen_icon.png", width: 14, color: seen ? Color(0xFF0266A8) : Colors.white38)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget chatContent(BuildContext context) {
    if (chat.messageType == MessageType.image && chat.file != null) {
      return InkWell(
          onTap: () {
            AppRoutes.push(context, PhotoViewerWidget(lsUrl: [chat.file?.path ?? ""]));
          },
          child: RoundedImage(url: chat.file?.path, width: 150, height: 150, image: const Icon(Icons.error_outline_rounded, color: Colors.red,), borderWidth: 0,));
    } else if (chat.messageType == MessageType.file && chat.file != null) {
      return InkWell(
        onTap: () {
          AppRoutes.push(context, WebviewPage(url: chat.file!.path, title: chat.file!.name,));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white24
          ),
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              Icon(Icons.file_present_rounded, color: isSender ? Colors.white : Colors.black87, size: 30,),
              const SizedBox(width: 5,),
              Expanded(child: Text("[File] ${chat.file?.name}", style: TextStyle(color: isSender ? Colors.white : Colors.black87, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis,))
            ],
          ),
        ),
      );
    }
    return Text(chat.content, style: TextStyle(color: isSender ? Colors.white : Colors.black87, fontSize: 15),);
  }
}