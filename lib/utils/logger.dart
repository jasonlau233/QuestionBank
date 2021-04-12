import 'dart:convert';
import 'dart:developer' as developer;

import '../config/build_config.dart';

/// 日志等级
enum _LogLevel { verbose, debug, info, warning, error, wtf }

class LogUtils {
  /// 工厂模式
  factory LogUtils() => _getInstance();

  /// 单例
  static LogUtils get instance => _getInstance();
  static LogUtils _instance;

  LogUtils._internal();

  static LogUtils _getInstance() {
    if (_instance == null) {
      _instance = LogUtils._internal();
    }
    return _instance;
  }

  DateTime get currentTime => DateTime.now();

  String get logName => "app.log";

  /// 输出日志
  void _showLog(dynamic message, {int level: 0, dynamic error, StackTrace stackTrace}) {
    if (BuildConfig.debug) {
      developer.log(
        jsonEncode(message),
        name: logName,
        time: currentTime,
        level: level,
        error: error,
        stackTrace: stackTrace,
      );
    }
    return;
  }

  /// Log a message at level [_LogLevel.verbose].
  void v(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _showLog(message, level: _LogLevel.verbose.index, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [_LogLevel.debug].
  void d(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _showLog(message, level: _LogLevel.debug.index, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [_LogLevel.info].
  void i(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _showLog(message, level: _LogLevel.info.index, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [_LogLevel.warning].
  void w(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _showLog(message, level: _LogLevel.warning.index, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [_LogLevel.error].
  void e(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _showLog(message, level: _LogLevel.error.index, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [_LogLevel.wtf].
  void wtf(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _showLog(message, level: _LogLevel.wtf.index, error: error, stackTrace: stackTrace);
  }
}
