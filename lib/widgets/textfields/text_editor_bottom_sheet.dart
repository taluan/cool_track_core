import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/material.dart';

import '../../utils/app_const.dart';

class TextEditorBottomSheet extends StatefulWidget {
  final String labelText;
  final String text;
  final BuildContext? context;
  final int? maxLength;
  final int? minLength;
  final bool required;
  const TextEditorBottomSheet({super.key, required this.labelText, required this.text, this.context, this.maxLength, this.minLength, this.required = false});

  static Future<dynamic>? show({
    required BuildContext context,
    required String labelText, required String text, int? maxLength, int? minLength, bool required = false
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return TextEditorBottomSheet(
          context: context,
          labelText: labelText,
          text: text, maxLength: maxLength, minLength: minLength, required: required,
        );
      },
    );
  }

  @override
  State<TextEditorBottomSheet> createState() => _TextEditorBottomSheetState();
}

class _TextEditorBottomSheetState extends State<TextEditorBottomSheet> {

  final textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    textEditingController.text = widget.text;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.viewInsets.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Hủy",
                    )),
                Text(
                  widget.labelText,
                  textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.of(context).pop(textEditingController.text.trim());
                      }
                    },
                    child: Text(
                      'Xong',
                      style: context.textTheme.labelMedium?.copyWith(
                          color: context.colorScheme.primary, fontWeight: FontWeight.w500, fontSize: 16),
                    )),
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: textEditingController,
                autofocus: true,
                autocorrect: false,
                maxLines: 15,
                minLines: 3,
                validator: widget.required
                    ? (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng điền thông tin";
                  } else if (widget.minLength != null && widget.minLength! > 0 &&
                      value.length < widget.minLength!) {
                    return 'Vui lòng nhập chuổi có độ dài ký tự >= ${widget.minLength!}';
                  } else if (widget.maxLength != null && widget.maxLength! > 0 &&
                      value.length > widget.maxLength!) {
                    return 'Vui lòng nhập chuổi có độ dài ký tự <= ${widget.maxLength!}';
                  }
                }
                    : null,
                decoration: InputDecoration(
                    hintText: 'Vui lòng nhập ${widget.labelText.toLowerCase()}',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(height: 10,)

        ],
      ),
    );
  }
}
