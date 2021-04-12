import 'package:flutter/material.dart';
import 'package:question_bank/em/answer_situation_type.dart';
import 'package:question_bank/model/data/report_card_entity.dart';
import 'package:question_bank/model/data/report_entity.dart';
import 'package:question_bank/utils/color.dart';
import 'package:question_bank/utils/icon.dart';

///未答
BoxDecoration unAnswerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(29)),
  border: Border.all(width: 1, color: ColorUtils.color_bg_splitLine),
);

///错误
BoxDecoration wrongAnswerDecoration = BoxDecoration(
  color: ColorUtils.color_textBg_text_choose_false,
  borderRadius: BorderRadius.all(Radius.circular(29)),
  border: Border.all(width: 0, style: BorderStyle.none),
);

///正确
BoxDecoration rightAnswerDecoration = BoxDecoration(
  color: ColorUtils.color_textBg_text_choose_true,
  borderRadius: BorderRadius.all(Radius.circular(29)),
  border: Border.all(width: 0, style: BorderStyle.none),
);

typedef void OnItemClickListen(String questionId, int childIndex);

///答题卡
class AnswerCardWidget extends StatefulWidget {
  final ReportCardEntity reportCardEntity;

  ///是否可以点击
  bool clickable = false;

  ///点击回调
  OnItemClickListen onItemClickListen;

  ///从答题报告进来 == 0  从做题页进来 == 1
  int comeFrom;

  AnswerCardWidget(this.reportCardEntity,
      {this.clickable, this.onItemClickListen, this.comeFrom = 0});

  @override
  _AnswerCardWidgetState createState() => _AnswerCardWidgetState();
}

class _AnswerCardWidgetState extends State<AnswerCardWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.reportCardEntity.groups == null ||
        widget.reportCardEntity.groups.isEmpty) {
      return SliverToBoxAdapter(child: Container());
    }
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        margin: EdgeInsets.only(top: 9),
        padding: EdgeInsets.only(left: 12, right: 12, top: 24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 6),
                  width: 4,
                  height: 12,
                  decoration: BoxDecoration(
                    color: ColorUtils.color_bg_theme,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                Text(
                  '答题卡',
                  style: TextStyle(
                      fontSize: 15,
                      color: ColorUtils.color_text_level1,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Container(
                  width: 10,
                  height: 10,
                  margin: EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    color: ColorUtils.color_textBg_text_choose_true,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 0, style: BorderStyle.none),
                  ),
                ),
                Text(
                  '正确',
                  style: TextStyle(
                      fontSize: 10, color: ColorUtils.color_text_level1),
                ),
                SizedBox(
                  width: 11,
                ),
                Container(
                  width: 10,
                  height: 10,
                  margin: EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    color: ColorUtils.color_textBg_text_choose_false,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 0, style: BorderStyle.none),
                  ),
                ),
                Text(
                  '错误',
                  style: TextStyle(
                      fontSize: 10, color: ColorUtils.color_text_level1),
                ),
                SizedBox(
                  width: 11,
                ),
                Container(
                  width: 10,
                  height: 10,
                  margin: EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                        width: 1, color: ColorUtils.color_bg_splitLine),
                  ),
                ),
                Text(
                  '未答',
                  style: TextStyle(
                      fontSize: 10, color: ColorUtils.color_text_level1),
                ),
              ],
            ),
            SizedBox(height: 5),
            Container(
              height: 0.5,
              width: double.infinity,
              color: ColorUtils.color_bg_splitLine,
            ),

            //组
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return GroupsChoice(
                    widget.reportCardEntity.groups[index], index);
              },
              itemCount: widget.reportCardEntity.groups.length,
            ),
          ],
        ),
      ),
    );
  }

  ///组
  Widget GroupsChoice(GroupsReport groupEntity, int groupIndex) {
    if (groupEntity.questionList == null || groupEntity.questionList.isEmpty) {
      return SizedBox();
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 9, right: 9, top: 8, bottom: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${splitTitle(groupEntity.name)}',
            style: TextStyle(fontSize: 14, color: ColorUtils.color_text_level1),
          ),
          SizedBox(
            height: 7,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, crossAxisSpacing: 29, mainAxisSpacing: 12),
            itemBuilder: (_, index) {
              AnswerSituationType situationType;
              if (groupEntity.questionList[index].userAnswer == null ||
                  groupEntity.questionList[index].userAnswer.isEmpty) {
                situationType = AnswerSituationType.UN_ANSWER;
              } else if (groupEntity.questionList[index].isCorrect == 0) {
                situationType = AnswerSituationType.WRONG_ANSWER;
              } else {
                situationType = AnswerSituationType.RIGHT_ANSWER;
              }
              return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (widget.clickable) {
                      String id;
                      if (groupEntity.questionList[index].extendId.isNotEmpty) {
                        id = groupEntity.questionList[index].extendId;
                      } else {
                        id = groupEntity.questionList[index].questionId;
                      }
                      int childIndex;
                      if (groupEntity.questionList[index].showNo.isNotEmpty &&
                          groupEntity.questionList[index].showNo
                              .contains('-')) {
                        childIndex = int.parse(groupEntity
                                .questionList[index].showNo
                                .split('-')
                                .last) -
                            1;
                      } else {
                        childIndex = -1;
                      }
                      widget.onItemClickListen?.call(id, childIndex);
                    }
                  },
                  child: buildAnswerItem(index + 1, situationType,
                      groupEntity.questionList[index], groupIndex));
            },
            itemCount: groupEntity.questionList.length,
          )
        ],
      ),
    );
  }

  int beforeCount = 0;
  int small = 1;
  List<String> bigQuesId = [];

  ///每题的答题情况
  Widget buildAnswerItem(int index, AnswerSituationType situationType,
      QuestionsReport questionsReport, int groupIndex) {
    BoxDecoration decoration;
    Color textColor;
    if (situationType == AnswerSituationType.UN_ANSWER) {
      decoration = unAnswerDecoration;
      textColor = ColorUtils.color_text_level1;
    } else if (situationType == AnswerSituationType.RIGHT_ANSWER) {
      decoration = rightAnswerDecoration;
      textColor = ColorUtils.color_text_choose_true;
    } else {
      decoration = wrongAnswerDecoration;
      textColor = ColorUtils.color_text_choose_fasle;
    }

    String show =
        '${questionsReport.showNo.isNotEmpty ? questionsReport.showNo : index}';
    String comeFromShow;
    if (!show.contains('-')) {
      beforeCount += 1;
      comeFromShow = beforeCount.toString();
    } else {
      List<String> split = show.split('-');
      if (!bigQuesId.contains(split[0])) {
        small = 1;
        beforeCount += 1;
        comeFromShow = '$beforeCount-$small';
        bigQuesId.add(split[0]);
      } else {
        small += 1;
        comeFromShow = '$beforeCount-$small';
      }
    }

    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          width: 30,
          height: 30,
          decoration: decoration,
          child: Text(
            '${widget.comeFrom == 1 ? comeFromShow : '${questionsReport.showNo.isNotEmpty ? questionsReport.showNo : index}'}',
            style: TextStyle(fontSize: 11, color: textColor),
          ),
        ),
        Visibility(
          visible: questionsReport.isAnyQuestions == 1,
          child: Align(
              alignment: Alignment.topRight,
              child: _buildProblem(ColorUtils.color_bg_colAndQs, 12.0)),
        ),
      ],
    );
  }

  /// 构建标疑icon
  Widget _buildProblem(Color color, double size) {
    return Icon(problem, color: color, size: size);
  }

  ///根据规则获取title
  String splitTitle(String title) {
    const List<String> splitString = ["#@#", "%@%"];
    for (var v in splitString) {
      if (title.contains(v)) {
        final List<String> splitArray = title.split(v);
        title = splitArray.first;
        break;
      }
    }
    return title;
  }
}
