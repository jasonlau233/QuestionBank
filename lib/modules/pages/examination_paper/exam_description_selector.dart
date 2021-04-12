import 'package:flutter/material.dart';

import '../../../model/data/exam_group_count_entity.dart';
import '../../../modules/widget/topic_number_widget.dart';
import '../../../utils/color.dart';
import '../../widget/bottom_sheet_chooser.dart';
import '../../widget/theme_button.dart';

/// 试卷说明的选择器
/// 创建者-v0.5版本-刘奥罕
/// 更新者-v0.5版本-刘奥罕

class ExamDescriptionSelector extends StatelessWidget {
  const ExamDescriptionSelector({
    Key key,
    @required this.examList,
    @required this.score,
    @required this.questionNumber,
    this.onClick,
  }) : super(key: key);

  /// 试卷说明选择器数据
  final List<ExamGroupCountEntity> examList;

  /// 选中某一项的回调
  final OnClick onClick;

  /// 总分数 用于弹窗
  final num score;

  /// 总题数 用于弹窗
  final num questionNumber;

  /// 单项item的高度
  final double _listItemHeight = 40;

  @override
  Widget build(BuildContext context) {
    var bottomPadding = MediaQuery.of(context)?.padding?.bottom ?? 0;
    return Container(
      width: double.infinity,
      height: _listItemHeight * (examList?.length ?? 0) + 130 + bottomPadding,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned.fill(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(padding: const EdgeInsets.only(top: 10)),
                Text(
                  '本次考试共${questionNumber ?? 0}道题、总分${score ?? 0}分',
                  style: const TextStyle(
                      color: ColorUtils.color_text_level3, fontSize: 16),
                ),
                const Padding(padding: const EdgeInsets.only(top: 6)),
                Text(
                  '请选择任意部分开始答题',
                  style: const TextStyle(
                      color: ColorUtils.color_text_level1, fontSize: 16),
                ),
                // 题目类型选项列表 （eg：单项选择题、多项、判断题、不定项）
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    itemBuilder: (_, index) {
                      var currentData = examList[index];
                      // 格式化名称
                      String groupName = formatName(currentData?.groupName);

                      return GestureDetector(
                        onTap: () {
                          Navigator.maybePop(context);
                          onClick?.call(index);
                        },
                        child: SizedBox(
                          height: _listItemHeight,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  groupName ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: ColorUtils.color_text_level1,
                                      fontSize: 16),
                                ),
                              ),
                              TopicNumberWidget(
                                leftStr:
                                    currentData?.finishNumber?.toString() ??
                                        '0',
                                rightStr:
                                    currentData?.groupCount?.toString() ?? '0',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: examList?.length ?? 0,
                  ),
                ),
                const Padding(padding: const EdgeInsets.only(top: 3)),
                const ThemeButton('进入考试后开始倒计时', width: 180),
                Padding(padding: EdgeInsets.only(top: 32 + bottomPadding)),
              ],
            ),
          ),
          // 关闭按钮
          Positioned(
            child: CloseButton(
              color: ColorUtils.color_bg_splitLine,
            ),
          ),
        ],
      ),
    );
  }

  /// 格式化名称
  String formatName(String groupName) {
    var needSubIndex = (groupName?.indexOf('#@#') ?? -1);
    if (needSubIndex > 0) {
      groupName = groupName.substring(0, needSubIndex);
      needSubIndex = groupName.indexOf('、');
      if (needSubIndex >= 0) {
        groupName = groupName.substring(needSubIndex + 1);
      }
    }
    return groupName;
  }

  /// 显示试卷说明选择器
  static Future<T> showBottom<T>({
    @required BuildContext context,
    @required List<ExamGroupCountEntity> examList,
    @required OnClick onClick,
    @required num score,
    @required num questionNumber,
  }) {
    // 处理总分数
    var forMatScore = score;
    var scoreIntValue = score?.toInt();
    if (score != null && score == scoreIntValue) {
      forMatScore = scoreIntValue;
    }
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: const Radius.circular(15),
          topRight: const Radius.circular(15),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: ExamDescriptionSelector(
            examList: examList,
            onClick: onClick,
            score: forMatScore,
            questionNumber: questionNumber,
          ),
        );
      },
    );
  }
}
