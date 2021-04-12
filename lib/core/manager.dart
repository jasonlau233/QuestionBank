import 'package:flutter/material.dart';

/// 环境变量
enum HttpEnv {
  /// 生产
  Production,

  /// 环境
  Test
}

/// 只做存储
class Manager {
  HttpOptions _config = HttpOptions();

  HttpOptions get config => _config;

  set config(HttpOptions options) {
    _config = options;
  }

  /// 工厂模式
  factory Manager() => _getInstance();

  /// 单利
  static Manager get shared => _getInstance();
  static Manager _instance;

  Manager._internal();

  static Manager _getInstance() {
    if (_instance == null) {
      _instance = new Manager._internal();
    }
    return _instance;
  }

  /// 获取主接口的地址
  String get getMainHostUrl {
    switch (_config.env) {
      case HttpEnv.Production:
        return _getMainHostProduction;
        break;
      case HttpEnv.Test:
        return _getMainHostTest;
        break;
      default:
        return "";
    }
  }

  /// 获取nc蓝鲸鉴权接口地址
  String get getNCBlueWhaleAuthHostUrl {
    switch (_config.env) {
      case HttpEnv.Production:
        return _getNCBlueWhaleHostAuthProduction;
        break;
      case HttpEnv.Test:
        return _getNCBlueWhaleHostAuthTest;
        break;
      default:
        return "";
    }
  }

  /// 获取核心层的地址
  String get getCoreHostUrl {
    switch (_config.env) {
      case HttpEnv.Production:
        return _getCoreHostProduction;
        break;
      case HttpEnv.Test:
        return _getCoreHostTest;
        break;
      default:
        return "";
    }
  }

  ///核心层试卷json文件的域名
  String get getCoreFileHostUrl {
    switch (_config.env) {
      case HttpEnv.Production:
        return _getCorePagerFileHosProduct;
        break;
      case HttpEnv.Test:
        return _getCorePagerFileHosTest;
        break;
      default:
        return "";
    }
  }

  ///Html5项目的域名
  String get getHtml5HostUrl {
    switch (_config.env) {
      case HttpEnv.Production:
        return _getHtml5HostUrlHosProduct;
        break;
      case HttpEnv.Test:
        return _getHtml5HostUrlHosTest;
        break;
      default:
        return "";
    }
  }

  /// 消息系统请求地址
  String get getNotifyHostUrl {
    switch (_config.env) {
      case HttpEnv.Production:
        return _getNotifyHostProduct;
        break;
      case HttpEnv.Test:
        return _getNotifyHostTest;
        break;
      default:
        return "";
    }
  }

  /// 主接口的生产和测试地址
  String get _getMainHostProduction => "https://kytkapp.hqjy.com";

  String get _getMainHostTest => "http://10.0.14.212:8210";

  /// nc蓝鲸的鉴权生产和测试地址
  String get _getNCBlueWhaleHostAuthProduction => "https://userinfo.hqjy.com";

  String get _getNCBlueWhaleHostAuthTest => "http://ucinfo.beta.hqjy.com";

  /// 核心层接口地址
  String get _getCoreHostProduction => "https://kaobatiku.hqjy.com/tk";

  String get _getCoreHostTest => "http://10.0.98.146:6002/tk";

  ///核心层试卷json文件的域名
  String get _getCorePagerFileHosTest => "http://newtikupc.beta.hqjy.com";

  String get _getCorePagerFileHosProduct => "http://newtikupc.hqjy.com";

  ///Html5项目的域名
  String get _getHtml5HostUrlHosProduct => "https://schoolh5.hqjy.com";

  String get _getHtml5HostUrlHosTest => "http://10.0.99.117:8888";

  /// 消息系统注册域名
  String get _getNotifyHostProduct => "https://hqjy-notify-web.hqjy.com";

  String get _getNotifyHostTest => "https://hqjy-notify-web.hqjy.com";
}

class HttpOptions {
  /// 链接时间
  int connectTimeout;

  /// 响应时间
  int receiveTimeout;

  /// 是否开启日志
  bool logEnable;

  /// 发送数据的时长
  int sendTimeout;

  /// 配置环境接口属性
  HttpEnv env;

  /// 请求的token
  String token;

  /// 导航key
  GlobalKey navigator;

  HttpOptions({
    this.connectTimeout = 100000,
    this.receiveTimeout = 100000,
    this.logEnable = true,
    this.sendTimeout = 60 * 1000,
    this.env = HttpEnv.Production,
    this.token = "",
    this.navigator,
  });

  HttpOptions copyWith({
    int connectTimeout,
    int receiveTimeout,
    bool logEnable,
    int sendTimeout,
    HttpEnv env,
    String token,
    GlobalKey navigator,
  }) {
    return HttpOptions(
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      logEnable: logEnable ?? this.logEnable,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      env: env ?? this.env,
      token: token ?? this.token,
      navigator: navigator ?? this.navigator,
    );
  }
}
