import 'package:flutter/material.dart';
import 'package:question_bank/utils/color.dart';
import '../../../../widget/html_render_content.dart';

class QuestionInfo extends StatelessWidget {
  /// 文本解析
  final String textAnalysis;

  /// 知识点
  final String knowledge;

  /// 来源
  final String originText;

  const QuestionInfo({
    Key key,
    this.textAnalysis = "",
    this.knowledge = "",
    this.originText = "",
  }) : super(key: key);

  /// 解析
  Widget get _buildAnalysisItem {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 4,
              height: 14,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: ColorUtils.color_text_theme,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              "解析",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ),
        HtmlRenderContent(
          htmlData: textAnalysis,
          htmlStyle: {
            "html": Style(
              fontSize: FontSize(14),
              color: ColorUtils.color_text_level2,
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
            ),
            "p": Style(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
            ),
          },
        ),
      ],
    );
  }

  /// 考点
  Widget get _buildKnowledgeItem {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, top: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 14,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: ColorUtils.color_text_theme,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                "考点",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          if (knowledge != null)
            Container(
              padding: const EdgeInsets.only(left: 6, right: 6, top: 2.5, bottom: 4),
              decoration: BoxDecoration(
                color: ColorUtils.color_textBg_choose_select_choose,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: ColorUtils.color_bg_theme, width: 1),
              ),
              margin: const EdgeInsets.only(top: 8, left: 8),
              child: Text(
                knowledge,
                style: TextStyle(fontSize: 11, color: ColorUtils.color_text_theme),
              ),
            )
        ],
      ),
    );
  }

  /// 来源
  Widget get _buildOrigin {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 4,
              height: 14,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: ColorUtils.color_bg_theme,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              "来源",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.color_text_level1),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 6, left: 8),
          child: Text(
            originText,
            style: const TextStyle(fontSize: 14, color: ColorUtils.color_text_level2),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 15, bottom: 12, right: 16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnalysisItem,
          _buildKnowledgeItem,
          _buildOrigin,
        ],
      ),
    );
  }
}
