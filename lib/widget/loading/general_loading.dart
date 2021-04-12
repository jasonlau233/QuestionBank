import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:question_bank/utils/color.dart';

import '../../utils/assets_bundle.dart';

class GeneralLoading extends StatelessWidget {
  /// 提醒文本
  final String title;

  const GeneralLoading({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          height: 118,
          width: 118,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Image.asset(loadingGifName),
              Positioned(
                bottom: 12,
                right: 0,
                left: 0,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: ColorUtils.color_bg_theme),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
