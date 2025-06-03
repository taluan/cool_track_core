import 'package:base_code_flutter/base_cubit/loadmore_cubit.dart';
import 'package:flutter/cupertino.dart';

import 'loadmore_view.dart';

class ListViewPaging extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry padding;
  final Widget separated;
  final LoadMoreCubit loadMoreCubit;

  const ListViewPaging({super.key, required this.itemCount, required this.itemBuilder, this.separated = const SizedBox.shrink(), required this.loadMoreCubit, this.padding = const EdgeInsets.only(bottom: 10)});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: itemCount + 1,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        controller: loadMoreCubit.scrollController,
        separatorBuilder: (_, __,) {
          return separated;
        },
        itemBuilder: (context, index) {
          if (index == itemCount) {
            return LoadMoreContainer(loadMoreCubit.loadMoreStream);
          } else {
            return itemBuilder(context, index);
          }
        });
  }
}
