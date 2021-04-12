import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/router/app_router_navigator.dart';
import 'color.dart';
import 'icon.dart';

class ThemeUtils {
  static isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarDividerColor: null,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  /// 暗黑主题
  static ThemeData get darkTheme {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
      highlightColor: Colors.transparent,
      splashFactory: const _NoSplashFactory(),
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        color: Colors.black,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: TextStyle(fontSize: 15, color: Colors.white),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        elevation: 0.0,
        selectedItemColor: ColorUtils.color_text_theme,
        unselectedItemColor: Colors.white,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 28),
        selectedLabelStyle: TextStyle(fontSize: 10),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
    );
  }

  /// 默认的主题
  static ThemeData get defaultTheme {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.light,
      highlightColor: Colors.transparent,
      splashFactory: const _NoSplashFactory(),
      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        color: Colors.white,
        centerTitle: false,
        elevation: 0.0,
        iconTheme: IconThemeData(color: ColorUtils.color_text_level1, size: 32),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: ColorUtils.color_text_level1,
        unselectedLabelColor: ColorUtils.color_text_level2,
        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: ColorUtils.color_text_level1),
        unselectedLabelStyle: TextStyle(fontSize: 16, color: ColorUtils.color_text_level2),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0.0,
        selectedItemColor: ColorUtils.color_text_theme,
        unselectedItemColor: ColorUtils.color_text_level2,
        selectedIconTheme: IconThemeData(size: 20),
        unselectedIconTheme: IconThemeData(size: 20),
        selectedLabelStyle: TextStyle(fontSize: 10),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
    );
  }

  /// 获取appbar默认标题的文本style
  static TextStyle getAppBarTitleTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: isDarkMode(context) ? Colors.white : ColorUtils.color_text_level1,
    );
  }

  /// 统一获取默认返回按钮
  static Widget getDefaultLeading({bool needNotifyEventBus = false}) {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          tooltip: null,
          icon: const Icon(back, size: 15, color: ColorUtils.color_text_level1),
          onPressed: () {
            AppRouterNavigator.of(context).pop(needNotifyEventBus: needNotifyEventBus);
          },
        );
      },
    );
  }

  /// 统一获取默认close icon关闭
  static Widget get getDefaultCloseButton {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          tooltip: null,
          icon: const Icon(close, color: ColorUtils.color_text_level1, size: 15),
          onPressed: () async {
            if (AppRouterNavigator.of(context).length == 1) {
              if (Platform.isIOS) {
                exit(0);
              } else {
                await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }
            } else {
              AppRouterNavigator.of(context).pop();
            }
          },
        );
      },
    );
  }
}

/// 去掉水波纹
class _NoSplashFactory extends InteractiveInkFeatureFactory {
  const _NoSplashFactory();

  InteractiveInkFeature create({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
    @required Offset position,
    @required Color color,
    TextDirection textDirection,
    bool containedInkWell: false,
    RectCallback rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    VoidCallback onRemoved,
  }) {
    return _NoSplash(
      controller: controller,
      referenceBox: referenceBox,
      color: color,
      onRemoved: onRemoved,
    );
  }
}

class _NoSplash extends InteractiveInkFeature {
  _NoSplash({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
    Color color,
    VoidCallback onRemoved,
  })  : assert(controller != null),
        assert(referenceBox != null),
        super(controller: controller, referenceBox: referenceBox, onRemoved: onRemoved) {
    controller.addInkFeature(this);
  }
  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
}
