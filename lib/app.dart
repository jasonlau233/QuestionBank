import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'config/build_config.dart';
import 'core/manager.dart';
import 'core/router/app_router_navigator.dart';
import 'route/path.dart' show ROOT_PATH;
import 'route/router.dart';
import 'utils/theme.dart';

/// 项目启动根实例
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: BuildConfig.appName,
      theme: ThemeUtils.defaultTheme,
      /// Todo UI没有去适配暗黑风格，APP也没必要去弄。太丑了。
      ///darkTheme: ThemeUtils.darkTheme,
      navigatorKey: Manager.shared.config.navigator,
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
      onGenerateRoute: (_) => null,
      builder: (BuildContext context, _) {
        return BotToastInit()(
          context,
          AppRouterNavigator(
            navigatorKey: Manager.shared.config.navigator,
            initialPages: [
              getRoute(ROOT_PATH),
            ],
          ),
        );
      },
      // 需要实现web请使用下面的拦截器
      // web使用的拦截器
      // routerDelegate: AppRouterDelegate(),
      // routeInformationParser: AppRouteInformationParser(),
    );
  }
}
