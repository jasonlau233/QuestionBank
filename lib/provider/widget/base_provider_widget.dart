import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider, Selector;

import '../../em/view_state_type.dart';
import '../../provider/view_model/base_view_model.dart';
import '../../widget/empty_data_container.dart';
import '../../widget/error_data_container.dart';
import '../../widget/loading_data_container.dart';

export 'package:provider/provider.dart' show Selector, Provider;

/// 基于ChangeNotifierProvider进行封装
class BaseProviderWidget<T extends BaseViewModel> extends StatefulWidget {
  /// 对应的provider监听
  final T viewModel;

  /// 对应的子类
  final Widget child;

  /// 空数据布局
  final Widget emptyChild;

  /// loading布局
  final Widget loadingChild;

  /// 错误布局
  final Widget errChild;

  /// 加载的文字标识
  final String title;

  /// 加载的文字标识
  final String emptyTitle;

  /// 加载的文字标识
  final String errorTitle;

  /// provider的过渡
  final TransitionBuilder transitionBuilder;

  /// 是否自动释放
  final bool autoDispose;

  /// 是否显示头部
  final bool showHeader;

  /// 回调函数
  final void Function(T viewModel) onModelReady;

  BaseProviderWidget({
    Key key,
    @required this.viewModel,
    @required this.child,
    this.autoDispose = true,
    this.onModelReady,
    this.showHeader = false,
    this.transitionBuilder,
    this.emptyChild,
    this.loadingChild,
    this.errChild,
    this.title = "正在加载中",
    this.emptyTitle = "暂无相关数据",
    this.errorTitle = "加载失败...",
  })  : assert(viewModel != null),
        assert(child != null),
        super(key: key);

  _BaseProviderWidgetState<T> createState() => _BaseProviderWidgetState<T>();
}

class _BaseProviderWidgetState<S extends BaseViewModel> extends State<BaseProviderWidget<S>> {
  @override
  void initState() {
    super.initState();
    if (widget.onModelReady != null) {
      widget.onModelReady.call(widget.viewModel);
    }
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      widget.viewModel?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<S>.value(
      value: widget.viewModel,
      child: Selector<S, ViewState>(
        builder: (_, ViewState value, Widget child) {
          switch (value) {
            case ViewState.Loading:
              return widget.loadingChild ?? LoadingDataContainer(showHeader: widget.showHeader, title: widget.title);
              break;
            case ViewState.Error:
              return widget.errChild ??
                  ErrorDataContainer(
                    title: widget.errorTitle,
                    onRefresh: () => widget.onModelReady?.call(widget.viewModel),
                    showHeader: widget.showHeader,
                  );
              break;
            case ViewState.Empty:
              return widget.emptyChild ??
                  EmptyDataContainer(
                    title: widget.emptyTitle,
                    showHeader: widget.showHeader,
                  );
              break;
            case ViewState.Idle:
            default:
              return widget.child;
              break;
          }
        },
        selector: (_, S model) => model.viewState,
      ),
      builder: widget.transitionBuilder,
    );
  }
}
