import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:question_bank/utils/theme.dart';

import '../app.dart';
import '../config/build_config_poly_v.dart';
import '../provider/view_model/common.dart';
import 'manager.dart';

/// 启动项目
void bootApplication() {
  /// 平滑滚动以提供不匹配的输入和显示频率
  /// 当输入和显示频率不同时，Flutter团队与Google内部合作伙伴合作，极大地提高了滚动性能。
  /// 例如，Pixel 4输入的运行频率为120hz，而显示屏的运行频率为90hz。滚动时，这种不匹配会导致性能下降。
  /// 使用新的resamplingEnabled标志，您可以利用我们在Flutter中完成的性能工作来解决此问题：
  /// GestureBinding.instance.resamplingEnabled = true;

  /// 只为了存储导航context的key
  Manager.shared.config = Manager.shared.config.copyWith(navigator: GlobalKey<NavigatorState>());

  /// 注册Flutter框架的异常回调
  FlutterError.onError = (FlutterErrorDetails details) async {
    /// 转发至Zone的错误回调
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  runZoned<Future<Null>>(
    () async {
      /// 启动
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<Common>(create: (_) => Common()),
          ],
          child: App(),
        ),
      );
    },
    onError: (error, stackTrace) async {
      /// 针对接口地址来选择是否需要打印
      if (Manager.shared.config.env == HttpEnv.Test) {
        print(error);
        print(stackTrace);
        return;
      }
      await _reportErrorToBuglyServer(error, stackTrace);
    },
  );

  /// 限制App图片缓存个数 100
  PaintingBinding.instance.imageCache.maximumSize = 100;

  /// 限制App图片缓存大小 50m
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20;

  /// 配置状态栏的操作
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: null,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  BuildConfigPolyV.initPolyVSDK();
}

/// 上报数据至Bugly服务器
Future<Null> _reportErrorToBuglyServer(dynamic error, dynamic stackTrace) async {
  /// 实现原生bugly插件
}
