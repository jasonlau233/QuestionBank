import 'package:flutter/painting.dart';

/// 存储于ui提供的颜色，格式为color_16进制颜色
class ColorUtils {
  ///以下为对外的方法，
  ///文本色-主色文本色-用于特别强调和突出的文字
  static const Color color_text_theme = _color_3291FA;

  ///文本色-1级文本色-主要用于标题和灰色背景内的文字
  static const Color color_text_level1 = _color_4D4D4D;

  ///文本色-2级文本色-主要用于简介和描述
  static const Color color_text_level2 = _color_707070;

  ///文本色-3级文本色-主要用于未选中和输入框的提示
  static const Color color_text_level3 = _color_CCCED1;

  ///背景色（包含色块、图标、线条）-主色背景色-用于特别强调和突出的背景
  static const Color color_bg_theme = _color_3291FA;

  /// 阴影色，用于某些按钮，如自定义刷题
  static const Color color_border_shadow = _color_29EEEEEE;

  ///背景色（包含色块、图标、线条）-主色背景色的不可点击状态
  static const Color color_bg_theme_notClick = _color_B9E6FF;

  ///背景色（包含色块、图标、线条）-用于收藏选中和标疑选中
  static const Color color_bg_colAndQs = _color_FFAB08;

  ///背景色（线条）-用于最普通的分割线，常用与白色背景
  static const Color color_bg_splitLine = _color_E6E6E6;

  ///背景色（色块）-白色色块直接用于间隔的色块
  static const Color color_bg_splitBlock = _color_F8F8F8;

  ///背景色（色块）-浅（灰）色文字的背景色（包含排除选项文本颜色的背景色块）
  static const Color color_textBg_forGray = _color_F7F8F9;

  ///背景色（线条）-非常短的分割线
  static const Color color_bg_splitLine_short = _color_F7F8F9;

  ///背景色（色块）-系统色文字的背景色
  static const Color color_textBg_forTheme = _color_ECF5FF;

  /// 边框色
  static const Color color_border_line = _color_D2EEFE;

  ///用于试卷说明页面的固定提示
  static const Color color_exam_tip = _color_333334;

  ///用于试卷列表未完成次数的文字颜色
  static const Color color_text_need_do = _color_AAAAAA;

  ///用于试卷列表试卷名称的文字颜色
  static const Color color_text_exam_name = _color_333333;

  ///用于试卷列表继续做题按钮的背景色
  static const Color color_bg_continue_btn = _color_0A8ECE;

  ///用于试卷列表页面背景色
  static const Color color_bg_exam_list_page = _color_FAFAFA;

  /**   start-表示对/错/疑问/排除的相关颜色   **/

  ///文本色-表示已选择的颜色
  ///背景色（图表）-表示未选择的图标背景色块
  ///Todo 看不懂代码，后面洪彬自己换
  static const Color color_textBg_choose_select_noChoose = _color_CCCCCC;

  ///Todo 前面统一替换成了color_text_theme，后面需要单独抽出来
  static const Color color_text_choose_select = _color_5CC9A5;

  ///背景色（包含图标、线条）-表示已选择的颜色
  ///Todo 前面统一替换成了color_bg_theme，后面需要单独抽出来
  static const Color color_bg_choose_select = _color_5CC9A5;

  ///背景色（色块）-表示已选择的文本颜色的背景色块
  static const Color color_textBg_choose_select_choose = _color_ECF5FF;

  ///文本色-表示正确的颜色
  static const Color color_text_choose_true = _color_5CC9A5;

  ///背景色（包含图标、线条）-表示正确的颜色
  static const Color color_bg_choose_true = _color_5CC9A5;

  ///背景色（色块）-表示正确的文本颜色的背景色块
  static const Color color_textBg_text_choose_true = _color_EBFBF7;

  ///文本色-表示错误的颜色
  static const Color color_text_choose_fasle = _color_E25237;

  ///背景色（图标、线条）-表示错误的颜色
  static const Color color_bg_choose_false = _color_E25237;

  ///背景色（色块）-表示错误的文本颜色的背景色块
  static const Color color_textBg_text_choose_false = _color_FEF0EE;

  ///背景色（线条）-用于做题页面未选择题目分割线颜色
  static const Color color_bg_noChoose_splitLine = _color_E1E1E1;

  ///文本色-表示排除的选项的颜色
  static const Color color_text_choose_exclude = _color_EBEBEB;

  ///背景色（包含图标、线条）-表示排除的颜色
  static const Color color_bg_choose_exclude = _color_EBEBEB;

  ///背景色（色块）-表示排除的容器背景色
  static const Color color_bg_exclude = _color_F5F5F5;

  ///背景色（色块）-表示排除的文字颜色
  static const Color color_text_exclude = _color_BFBFBF;

  ///阴影色 删除错题
  static const Color color_shadow_remove_error_question = _color_FFCBECFF;

  ///背景色（色块）-表示排除的文本颜色的背景色块
  static const Color color_textBg_text_choose_exclude = _color_F7F8F9;

  /**   end-表示对/错/疑问/排除的相关颜色   **/

  /** start 错题管理题目类型颜色**/

  ///用于错题管理题目分布的多选题
  static const Color color_multi_choice = _color_5968FA;

  ///用于错题管理题目分布的判断题
  static const Color color_judgement = _color_BE4FF8;

  ///用于错题管理题目分布的不定项选择题
  static const Color color_uncertainty_choice = _color_FB3FA5;

  /** end 错题管理题目类型颜色**/

  /** start 学情分析报告进度目类型颜色**/

  ///学情分析报告进度背景色
  static const Color color_learning_situation_bg = _color_BDD6F6;

  static const Color color_learning_situation_target_bg = _color_F9E9E8;

  ///学情分析报告饼状图线条的颜色
  static const Color color_learning_situation_radar_chart_line = _color_AAECFF;

  /** end 学情分析报告进度目类型颜色**/

  ///以下为私有方法，用于和UI的颜色固定，不对外开放调用
  ///主色，用于特别强调和突出的文字、按钮和icon
  static const Color _color_3291FA = const Color(0xFF3291FA);

  static const Color _color_F5F5F5 = const Color(0xFFF5F5F5);

  ///用于题目选项选对后的文字和图标的颜色
  static const Color _color_5CC9A5 = const Color(0xFF5CC9A5);

  ///用于题目选项选错后的文字和图标的颜色
  static const Color _color_E25237 = const Color(0xFFE25237);

  ///辅助色，用于收藏选中和标疑选中
  static const Color _color_FFAB08 = const Color(0xFFFFAB08);

  ///用于题目选中后的背景色和图标框内颜色
  static const Color _color_ECF5FF = const Color(0xFFECF5FF);

  ///用于题目选对后的背景色
  static const Color _color_EBFBF7 = const Color(0xFFEBFBF7);

  ///用于题目排除的文字颜色色
  static const Color _color_BFBFBF = const Color(0xFFBFBFBF);

  ///用于题目选错后的背景色
  static const Color _color_FEF0EE = const Color(0xFFFEF0EE);

  ///用于重要级文字、标题行文字（如导航名称、资讯标题、列表标题等）
  static const Color _color_4D4D4D = const Color(0xFF4D4D4D);

  ///用于普通级文字 空白页面文字
  static const Color _color_707070 = const Color(0xFF707070);

  ///用于登录页面提示文字颜色
  static const Color _color_CCCED1 = const Color(0xFFCCCED1);

  ///用于页面分割线
  static const Color _color_E6E6E6 = const Color(0xFFE6E6E6);

  ///用于填充背景色
  static const Color _color_F8F8F8 = const Color(0xFFF8F8F8);

  ///用于填充边框色
  static const Color _color_D2EEFE = const Color(0xFFD2EEFE);

  ///用于做题页面未选择题目分割线颜色
  static const Color _color_E1E1E1 = Color(0xFFE1E1E1);

  ///用于做题页面未选择题目选项（ABCD）的描边和文字颜色
  static const Color _color_CCCCCC = const Color(0xFFCCCCCC);

  ///用于做题页面排除选项背景的描边和图标和文字的颜色
  static const Color _color_EBEBEB = const Color(0xFFEBEBEB);

  ///用于做题页面排除选项背景的填充颜色和自定义刷题未选择题型的背景色
  static const Color _color_F7F8F9 = Color(0xFFF7F8F9);

  ///用于登录页和我的页面退出按钮的背景色
  static const Color _color_B9E6FF = Color(0xFFB9E6FF);

  ///用于错题管理题目分布的多选题
  static const Color _color_5968FA = Color(0xFF5968FA);

  ///用于错题管理题目分布的判断题
  static const Color _color_BE4FF8 = Color(0xFFBE4FF8);

  ///用于错题管理题目分布的不定项选择题
  static const Color _color_FB3FA5 = Color(0xFFFB3FA5);

  ///用于试卷说明页面（eg:财政部机考考试要求）
  static const Color _color_333334 = Color(0xFF333334);

  ///用于试卷列表未完成次数的文字颜色
  static const Color _color_AAAAAA = Color(0xFFAAAAAA);

  ///用于试卷列表试卷名称的文字颜色
  static const Color _color_333333 = Color(0xFF333333);

  ///用于试卷列表继续做题按钮的背景色
  static const Color _color_0A8ECE = Color(0xFF0A8ECE);

  ///用于试卷列表页面背景色
  static const Color _color_FAFAFA = Color(0xFFFAFAFA);

  ///用于某些按钮对应需要阴影色 如自定义刷题
  static const Color _color_29EEEEEE = Color(0x29EEEEEE);

  /// 阴影色删除错题阴影
  static const Color _color_FFCBECFF = Color(0xFFCBECFF);

  ///学情分析报告进度背景色
  static const Color _color_BDD6F6 = Color(0xFFBDD6F6);

  ///学情分析报告目标背景色
  static const Color _color_F9E9E8 = Color(0xFFF9E9E8);

  ///学情分析报告饼状图线条的颜色
  static const Color _color_AAECFF = Color(0xffAAECFF);
}
