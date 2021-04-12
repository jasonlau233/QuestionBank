import 'dart:async';

/// event bus
class EventBus {
  /// 工厂模式
  factory EventBus() => _getInstance();

  /// 单例
  static EventBus get instance => _getInstance();
  static EventBus _instance;

  /// 对应的streamController
  final Map<String, StreamController> _streamControllerMap = {};

  EventBus._internal();

  static EventBus _getInstance() {
    if (_instance == null) {
      _instance = EventBus._internal();
    }
    return _instance;
  }

  /// 注册对应的事件controller
  void register(String key) {
    if (!_streamControllerMap.containsKey(key)) {
      _streamControllerMap[key] = StreamController.broadcast();
    }
  }

  /// 注册多个事件controller
  void registerAll(List<String> eventList) {
    if (eventList.length > 0) {
      eventList.forEach(
        (element) {
          register(element);
        },
      );
    }
  }

  /// 注册监听事件
  StreamSubscription registerListen(String eventName, Function(dynamic) onData) {
    if (!_streamControllerMap.containsKey(eventName)) {
      assert(true);
    }
    return _streamControllerMap[eventName].stream.listen(onData);
  }

  /// 发送事件
  void post(String key, dynamic event) {
    if (_streamControllerMap.containsKey(key)) {
      _streamControllerMap[key]?.add(event);
    }
  }

  /// 取消注册
  void unRegister(String key) {
    if (_streamControllerMap.containsKey(key)) {
      _streamControllerMap[key].close();
      _streamControllerMap.remove(key);
    }
  }

  /// 取消注册
  void destroy() {
    if (_streamControllerMap.values.length > 0) {
      _streamControllerMap.values.forEach(
        (element) {
          element.close();
        },
      );
      _streamControllerMap.clear();
    }
  }
}
