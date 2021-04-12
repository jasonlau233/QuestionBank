import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import '../../../core/manager.dart';
import '../../../core/router/app_router_navigator.dart';
import '../../../route/path.dart';

import '../../../core/network/data/server_response_entity.dart';
import '../../../utils/toast.dart';
import '../error/response_error.dart';
import '../http.dart';

/// 响应拦截器
class ResponseAfterInterceptors extends InterceptorsWrapper {
  @override
  Future onResponse(Response response) {
    Future.delayed(const Duration(milliseconds: 350), () => ToastUtils.cleanAllLoading());

    if (response.statusCode != 200) {
      return HttpNativeClient.shared.reject(
        ResponseError.exception(Exception.unacceptableStatusCode),
      );
    }

    if (response.data == null) {
      return HttpNativeClient.shared.reject(
        ResponseError.exception(Exception.dataNotFound),
      );
    }

    var json;

    if (response.data is String) {
      json = jsonDecode(response.data);
    } else {
      json = response.data;
    }

    if (json == null) {
      return HttpNativeClient.shared.reject(
        ResponseError.exception(Exception.jsonSerializationFailed),
      );
    }

    /// 不去解析文件那些鬼没有code的还很诡异
    if (response.request.uri.origin == Manager.shared.getCoreFileHostUrl) {
      response.data = json;
      return HttpNativeClient.shared.resolve(response);
    }

    /// 解析数据以及对应的检查是否正确响应
    final ServerResponseEntity entity = ServerResponseEntity.fromJson(json);

    switch (entity.code) {
      case 200:
      case 0:
        response.data = json;
        return HttpNativeClient.shared.resolve(response);
        break;

      /// 登录过期
      case 5001:
        AppRouterNavigator.of(Manager.shared.config.navigator.currentContext).setRoot(LOGIN_PATH);
        return HttpNativeClient.shared.reject(
          ResponseError.exception(Exception.tokenVerifyFail, message: entity.msg ?? "", status: entity.code),
        );
        break;

      default:
        return HttpNativeClient.shared.reject(
          ResponseError.exception(Exception.executeFail, message: entity.msg ?? "", status: entity.code),
        );
        break;
    }
  }

  @override
  Future onError(DioError e) {
    Future.delayed(const Duration(milliseconds: 350), () => ToastUtils.cleanAllLoading());
    if (e is DioError) {
      if (e.error is HttpException) {
        ToastUtils.showText(text: e.error.message);
      } else if (e.error is SocketException) {
        ToastUtils.showText(text: "当前网络暂不可用,请稍后重试");
      } else if (e.error is ResponseError) {
        ToastUtils.showText(text: e.error.message);
      }
    }
    return super.onError(e);
  }
}
