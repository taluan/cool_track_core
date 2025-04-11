
import 'package:base_code_flutter/widgets/textfields/title_label_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_const.dart';

class RoundedTextField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final bool readOnly;
  final bool autofocus;
  final bool required;
  final Color? backgroundColor;
  final InputBorder? focusedBorder;
  final int? minLines;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool enabled;
  final TextCapitalization? textCapitalization;
  final BoxConstraints? suffixIconConstraints;
  final int? maxLength;
  final GestureTapCallback? onTap;
  const RoundedTextField(
      {super.key,
      this.initialValue,
      this.hintText,
      this.labelText,
      this.prefixIcon,
      this.textInputType,
      this.inputFormatters,
      this.required = false,
      this.readOnly = false,
      this.autofocus = false,
      this.backgroundColor,
      this.focusedBorder,
      this.onChanged,
      this.controller,
      this.suffixIcon,
      this.validator,
      this.obscureText,
      this.minLines,
      this.maxLines = 1,
      this.textStyle,
      this.labelStyle,
      this.hintStyle,
      this.margin,
      this.padding,
      this.textAlign,
      this.textCapitalization,
      this.suffixIconConstraints,
      this.maxLength,
      this.enabled = true,
      this.onTap,});

  @override
  Widget build(BuildContext context) {
    final placeHolder = hintText ?? (labelText != null ? 'Nhập ${labelText!.toLowerCase()}' : null);
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if ((labelText ?? '').isNotEmpty)
            TitleLabelText(labelText: labelText, labelStyle: labelStyle, required: required,),
          TextFormField(
            textAlign: textAlign ?? TextAlign.start,
            initialValue: initialValue,
            keyboardType: textInputType,
            inputFormatters: inputFormatters,
            controller: controller,
            validator: validator ?? (required ? (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng điền thông tin bắt buộc';
              }
            } : null),
            obscureText: obscureText ?? false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            readOnly: readOnly,
            minLines: minLines,
            maxLines:
                obscureText == true ? 1 : (minLines != null ? maxLines : 1),
            autocorrect: false,
            autofocus: autofocus,
            enabled: enabled,
            maxLength: maxLength,
            onTap: onTap,
            style: textStyle,
            buildCounter: (context,
                {required currentLength, required isFocused, maxLength}) {
              return maxLength == null
                  ? null
                  : Container(
                      transform: Matrix4.translationValues(0, -5, 0),
                      child: Text("$currentLength/$maxLength"),
                    );
            },
            textCapitalization: textCapitalization ??
                (obscureText == true
                    ? TextCapitalization.none
                    : TextCapitalization.sentences),
            decoration: InputDecoration(
              contentPadding: padding ?? const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
              focusedBorder: focusedBorder,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              errorMaxLines: 2,
              isDense: true,
              suffixIconConstraints: suffixIconConstraints,
              hintText: placeHolder,
              hintStyle: hintStyle,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: !enabled ? Colors.grey : (backgroundColor ?? Colors.white),
              focusColor: Colors.white,
              prefixIconConstraints: const BoxConstraints(maxHeight: 48),
            ),
            onChanged: onChanged,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}
