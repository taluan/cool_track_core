import 'package:flutter/material.dart';

import '../../base_core.dart';

class AppbarDefault extends AppBar {
  AppbarDefault(
      {super.key,
      required BuildContext context,
      super.flexibleSpace,
        Widget? titleWidget,
      String? title,
      double? elevation,
        Widget? leading,
      bool enableBackButton = true,
      VoidCallback? onBackAction,
      super.actions,
      PreferredSizeWidget? bottomAppBar})
      : super(
          title: titleWidget ?? Text(
            title?.toUpperCase() ?? "",
            maxLines: 2,
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          titleSpacing: -10,
          elevation: elevation ?? 1,
          scrolledUnderElevation: elevation ?? 1,
          shadowColor: Colors.black12,
          leading: leading ?? (!enableBackButton
              ? const SizedBox()
              : IconButton(
                  onPressed: onBackAction ??
                      () {
                        Navigator.of(context).pop();
                      },
                  icon: Image.asset("assets/images/back_icon.png", width: 26, color: Colors.white,))),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          bottom: bottomAppBar,
        );
}

// class AppbarCustomBackground extends AppBar {
//   AppbarCustomBackground(
//       {super.key,
//       required BuildContext context,
//       String? title,
//       double? elevation,
//       bool enableBackButton = true,
//       VoidCallback? onBackAction,
//       super.actions,
//       PreferredSizeWidget? bottomAppBar})
//       : super(
//           title: Text(
//             title ?? "",
//             maxLines: 2,
//             textAlign: TextAlign.center,
//           ),
//           centerTitle: false,
//           titleSpacing: -5,
//           elevation: elevation ?? 2,
//           scrolledUnderElevation: elevation ?? 2,
//           shadowColor: Colors.black12,
//           flexibleSpace: Assets.images.homeHeader.image(fit: BoxFit.cover, package: packageName),
//           leading: !enableBackButton
//               ? const SizedBox()
//               : IconButton(
//                   onPressed: onBackAction ??
//                       () {
//                         Navigator.of(context).pop();
//                       },
//                   icon: Assets.images.backButton
//                       .image(width: 26, color: Colors.white)),
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           surfaceTintColor: Theme.of(context).colorScheme.primary,
//           titleTextStyle: AppBarTheme.of(context).titleTextStyle?.copyWith(color: Colors.white),
//           bottom: bottomAppBar,
//         );
// }
