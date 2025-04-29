
import 'package:base_code_flutter/base_core.dart';
import 'package:base_code_flutter/utils/helper_utils.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../../generated/l10n.dart';
import '../../model/keyvalue_model.dart';
import '../../utils/app_const.dart';
import '../textfields/searchbar_textfield.dart';
import '../widget_no_data.dart';

// ignore: must_be_immutable
class DropDownSelectionBottomSheet<T extends KeyValueObject > extends StatefulWidget {
  final ScrollController? controller;
  final String title;
  final List<T> datas;
  final Future<List<T>> Function(String?)? searchDataAsync;
  List<T>? selected;
  final bool multiSelect;
  final Widget? Function(T)? titleBuilder;

  DropDownSelectionBottomSheet({
    this.controller,
    required this.title,
    required this.datas,
    this.searchDataAsync,
    this.titleBuilder,
    this.selected = const [],
    this.multiSelect = false,
    super.key,
  });

  static Future<T?> show<T extends KeyValueObject >(BuildContext context,
      {T? selectedValue, List<T>? listItems, String? title}) async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    final List<T>? result = await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder( // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (_) => DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: .92,
            expand: false,
            builder: (_, controller) {
            return DropDownSelectionBottomSheet<T>(
              controller: controller,
              selected: selectedValue != null ? [selectedValue] : [],
              datas: listItems ?? [], title: title ?? "",
            );
          }
        ));
    return result?.firstOrNull;
  }

  @override
  State<DropDownSelectionBottomSheet> createState() =>
      _DropDownSelectionBottomSheetState<T>();
}

class _DropDownSelectionBottomSheetState<T extends KeyValueObject >
    extends State<DropDownSelectionBottomSheet<T>> {
  TextEditingController? searchController;
  BehaviorSubject<String>? searchOnChange;
  List<T>? selected;
  final listDataStream = BehaviorSubject<List<T>?>();
  final loadingStream = BehaviorSubject<bool?>();

  @override
  void initState() {
    super.initState();
    listDataStream.value = List<T>.from(widget.datas);
    selected = [...(widget.selected ?? [])];
    searchController = TextEditingController();
    searchOnChange = BehaviorSubject();
    searchOnChange
        ?.debounceTime(const Duration(milliseconds: 300))
        .listen((text) async {
          if (widget.searchDataAsync != null) {
            if (text.trim().isEmpty) {
              listDataStream.value = widget.datas;
            } else {
              loadingStream.value = true;
              listDataStream.value = await widget.searchDataAsync?.call(text);
              loadingStream.value = false;
            }
          } else {
            var textSearch = removeDiacritics(text.toLowerCase().trim());
            var filterResult = text.isEmpty
                ? widget.datas
                : List<T>.from(widget.datas)
                .where((element) =>
            removeDiacritics(element.titleDisplay.toLowerCase().trim())
                .contains(textSearch) ==
                true)
                .toList();
            listDataStream.value = filterResult;
          }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Color(0xffB5BBC5),
              borderRadius: BorderRadius.all(Radius.circular(2))
          ),
          height: 4,
          width: 60.sp,
          margin: const EdgeInsets.only(top: 5, bottom: 5),
        ),
        Container(
          height: AppConst.navigationBarHeight,
          color: Colors.white,
          child: Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.current.cancel,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.grey),
                  )),
              Expanded(
                  child: Text(
                    widget.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    textAlign: TextAlign.center,
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(selected);
                    // print("toch back ${selectedDate}");
                  },
                  child: Text(
                    S.current.done,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  )),
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
        // const Divider(),
        if (widget.datas.length > 10)
          SearchBarTextField(
            margin: const EdgeInsets.only(left: 12, top: 10, right: 12),
            autofocus: false,
            editingController: searchController,
            onChanged: _search,
            onClear: () {
              listDataStream.value = widget.datas;
            },
          ),
        Expanded(
          child: StreamBuilder<bool?>(
              stream: loadingStream,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return const Center(child: CircularProgressIndicator());
                }
              return StreamBuilder<List<T>?>(
                stream: listDataStream,
                builder: (context, snapshot) {
                  final datas = snapshot.data ?? [];
                  if (datas.isEmpty) {
                    return NoDataWidget(connectionState: snapshot.connectionState,);
                  }
                  return ListView.separated(
                    controller: widget.controller,
                    separatorBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Divider(height: 0),
                      );
                    },
                    itemBuilder: (context, index) {
                      var item = datas[index];
                      bool isChecked = selected?.contains(item) == true;
                      return ListTile(
                        splashColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        onTap: () {
                          if (widget.multiSelect) {
                            setState(() {
                              if (isChecked) {
                                selected?.remove(item);
                              } else {
                                selected?.add(item);
                              }
                            });
                          } else {
                            Navigator.of(context).pop([item]);
                          }
                        },
                        title: widget.titleBuilder?.call(item) ?? Text(item.titleDisplay, maxLines: 1, overflow: TextOverflow.ellipsis,),
                        trailing: isChecked
                            ? Icon(
                                Icons.check,
                                color: context.colorScheme.primary,
                              )
                            : null,
                      );
                    },
                    itemCount: datas.length,
                  );
                }
              );
            }
          ),
        ),
        // if (widget.multiSelect && listDataStream.valueOrNull?.isNotEmpty == true)
        //   SafeArea(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop(selected);
        //           },
        //           style: TextButton.styleFrom(
        //             visualDensity: const VisualDensity(vertical: -1),
        //
        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConst.textFieldBorderRadius)),
        //             minimumSize: Size(220.w, 48),
        //           ),
        //           child: Text(S.current.done,
        //               style: context.textTheme.titleLarge),
        //         )
        //       ],
        //     ),
        //   )
      ],
    );
  }


  void _search(String queryString) {
    searchOnChange?.add(queryString);
  }

  @override
  void dispose() {
    loadingStream.close();
    listDataStream.close();
    searchController?.dispose();
    super.dispose();
  }
}
