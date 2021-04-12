import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../my_image.dart';
import 'my_loading_more_base.dart';
import 'my_loading_more_indicator.dart';
import 'my_refresh_indicator.dart';
import 'need_clear_photo_cache_mixin.dart';

typedef Widget BuildListItemCallBack<A>(
    BuildContext context, A data, int index);

///
/// 上下拉刷新-适用于普通列表，Sliver列表，NesSliver列表，瀑布流，Grid表格
/// 下拉刷新使用flutter sdk自带，
/// 加载更多使用第三方插件，文档：https://github.com/fluttercandies/loading_more_list/blob/master/README-ZH.md
///
///
class MyRefresh<T> extends StatefulWidget {
  @override
  MyRefreshState<T> createState() => MyRefreshState<T>();

  const MyRefresh({
    Key key,
    @required this.loadDataCallBack,
    @required this.buildListItemCallBack,
    this.onDataChangeListener,
    this.pageSize = 10,
    this.headSlivers,
    this.bottomSlivers,
    this.needClearPhotoCache = false,
    this.isSliver = false,
    this.isNes = false,
    this.haveRefresh = true,
    this.loadingMoreBusyingWidget,
    this.fullScreenBusyingWidget,
    this.errorWidget,
    this.fullScreenErrorWidget,
    this.noMoreLoadWidget,
    this.emptyWidget,
    this.scrollController,
    this.physics,
  }) : super(key: key);

  ///滚动物理效果，默认Always
  final ScrollPhysics physics;

  ///滚动控制，非必传
  final ScrollController scrollController;

  ///数据变化的回调
  final OnDataChangeListener onDataChangeListener;

  ///加载列表数据的回调
  final LoadDataCallBack loadDataCallBack;

  ///默认一页的数据条数,默认10条
  final int pageSize;

  ///列表item的构建回调
  final BuildListItemCallBack<T> buildListItemCallBack;

  ///是否用于Sliver系列       default=false
  final bool isSliver;

  ///是否用于NestedScrollView    default=false
  final bool isNes;

  ///是否有下拉刷新     default true
  final bool haveRefresh;

  ///加载更多页的loading控件
  final Widget loadingMoreBusyingWidget;

  ///加载第一页的loading控件
  final Widget fullScreenBusyingWidget;

  ///加载更多页失败的控件
  final Widget errorWidget;

  ///加载第一页失败的控件
  final Widget fullScreenErrorWidget;

  ///没有更多页的控件
  final Widget noMoreLoadWidget;

  ///为空页的控件
  final Widget emptyWidget;

  /// 是否需要清理列表中的图片缓存，default=false，true时需要同时满足以下条件才有效
  /// 1：数据类需要 mixin [NeedClearPhotoCacheMixin]
  final bool needClearPhotoCache;

  ///列表的头部和底部，仅isSliver=true时才有效,且集合中所有widget也必须属于Sliver系列
  final List<Widget> headSlivers;

  final List<Widget> bottomSlivers;
}

class MyRefreshState<T> extends State<MyRefresh<T>> {
  //数据源
  MyLoadingMoreBase<T> _listSource;

  //列表的加载状态指示器
  MyLoadingMoreIndicator _loadingIndicator;

  //下拉刷新的State Key
  GlobalKey<RefreshIndicatorState> _refreshKey;

  @override
  void initState() {
    super.initState();

    if (widget.haveRefresh == true) {
      _refreshKey = new GlobalKey();
    }

    _listSource = MyLoadingMoreBase(
        loadDataCallBack: widget.loadDataCallBack,
        pageSize: widget.pageSize,
        onDataChangeListener: widget.onDataChangeListener);

    _loadingIndicator = MyLoadingMoreIndicator(
      listSourceRepository: _listSource,
      loadingMoreBusyingWidget: widget.loadingMoreBusyingWidget,
      fullScreenBusyingWidget: widget.fullScreenBusyingWidget,
      errorWidget: widget.errorWidget,
      fullScreenErrorWidget: widget.fullScreenErrorWidget,
      noMoreLoadWidget: widget.noMoreLoadWidget,
      emptyWidget: widget.emptyWidget,
      isSliver: widget.isSliver,
      //emptyIconColor: Color(),
      //emptyMsgColor: Color(),
    );
  }

  @override
  void dispose() {
    if (widget.needClearPhotoCache == true) {
      _clearPhotosMemory();
    }
    _listSource?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadMoreList = widget.isSliver == true
        ? _buildJustLoadMoreList4Sliver()
        : _buildJustLoadMoreList();

    if (widget.haveRefresh == false) return loadMoreList;

    return MyRefreshIndicator(
      refreshKey: _refreshKey,
      onRefresh: () => _listSource?.refresh(false),
      child: loadMoreList,
      isNes: widget.isNes,
    );
  }

  ///公开方法：回到顶部
  void goTop() async {
    //需要时请联系我
  }

  ///公开方法：主动刷新，参数为是否显示指示器
  void refresh(
      {bool showIndicator = false, bool clearBeforeRequest = true}) async {
    if (widget.haveRefresh != true) return;
    if (showIndicator == true) {
      _refreshKey?.currentState?.show();
    } else {
      _listSource?.refresh(clearBeforeRequest);
    }
  }

  ///根据下标删除列表中某个元素
  void deleteItemByIndex({int index}) {
    if (index == -1 ||
        _listSource == null ||
        index == null ||
        index >= _listSource.length) {
      return;
    }
    _listSource.removeAt(index);
    if (_listSource.length == 0) {
      _listSource.indicatorStatus = IndicatorStatus.empty;
    }
    _listSource.setState();
  }

  ///拿到当前列表所有数据
  List<T> getListData() {
    return _listSource;
  }

  ScrollPhysics get _defaultPhysics =>
      Platform.isIOS ? BouncingScrollPhysics() : ClampingScrollPhysics();

  ///普通的加载更多列表
  Widget _buildJustLoadMoreList() {
    return LoadingMoreList<T>(
      ListConfig<T>(
        physics: widget.physics ?? _defaultPhysics,
        controller: widget.scrollController,
        shrinkWrap: true,
        showGlowTrailing: false,
        showGlowLeading: false,
        indicatorBuilder: _loadingIndicator.build,
        itemBuilder: widget.buildListItemCallBack,
        sourceList: _listSource,
        extendedListDelegate: ExtendedListDelegate(
          collectGarbage:
              widget.needClearPhotoCache == true ? _collectGarbage : null,
        ),
      ),
    );
  }

  ///Sliver系列的加载更多列表
  Widget _buildJustLoadMoreList4Sliver() {
    var _list = LoadingMoreSliverList<T>(
      SliverListConfig<T>(
        indicatorBuilder: _loadingIndicator.build,
        itemBuilder: widget.buildListItemCallBack,
        sourceList: _listSource,
        lastChildLayoutType: LastChildLayoutType.foot,
        extendedListDelegate: ExtendedListDelegate(
          collectGarbage:
              widget.needClearPhotoCache == true ? _collectGarbage : null,
        ),
      ),
    );

    var _slivers = <Widget>[];

    //添加头部，如果有的话
    if ((widget.headSlivers?.length ?? 0) > 0) {
      _slivers.addAll(widget.headSlivers);
    }
    //添加列表
    _slivers.add(_list);

    //添加底部
    if ((widget.bottomSlivers?.length ?? 0) > 0) {
      _slivers.addAll(widget.bottomSlivers);
    }

    return LoadingMoreCustomScrollView(
      controller: widget.scrollController,
      showGlowLeading: false,
      showGlowTrailing: false,
      rebuildCustomScrollView: true,
      physics: widget.physics ?? _defaultPhysics,
      slivers: _slivers,
    );
  }

  ///列表不可见部分回调，通常用于清理图片缓存
  void _collectGarbage(List<int> indexes) {
    indexes.forEach((index) {
      final item = _listSource[index];
      _clearItemMemory(item);
    });
  }

  ///清掉图片缓存 针对列表全部
  void _clearPhotosMemory() async {
    if ((_listSource?.length ?? 0) > 0) {
      _listSource.forEach((item) {
        _clearItemMemory(item);
      });
    }
  }

  ///清掉图片缓存 针对单个item
  void _clearItemMemory(T item) {
    if (item is NeedClearPhotoCacheMixin<T>) {
      var urlList = item.getClearPhotoPaths(item);
      evictNetworkImages(urlList);
    }
  }
}
