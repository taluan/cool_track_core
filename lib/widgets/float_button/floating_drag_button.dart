import 'dart:async';

// import 'src/floating_chat_icon.dart';
import 'package:flutter/material.dart';

import '../../base_core.dart';

class FloatingDragButton extends StatefulWidget {
  /// The FloatingChatButton can be stacked on top of another view inside its
  /// parent. This specifies the widget that it should be stacked on top of
  final Widget? child;

  /// Used to specify custom chat icon widget. If not specified, the material chat icon
  /// widget will be used
  final Widget floatIconWidget;

  /// The vertical distance between the chat icon and it's bounds in one of its
  /// default resting spaces
  final double verticalOffset;

  /// The horizontal distance between the chat icon and it's bounds in one of its
  /// default resting spaces
  final double horizontalOffset;

  final Function(BuildContext) onTap;


  FloatingDragButton(
      {this.child,
        required this.floatIconWidget, required this.onTap,
        this.verticalOffset = 30, this.horizontalOffset = 10,
      Key? key})
      : super(key: key);
  @override
  FloatingDragButtonState createState() => FloatingDragButtonState();
}

class FloatingDragButtonState extends State<FloatingDragButton> {
  bool isTop = false;
  bool isRight = true;
  double dy = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void _setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    dy = widget.verticalOffset + 50;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var iconWidget = Material(
            color: Colors.transparent,
            child: FloatingActionButton.small( //<-- SEE HERE
              backgroundColor: Colors.deepOrangeAccent,
              onPressed: () {
                widget.onTap(context);
              },
              child: widget.floatIconWidget,
            ),
          );
      return Stack(children: [
        if (widget.child != null) widget.child!,
        Positioned(
            // bottom: (isTop) ? null : widget.verticalOffset + context.paddingBottom,
            top: dy,
            right: (isRight) ? widget.horizontalOffset : null,
            left: (isRight) ? null : widget.horizontalOffset,
            child: Draggable(
              feedback: iconWidget,
              childWhenDragging: const SizedBox(),
              onDragEnd: (draggableDetails) {
                _setStateIfMounted(() {
                  dy = draggableDetails.offset.dy;
                  final maxY = screenUtil.screenHeight - screenUtil.bottomBarHeight - 50;
                  if (dy < screenUtil.statusBarHeight) {
                    dy = screenUtil.statusBarHeight;
                  } else if (dy > maxY) {
                    dy = maxY;
                  }
                  // print("y: ${dy} - height: ${context.screenSize.height - context.padding.bottom - 50}");
                  // isTop = (draggableDetails.offset.dy <
                  //     (MediaQuery.of(context).size.height) / 2);
                  isRight = (draggableDetails.offset.dx >
                      (MediaQuery.of(context).size.width) / 2);
                });
              },
              child: iconWidget,
            ))
      ]);
    });
    // return
  }
}
