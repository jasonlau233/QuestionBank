import 'package:flutter/material.dart';
import 'package:question_bank/widget/custom_widget.dart';

import '../../core/router/app_router_navigator.dart';
import '../../model/data/storage_user_info_entity.dart';
import '../../provider/view_model/common.dart';
import '../../provider/widget/base_provider_widget.dart';
import '../../route/path.dart';
import '../../utils/color.dart';
import '../../utils/icon.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// 构建用户信息栏目
  Widget get _buildUserInfo {
    return Selector<Common, StorageUserInfoEntity>(
      selector: (BuildContext context, Common model) {
        return model.storageUserInfoEntity;
      },
      builder: (BuildContext context, StorageUserInfoEntity value, Widget child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                value.avatar,
                fit: BoxFit.cover,
                width: 114.0,
                height: 114.0,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 9),
              child: Text(
                value.nickname,
                style: TextStyle(color: ColorUtils.color_text_level1, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          ],
        );
      },
    );
  }

  /// 退出登录
  void _exitLogin() async {
    final bool isConfirm = await showIosTipsDialog(
      context,
      '退出登陆',
      '是否退出当前账号?',
      cancel: () {
        Navigator.of(context).pop(false);
      },
      confirm: () {
        Navigator.of(context).pop(true);
      },
    );

    if (isConfirm) {
      if (mounted) {
        await Provider.of<Common>(context, listen: false).exitLogin();
        Future.delayed(
          const Duration(milliseconds: 350),
          () => AppRouterNavigator.of(context).setRoot(LOGIN_PATH),
        );
      }
    }
  }

  /// 构建我的信息
  Widget get _buildMyInfo {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      height: 180,
      child: _buildUserInfo,
    );
  }

  /// 构建我的信息
  Widget _buildItem(String title, IconData iconData) {
    return Container(
      color: Colors.white,
      height: 42,
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(iconData, size: 15, color: ColorUtils.color_text_level1),
              Container(
                margin: const EdgeInsets.only(left: 9),
                child: Text(
                  title,
                  style: TextStyle(color: ColorUtils.color_text_level1, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          const Icon(arrowForward, size: 14, color: ColorUtils.color_text_level1),
        ],
      ),
    );
  }

  /// 构建我的信息
  Widget get _buildExitLoginButton {
    return GestureDetector(
      onTap: _exitLogin,
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        // width: 319,
        height: 40,
        child: const Text(
          "退出登录",
          style: TextStyle(
            color: ColorUtils.color_text_level1,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMyInfo,
          _buildItem("修改昵称", updateNickname),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Container(color: ColorUtils.color_bg_splitLine, height: 1),
          ),
          _buildItem("关于我们", aboutUs),
          _buildExitLoginButton,
        ],
      ),
    );
  }
}
