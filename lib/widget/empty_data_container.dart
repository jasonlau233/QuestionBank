import 'package:flutter/material.dart';
import 'package:question_bank/utils/color.dart';
import 'package:question_bank/utils/theme.dart';

import '../utils/assets_bundle.dart';

class EmptyDataContainer extends StatelessWidget {
  /// 标题
  final String title;

  /// assets bundle图片ur;
  final String assetBundleUrl;

  final bool showHeader;

  const EmptyDataContainer({Key key, this.title = "暂无相关数据", this.assetBundleUrl = errorDataName, this.showHeader = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showHeader
          ? AppBar(
              automaticallyImplyLeading: false,
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
          ],
        ),
      ),
    );
  }
}
