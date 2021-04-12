import 'package:flutter/material.dart';
import 'package:question_bank/utils/color.dart';

class QuestionAnswerInfo extends StatelessWidget {
  /// 类型,都是后端那些类型
  final int type;

  /// 答题速度的文字
  final String speedText;

  /// 易错想百分比字符
  final String percentText;

  /// 易错项
  final String errorItemText;

  /// 正确答案文字
  final String rightAnswerText;

  /// 用户的答案
  final String userAnswerText;

  /// 用户的答案
  final bool userAnswerTrue;

  const QuestionAnswerInfo({
    Key key,
    this.type = 1,
    this.percentText = "",
    this.speedText = "",
    this.errorItemText = "",
    this.rightAnswerText = "",
    this.userAnswerText = "",
    this.userAnswerTrue = false,
  }) : super(key: key);

  /// 单选对应的解析答案item
  Widget get _buildOneAnswer {
    return Container(
      color: Colors.white,
      height: 110,
      margin: const EdgeInsets.only(bottom: 9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAnswerText,
          Container(
            height: 63,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSpeedItemText,
                Container(
                  height: 21,
                  width: 1,
                  color: ColorUtils.color_bg_splitLine_short,
                ),
                _buildAllRightText,
                Container(
                  height: 21,
                  width: 1,
                  color: ColorUtils.color_bg_splitLine_short,
                ),
                _buildErrItemText
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建对应的判断选项
  Widget get _buildTrueOrFalseAnswer {
    return Container(
      color: Colors.white,
      height: 110,
      margin: const EdgeInsets.only(bottom: 9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAnswerText,
          Container(
            color: Colors.white,
            height: 63,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSpeedItemText,
                Container(
                  height: 21,
                  width: 1,
                  color: ColorUtils.color_bg_splitLine_short,
                ),
                _buildAllRightText,
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建多个选项
  Widget get _buildMoreAnswer {
    return Container(
      color: Colors.white,
      height: 110,
      margin: const EdgeInsets.only(bottom: 9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAnswerText,
          Container(
            height: 63,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSpeedItemText,
                Container(
                  height: 21,
                  width: 1,
                  color: ColorUtils.color_bg_splitLine_short,
                ),
                _buildAllRightText,
                Container(
                  height: 21,
                  width: 1,
                  color: ColorUtils.color_bg_splitLine_short,
                ),
                _buildErrItemText,
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget get _buildAnswerText {
    return Container(
      height: 47,
      color: ColorUtils.color_bg_splitBlock,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Text.rich(
        TextSpan(
          text: "正确答案是",
          style: TextStyle(fontSize: 16, color: ColorUtils.color_text_level1),
          children: [
            TextSpan(
              text: rightAnswerText,
              style: TextStyle(color: ColorUtils.color_text_choose_true),
            ),
            const TextSpan(text: "，"),
          ]..addAll(
              userAnswerText == null || userAnswerText == ""
                  ? [
                      TextSpan(
                        text: "你未作答",
                        style: TextStyle(
                          color: ColorUtils.color_text_choose_fasle,
                        ),
                      )
                    ]
                  : [
                      const TextSpan(text: "你的答案是"),
                      TextSpan(
                        text: userAnswerText,
                        style: TextStyle(
                          color: userAnswerTrue && rightAnswerText.length == userAnswerText.length ? ColorUtils.color_text_choose_true : ColorUtils.color_text_choose_fasle,
                        ),
                      ),
                    ],
            ),
        ),
      ),
    );
  }

  /// 构建错误文本item
  Widget get _buildErrItemText {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "易错选项",
          style: TextStyle(fontSize: 14, color: ColorUtils.color_text_level1, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          child: Text(
            errorItemText,
            style: const TextStyle(fontSize: 14, color: ColorUtils.color_text_choose_fasle),
          ),
        ),
      ],
    );
  }

  /// 构建答题用时文本控制
  Widget get _buildSpeedItemText {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "答题用时",
          style: TextStyle(fontSize: 14, color: ColorUtils.color_text_level1, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          child: Text(
            speedText,
            style: const TextStyle(fontSize: 14, color: ColorUtils.color_text_theme),
          ),
        )
      ],
    );
  }

  /// 构建对的文字
  Widget get _buildAllRightText {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "全站正确率",
          style: TextStyle(fontSize: 14, color: ColorUtils.color_text_level1, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          child: Text(
            percentText,
            style: TextStyle(fontSize: 14, color: ColorUtils.color_text_choose_true),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {

      /// 单选
      case 1:
        return _buildOneAnswer;
        break;

      /// 判断
      case 3:
        return _buildTrueOrFalseAnswer;
        break;

      /// 多选 不定项
      case 2:
      case 7:
        return _buildMoreAnswer;
        break;

      default:
        return Container(height: 0, width: 0);
    }
  }
}
