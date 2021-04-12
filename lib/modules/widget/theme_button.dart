import 'dart:math';

import 'package:flutter/material.dart';

import '../../utils/color.dart';
import '../../widget/lock_gesture_detector.dart';

///
/// 主题样式的按钮
///
class ThemeButton extends StatelessWidget {
  const ThemeButton(
    this.text, {
    Key key,
    this.width,
    this.height,
    this.onItemClickListenCallback,
    this.decoration,
  }) : super(key: key);

  /// 按钮文字
  final String text;

  /// 按钮点击事件
  final OnItemClickListenCallback onItemClickListenCallback;

  /// 按钮宽度
  final double width;

  /// 按钮高度
  final double height;

  /// 最小限制
  final double _minWidth = 82;
  final double _minHeight = 30;

  /// 装饰
  final Decoration decoration;

  @override
  Widget build(BuildContext context) {
    var tmpMinHeight = max((height ?? 0), _minHeight);
    return LockGestureDetector(
      onItemClickListenCallback: onItemClickListenCallback,
      child: Text(
        text ?? '',
        style:
            const TextStyle(fontSize: 14, color: ColorUtils.color_text_theme),
      ),
    );
  }

  /*
  *   @override
  Widget build(BuildContext context) {
    var tmpMinHeight = max((height ?? 0), _minHeight);
    return LockGestureDetector(
      onItemClickListenCallback: onItemClickListenCallback,
      child: Container(
        width: width ?? _minWidth,
        height: height ?? _minHeight,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
        constraints: BoxConstraints(
          minWidth: max((width ?? 0), _minWidth),
          minHeight: tmpMinHeight,
        ),
        decoration: decoration ??
            BoxDecoration(
              color: ColorUtils.color_textBg_choose_select_choose,
              borderRadius:
                  BorderRadius.all(Radius.circular(tmpMinHeight / 2.0)),
              border: Border.all(color: ColorUtils.color_bg_theme, width: 1),
            ),
        child: Text(
          text ?? '',
          style:
              const TextStyle(fontSize: 9, color: ColorUtils.color_text_theme),
        ),
      ),
    );
  }*/
}
