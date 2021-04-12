import 'package:flutter/material.dart';
import 'package:question_bank/utils/color.dart';

//tabar 底部指示条
class CustomTabIndictor extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _YiHuaIndictorPainter();
  }
}

class _YiHuaIndictorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint();
//    paint.color = ;
    paint.color = ColorUtils.color_bg_theme;
    paint.style = PaintingStyle.fill;
    // final w = configuration.size.width / 10;
    // final h = configuration.size.width / 20;
    final w = 30.0;
    final h = 3.0;

    //构建矩形
    Rect rect = Rect.fromLTWH(offset.dx - w / 2 + configuration.size.width / 2,
        configuration.size.height - h, w, h);
    //根据上面的矩形,构建一个圆角矩形
    RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(h / 2));

    /*canvas.drawRect(
        Rect.fromLTWH(offset.dx - w / 2 + configuration.size.width / 2,
            configuration.size.height - h, w, h),
        paint);*/
    canvas.drawRRect(rrect, paint);
  }
}
