import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';


import '../../utils/app_const.dart';
import '../bottom_sheet/widget_datetime_picker.dart';
import '../textfields/rounded_textfield.dart';

class DateTimeValueController extends ValueNotifier<DateTime?> {
  DateTimeValueController({DateTime? selected}) : super(selected);

  void close() {
    dispose();
  }
}

class DatePickerSelectField extends StatefulWidget {
  final DateTimeValueController? controller;
  final DateTime? selectedDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final String dateFormat;
  final String? hintText;
  final String? labelText;
  final TextStyle? textStyle;
  final Function(DateTime)? onChangedDate;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool selectTime;
  final Widget? icon;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool required;

  const DatePickerSelectField(
      {super.key,
      this.controller,
      this.selectedDate,
      this.minDate,
      this.maxDate,
      this.dateFormat = AppConst.dateFormat,
      this.hintText,
      this.labelText,
      this.textStyle,
      this.onChangedDate,
      this.validator,
      this.enabled = true,
      this.selectTime = false,
      this.icon,
      this.margin,
      this.padding,
      this.required = false,
      this.backgroundColor})
      : assert(
          selectedDate == null || controller == null,
        );

  @override
  _DatePickerSelectFieldState createState() => _DatePickerSelectFieldState();
}

class _DatePickerSelectFieldState extends State<DatePickerSelectField> {
  DateTime? selectedDate;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      selectedDate = widget.controller?.value;
      widget.controller?.addListener(onChangeListener);
    } else {
      selectedDate = widget.selectedDate;
    }
    _editingController = TextEditingController(text: _dateString());
  }

  void onChangeListener() {
    selectedDate = widget.controller?.value;
    _editingController.text = _dateString();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(onChangeListener);
    _editingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DatePickerSelectField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (convertDateToString(selectedDate, widget.dateFormat) !=
        convertDateToString(oldWidget.selectedDate, widget.dateFormat)) {
      _editingController.dispose();
      _editingController = TextEditingController(text: _dateString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final hintText = widget.hintText ?? (widget.labelText != null ? "Chọn ${widget.labelText!.toLowerCase()}" : null);
    return RoundedTextField(
      margin: widget.margin,
      padding: widget.padding,
      required: widget.required,
      readOnly: true,
      controller: _editingController,
      hintText: hintText,
      labelText: widget.labelText,
      textStyle: widget.textStyle,
      backgroundColor: widget.backgroundColor,
      validator: widget.validator ?? (widget.required ? (value) {
        if (value == null || value.isEmpty) {
          return "Vui lòng chọn giá trị";
        }
      } : null),
      suffixIconConstraints: const BoxConstraints(maxHeight: 20, minWidth: 34),
      suffixIcon: widget.icon ?? Icon(Icons.date_range_rounded),
      onTap: widget.enabled
          ? () {
              if (widget.selectTime) {
                _showDateTimePicker();
              } else {
                _showCalendarPicker();
              }
            }
          : null,
    );
  }

  String _dateString() {
    return convertDateToString(selectedDate, widget.dateFormat);
  }

  void _showCalendarPicker() async {
    DateTime firstDate = widget.minDate ?? DateTime(DateTime.now().year - 5);
    DateTime lastDate = widget.maxDate ?? DateTime(DateTime.now().year + 5);
    if (selectedDate != null) {
      if (selectedDate!.isBefore(firstDate)) {
        selectedDate = firstDate;
      }
      if (selectedDate!.isAfter(lastDate)) {
        selectedDate = lastDate;
      }
    }
    DateTime? value = await showDatePicker(
        context: context,
        // locale: localizationManager.getCurrentLocale(),
        initialDate: selectedDate ??
            (lastDate.compareTo(DateTime.now()) < 0
                ? lastDate
                : DateTime.now()),
        firstDate: firstDate,
        lastDate: lastDate,
        initialDatePickerMode: DatePickerMode.day,
        initialEntryMode: DatePickerEntryMode.calendarOnly);
    // print("value: $value");
    if (value != null && value != selectedDate) {
      if (widget.controller != null) {
        widget.controller?.value = value;
      } else {
        selectedDate = value;
        _editingController.text = _dateString();
      }
      if (widget.onChangedDate != null) {
        widget.onChangedDate!(value);
      }
    }
  }

  void _showDatePicker() {
    DateTime firstDate = widget.minDate ?? DateTime(DateTime.now().year - 5);
    DateTime lastDate = widget.maxDate ?? DateTime(DateTime.now().year + 5);
    if (selectedDate != null) {
      if (selectedDate!.isBefore(firstDate)) {
        selectedDate = firstDate;
      }
      if (selectedDate!.isAfter(lastDate)) {
        selectedDate = lastDate;
      }
    }
    DatePicker.showDatePicker(context,
        dateFormat: widget.dateFormat,
        initialDateTime: selectedDate ??
            (lastDate.compareTo(DateTime.now()) < 0
                ? lastDate
                : DateTime.now()),
        minDateTime: firstDate,
        maxDateTime: lastDate,
        locale: DateTimePickerLocale.vi, onConfirm: (value, _) {
      if (value != selectedDate) {
        if (widget.controller != null) {
          widget.controller?.value = value;
        } else {
          selectedDate = value;
          _editingController.text = _dateString();
        }
        if (widget.onChangedDate != null) {
          widget.onChangedDate!(value);
        }
      }
    });
  }

  void _showDateTimePicker() async {
    DateTime firstDate = widget.minDate ?? DateTime(DateTime.now().year - 5);
    DateTime lastDate = widget.maxDate ?? DateTime(DateTime.now().year + 5);
    if (selectedDate != null) {
      if (selectedDate!.isBefore(firstDate)) {
        selectedDate = firstDate;
      }
      if (selectedDate!.isAfter(lastDate)) {
        selectedDate = lastDate;
      }
    }
    DateTime? value = await DateTimePickerBottomSheet.show(context,
        selectedDate: selectedDate ?? DateTime.now(),
        minimumDate: firstDate,
        maximumDate: lastDate);
    if (value != null && value != selectedDate) {
      if (widget.controller != null) {
        widget.controller?.value = value;
      } else {
        selectedDate = value;
        _editingController.text = _dateString();
      }
      if (widget.onChangedDate != null) {
        widget.onChangedDate!(value);
      }
    }
  }
}
