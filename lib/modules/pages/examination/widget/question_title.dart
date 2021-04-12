import 'package:flutter/material.dart';
import 'package:question_bank/utils/color.dart';
import '../../../../widget/html_render_content.dart';

class QuestionTitle extends StatelessWidget {
  /// 题目类型名字
  final String typeName;

  /// 问题标题
  final String title;

  /// 错了多少次
  final String errorNum;

  const QuestionTitle({Key key, this.typeName = "", this.title = "", this.errorNum = ""}) : super(key: key);

  Widget get _buildMainHtml {
    String newTitle = title;
    if (!newTitle.contains("<p>")) {
      newTitle = "<p><title></title>" + title + "</p>";
    } else {
      newTitle = title.replaceFirst("<p>", "<p><title></title>");
      newTitle = newTitle.trim();
    }
    return HtmlRenderContent(
      htmlData: newTitle,
      htmlStyle: {
        "p": Style(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.all(0),
        ),
        "html": Style(
          fontSize: FontSize(16),
          color: ColorUtils.color_text_level1,
        ),
        "table": Style(
          border: Border(
            left: const BorderSide(color: ColorUtils.color_textBg_forGray),
            right: const BorderSide(color: ColorUtils.color_textBg_forGray),
            top: const BorderSide(color: ColorUtils.color_textBg_forGray),
          ),
        ),
        "tr": Style(
          border: Border(
            bottom: BorderSide(color: ColorUtils.color_textBg_forGray),
          ),
        ),
        "td": Style(
          padding: EdgeInsets.all(6),
        ),
      },
      customRender: {
        "title": (context, Widget child, attributes, _) {
          return Container(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 2),
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              color: ColorUtils.color_bg_theme,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Text(
              typeName,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          );
        },
        "error": (context, Widget child, attributes, _) {
          return Container(
            alignment: Alignment.center,
            width: 65,
            height: 18,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              color: ColorUtils.color_bg_theme,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Text(
              typeName,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          );
        }
      },
    );
  }

  Widget _buildTag(Color bgColor, String text) {
    return Container(
      height: 16,
      width: 54,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 15, left: 5, right: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainHtml,
          if (errorNum != null && errorNum.isNotEmpty)
            _buildTag(ColorUtils.color_bg_choose_false, "错了" + errorNum + "次"),
        ],
      ),
    );
  }
}
