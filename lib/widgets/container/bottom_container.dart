import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/material.dart';

import '../../utils/app_const.dart';

class BottomContainer extends StatelessWidget {
  final Widget child;
  const BottomContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // height: context.paddingBottom + AppConst.bottomBarHeight,
      padding: EdgeInsets.only(
          left: 12, top: 12, bottom: context.paddingBottom + 12, right: 12),
      child: child,
    );
  }
}
