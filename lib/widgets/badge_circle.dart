import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/material.dart';

class BadgeCircle extends StatelessWidget {
  final int count;
  final double scale;
  final Color? textColor;
  final Color? backgroundColor;

  const BadgeCircle({super.key, this.count = 0, this.scale = 1, this.textColor = Colors.white, this.backgroundColor = Colors.red});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: sizeForScale(scale),
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
            const BorderRadius.all(Radius.circular(12.0)),
            color: backgroundColor,
            // gradient: backgroundColor != null ? null : const LinearGradient(
            //     colors: [
            //       Colors.deepOrange,
            //       Colors.orange,
            //       Colors.orangeAccent
            //     ]
            // ),
            border: Border.all(width: 1.0, color: Colors.white),
          ),
          constraints:
          const BoxConstraints(minWidth: 22, minHeight: 22, maxHeight: 22),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          alignment: Alignment.center,
          child: Text(
            count < 100 ? count.toString() : "99+",
            style: TextStyle(color: textColor, fontSize: 13, height: 1.2, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
