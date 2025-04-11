import 'package:base_code_flutter/base_core.dart';
import 'package:base_code_flutter/management/cache_manager.dart';
import 'package:base_code_flutter/model/log_api_model.dart';
import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:base_code_flutter/widgets/snackbar/app_snackbar.dart';
import 'package:base_code_flutter/widgets/textfields/searchbar_textfield.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rxdart/rxdart.dart';
import '../../utils/app_const.dart';



class LogApiCubit extends BaseCubit {

  TextEditingController searchController = TextEditingController();
  BehaviorSubject<List<LogApiModel>?> datasStream = BehaviorSubject();

  @override
  void initCubit() {
    searchOnChanged("");
  }

  void searchOnChanged(String keyword) {
    keyword = keyword.trim().toLowerCase();
    if (keyword.isEmpty) {
      datasStream.sink.add(MemoryCached.instance.logApis);
      return;
    }
    datasStream.sink.add(MemoryCached.instance.logApis.where((element) => removeDiacritics(element.url.toLowerCase()).contains(keyword)).toList());
  }

  @override
  void dispose() {
    datasStream.close();
  }
}

class LogApiPage extends BaseStatelessWidget<LogApiCubit> {
  LogApiPage() : super(title: 'Log API', createCubit: () => LogApiCubit());

  @override
  List<Widget> actionButton(BuildContext context) {
    // TODO: implement getActionButton
    return [
      TextButton(
      onPressed: () {
        MemoryCached.instance.logApis.clear();
        cubit.datasStream.sink.add(null);
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        visualDensity: const VisualDensity(vertical: -1),
        foregroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(13)),
        minimumSize: const Size(44, 44),
      ),
      child: Text('Xóa',
          style: context.textTheme.labelMedium?.copyWith(color: Colors.black87)),
    )];
  }

  @override
  // TODO: implement backgroundColor
  Color? get backgroundColor => Colors.white;

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        SearchBarTextField(
          hintText: "Tìm kiếm",
          editingController: cubit.searchController,
          onChanged: cubit.searchOnChanged,
          autofocus: false,
          margin: const EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 1),
          onClear: () {
            cubit.searchOnChanged("");
          },
        ),
        Expanded(child: StreamBuilder<List<LogApiModel>?>(
            stream: cubit.datasStream,
            builder: (context, snapshot) {
              final datas = snapshot.data ?? [];
              return ListView.builder(
                  itemCount: datas.length,
                  itemBuilder: (context, index) {
                    final item = datas[index];
                    return ExpansionTile(title: Text("${item.statusCode} : ${item.url}", style: context.textTheme.labelMedium?.copyWith(color: (item.statusCode < 200 || item.statusCode > 300 || item.response.contains('Status":{"Code":500') || item.response.contains('Status":{"Code":401')) ? Colors.red : Colors.black87),),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      backgroundColor: Colors.white,
                      childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      children: [
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: "${item.url}\nParams: ${item.params}\nResponse: ${item.response}"));
                                AppSnackBar.showSuccess(context, message: 'Đã copy vào clipboard', displayDuration: const Duration(milliseconds: 2000));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 2.0),
                                backgroundColor: context.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),),
                              child: const Text(
                                "Copy all",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                            const SizedBox(width: 12,),
                            ElevatedButton(
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: item.header));
                                AppSnackBar.showSuccess(context, message: 'Đã copy vào clipboard', displayDuration: const Duration(milliseconds: 2000));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 2.0),
                                backgroundColor: context.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),),
                              child: const Text(
                                "Header",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                            const SizedBox(width: 12,),
                            ElevatedButton(
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: item.response));
                                AppSnackBar.showSuccess(context, message: 'Đã copy vào clipboard', displayDuration: const Duration(milliseconds: 2000));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 2.0),
                                backgroundColor: context.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),),
                              child: const Text(
                                "Response",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        Text("Time request: ${item.createdDate}",),
                        const SizedBox(height: 5,),
                        Text("Header: ${item.header}"),
                        const SizedBox(height: 5,),
                        Text("Params: ${item.params}",),
                        const SizedBox(height: 5,),
                        Text("Response: ${item.response}",),
                      ],);
                  });
            }
        ))
      ],
    );
  }


}