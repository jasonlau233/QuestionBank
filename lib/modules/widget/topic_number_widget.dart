import 'package:flutter/material.dart';

import '../../utils/color.dart';

///
/// 题目数量 （eg: 0/20 > ）
///
class TopicNumberWidget extends StatelessWidget {
  const TopicNumberWidget({
    Key key,
    @required this.leftStr,
    @required this.rightStr,
  }) : super(key: key);

  /// 分隔符左边文本，（eg：已做题数）
  final String leftStr;

  /// 分隔符左边右边，（eg：题目总数）
  final String rightStr;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 20,
      margin: const EdgeInsets.only(left: 12),
      padding: const EdgeInsets.only(left: 4),
      decoration: const BoxDecoration(
        color: ColorUtils.color_textBg_choose_select_choose,
        borderRadius: const BorderRadius.all(const Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 1.5, left: 4),
            child: Text.rich(
              TextSpan(
                text: leftStr?.toString() ?? '',
                style: const TextStyle(
                    fontSize: 11, color: ColorUtils.color_text_level1),
                // default text style
                children: <TextSpan>[
                  const TextSpan(
                    text: '/',
                    style: const TextStyle(color: ColorUtils.color_text_level3),
                  ),
                  TextSpan(
                    text: rightStr?.toString() ?? '',
                    style: const TextStyle(
                        color: ColorUtils.color_text_level3, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 11,
            color: ColorUtils.color_bg_theme,
          ),
          SizedBox(
            width: 4,
          )
        ],
      ),
    );
  }
}
