import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/material.dart';

import '../../base_core.dart';
import '../../utils/app_const.dart';

class BottomContainer extends StatelessWidget {
  final Widget child;
  final bool showDivider;
  const BottomContainer({super.key, required this.child, this.showDivider = false});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = context.viewInsets.bottom > screenUtil.bottomBarHeight ? 0 : context.paddingBottom;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: showDivider ? Border(top: BorderSide(color: context.theme.dividerColor, width: 0.5)) : null,
      ),
      // height: context.paddingBottom + AppConst.bottomBarHeight,
      padding: EdgeInsets.only(
          left: 12, top: 12, bottom: bottomPadding + 12, right: 12),
      child: child,
    );
  }
}
