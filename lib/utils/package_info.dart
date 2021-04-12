import 'package:package_info/package_info.dart';

class PackageInfoUtils {
  /// app包信息
  PackageInfo _appPackageInfo;

  /// 工厂模式
  factory PackageInfoUtils() => _getInstance();

  /// 单例
  static PackageInfoUtils get instance => _getInstance();
  static PackageInfoUtils _instance;

  PackageInfoUtils._internal();

  static PackageInfoUtils _getInstance() {
    if (_instance == null) {
      _instance = PackageInfoUtils._internal();
    }
    return _instance;
  }

  /// 获取app buildConfig信息
  Future<PackageInfo> get getPackageInfo async {
    if (_appPackageInfo == null) {
      _appPackageInfo = await PackageInfo.fromPlatform();
    }
    return _appPackageInfo;
  }
}
