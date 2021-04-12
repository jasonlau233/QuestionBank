import 'package:flutter/material.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/modules/pages/study_analysis_page.dart';
import 'package:question_bank/utils/theme.dart';

void main() => runApp(MyApp());

///
/// 用来显示想要绘制的页面（把页面放到home就好）
///
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: BuildConfig.appName,
      theme: ThemeUtils.defaultTheme,
      home: StudyAnalysisPage(),
    );
  }
}
