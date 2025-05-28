import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../base_core.dart';
import '../model/pagedata_model.dart';
enum LoadMoreStatus { haveMore, loading, finished }

abstract class LoadMoreCubit<T> extends BaseCubit {
  final T Function(Map<String, dynamic> json) target;
  LoadMoreCubit(this.target) {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          loadMoreStatus == LoadMoreStatus.haveMore) {
        loadMoreStream.sink.add(LoadMoreStatus.loading);
        Future.delayed(const Duration(milliseconds: 500)).then((_) {
          onLoadMore();
        });
      }
    });
  }
  BehaviorSubject<LoadMoreStatus> loadMoreStream =
      BehaviorSubject.seeded(LoadMoreStatus.finished);
  BehaviorSubject<List<T>?> dataStream = BehaviorSubject();
  final countStream = BehaviorSubject<int?>();
  final scrollController = ScrollController();
  int pageIndex = 1;
  int get pageSize => 30;

  LoadMoreStatus get loadMoreStatus => loadMoreStream.stream.value;

  ApiRouter get apiRouter;

  @override
  void initCubit() {
    loadDatas();
  }

  void onLoadMore() {
    if (isClosed) {
      return;
    }
    debugPrint("onLoadMore");
    pageIndex++;
    loadDatas(isShowLoading: false);
  }

  void resetPage() {
    pageIndex = 1;
  }

  void clearDatas() {
    dataStream.sink.add(null);
  }

  Future<void> reloadDatas() async {
    pageIndex = 1;
    dataStream.value = null;
    await loadDatas(isShowLoading: true);
  }

  Future<void> refreshDatas() async {
    pageIndex = 1;
    await loadDatas(isShowLoading: false);
  }

  Future<void> loadDatas({bool isShowLoading = true}) async {
    if (dataStream.valueOrNull == null && isShowLoading) {
      showLoading();
    }
    final response =
        await apiClient.request(router: apiRouter, target: (json) => PageDataModel<T>.fromJson(json, target));
    response.onCompleted(success: (result) {
      if (isClosed) {
        return;
      }
      List<T> datas = result?.items ?? [];
      if (pageIndex <= 1) {
        countStream.value = result?.count;
        dataStream.sink.add(datas);
      } else {
        dataStream.sink.add((dataStream.valueOrNull ?? [])..addAll(datas));
      }
      if (datas.length >= pageSize) {
        loadMoreStream.sink.add(LoadMoreStatus.haveMore);
      } else {
        loadMoreStream.sink.add(LoadMoreStatus.finished);
      }
    }, error: (code, msg) {
      if (dataStream.valueOrNull == null) {
        dataStream.sink.add(null);
      }
      loadMoreStream.sink.add(LoadMoreStatus.finished);
      errorHandler(code, msg);
    });
    hideLoading();
  }

  @override
  void dispose() {
    scrollController.dispose();
    countStream.close();
    loadMoreStream.close();
    dataStream.close();
    super.dispose();
  }
}
