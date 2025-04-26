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
import '../../utils/app_routes.dart';
import 'log_detail_page.dart';



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
  LogApiPage({super.key}) : super(title: 'Log API', createCubit: () => LogApiCubit());

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
          borderColor: context.theme.dividerColor,
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
                    return  ListTile(
                      onTap: () {
                        AppRoutes.push(context, LogDetailPage(item: item));
                      },
                      title: Text("[${item.method}] ${item.statusCode} ${item.url}", style: TextStyle(fontSize: 13, color: (item.statusCode != 200 || item.response.contains('Status":{"Code":500') || item.response.contains('Status":{"Code":401')) ? Colors.red : Colors.black87),),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                      contentPadding: const EdgeInsets.only(left: 12, right: 5),
                    );
                  });
            }
        ))
      ],
    );
  }


}