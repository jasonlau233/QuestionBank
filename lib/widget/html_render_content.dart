import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
export 'package:flutter_html/style.dart';

class HtmlRenderContent extends StatelessWidget {
  /// HTML
  final String htmlData;

  /// html样式
  final Map<String, Style> htmlStyle;

  final Map<String, CustomRender> customRender;

  const HtmlRenderContent({
    Key key,
    @required this.htmlData,
    this.htmlStyle,
    this.customRender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData == null ? "" : htmlData,
      style: htmlStyle,
      customRender: customRender,
    );
  }
}
