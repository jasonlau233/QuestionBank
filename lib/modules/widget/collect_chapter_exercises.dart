import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:question_bank/core/router/app_router_navigator.dart';
import 'package:question_bank/model/data/collect_accord_chapter_entity.dart';
import 'package:question_bank/route/path.dart';

import '../../flutter/custom_expansion_panel.dart';
import '../../provider/view_model/common.dart';
import '../../provider/widget/base_provider_widget.dart';
import '../../utils/color.dart';
import 'chapter_exercises.dart';

/// 练习业务ui
class CollectChapterExercises extends StatelessWidget {
  final AppCollectionChapterList data;

  /// 是否需要展开
  final bool isExpanded;

  const CollectChapterExercises({Key key, this.data, this.isExpanded = false})
      : super(key: key);

  /// 构建统一item样式
  Widget _buildPanelChildItem({
    String chapterName: "",
    int finishNumber: 0,
    int allNumber: 0,
    EdgeInsets padding: const EdgeInsets.only(left: 43, right: 12),
    bool isHeader: true,
  }) {
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
                    fontSize: 16,
                    color: ColorUtils.color_text_level1,
                    fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 20,
            width: 52,
            margin: const EdgeInsets.only(left: 12),
            padding: const EdgeInsets.only(left: 14, right: 10),
            decoration: BoxDecoration(
              color: ColorUtils.color_textBg_choose_select_choose,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 1.5),
                  child: Text.rich(
                    TextSpan(
                        text: finishNumber.toString(),
                        style: TextStyle(
                            fontSize: 11, color: ColorUtils.color_text_level1)),
                  ),
                ),
                Visibility(
                  visible: !isHeader,
                  child: const Icon(Icons.arrow_forward_ios,
                      size: 12, color: ColorUtils.color_bg_theme),
                )
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
      int initialOpenPanelValue = 0;
      if (isExpanded) {
        initialOpenPanelValue = data.id;
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
                chapterName: data.name,
                allNumber: data.allNumber,
                finishNumber: data.collectionNumbers,
                padding: const EdgeInsets.only(left: 0, right: 12),
              );
            },
            body: Column(
              children: data.sectionList != null && data.sectionList.length > 0
                  ? data.sectionList
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
                            List<String> questionIdList = <String>[];
                            Map<String, String> collectIdMap =
                                Map<String, String>();
                            for (QuestionIdAndCollectionIds question
                                in e.questionIdAndCollectionIds) {
                              questionIdList.add(question.questionId);
                              collectIdMap[question.questionId] =
                                  question.collectionId;
                            }
                            AppRouterNavigator.of(context).push(
                              EXAMINATION_PATH,
                              needLogin: true,
                              params: {
                                "type": 4,
                                "origin": 1,
                                "examId": "",
                                "title": '${e.name}',

                                ///章节+收藏题目
                                "mainTitle": '${data.name} ${e.name}',
                                "paperUuid": e.paperUuid,
                                "subLibraryModuleId": e.subModuleId.toString(),
                                "questionIdList": questionIdList,
                                "collectIdMap": collectIdMap,
                                "showProblem": false,
                              },
                            );
                          },
                          child: _buildPanelChildItem(
                            chapterName: e.name,
                            allNumber: e.allNumbers,
                            finishNumber: e.collectionNumbers,
                            isHeader: false,
                          ),
                        ),
                      )
                      .toList()
                  : [],
            ),
            value: data.id,
          ),
        ],
      );
    }
    return Container();
  }

  /// 构建展开
  Widget _buildPanelItem(BuildContext context) {
    if (data == null) {
      return Container(width: 0, height: 0);
    }

    return _buildPanelList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: _buildPanelItem(context),
    );
  }
}
