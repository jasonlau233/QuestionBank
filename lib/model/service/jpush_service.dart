import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/utils/device_info.dart';
import 'package:uuid/uuid.dart';

import '../../constants/network_path_constants.dart';
import '../../core/manager.dart';
import '../../core/network/http.dart';

class JpushService {
  /// 获取用户数据
  static Future<void> registerPushToken(String userId, String pushToken) async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    try {
      String deviceUuid = "";
      String deviceType = "";
      String deviceModel = "";
      String deviceName = "";
      if (Platform.isIOS) {
        deviceType = "2";
        final IosDeviceInfo iosDeviceInfo = await DeviceInfoUtils.instance.getIosDeviceInfo;
        deviceUuid = iosDeviceInfo.identifierForVendor;
        deviceName = iosDeviceInfo.name;
        deviceModel = "${iosDeviceInfo.model}/${iosDeviceInfo.systemVersion}";
      } else if (Platform.isAndroid) {
        final AndroidDeviceInfo androidDeviceInfo = await DeviceInfoUtils.instance.getAndroidDeviceInfo;
        deviceUuid = androidDeviceInfo.androidId;
        deviceType = "1";
        deviceName = androidDeviceInfo.device;
        deviceModel =
            "${androidDeviceInfo.manufacturer}/${androidDeviceInfo.model}/${androidDeviceInfo.version.sdkInt}";
      }

      await HttpNativeClient.shared.post<dynamic>(
        Manager.shared.getNotifyHostUrl + registerPushTokenToServer,
        data: <String, dynamic>{
          "pushToken": pushToken,
          "systemId": BuildConfig.serverJPushSystemId,
          "tag": Manager.shared.config.env == HttpEnv.Production ? "" : "测试",
          "userId": userId,
          "deviceUuid": deviceUuid,
          "deviceType": deviceType,
          "deviceName": deviceName,
          "deviceModel": deviceModel,
        },
        options: Options(
          headers: <String, dynamic>{
            "request-id": Uuid().v1(),
            "appId": BuildConfig.serverJPushAppId,
            "source": BuildConfig.serverJPushSystemId,
            "sign": md5.convert(
              Utf8Encoder().convert(
                BuildConfig.serverJPushAppSecret + timestamp.toString(),
              ),
            ),
            "timestamp": timestamp,
          },
        ),
      );
      return true;
    } catch (err) {
      print(err);
      return null;
    }
  }
}
