import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class BannerSwiper extends StatelessWidget {
  /// 图片资源
  final List<String> data;

  /// 子项构建
  final IndexedWidgetBuilder itemBuilder;

  /// 是否自动播放
  final bool autoPlay;

  ///The swiper pagination plugin
  final SwiperPlugin pagination;

  ///the swiper control button plugin
  final SwiperPlugin control;

  /// 是否重复
  final bool loop;

  const BannerSwiper({
    Key key,
    @required this.itemBuilder,
    this.autoPlay = true,
    @required this.data,
    this.pagination,
    this.control,
    this.loop = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: itemBuilder,
      indicatorLayout: PageIndicatorLayout.COLOR,
      autoplay: autoPlay,
      itemCount: data.length,
      pagination: pagination,
      loop: loop,
      control: control,
    );
  }
}
