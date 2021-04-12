import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_bank/constants/eventbus_key_constants.dart';
import 'package:question_bank/utils/event_bus.dart';
import 'package:question_bank/utils/toast.dart';

import '../../provider/view_model/common.dart';
import '../../route/path.dart';
import '../../route/router.dart';

class AppRouterNavigator extends StatefulWidget {
  const AppRouterNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.initialPages,
  }) : super(key: key);

  /// 导航key
  final GlobalKey<NavigatorState> navigatorKey;

  /// 初始化的路由
  final List<Page<Object>> initialPages;

  static AppRouterNavigatorState of(BuildContext context) {
    return context.findAncestorStateOfType<AppRouterNavigatorState>();
  }

  @override
  AppRouterNavigatorState createState() => AppRouterNavigatorState();
}

class AppRouterNavigatorState extends State<AppRouterNavigator> {
  /// 页面栈
  final List<Page> _stack = <Page>[];

  @override
  void initState() {
    super.initState();
    _stack.addAll(widget.initialPages);
  }

  /// 获取当前页面
  String get currentPageName => _stack.isEmpty ? null : _stack.last.name;

  /// 直接清空所有栈，显示默认的页面
  void setRoot(String path) {
    _stack.clear();
    push(path);
  }

  /// 推入新的页面
  void push(
    String path, {
    bool needLogin = false,
    Map<String, dynamic> params: const {},
  }) {
    setState(
      () {
        _stack.add(
          needLogin && !Provider.of<Common>(context, listen: false).isLogin
              ? getRoute(
                  LOGIN_PATH,
                  params: params,
                )
              : getRoute(path, params: params),
        );
      },
    );
  }

  /// 退出
  bool pop({bool needNotifyEventBus = false}) {
    if (_stack.isNotEmpty) {
      setState(
        () => _stack.remove(_stack[_stack.length - 1]),
      );
      if (needNotifyEventBus) {
        EventBus.instance.post(EVENTBUS_PAGE_DESTROY_KEY, currentPageName);
      }
      return true;
    }
    return false;
  }

  /// 退出
  bool isEmpty() => _stack.isEmpty;

  /// 长度
  int get length => _stack.length;

  /// 删除某个页面
  bool remove(Page page) {
    final int index = _stack.indexOf(page);
    if (index == -1) {
      return false;
    }
    setState(
      () => _stack.remove(page),
    );
    return true;
  }

  /// 替换当前页面
  bool replace(
    String path, {
    Map<String, dynamic> params: const {},
    bool needNotifyEventBus: false,
  }) {
    if (_stack.isNotEmpty) {
      _stack.remove(_stack[_stack.length - 1]);
    }

    if (needNotifyEventBus) {
      EventBus.instance.post(EVENTBUS_PAGE_DESTROY_KEY, currentPageName);
    }

    push(path, params: params);
    return true;
  }

  /// 页面退出检查
  bool _onPopPage(Route<dynamic> route, dynamic result) {
    /// 不管如何是否有modal出现都要关闭，以免操作loading成卡主导致了没有关闭，导致栈已经进行更新
    ToastUtils.cleanAllLoading();

    if (!route.didPop(result)) {
      return false;
    }

    if (_stack.isNotEmpty) {
      final bool isRemove = remove(route.settings as Page);
      if (isRemove && route.settings.name == EXAMINATION_PATH) {
        /// 发送页面关闭通知，让有需要的页面去判断是否需要刷新页面
        /// 让他在后台在进行，如果不后台操作,可能在执行动画导致有问题卡顿
        EventBus.instance.post(EVENTBUS_PAGE_DESTROY_KEY, currentPageName);
      }
      return isRemove;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(key: widget.navigatorKey, onPopPage: _onPopPage, pages: List.of(_stack));
  }
}
