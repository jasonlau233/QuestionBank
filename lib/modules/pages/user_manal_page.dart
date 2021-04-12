import 'package:flutter/material.dart';
import 'package:question_bank/config/build_config.dart';

import '../../utils/theme.dart';
import '../../widget/native_webview.dart';

class UserManualPage extends StatelessWidget {
  final String url;

  const UserManualPage({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(BuildConfig.appBarHeight),
        child: AppBar(
          leading: ThemeUtils.getDefaultLeading(),
          centerTitle: true,
          title: Text(
            "用户使用协议",
            style: ThemeUtils.getAppBarTitleTextStyle(context),
          ),
        ),
      ),
      body: NativeWebView(url: url),
    );
  }
}
