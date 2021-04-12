import 'package:flutter/material.dart';
import 'package:question_bank/utils/color.dart';

/// 回调函数
typedef void OnItemClickListen(int currentIndex);
typedef bool OnItemClickBeforeListen(int currentIndex);

/// 对应的item实体bean
class NavigatorBarItemBean {
  /// 标题
  final String label;

  /// 非选择的icon
  final Icon unSelectIcon;

  /// 选择的icon
  final Icon selectIcon;

  const NavigatorBarItemBean(this.label, this.unSelectIcon, this.selectIcon);
}

/// 导航button
class NavigatorBar extends StatefulWidget {
  /// 列表项目
  final List<NavigatorBarItemBean> items;

  /// 点击回调事件
  final OnItemClickBeforeListen onItemClickBeforeListen;
  final OnItemClickListen onItemClickAfterListen;

  const NavigatorBar({Key key, this.items, this.onItemClickBeforeListen, this.onItemClickAfterListen})
      : assert(items != null),
        assert(items.length >= 2),
        super(key: key);

  @override
  _NavigatorBarState createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
  /// 当前的索引
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  /// 点击事件
  void onTapNavigatorItem(int index) {
    if (index != currentIndex) {
      if (widget.onItemClickBeforeListen != null) {
        final bool isCancel = widget.onItemClickBeforeListen.call(currentIndex);
        if (!isCancel) {
          return;
        }
      }
      setState(() => currentIndex = index);
      widget.onItemClickAfterListen?.call(currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTapNavigatorItem,
      items: widget.items
          .map<BottomNavigationBarItem>(
            (e) => BottomNavigationBarItem(
          icon: Container(child: e.unSelectIcon, margin: const EdgeInsets.only(bottom: 4)),
          activeIcon: Container(child: e.selectIcon, margin: const EdgeInsets.only(bottom: 4)),
          label: e.label,
        ),
      )
          .toList(),
    );
  }
}
