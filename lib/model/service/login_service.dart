import 'dart:io';

import 'package:dio/dio.dart';

import '../../utils/package_info.dart';
import '../../constants/network_path_constants.dart';
import '../../core/manager.dart';
import '../../core/network/http.dart';

class LoginService {
  /// 登录
  static Future<String> sendUserLoginInfoToServer(String phone, String captcha) async {
    try {
      var packageInfo = await PackageInfoUtils.instance.getPackageInfo;
      var res = await HttpNativeClient.shared.post<dynamic>(
        Manager.shared.getNCBlueWhaleAuthHostUrl + ncSMSLogin,
        data: <String, dynamic>{
          "versionCode": int.tryParse(packageInfo.version.replaceAll(".", "")),
          "mobileNo": phone,
          "otp": captcha,
          "clientType": Platform.isIOS ? "ios" : "android",
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          extra: {
            "x-request-loading": true,
            "x-request-message": "正在登录...",
          },
        ),
      );
      return res.data["data"]["token"];
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取短信验证码
  static Future<bool> getSmsCaptcha(String phone) async {
    try {
      await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getNCBlueWhaleAuthHostUrl + ncSMSCaptcha,
        queryParameters: <String, dynamic>{"mobileNo": phone, "type": 3},
        options: Options(
          extra: {
            "x-request-loading": true,
            "x-request-message": "正在请求验证码",
          },
        ),
      );
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  /// 服务器退出登录
  static Future<void> exitUserLoginToServer() async {
    try {
      await HttpNativeClient.shared.post<dynamic>(
        Manager.shared.getNCBlueWhaleAuthHostUrl + ncUserLogout,
        data: <String, dynamic>{
          "token": Manager.shared.config.token,
        },
      );
    } catch (err) {
      print(err);
    }
  }
}
