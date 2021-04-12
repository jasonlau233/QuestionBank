import 'package:dio/native_imp.dart';
import '../manager.dart';

import 'interceptors/logger.dart';
import 'interceptors/request_before.dart';
import 'interceptors/response_after.dart';

/// 网络请求
class HttpNativeClient extends DioForNative {
  /// 工厂模式
  factory HttpNativeClient() => _getInstance();

  /// 单利
  static HttpNativeClient get shared => _getInstance();
  static HttpNativeClient _instance;

  HttpNativeClient._internal();

  static HttpNativeClient _getInstance() {
    if (_instance == null) {
      _instance = new HttpNativeClient._internal();
      _instance._init();
    }
    return _instance;
  }

  /// 初始化配置等等之类
  void _init() {
    final HttpOptions os = Manager.shared.config;
    options.connectTimeout = os.connectTimeout;
    options.receiveTimeout = os.receiveTimeout;
    options.sendTimeout = os.sendTimeout;
    interceptors.addAll([
      RequestBeforeInterceptors(),
      LoggerInterceptors(),
      ResponseAfterInterceptors(),
    ]);
  }
}
