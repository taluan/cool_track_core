import 'package:base_code_flutter/base_cubit/loadmore_cubit.dart';
import 'package:flutter/material.dart';


class LoadMoreContainer extends StatelessWidget {
  final Stream<LoadMoreStatus> loadMoreStream;
  final EdgeInsetsGeometry? margin;
  const LoadMoreContainer(this.loadMoreStream, {super.key, this.margin});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoadMoreStatus>(
        stream: loadMoreStream,
        builder: (context, snapshot) {
          return Container(
            alignment: Alignment.center,
            height: 30,
            margin: margin,
            child: snapshot.data == LoadMoreStatus.loading ? const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator()) : null,
          );
        }
    );
  }
}
