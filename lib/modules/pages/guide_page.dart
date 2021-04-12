import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:question_bank/constants/storage_key_constants.dart';
import 'package:question_bank/core/router/app_router_navigator.dart';
import 'package:question_bank/route/path.dart';
import 'package:question_bank/utils/storage.dart';

///引导页
class GuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _createPageView(context),
    );
  }

  Widget _createPageView(context) {
    return PageView(
      dragStartBehavior: DragStartBehavior.down,
      children: <Widget>[
        Container(
          child: Center(
            child: Image.asset('assets/images/guide/guide_one.png'),
          ),
        ),
        Container(
          child: Center(
            child: Image.asset('assets/images/guide/guide_two.png'),
          ),
        ),
        Container(
          child: Center(
            child: Image.asset('assets/images/guide/guide_three.png'),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            AppRouterNavigator.of(context).replace(LOGIN_PATH);
            StorageUtils.setBool(STORAGE_FIRST_IN, false);
          },
          child: Container(
            child: Center(
              child: Image.asset('assets/images/guide/guide_four.png'),
            ),
          ),
        ),
      ],
    );
  }
}
