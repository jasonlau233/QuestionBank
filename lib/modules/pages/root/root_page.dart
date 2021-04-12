import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:question_bank/constants/eventbus_key_constants.dart';
import 'package:question_bank/utils/event_bus.dart';
import 'package:question_bank/widget/custom_widget.dart';

import '../../../core/router/app_router_navigator.dart';
import '../../../modules/pages/my_page.dart';
import '../../../provider/view_model/common.dart';
import '../../../route/path.dart' show GUIDE_PATH, LOGIN_PATH;
import '../../../utils/icon.dart';
import '../practice/practice_page.dart';
import 'widget/navigator_bar.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  /// 对应的pageView controller;
  PageController _pageController;

  @override
  void initState() {
    super.initState();

    /// 启动需要注册的事件名字
    EventBus.instance.registerAll(
      [
        EVENTBUS_PAGE_DESTROY_KEY,
      ],
    );
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    EventBus.instance.destroy();
    super.dispose();
  }

  /// 点击底部导航回调前
  bool _onItemClickBeforeListen(int index) {
    final bool isUserLogin = Provider.of<Common>(context, listen: false).isLogin;
    if (!isUserLogin) {
      AppRouterNavigator.of(context).push(LOGIN_PATH);
      return false;
    }
    return true;
  }

  /// 点击底部导航回调后
  void _onItemClickAfterListen(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          showExitConfirmDialog();
          return false;
        },
        child: PageView.builder(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (BuildContext ctx, int index) {
            switch (index) {
              case 0:
                return PracticePage();
                break;

              case 1:
                return MyPage();
                break;

              default:
                return Container();
                break;
            }
          },
        ),
      ),
      bottomNavigationBar: NavigatorBar(
        onItemClickBeforeListen: _onItemClickBeforeListen,
        onItemClickAfterListen: _onItemClickAfterListen,
        items: [
          NavigatorBarItemBean(
            "练习",
            Icon(unSelectPractice),
            Icon(selectPractice),
          ),
          NavigatorBarItemBean(
            "我的",
            Icon(unSelectMy),
            Icon(selectMy),
          ),
        ],
      ),
    );
  }

  /// 退出弹窗
  void showExitConfirmDialog() async {
    final bool isSuccess = await showIosTipsDialog(context, '提示', '您确定要退出', cancel: () {
      Navigator.of(context).pop();
    }, confirm: () {
      Navigator.of(context).pop(true);
    });
    if (isSuccess == true) {
      await SystemNavigator.pop();
    }
  }
}
