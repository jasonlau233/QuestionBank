import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:question_bank/model/data/report_entity.dart';

import '../../flutter/custom_expansion_panel.dart';
import '../../provider/view_model/common.dart';
import '../../provider/widget/base_provider_widget.dart';
import '../../utils/color.dart';
import 'chapter_exercises.dart';

/// 练习业务ui
class ReportChapterExercises extends StatelessWidget {
  final Chapters data;

  /// 是否需要展开
  final bool isExpanded;

  const ReportChapterExercises({Key key, this.data, this.isExpanded = false})
      : super(key: key);

  /// 构建统一item样式
  Widget _buildPanelChildItem({
    String chapterName: "",
    int totalCount,
    int rightCount,
    int totalTime,
    EdgeInsets padding: const EdgeInsets.only(left: 43, right: 12),
    bool isHeader: true,
  }) {
    double rightPercent;
    String rightPercentStr;
    if (rightCount == 0 || totalCount == 0) {
      rightPercent = 0;
    } else {
      rightPercent = rightCount / totalCount * 100;
    }
    rightPercentStr = rightPercent.toStringAsFixed(2);
    return Container(
      alignment: Alignment.centerLeft,
      height: 55,
      color: Colors.white,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapterName,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorUtils.color_text_level2,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '共$totalCount题，答对了$rightCount道，正确率$rightPercentStr%,用时${useTime(totalTime)}',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorUtils.color_text_need_do,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建panelList
  Widget _buildPanelList(BuildContext context) {
    if (data != null) {
      String initialOpenPanelValue = '';
      if (isExpanded) {
        initialOpenPanelValue = data.chapterName;
      }
      return CustomExpansionPanelList.radio(
        bottomDividerColor: Color(0xFFFAFAFA),
        elevation: 0,
        expandedHeaderPadding: const EdgeInsets.all(0),
        initialOpenPanelValue: initialOpenPanelValue,
        expansionCallback: (int index, bool isExpanded) {
          print(isExpanded);
        },
        children: [
          CustomExpansionPanelRadio(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return _buildPanelChildItem(
                chapterName: data.chapterName,
                totalCount: data.allNumber,
                rightCount: data.rightNumber,
                totalTime: data.totalTime.toInt(),
                padding: const EdgeInsets.only(left: 0, right: 12),
              );
            },
            body: Column(
              children: data.sections != null && data.sections.length > 0
                  ? data.sections
                      .map<Widget>(
                        (e) => GestureDetector(
                          onTap: () {
                            final bool isFirstSettings =
                                Provider.of<Common>(context, listen: false)
                                    .isFirstSettings;
                            if (isFirstSettings) {
                              showCustomBrushQuestionBottomSheet(
                                  context: context);
                              return;
                            }
                          },
                          child: _buildPanelChildItem(
                            chapterName: e.sectionName,
                            totalCount: e.allNumber,
                            rightCount: e.rightNumber,
                            totalTime: e.totalTime.toInt(),
                            isHeader: false,
                          ),
                        ),
                      )
                      .toList()
                  : [],
            ),
            value: data.chapterName,
          ),
        ],
      );
    }
    return Container();
  }

  ///用时
  String useTime(int seconds) {
    if (seconds < 60 && seconds >= 0) {
      return '$seconds秒';
    } else {
      if (seconds % 60 > 0) {
        return '${seconds ~/ 60}分${seconds % 60}秒';
      } else {
        return '${seconds ~/ 60}分';
      }
    }
  }

  /// 构建展开
  Widget _buildPanelItem(BuildContext context) {
    if (data == null) {
      return SliverToBoxAdapter(child: Container(width: 0, height: 0));
    }

    return _buildPanelList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: _buildPanelItem(context),
    );
  }
}
