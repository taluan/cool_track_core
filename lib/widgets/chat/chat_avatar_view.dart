import 'package:base_code_flutter/widgets/widget_network_image.dart';
import 'package:flutter/material.dart';

class ChatAvatarView extends StatelessWidget {
  final String? avatar;
  final String? avatarName;
  final double size;
  final List<BoxShadow>? boxShadow;
  const ChatAvatarView({super.key, this.avatar, this.avatarName, this.size = 40, this.boxShadow});

  @override
  Widget build(BuildContext context) {
    return CircleImage(
      image: Container(
        color: const Color(0xffc5c4c4),
        alignment: Alignment.center,
        child: Text(avatarName ?? "", style: TextStyle(color: Colors.white, fontSize: size/2.5, fontWeight: FontWeight.w600),),
      ),
      url: avatar,
      size: size,
      boxShadow: boxShadow,
    );
  }
}
