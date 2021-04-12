import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/constants/network_path_constants.dart';
import 'package:question_bank/core/manager.dart';
import 'package:question_bank/utils/icon.dart';

import '../../core/router/app_router_navigator.dart';
import '../../modules/style/login_page_style.dart';
import '../../provider/view_model/login_view_model.dart';
import '../../provider/widget/base_provider_widget.dart';
import '../../route/path.dart';
import '../../utils/color.dart';
import '../../utils/theme.dart';
import '../../utils/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// view model
  LoginViewModel _loginViewModel;

  /// 文本控制器
  TextEditingController _accountEditingController = TextEditingController();

  /// 焦点
  FocusNode _accountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loginViewModel = LoginViewModel();
  }

  @override
  void dispose() {
    _accountFocusNode.dispose();
    _accountEditingController.dispose();
    _loginViewModel = null;
    super.dispose();
  }

  ///登录
  Widget get _buildTitle {
    return Container(
      margin: const EdgeInsets.only(bottom: 38, top: 36),
      padding: const EdgeInsets.only(left: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 36,
                width: 36,
                margin: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  "assets/images/logo.png",
                ),
              ),
              const Text('欢迎使用考霸题库', style: titleStyle),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 9),
            child: const Text('若该手机号未注册，我们将自动为您注册', style: descStyle),
          )
        ],
      ),
    );
  }

  /// 账号
  Widget get _accountTextField {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.only(left: 28, right: 28),
      child: TextField(
        style: TextStyle(fontSize: 16, color: ColorUtils.color_text_level1),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        focusNode: _accountFocusNode,
        textInputAction: TextInputAction.done,
        controller: _accountEditingController,
        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
        onChanged: (value) {
          if (value.isNotEmpty) {
            _loginViewModel.canUseLoginBtn = true;
          } else {
            _loginViewModel.canUseLoginBtn = false;
          }
        },
        obscureText: false,
        onSubmitted: (value) {},
        maxLines: 1,
        maxLength: 11,
        cursorColor: ColorUtils.color_bg_theme,
        decoration: InputDecoration(
          hintText: "请输入手机号码",
          hintStyle: hitTextStyle,
          suffix: GestureDetector(
            onTap: () {
              _accountEditingController.clear();
            },
            child: Icon(clear, size: 16, color: ColorUtils.color_text_level3),
          ),
          counterText: "",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.color_bg_splitLine),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.color_bg_splitLine),
          ),
          hintMaxLines: 1,
        ),
      ),
    );
  }

  /// 构建协议
  Widget get _buildPrivacyAgreement {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "登陆即代表同意",
                style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level1),
              ),
              TextSpan(
                text: "《用户使用协议》",
                style: TextStyle(fontSize: 12, color: ColorUtils.color_text_theme),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AppRouterNavigator.of(context).push(
                      USER_MANUAL_PATH,
                      params: {
                        "url": Manager.shared.getHtml5HostUrl + userPrivacy,
                      },
                    );
                  },
              ),
              TextSpan(
                text: "和",
                style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level1),
              ),
              TextSpan(
                text: "《隐私协议》",
                style: TextStyle(height: 1.5, fontSize: 12, color: ColorUtils.color_text_theme),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AppRouterNavigator.of(context).push(
                      USER_PRIVACY_AGREEMENT_PATH,
                      params: {
                        "url": Manager.shared.getHtml5HostUrl + privacy,
                      },
                    );
                  },
              ),
            ],
          )),
    );
  }

  /// 前往验证码页面
  void _doGetCaptcha() async {
    if (_loginViewModel.canUseLoginBtn) {
      /// 验证是否正确的手机号码格式
      final String phone = _accountEditingController.value.text.trim();
      if (!RegExp(r"1[0-9]\d{9}$").hasMatch(phone)) {
        ToastUtils.showText(text: "手机号码错误");
        _accountFocusNode.requestFocus();
        return;
      }
      _accountFocusNode.unfocus();
      AppRouterNavigator.of(context).push(
        CAPTCHA_PATH,
        params: <String, dynamic>{"phone": phone},
      );
    }
  }

  /// 构建登录按钮
  Widget get _buildLoginButton {
    return Padding(
      padding: const EdgeInsets.only(top: 33),
      child: GestureDetector(
        onTap: _doGetCaptcha,
        child: Selector<LoginViewModel, bool>(
          selector: (BuildContext context, LoginViewModel model) {
            return model.canUseLoginBtn;
          },
          builder: (BuildContext context, bool value, Widget child) {
            return AnimatedCrossFade(
              firstChild: Container(
                alignment: Alignment.center,
                height: 48,
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: ColorUtils.color_bg_theme,
                ),
                child: child,
              ),
              secondChild: Container(
                alignment: Alignment.center,
                height: 48,
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: ColorUtils.color_bg_theme_notClick,
                ),
                child: child,
              ),
              crossFadeState: value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 350),
            );
          },
          child: Text(
            "获取验证码",
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseProviderWidget<LoginViewModel>(
      viewModel: _loginViewModel,
      child: GestureDetector(
        onTap: () {
          if (MediaQuery.of(context).viewInsets.bottom >= 0) {
            _accountFocusNode.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // leading: ThemeUtils.getDefaultCloseButton,
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     switch (Manager.shared.config.env) {
          //       case HttpEnv.Production:
          //         Manager.shared.config = Manager.shared.config.copyWith(env: HttpEnv.Test);
          //         break;
          //       case HttpEnv.Test:
          //         Manager.shared.config = Manager.shared.config.copyWith(env: HttpEnv.Production);
          //         break;
          //     }
          //     setState(() {});
          //   },
          //   child: Text(
          //     Manager.shared.config.env == HttpEnv.Test ? "测试" : "生产",
          //     style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          //   ),
          // ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildTitle,
                      _accountTextField,
                      _buildLoginButton,
                    ],
                  ),
                ),
                SafeArea(
                  bottom: true,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildPrivacyAgreement,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
