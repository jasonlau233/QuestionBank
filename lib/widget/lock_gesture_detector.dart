import 'package:flutter/material.dart';

/// 回调点击事件
typedef Future<bool> OnItemClickListenCallback();

class LockGestureDetector extends StatefulWidget {
  /// 子视图
  final Widget child;

  /// 回调事件
  final OnItemClickListenCallback onItemClickListenCallback;
  final OnItemClickListenCallback onItemLongClickListenCallback;

  const LockGestureDetector({Key key, this.child, this.onItemClickListenCallback, this.onItemLongClickListenCallback})
      : super(key: key);

  @override
  _LockGestureDetectorState createState() => _LockGestureDetectorState();
}

class _LockGestureDetectorState extends State<LockGestureDetector> {
  /// 本地锁
  bool _localLock = false;

  /// 点击事件
  void _onItemClickListener() async {
    if (_localLock || widget.onItemClickListenCallback == null) return;

    _localLock = true;
    await widget.onItemClickListenCallback.call();
    _localLock = false;
  }

  /// 点击事件
  void _onLongItemClickListener() {
    widget.onItemLongClickListenCallback.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _onLongItemClickListener,
      onTap: _onItemClickListener,
      child: widget.child,
    );
  }
}
