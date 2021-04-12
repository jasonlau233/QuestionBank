import 'package:flutter/widgets.dart';
import 'package:loading_more_list/loading_more_list.dart';

typedef Future<C> LoadDataCallBack<C>(int offset);

typedef void OnDataChangeListener<C>(List<C> data);

///
/// 数据源基类 封装上下拉刷新逻辑
///
class MyLoadingMoreBase<T> extends LoadingMoreBase<T> {
  MyLoadingMoreBase({
    @required this.loadDataCallBack,
    this.pageSize = 20,
    this.onDataChangeListener,
  }) : assert(pageSize != null);

  /// 加载数据的回调方法
  LoadDataCallBack loadDataCallBack;

  /// 数据变化的回调
  OnDataChangeListener onDataChangeListener;

  /// 默认第一页
  int _offset = 1;

  /// 是否还有更多数据
  bool _hasMore = true;

  /// 每页多少条数据 default=20
  int pageSize;

  @override
  bool get hasMore => _hasMore;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    debugPrint('CustomLoadingMoreBase clearBeforeRequest=$clearBeforeRequest');
    _offset = 0;
    _hasMore = true;
    return await super.refresh(clearBeforeRequest);
  }

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    debugPrint('CustomLoadingMoreBase isLoadMoreAction=$isLoadMoreAction');
    bool isSuccess = false;
    bool hasError = false;
    var newOffset = _offset + 1;
    try {
      var listData = await loadDataCallBack(newOffset);
      if (newOffset == 1) {
        this.clear();
      }

      //集合数据
      var list;

      //如果listData本身就是一个集合
      if (listData is List) {
        list = listData;
      } else {
        //否则看下集合数据是不是在result字段里面
        bool isInoResult;
        try {
          isInoResult = (listData?.result?.length ?? 0) > 0;
        } catch (e) {
          debugPrint('CustomLoadingMoreBase: is not in result');
        }

        if (isInoResult == true) {
          list = listData.result;
        }
      }

      //操作集合数据
      if (list is List) {
        for (var item in list) {
          this.add(item);
        }
        _offset = newOffset;
        _hasMore = list.length >= pageSize;
      } else {
        _hasMore = false;
      }

      isSuccess = true;
    } catch (exception, stack) {
      hasError = true;
      print(exception);
      print(stack);
    }
    if (onDataChangeListener != null) {
      onDataChangeListener(this);
    }
    return isLoadMoreAction ? isSuccess : !hasError;
  }
}
