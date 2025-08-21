import 'package:flutter/material.dart';

import '../../../utils/app_const.dart';

class SearchBarTextField extends StatelessWidget {
  const SearchBarTextField({super.key,
    this.autofocus = true,
    required this.editingController,
    this.hintText,
    this.margin,
    this.onFieldSubmitted,
    this.onChanged,
    this.onClear,
    this.borderColor,
    this.backgroundColor = Colors.white,
  });

  final bool autofocus;
  final EdgeInsetsGeometry? margin;
  final TextEditingController editingController;
  final String? hintText;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: borderColor ?? Colors.grey, width: 1.0),
    );
    return Container(
      margin: margin ?? const EdgeInsets.only(
        left: 10,
      ),
      child: TextFormField(
        textInputAction: TextInputAction.search,
        autofocus: autofocus,
        autocorrect: false,
        controller: editingController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          hintText: hintText,
          // hintStyle: AppConfig.primaryTextStyle
          //     .copyWith(color: AppColor.placeholderTextColor),
          fillColor: backgroundColor,
          filled: true,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Icon(Icons.search_rounded, size: 26, color: Colors.grey,),
          ),
          isDense: true,
          prefixIconConstraints:const BoxConstraints(maxWidth: 38, maxHeight: 38),
            suffixIconConstraints:const BoxConstraints(maxWidth: 38, maxHeight: 38),
          suffixIcon: ValueListenableBuilder(
              valueListenable: editingController,
              builder: (context, data, widget) {
                return data.text.isEmpty ? const SizedBox() : IconButton(
                // padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                icon: const CircleAvatar(
                    radius: 12, backgroundColor: Color(0xFFE7E8EB),
                    child: Icon(Icons.close, color: Colors.grey, size: 14)),
                onPressed: () {
                  editingController?.clear();
                  if (onClear != null) {
                    onClear!();
                  }
                },
              );
            }
          ),
        ),
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
      ),
    );
  }
}