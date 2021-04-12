import 'package:flutter_poly_v_plugin/flutter_poly_v_plugin.dart';
import '../utils/logger.dart';


///
/// 保利威视配置工具类
///
class BuildConfigPolyV{
  /// 保利威视签名信息
  static const _POLY_V_CONFIG =
      '1px9aEABjhLto06BTja7noP2myjgSnPOhNm9bC0YOVukGGlp2zLMVbGdWdXEnX3HJhB/XWLJQGSwausH8kk42hdK052SQy60j3PVxyuFTc0OVVZ/xEX7w2K0K8hvhWgVLafq9pedRWJojnftoTFhBQ==';
  static const _POLY_V_AES = 'VXtlHmwfS2oYm0CZ';
  static const _POLY_V_IV = '2u9gDPKdX6GyQJKU';


  /// 初始化保利威SDK
  static void initPolyVSDK() async {
    bool initResult = await FlutterPolyVPlugin.initPolyV(
      config: _POLY_V_CONFIG,
      aes: _POLY_V_AES,
      iv: _POLY_V_IV,
    );
    LogUtils.instance.d('poly_v_plugin initPolyVSDK result=$initResult');
  }
}