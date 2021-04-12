import 'package:flutter/material.dart';
import 'package:question_bank/utils/color.dart';

/// 默认的头部刷新
class MyRefreshIndicator extends StatelessWidget {
  const MyRefreshIndicator({
    this.refreshKey,
    Key key,
    @required this.onRefresh,
    @required this.child,
    this.isNes = false,
  }) : super(key: key);

  final Key refreshKey;

  /// 刷新回调
  final RefreshCallback onRefresh;

  /// 子部件 （eg: [ListView]）
  final Widget child;

  /// 是否用于NestedScrollView default=false
  final bool isNes;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      color: ColorUtils.color_bg_theme,
      backgroundColor: Colors.white,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
