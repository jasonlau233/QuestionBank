import 'package:flutter/foundation.dart';
import 'package:question_bank/provider/view_model/base_view_model.dart';

import '../../model/service/login_service.dart';

class CaptchaModel extends BaseViewModel {
  /// 验证码倒计时
  int _captchaTimeInterval = 0;

  int get captchaTimeInterval => _captchaTimeInterval;

  set captchaTimeInterval(int time) {
    if (time == _captchaTimeInterval) return;
    _captchaTimeInterval = time;
    notifyListeners();
  }

  /// 验证码
  String _captchaCode = "????";

  String get captchaCode => _captchaCode;

  set captchaCode(String code) {
    if (code == _captchaCode) return;
    _captchaCode = code;
    notifyListeners();
  }

  /// 获取对应的短信验证码
  Future<bool> getSmsCaptcha(String phone) async {
    return await LoginService.getSmsCaptcha(phone);
  }

  /// 获取对应的短信验证码
  Future<String> loginToServer(String phone, String captcha) async {
    return await LoginService.sendUserLoginInfoToServer(phone, captcha);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
