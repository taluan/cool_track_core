import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../generated/l10n.dart';


class DateRangePicker extends StatefulWidget {
  final String dateFormat;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? maxDate;
  final DateTime? minDate;
  final Function(DateTime, DateTime) onSubmited;
  const DateRangePicker(
      {super.key,
      this.dateFormat = 'dd/MM/yyyy',
      this.startDate,
      this.endDate,
        this.maxDate, this.minDate,
      required this.onSubmited});

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();

  static void showDateRangePicker(BuildContext context,
      {String dateFormat = 'dd/MM/yyyy',
      DateTime? startDate,
      DateTime? endDate,
        DateTime? maxDate,
        DateTime? minDate,
      required Function(DateTime, DateTime) onSubmited}) async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(19.0),
          ),
        ),
        builder: (context) {
          return DateRangePicker(
            dateFormat: dateFormat,
            startDate: startDate,
            endDate: endDate,
            maxDate: maxDate,
            minDate: minDate,
            onSubmited: onSubmited,
          );
        });
  }
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Chọn khoản thời gian', style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.black38)
            ),
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  'Từ: ',
                  style: context.textTheme.labelMedium,
                ),
                Text(convertDateToString(_startDate, widget.dateFormat),
                    style: context.textTheme.labelMedium?.copyWith( fontWeight: FontWeight.bold)),
                const Expanded(
                    child: Icon(
                      Icons.arrow_forward_outlined,
                      size: 18,
                    )),
                Text('Đến: ',
                    style: context.textTheme.labelMedium),
                Text(convertDateToString(_endDate, widget.dateFormat),
                    style: context.textTheme.labelMedium?.copyWith( fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(
            height: 340,
            child: SfDateRangePicker(
              onSelectionChanged: (dateRange) {
                setState(() {
                  _startDate = dateRange.value.startDate;
                  _endDate = dateRange.value.endDate ?? dateRange.value.startDate;
                });
              },
              backgroundColor: Colors.white,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(_startDate, _endDate),
              maxDate: widget.maxDate, minDate: widget.minDate,
              showActionButtons: true,
              confirmText: S.current.agree,
              cancelText: S.current.cancel,
              navigationMode: DateRangePickerNavigationMode.scroll,
              onCancel: () {
                Navigator.of(context).pop();
              },
              onSubmit: (dateRange) {
                if (_startDate != null && _endDate != null) {
                  Navigator.of(context).pop();
                  widget.onSubmited(_startDate!, _endDate!);
                }
              },
            ),
          ),
          // RoundedButton(title: 'Áp dụng', onPressed: () {
          //
          // },),
          // SizedBox(height: context.paddingBottom,)
        ],
      ),
    );
  }
}
