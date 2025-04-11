import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';
import '../../utils/app_const.dart';

class DateTimePickerBottomSheet extends StatefulWidget {
  final DateTime? selectedDate;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  const DateTimePickerBottomSheet(
      {super.key, this.selectedDate, this.minimumDate, this.maximumDate});

  static Future<dynamic> show(BuildContext context,
      {DateTime? selectedDate, DateTime? minimumDate, DateTime? maximumDate}) {
    return showCupertinoModalPopup(
        context: context,
        builder: (_) => DateTimePickerBottomSheet(
              selectedDate: selectedDate,
              minimumDate: minimumDate,
              maximumDate: maximumDate,
            ));
  }

  @override
  _DateTimePickerBottomSheetState createState() =>
      _DateTimePickerBottomSheetState();
}

class _DateTimePickerBottomSheetState extends State<DateTimePickerBottomSheet> {
  DateTime? selectedDate;

  @override
  void initState() {
    selectedDate = widget.selectedDate ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SizedBox(
            height: 300,
            child: CupertinoDatePicker(
                initialDateTime: widget.selectedDate ?? DateTime.now(),
                minimumDate: widget.minimumDate,
                maximumDate: widget.maximumDate,
                use24hFormat: true,
                onDateTimeChanged: (val) {
                  setState(() {
                    selectedDate = val;
                  });
                }),
          ),
          Container(
            height: AppConst.navigationBarHeight,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      S.current.cancel,
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    )),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? DateFormat().format(selectedDate!)
                        : "",
                    style: context.textTheme.titleMedium?.copyWith(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(selectedDate);
                      // print("toch back ${selectedDate}");
                    },
                    child: Text(
                      S.current.done,
                      style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: AppConst.navigationBarHeight),
            child: Divider(
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
