class BuildConfig {
  static const bool debug = false;
  static const String appName = "初级考霸题库";

  /// 产品线
  static const int productLine = 1;

  ///标题栏高度
  static const double appBarHeight = 48;

  ///错题本的subId
  static const String ERROR_ID = '-1001';

  /// 对应的极光推送配置
  static const String serverJPushAppId = "d3ed7d0e7da0434da32f5a2aed6a04e8";
  static const int serverJPushSystemId = 10100000000004;
  static const String serverJPushAppSecret = "55156a6719c54be38abdcc3d5902b805";
  static const String androidJPushAppKey = '8030ecdc2ac72e92c4b9b3b7';
  static const String iosJPushAppKey = '8030ecdc2ac72e92c4b9b3b7';

  /// 和Android配置的channel一直
  static const String jPushChannel = "developer-default";
}
