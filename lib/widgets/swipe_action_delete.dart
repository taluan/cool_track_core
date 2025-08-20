import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

class SwipeActionDeleteCell extends StatelessWidget {
  final Key key;
  final Widget child;
  final bool isDraggable;
  final Widget? actionIcon;
  final int? index;
  final SwipeActionOnTapCallback onTap;
  const SwipeActionDeleteCell({required this.key, required this.child, this.isDraggable = true, required this.onTap, this.actionIcon, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
        backgroundColor: Colors.transparent,
        index: index,
        isDraggable: isDraggable,
        key: key,
        trailingActions: [
          SwipeAction(
              color: Colors.redAccent,
              content: actionIcon ?? Icon(Icons.delete_rounded, color: Colors.white, size: 26,),
              onTap: onTap),
        ],
      child: child,
    );
  }
}

