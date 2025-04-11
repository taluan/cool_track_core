import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/keyvalue_model.dart';
import '../bottom_sheet/bottomsheet_dropdown_select.dart';
import '../textfields/rounded_textfield.dart';
import '../widget_no_data.dart';
import 'multiple_choice_formfield.dart';

typedef SelectItemCallback<T> = Function(T);

class DropDownValueController<T extends KeyValueObject>
    extends ValueNotifier<List<T>?> {
  DropDownValueController({T? selectedItem})
      : super(selectedItem != null ? [selectedItem] : null);

  DropDownValueController.fromSelectedItems(super.selectedItems);

  /// The current value the user is editing.
  T? get selectedItem => value?.firstOrNull;

  set selectedItem(KeyValueObject? newValue) {
    if (newValue?.hashKey != selectedItem?.hashKey) {
      value = newValue != null ? [newValue as T] : null;
    }
  }

  List<T>? get selectedItems => value;

  set selectedItems(List<KeyValueObject>? newValue) {
    if (!listEquals(value, newValue)) {
      value = newValue?.cast<T>();
    }
  }


  Function(List<T>)? _onUpdateDataSource;
  Function()? _onClearDataSource;

  void updateDataSource(List<T> datas) {
    _onUpdateDataSource?.call(datas);
  }

  void clearCache() {
    _onClearDataSource?.call();
  }

  void clear() {
    if (value != null) {
      value = null;
    }
    _onClearDataSource?.call();
  }

  void close() {
    dispose();
  }
}

// ignore: must_be_immutable
class RoundedDropDown<T extends KeyValueObject> extends StatefulWidget {
  List<T>? selectedItems;
  final String? labelText;
  final String? hintText;
  final SelectItemCallback? onChanged;
  final FormFieldValidator<String>? validator;
  final DropDownValueController<T>? controller;
  final bool enabled;
  final bool Function()? checkBeforeShowItem;
  final Future<List<T>> Function(String?)? dataAsync;
  final List<T>? datas;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final bool isCache;
  final bool searchLocal;
  final int maxLine;
  final Color? backgroundColor;
  final bool required;
  final Widget? Function(T)? titleBuilder;

  late final bool multiSelect;

  RoundedDropDown({
    super.key,
    this.hintText,
    this.labelText,
    this.datas,
    T? selectedItem,
    this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.checkBeforeShowItem,
    this.prefixIcon,
    this.suffixIcon,
    this.dataAsync,
    this.required = false,
    this.margin,
    this.padding,
    this.textStyle,
    this.textAlign,
    this.backgroundColor,
    this.maxLine = 1,
    this.isCache = true,
    this.searchLocal = true,
    this.titleBuilder,
  })  : assert(
          selectedItem == null || controller == null,
        ),
        assert(
          datas == null || dataAsync == null,
        ) {
    multiSelect = false;
    if (selectedItem != null) {
      selectedItems = [selectedItem];
    } else if (controller?.selectedItems != null) {
      selectedItems = controller!.selectedItems;
    }
  }

  RoundedDropDown.multiSelection({
    super.key,
    this.hintText,
    this.labelText,
    this.datas,
    this.selectedItems,
    this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.checkBeforeShowItem,
    this.prefixIcon,
    this.suffixIcon,
    this.dataAsync,
    this.required = false,
    this.margin,
    this.padding,
    this.textStyle,
    this.textAlign,
    this.backgroundColor,
    this.maxLine = 1,
    this.isCache = true,
    this.searchLocal = true,
    this.titleBuilder
  })  : assert(
          selectedItems == null || controller == null,
        ),
        assert(
          datas == null || dataAsync == null,
        ) {
    multiSelect = true;
    if (controller?.selectedItems != null) {
      selectedItems = controller!.selectedItems;
    }
  }

  @override
  State<RoundedDropDown> createState() {
    return multiSelect ? _RoundedDropDownMultipleState<T>() : _RoundedDropDownState<T>();
  }
}

class _RoundedDropDownState<T extends KeyValueObject> extends State<RoundedDropDown<T>> {
  var textController = TextEditingController();
  List<T> datas = [];

  @override
  void initState() {
    if (widget.controller != null) {
      widget.selectedItems = widget.controller?.selectedItems;
      widget.controller?.addListener(onChangeListener);

      widget.controller?._onUpdateDataSource = (dataSource) {
        datas = dataSource;
      };
      widget.controller?._onClearDataSource = () {
        datas.clear();
      };
    }
    textController.text = generateSelectedTitle();
    super.initState();
  }

  void onChangeListener() {
    widget.selectedItems = widget.controller?.selectedItems;
    textController.text = generateSelectedTitle();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(onChangeListener);
    textController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RoundedDropDown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.selectedItems, oldWidget.selectedItems)) {
      // print("didUpdateWidget oldWidget${oldWidget.selectedItems?.fold("", (previousValue, element) => "${previousValue}_${element.title}")}");
      // print("didUpdateWidget ${widget.selectedItems?.fold("", (previousValue, element) => "${previousValue}_${element.title}")}");
      textController.dispose();
      textController = TextEditingController(text: generateSelectedTitle());
    }
  }

  @override
  Widget build(BuildContext context) {
    final hintText = widget.hintText ?? (widget.labelText != null ? 'Vui lòng chọn ${widget.labelText!.toLowerCase()}' : null);
    return RoundedTextField(
      controller: textController,
      readOnly: true,
      margin: widget.margin,
      padding: widget.padding,
      required: widget.required,
      labelText: widget.labelText,
      hintText: hintText,
      validator: widget.validator ?? (widget.required ? (value) {
        if (value == null || value.isEmpty) {
          return "Vui lòng chọn giá trị";
        }
      } : null),
      textStyle: widget.textStyle,
      textAlign: widget.textAlign,
      backgroundColor: widget.backgroundColor,
      enabled: widget.enabled,
      maxLines: widget.maxLine,
      minLines: 1,
      suffixIconConstraints:
      const BoxConstraints(minHeight: 24, minWidth: 34),
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon ??  const Icon(Icons.keyboard_arrow_down_outlined, size: 22, color: Colors.grey),
      onTap: widget.enabled
          ? () async {
        FocusScope.of(context).unfocus();
        if (widget.checkBeforeShowItem == null ||
            widget.checkBeforeShowItem?.call() == true) {
          await SystemChannels.textInput.invokeMethod('TextInput.hide');
          showDropDownSelect();
        }
      }
          : null,
    );
  }


  void showDropDownSelect() async {
    final title = widget.hintText ?? (widget.labelText != null ? "Chọn ${widget.labelText!.toLowerCase()}" : null);
    Widget body = DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: .92,
      expand: false,
      builder: (_, controller) {
        Widget child;
        if (widget.dataAsync != null &&
            (widget.isCache ? datas.isEmpty : true)) {
          child = FutureBuilder(
            future: widget.dataAsync!(null),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data?.isEmpty == true) {
                return const SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: NoDataWidget()
                );
              }
              final List<T> lsData =
              List.from(snapshot.data ?? []);
              if (widget.isCache) {
                //cache data source
                datas = lsData;
              }
              debugPrint('data length: ${lsData.length}');
              return DropDownSelectionBottomSheet(
                controller: controller,
                title: title ?? "",
                datas: lsData,
                searchDataAsync: !widget.searchLocal ? widget.dataAsync : null,
                multiSelect: widget.multiSelect,
                selected: widget.selectedItems,
                titleBuilder: widget.titleBuilder,
              );
            },
          );
        } else {
          child = DropDownSelectionBottomSheet(
            controller: controller,
            title: title ?? "",
            datas: widget.datas ?? datas,
            searchDataAsync: !widget.searchLocal ? widget.dataAsync : null,
            multiSelect: widget.multiSelect,
            selected: widget.selectedItems,
            titleBuilder: widget.titleBuilder,
          );
        }
        return child;
      },
    );
    List<T>? selectResult =
        await showModalBottomSheet<List<T>?>(
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      // useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: body);
      },
    );
    if (selectResult != null) {
      //kiểm tra nếu trùng value thì return
      if (widget.multiSelect) {
        if (listEquals(selectResult, widget.selectedItems)) {
          return;
        }
      } else if (selectResult.firstOrNull?.hashKey ==
          widget.selectedItems?.firstOrNull?.hashKey) {
        return;
      }
      if (widget.controller != null) {
        if (widget.controller?.selectedItems != selectResult) {
          widget.controller?.selectedItems = selectResult;
        }
      } else {
        widget.selectedItems = selectResult;
        textController.text = generateSelectedTitle();
      }
      if (widget.onChanged != null) {
        widget.onChanged?.call(
            widget.multiSelect ? selectResult : selectResult.firstOrNull);
      }
    }
  }

  String generateSelectedTitle() {
    return widget.selectedItems?.map((e) => e.titleDisplay.toString()).join(', ') ??
        '';
  }
}

class _RoundedDropDownMultipleState<T extends KeyValueObject> extends State<RoundedDropDown<T>> {
  List<T> datas = [];
  late MultipleChoiceFormFieldController<T> multipleChoiceFormFieldController;

  @override
  void initState() {
    multipleChoiceFormFieldController = MultipleChoiceFormFieldController<T>();
    if (widget.controller != null) {
      widget.selectedItems = widget.controller?.selectedItems;
      widget.controller?.addListener(onChangeListener);

      widget.controller?._onUpdateDataSource = (dataSource) {
        datas = dataSource;
      };
      widget.controller?._onClearDataSource = () {
        datas.clear();
      };
    }
    super.initState();
  }

  void onChangeListener() {
    debugPrint("onChangeListener: ${widget.controller?.selectedItems}");
    widget.selectedItems = widget.controller?.selectedItems;
    multipleChoiceFormFieldController.updateValue(widget.controller?.selectedItems);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(onChangeListener);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final hintText = widget.hintText ?? (widget.labelText != null ? "Chọn ${widget.labelText!.toLowerCase()}" : null);
    return MultipleChoiceFormField<T>(
      controller: multipleChoiceFormFieldController,
      labelText: widget.labelText,
      hintText: hintText,
      required: widget.required,
      enabled: widget.enabled,
      initialValue: widget.selectedItems ?? [],
      showSelectedItems: () => showDropDownSelect(),
      onChanged: (values) {
        // debugPrint("MultipleChoiceFormField onChanged");
      widget.selectedItems = values;
      if (widget.controller != null) {
        widget.controller?.selectedItems = values;
      }
      if (widget.onChanged != null) {
        widget.onChanged?.call(widget.selectedItems);
      }
    },);
  }


  Future<List<T>?> showDropDownSelect() async {
    FocusScope.of(context).unfocus();
    if (widget.checkBeforeShowItem != null &&
        widget.checkBeforeShowItem?.call() == false) {
      return null;
    }
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    Widget body = DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: .92,
      expand: false,
      builder: (_, controller) {
        Widget child;
        if (widget.dataAsync != null &&
            (widget.isCache ? datas.isEmpty : true)) {
          child = FutureBuilder(
            future: widget.dataAsync!(null),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data?.isEmpty == true) {
                return const SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: NoDataWidget()
                );
              }
              final List<T> lsData =
              List.from(snapshot.data ?? []);
              if (widget.isCache) {
                //cache data source
                datas = lsData;
              }
              debugPrint('data length: ${lsData.length}');
              return DropDownSelectionBottomSheet(
                controller: controller,
                title: widget.hintText ?? widget.labelText ?? "",
                datas: lsData,
                searchDataAsync: !widget.searchLocal ? widget.dataAsync : null,
                multiSelect: widget.multiSelect,
                selected: widget.selectedItems,
                titleBuilder: widget.titleBuilder,
              );
            },
          );
        } else {
          child = DropDownSelectionBottomSheet(
            controller: controller,
            title: widget.hintText ?? widget.labelText ?? "",
            datas: widget.datas ?? datas,
            searchDataAsync: !widget.searchLocal ? widget.dataAsync : null,
            multiSelect: widget.multiSelect,
            selected: widget.selectedItems,
            titleBuilder: widget.titleBuilder,
          );
        }
        return child;
      },
    );
    List<T>? selectResult =
    await showModalBottomSheet<List<T>?>(
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      // useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: body);
      },
    );
    return selectResult;
  }

  String generateSelectedTitle() {
    return widget.selectedItems?.map((e) => e.titleDisplay.toString()).join(', ') ??
        '';
  }
}
