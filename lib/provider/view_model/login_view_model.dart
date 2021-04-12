import 'package:flutter/foundation.dart';
import 'base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  /// 是否可以请求登录接口
  bool _canUseLoginBtn = false;

  bool get canUseLoginBtn => _canUseLoginBtn;

  set canUseLoginBtn(bool canUse) {
    if (canUse == _canUseLoginBtn) return;
    _canUseLoginBtn = canUse;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
