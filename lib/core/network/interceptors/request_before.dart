import 'package:dio/dio.dart';

import '../../../utils/toast.dart';
import '../../manager.dart';

/// 请求钱
class RequestBeforeInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    /// 设置请求头的header
    options.headers["token"] = Manager.shared.config.token;

    /// 检查是否请求接口需要自动调用到对应的弹出层
    if (options.extra != null) {
      /// 检查是否需要弹起loading
      final bool showLoading = options.extra.containsKey("x-request-loading");
      final bool showLoadingMessage =
          options.extra.containsKey("x-request-message");

      if (showLoading) {
        if (showLoadingMessage) {
          ToastUtils.showGeneralLoading(
              title: options.extra["x-request-message"]);
        } else {
          ToastUtils.showGeneralLoading();
        }
      }
    }
    return super.onRequest(options);
  }
}
