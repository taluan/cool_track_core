import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/material.dart';

import '../../utils/app_const.dart';

class TitleLabelText extends StatelessWidget {
  final TextStyle? labelStyle;
  final String? labelText;
  final bool required;
  final EdgeInsetsGeometry? padding;
  const TitleLabelText({super.key, this.labelStyle, this.labelText, this.required = false, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 8.0, bottom: 6),
      child: Text.rich(
        TextSpan(
          text: labelText ?? '',
          // children: [
          //   if (required == true)
          //     TextSpan(
          //       text: ' *',
          //       style: (labelStyle ?? context.textTheme.titleSmall)?.copyWith(color: Colors.red),
          //     ),
          // ],
          style: labelStyle ?? context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
