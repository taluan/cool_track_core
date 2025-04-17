import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/app_const.dart';
import '../textfields/title_label_text.dart';

class MultipleChoiceFormFieldController<T> {
  FormFieldState<List<T>?>? _state;

  void attach(FormFieldState<List<T>?> state) {
    _state = state;
  }

  void detach() {
    _state = null;
  }

  void updateValue(List<T>? newValue) {
    _state?.didChange(newValue);
  }

  void clear() {
    _state?.didChange([]);
  }
}

class MultipleChoiceFormField<T> extends FormField<List<T>?> {
  MultipleChoiceFormField({super.key,
    MultipleChoiceFormFieldController<T>? controller,
    String? labelText,
    String? hintText,
    bool required = false,
    bool enabled = true,
    super.initialValue,
    Function(List<T>)? onChanged,
    required Future<List<T>?> Function() showSelectedItems,
    final Widget? Function(T)? itemBuilder,
  }) : super(
    validator: (required ? (value) {
      if (value == null || value.isEmpty) {
        return "Vui lòng chọn giá trị";
      }
    } : null),
    builder: (state) {
      if (controller != null) {
        controller.attach(state);
      }
      return _MultipleChoiceFormFieldWidget<T>(
        state: state,
        labelText: labelText,
        hintText: hintText,
        required: required,
        enable: enabled,
        showSelectedItems: showSelectedItems,
        itemBuilder: itemBuilder,
        onChanged: onChanged,
      );
    },
  );
}


class _MultipleChoiceFormFieldWidget<T> extends StatelessWidget {
  final FormFieldState<List<T>?> state;
  final String? labelText;
  final String? hintText;
  final bool required;
  final bool enable;
  final Future<List<T>?> Function() showSelectedItems;
  final Widget? Function(T)? itemBuilder;
  final Function(List<T>)? onChanged;

  const _MultipleChoiceFormFieldWidget({
    required this.state,
    this.labelText,
    this.hintText,
    required this.required,
    required this.showSelectedItems,
    this.enable = true,
    this.itemBuilder,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = state.hasError && state.errorText != null;
    final values = state.value ?? [];
    final inputDecorationTheme = context.inputDecorationTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((labelText ?? "").isNotEmpty)
          TitleLabelText(labelText: labelText, required: required,),
        InkWell(
          onTap: enable ? () async {
            final result = await showSelectedItems();
            if (result != null) {
              if (values.isEmpty && result.isNotEmpty) {
                state.reset();
              }
              if (!listEquals(values, result)) {
                state.didChange(result);
                onChanged?.call(result);
              }
            }
          } : null,
          child: Container(
            decoration: BoxDecoration(
                color: enable ? Colors.white : context.theme.disabledColor,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: hasError ? context.colorScheme.error: inputDecorationTheme.border?.borderSide.color ?? Colors.grey.shade200)
            ),
            constraints: const BoxConstraints(minHeight: AppConst.textFieldHeight, maxHeight: 200),
            padding: const EdgeInsets.all(1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: values.isEmpty ? Padding(
                    padding: const EdgeInsets.only(left: 10, top: 11, bottom: 6, right: 10),
                    child: Text(hintText?.toString() ?? "", style: inputDecorationTheme.hintStyle,)) :
                SingleChildScrollView(
                  padding: const EdgeInsets.all(7),
                  child: Wrap(
                    spacing: 5, runSpacing: 5,
                    children: values.map((e) => Chip(
                      backgroundColor: const Color(0x145D6573),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: inputDecorationTheme.border?.borderSide,
                      label: itemBuilder?.call(e) ?? Text(e.toString(), maxLines: 1, overflow: TextOverflow.ellipsis,),
                      labelStyle: inputDecorationTheme.labelStyle,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                      deleteIcon: enable ? Icon(
                        Icons.close,
                        size: 16, color: Colors.grey,
                      ) : const SizedBox(),
                      onDeleted: () {
                        state.didChange(values..remove(e));
                        onChanged?.call(values);
                      },
                    )).toList(),
                  ),
                )),
                const Padding(
                    padding: EdgeInsets.only(top: 9, right: 8),
                    child: Icon(Icons.keyboard_arrow_down_outlined, size: 22, color: Colors.grey,))
              ],
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 6),
            child: Text(
              state.errorText ?? "Invalid field",
              style: context.textTheme.labelMedium?.copyWith(color: context.colorScheme.error, fontSize: 13),
            ),
          )
      ],
    );
  }
}