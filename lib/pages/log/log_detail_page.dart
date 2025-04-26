import 'dart:convert';

import 'package:base_code_flutter/model/log_api_model.dart';
import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:base_code_flutter/widgets/snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

import '../../utils/app_const.dart';


class LogDetailPage extends StatelessWidget {
  final LogApiModel item;
  LogDetailPage({super.key, required this.item});


  final jsonViewThem = JsonViewTheme(
      viewType: JsonViewType.base,
      openIcon: const Icon(
        Icons.arrow_drop_down,
        size: 18,
        color: Colors.grey,
      ),
      closeIcon: const Icon(
        Icons.arrow_drop_up,
        size: 18,
        color: Colors.grey,
      ),
      backgroundColor: Colors.white, defaultTextStyle: TextStyle(color: Colors.black87));

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? json;
    try {
      json = jsonDecode(item.response);
    } catch (_) {}
    return Scaffold(
        appBar: AppBar(
          title: const Text("Log Detail"),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 1,
          shadowColor: Colors.black26,
          actions: [
            TextButton.icon(onPressed: () async {
              await Clipboard.setData(ClipboardData(
                  text: "[${item.method}] ${item.url}\nHeaders: ${item.header}\nParams: ${item.params}\nResponse: ${item.response}\nStartTime: ${item.createdDate}\nEndRequestTime: ${item.endRequestDate}"));
              AppSnackBar.showSuccess(context, message: 'Đã copy vào clipboard', displayDuration: const Duration(milliseconds: 2000));
            }, label: const Text('Copy all'), icon: const Icon(Icons.copy),)
          ],
          // elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text("[${item.method}] ${item.url}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  )),
                  IconButton(onPressed: ()  async {
                    await Clipboard.setData(ClipboardData(text: "[${item.method}] ${item.url}"));
                    AppSnackBar.showSuccess(context, message: 'Đã copy vào clipboard', displayDuration: const Duration(milliseconds: 2000));
                  }, icon: const Icon(Icons.copy),)
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Header:",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  )),
                  IconButton(onPressed: ()  async {
                    await Clipboard.setData(ClipboardData(text: item.header));
                    AppSnackBar.showSuccess(context, message: 'Đã copy vào clipboard', displayDuration: const Duration(milliseconds: 2000));
                  }, icon: const Icon(Icons.copy),)
                ],
              ),
              // Text(item.header),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.grey, width: 0.75)),
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.all(2),
                child: JsonView.string(
                  item.header,
                  theme: jsonViewThem,
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                        "Params:",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      )),
                  IconButton(onPressed: ()  async {
                    await Clipboard.setData(ClipboardData(text: item.params));
                    AppSnackBar.showSuccess(context, message: 'Đã copy vào clipboard', displayDuration: const Duration(milliseconds: 2000));
                  }, icon: const Icon(Icons.copy),)
                ],
              ),
              Text(item.params),
              Row(
                children: [
                  // Text(
                  //   "Response ",
                  //   style: AppConfig.blackBoldTextStyle,
                  // ),
                  Expanded(
                    child: Text(
                      "Response status code: ${item.statusCode}",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: (item.statusCode != 200 ||
                              item.response.contains('Status":{"Code":500') ||
                              item.response.contains('Status":{"Code":401'))
                              ? Colors.red
                              : Colors.black87),
                    ),
                  ),
                  IconButton(onPressed: ()  async {
                    await Clipboard.setData(ClipboardData(text: item.response));
                    AppSnackBar.showSuccess(context, message: 'Đã copy vào clipboard', displayDuration: const Duration(milliseconds: 2000));
                  }, icon: const Icon(Icons.copy),)
                ],
              ),
              json != null
                  ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                    child: JsonView.map(
                        json,
                        theme: jsonViewThem,
                      ),
                  )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Colors.grey, width: 0.75)),
                      padding: const EdgeInsets.all(10),
                      child: Text(item.response)),
              Text("StartTime: ${item.createdDate}"),
              Text("EndTime: ${item.endRequestDate}"),
              if (item.endRequestDate != null)
                Text("Duration: ${formatNumber(value: item.endRequestDate!.difference(item.createdDate).inMilliseconds)} ms"),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('ĐÓNG', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),)),
              const SizedBox(height: 30,),

            ],
          ),
        ),
      // persistentFooterAlignment: AlignmentDirectional.center,
      // persistentFooterButtons: [

      // ],
    );
  }
}
