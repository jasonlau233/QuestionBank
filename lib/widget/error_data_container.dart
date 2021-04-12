import 'package:flutter/material.dart';
import 'package:question_bank/utils/theme.dart';
import 'package:question_bank/widget/lock_gesture_detector.dart';

import '../utils/assets_bundle.dart';
import '../utils/color.dart';

typedef void OnRefresh();

class ErrorDataContainer extends StatelessWidget {
  /// 标题
  final String title;

  /// assets bundle图片ur;
  final String assetBundleUrl;

  final OnRefresh onRefresh;

  final bool showHeader;

  const ErrorDataContainer({
    Key key,
    this.title = "加载失败...",
    this.assetBundleUrl = errorDataName,
    this.onRefresh,
    this.showHeader = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showHeader
          ? AppBar(
              leading: ThemeUtils.getDefaultLeading(),
            )
          : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              emptyDataName,
              width: 165,
              height: 165,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level2),
            ),
            LockGestureDetector(
              onItemClickListenCallback: () async {
                onRefresh?.call();
                return true;
              },
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                height: 43,
                width: 192,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: ColorUtils.color_bg_theme,
                ),
                alignment: Alignment.center,
                child: Text(
                  "点击刷新",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
