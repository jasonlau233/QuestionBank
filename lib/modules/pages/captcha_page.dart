import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/captcha_page_style.dart';
import '../../constants/storage_key_constants.dart';
import '../../core/manager.dart';
import '../../core/router/app_router_navigator.dart';
import '../../model/data/storage_user_info_entity.dart';
import '../../provider/view_model/captcha_view_model.dart';
import '../../provider/view_model/common.dart';
import '../../provider/widget/base_provider_widget.dart';
import '../../route/path.dart';
import '../../utils/color.dart';
import '../../utils/storage.dart';
import '../../utils/theme.dart';
import '../../utils/toast.dart';

class CaptchaPage extends StatefulWidget {
  /// 手机号码
  final String phone;

  const CaptchaPage({Key key, @required this.phone}) : super(key: key);

  @override
  _CaptchaPageState createState() => _CaptchaPageState();
}

class _CaptchaPageState extends State<CaptchaPage> with WidgetsBindingObserver {
  /// view model
  CaptchaModel _captchaModel;

  /// 文本控制器
  TextEditingController _numberController = TextEditingController();

  /// 焦点
  FocusNode _numberNode = FocusNode();

  /// 短信验证码锁
  bool _smsCaptchaIsStartRequest = false;

  /// 登录锁
  bool _loginLock = false;

  /// 验证码倒计时
  Timer _countDownTimer;

  @override
  void initState() {
    super.initState();
    _captchaModel = CaptchaModel();
  }

  @override
  void dispose() {
    _clearCountDownTimer();
    _numberNode.dispose();
    _numberController.dispose();
    _captchaModel = null;
    super.dispose();
  }

  /// 创建定时器
  void _createCountDownTimer() {
    if (_countDownTimer == null) {
      _countDownTimer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (timer.tick == 60) {
            timer.cancel();
            _countDownTimer = null;
          }
          if (_captchaModel != null) {
            if (_captchaModel.captchaTimeInterval != 0) {
              _captchaModel.captchaTimeInterval--;
            }
          }
        },
      );
    }
  }

  /// 创建定时器
  void _clearCountDownTimer() {
    if (_countDownTimer != null) {
      _countDownTimer.cancel();
      _countDownTimer = null;
    }
  }

  /// 获取验证码
  void _getCaptcha() async {
    if (_smsCaptchaIsStartRequest || _captchaModel.captchaTimeInterval != 0) {
      return;
    }

    _smsCaptchaIsStartRequest = true;
    final bool isSuccess = await _captchaModel.getSmsCaptcha(widget.phone);
    _smsCaptchaIsStartRequest = false;
    if (!isSuccess) {
    } else {
      _captchaModel.captchaTimeInterval = 59;
      _createCountDownTimer();
      return ToastUtils.showText(text: "验证码发送成功");
    }
  }

  /// 模型加载
  void _onModelReady(CaptchaModel model) async {
    final bool isSuccess = await model.getSmsCaptcha(widget.phone);
    if (isSuccess) {
      _captchaModel.captchaTimeInterval = 59;
      _createCountDownTimer();
      return ToastUtils.showText(text: "验证码发送成功");
    }
  }

  /// 检查验证码
  void _checkCaptchaCode(String value) async {
    if (value != _captchaModel.captchaCode) {
      if (value.isEmpty) {
        _captchaModel.captchaCode = "????";
        return;
      }
      final int codeLen = 4 - value.length;
      if (codeLen == 0) {
        /// 可以执行对应的请求后端了 满足了4位数字
        _captchaModel.captchaCode = value;
        await _doLogin(value);
      } else {
        for (int i = 0; i < codeLen; i++) {
          value += "?";
        }
        _captchaModel.captchaCode = value;
      }
    }
  }

  ///标题
  Widget get _buildTitle {
    return Container(
      margin: const EdgeInsets.only(top: 36),
      padding: const EdgeInsets.only(left: 28, right: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('输入验证码', style: titleStyle),
          Container(
            margin: const EdgeInsets.only(top: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('验证码已发送至' + widget.phone, style: descStyle),
                GestureDetector(onTap: _getCaptcha, child: _buildSendCaptchaButton)
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 获取验证码按钮
  Widget get _buildSendCaptchaButton {
    return Selector<CaptchaModel, int>(
      selector: (BuildContext context, CaptchaModel model) {
        return model.captchaTimeInterval;
      },
      builder: (BuildContext context, int value, Widget child) {
        String text = "重新获取";
        if (value != 0) {
          text = "(${value}s)后重新获取";
        }
        return Text(text, style: captchaTextStyle);
      },
    );
  }

  /// 账号
  Widget get _buildTextField {
    return Container(
      margin: const EdgeInsets.only(top: 73),
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: 0,
            duration: const Duration(milliseconds: 250),
            child: Container(
              margin: const EdgeInsets.only(left: 28, right: 28),
              child: TextField(
                style: TextStyle(fontSize: 16, color: ColorUtils.color_text_level1),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                autofocus: true,
                autofillHints: [AutofillHints.oneTimeCode],
                textInputAction: TextInputAction.done,
                controller: _numberController,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                onChanged: _checkCaptchaCode,
                obscureText: false,
                onSubmitted: _checkCaptchaCode,
                maxLines: 1,
                maxLength: 4,
                cursorColor: ColorUtils.color_bg_theme,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              SystemChannels.textInput.invokeMethod('TextInput.show');
            },
            child: Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(left: 28, right: 28),
              child: Selector<CaptchaModel, String>(
                selector: (BuildContext context, CaptchaModel model) {
                  return model.captchaCode;
                },
                builder: (BuildContext context, String value, Widget child) {
                  if (value == "????") {
                    return child;
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      value.length,
                      (index) {
                        Widget textWidget;
                        //这个比较特殊，和文字一个颜色
                        Color borderColor = ColorUtils.color_text_level3;
                        if (value[index] != "?") {
                          //这个比较特殊，和文字一个颜色
                          borderColor = ColorUtils.color_text_level2;
                          textWidget = Text(
                            value[index],
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                          );
                        }
                        return Container(
                          alignment: Alignment.center,
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: borderColor, width: 1),
                            ),
                          ),
                          child: textWidget,
                        );
                      },
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: ColorUtils.color_text_level3, width: 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 登录
  Future<void> _doLogin(String value) async {
    if (!_loginLock) {
      _loginLock = true;
      final String token = await _captchaModel.loginToServer(widget.phone, value);
      _loginLock = false;
      if (token != null) {
        _numberNode.unfocus();
        Manager.shared.config = Manager.shared.config.copyWith(token: token);
        final StorageUserInfoEntity entity = await Provider.of<Common>(context, listen: false).getUserInfo(token);
        await StorageUtils.setString(STORAGE_USER_INFO_KEY, jsonEncode(entity.toJson()));
        Provider.of<Common>(context, listen: false).setLoginStatus();
        AppRouterNavigator.of(context).setRoot(ROOT_PATH);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseProviderWidget<CaptchaModel>(
      viewModel: _captchaModel,
      onModelReady: _onModelReady,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: ThemeUtils.getDefaultLeading(),
        ),
        body: GestureDetector(
          onTap: () {
            if (MediaQuery.of(context).viewInsets.bottom >= 0) {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            }
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildTitle,
                  Expanded(
                    child: _buildTextField,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
