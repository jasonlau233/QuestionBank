import 'package:device_info/device_info.dart';

class DeviceInfoUtils {
  /// 设备信息
  AndroidDeviceInfo _androidInfo;
  IosDeviceInfo _iosInfo;

  /// 工厂模式
  factory DeviceInfoUtils() => _getInstance();

  /// 单例
  static DeviceInfoUtils get instance => _getInstance();
  static DeviceInfoUtils _instance;

  DeviceInfoUtils._internal();

  static DeviceInfoUtils _getInstance() {
    if (_instance == null) {
      _instance = DeviceInfoUtils._internal();
    }
    return _instance;
  }

  /// 获取Android设备信息
  Future<AndroidDeviceInfo> get getAndroidDeviceInfo async {
    if (_androidInfo == null) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      _androidInfo = await deviceInfo.androidInfo;
    }
    return _androidInfo;
  }

  /// 获取ios设备信息
  Future<IosDeviceInfo> get getIosDeviceInfo async {
    if (_iosInfo == null) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      _iosInfo = await deviceInfo.iosInfo;
    }
    return _iosInfo;
  }
}
