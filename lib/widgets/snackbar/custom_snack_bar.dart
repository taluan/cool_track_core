import 'dart:math';

import 'package:flutter/material.dart';

/// Popup widget that you can use by default to show some information
class CustomSnackBar extends StatefulWidget {
  const CustomSnackBar.success({
    Key? key,
    required this.message,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 12),
    this.icon = const Icon(Icons.check_circle_rounded, color: Colors.green,),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: Colors.black87,
    ),
    this.maxLines = 3,
    this.iconPositionLeft = 12,
    this.backgroundColor = const Color(0xffEAF6ED),
    this.borderRadius = kDefaultBorderRadius,
    this.boxShadow,
    this.border,
    this.textScaleFactor = 1.0,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  const CustomSnackBar.info({
    Key? key,
    required this.message,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.info_outline_rounded,
      color: Colors.blue,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: Colors.black87,
    ),
    this.maxLines = 2,
    this.iconPositionLeft = 12,
    this.backgroundColor = const Color(0xff2196F3),
    this.boxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.border,
    this.textScaleFactor = 1.0,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  const CustomSnackBar.error({
    Key? key,
    required this.message,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.error_outline,
      color: Colors.redAccent,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: Colors.black87,
    ),
    this.maxLines = 2,
    this.iconPositionLeft = 12,
    this.backgroundColor = const Color(0xffff5252),
    this.boxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.border,
    this.textScaleFactor = 1.0,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  final String message;
  final Widget icon;
  final Color backgroundColor;
  final TextStyle textStyle;
  final int maxLines;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final BorderRadius borderRadius;
  final double iconPositionLeft;
  final EdgeInsetsGeometry messagePadding;
  final double textScaleFactor;
  final TextAlign textAlign;

  @override
  CustomSnackBarState createState() => CustomSnackBarState();
}

class CustomSnackBarState extends State<CustomSnackBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        border: widget.border,
        boxShadow: widget.boxShadow,
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(width: widget.iconPositionLeft,),
          widget.icon,
          Expanded(
            child: Padding(
              padding: widget.messagePadding,
              child: Text(
                widget.message,
                style: theme.textTheme.bodyMedium?.merge(widget.textStyle),
                textAlign: widget.textAlign,
                overflow: TextOverflow.ellipsis,
                maxLines: widget.maxLines,
                textScaleFactor: widget.textScaleFactor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// const kDefaultBoxShadow = [
//   BoxShadow(
//     color: Colors.black26,
//     offset: Offset(0, 8),
//     spreadRadius: 1,
//     blurRadius: 30,
//   ),
// ];

const kDefaultBorderRadius = BorderRadius.all(Radius.circular(12));
