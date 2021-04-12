import 'package:dio/dio.dart';
import '../../manager.dart';

/// 日志拦截器
class LoggerInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    final HttpOptions managerOptions = Manager.shared.config;
    if (managerOptions.logEnable) {
      print("✅ ==================================================================");
      print("✅ " + '${options.uri.toString()}');
      print('✅ METHOD:${options.method}');
      print('✅ HEADER:${options.headers}');
      if (options.method == 'GET') {
        print('✅ Body:${options.queryParameters}');
      } else {
        print('✅ Body:${options.data}');
      }
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    final HttpOptions managerOptions = Manager.shared.config;
    if (managerOptions.logEnable) {
      print("✅ ==================================================================");
      print('🇨🇳 Return Data:');
      print('🇨🇳 ${response.data}');
    }
    return super.onResponse(response);
  }
}
