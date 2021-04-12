import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:question_bank/utils/color.dart';
import '../widget/refresh/my_refresh.dart';

///
/// 上下拉刷新例子
///
class RefreshDemo extends StatefulWidget {

  @override
  _RefreshDemoState createState() => _RefreshDemoState();
}

class _RefreshDemoState extends State<RefreshDemo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('上下拉刷新demo',style: const TextStyle(color: ColorUtils.color_text_level1),),
        centerTitle: true,
        elevation: 10,
      ),
      body: MyRefresh<int>(
        loadDataCallBack: _loadData,
        buildListItemCallBack: _buildListItem,
      ),
    );
  }

  ///加载数据
  Future<RefreshBean> _loadData(newOffset) {
    List<int> list = new List();
    for (var i = 0; i < 20; i++) {
      list.add(Random().nextInt(1000));
    }
    return Future.delayed(
        Duration(seconds: 2), () => RefreshBean(result: list));
  }

  ///列表Item
  Widget _buildListItem(BuildContext context, int data, int index) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]))),
      child: Center(
        child: Text('$data'),
      ),
    );
  }
}

///
/// 演示用的数据类
///
class RefreshBean {
  final List<int> result;
  RefreshBean({this.result});
}
