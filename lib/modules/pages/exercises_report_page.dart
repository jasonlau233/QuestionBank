import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/core/router/app_router_navigator.dart';
import 'package:question_bank/em/pager_type.dart';
import 'package:question_bank/em/view_state_type.dart';
import 'package:question_bank/model/data/exam_info_entity.dart';
import 'package:question_bank/model/data/report_card_entity.dart';
import 'package:question_bank/model/data/report_entity.dart';
import 'package:question_bank/modules/widget/chapter_exercises.dart';
import 'package:question_bank/modules/widget/report_chapter_exercises.dart';
import 'package:question_bank/provider/view_model/common.dart';
import 'package:question_bank/provider/view_model/report_view_model.dart';
import 'package:question_bank/provider/widget/base_provider_widget.dart';
import 'package:question_bank/route/path.dart';
import 'package:question_bank/utils/color.dart';
import 'package:question_bank/utils/toast.dart';
import 'package:question_bank/widget/percent_indicator/circular_percent_indicator.dart';

import '../../utils/theme.dart';
import '../widget/answer_card_widget.dart';

class ExercisesReportPage extends StatefulWidget {
  /// 标题
  final String title;

  ///用来展示的title
  final String mainTitle;

  ///做题记录id
  final String recordId;

  ///试卷id
  final String paperUuid;

  ///考试id
  final String examId;

  ///产品线id
  final int pid;

  ///多个题目id（用逗号隔开）
  final String questionIds;

  ///子模块id
  final int subModuleId;

  ///类型名字
  final String subModuleName;

  ///做题模式
  final String mode;

  ///从试卷答题卡跳转过来的答题卡数据
  final List<Groups> groupInfo;

  final int memType;

  const ExercisesReportPage(
      {Key key,
      this.title,
      this.mainTitle,
      this.recordId,
      this.paperUuid,
      this.examId,
      this.pid,
      this.questionIds,
      this.subModuleId,
      this.subModuleName,
      this.mode,
      this.groupInfo,
      this.memType})
      : super(key: key);

  @override
  _ExercisesReportPageState createState() => _ExercisesReportPageState();
}

class _ExercisesReportPageState extends State<ExercisesReportPage> {
  ReportViewModel reportViewModel;

  //小题id 的String
  String questionChildIds;

  @override
  void initState() {
    reportViewModel = ReportViewModel(widget.memType);
    reportViewModel.pagerType = PagerType.PRACTICE;
    List<String> questionIds = [];

    ///接口传小题id，小题全部遍历出来
    getQuestionChildIds(questionIds);

    super.initState();
  }

  ///接口传小题id，小题全部遍历出来
  void getQuestionChildIds(List<String> questionIds) {
    if (widget.groupInfo != null) {
      for (Groups groups in widget.groupInfo) {
        for (QuestionItem questions in groups.questionsItem) {
          questionIds.add(questions.id);
          for (QuestionItem questions in questions.questionChildrenList) {
            questionIds.add(questions.id);
          }
        }
      }

      ///题目id List转成String，骚操作，请勿模仿
      questionChildIds = questionIds.toString();
      questionChildIds = questionChildIds.replaceAll('[', '');
      questionChildIds = questionChildIds.replaceAll(']', '');
      questionChildIds = questionChildIds.replaceAll(' ', '');
    }
  }

  @override
  void dispose() {
    reportViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseProviderWidget<ReportViewModel>(
      viewModel: reportViewModel,
      onModelReady: (model) async {
        await onModelReady(model);
      },
      showHeader: true,
      child: Scaffold(
        backgroundColor: ColorUtils.color_bg_splitBlock,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(BuildConfig.appBarHeight),
          child: AppBar(
            leading: ThemeUtils.getDefaultLeading(),
            centerTitle: true,
            title: Text(
              '练习做题报告',
              style: ThemeUtils.getAppBarTitleTextStyle(context),
            ),
          ),
        ),

        ///报告信息
        body: Consumer<ReportViewModel>(
          builder: (_, model, child) {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    ///考试信息及个人信息
                    SliverToBoxAdapter(
                        child: _buildReportInfo(model.reportEntity)),

                    ///答题卡
                    SliverToBoxAdapter(
                      child: AnswerCardWidget(
                        model.reportCardEntity,
                        clickable: true,
                        onItemClickListen: (String questionId, int childIndex) {
                          jumpSingleQuestion(questionId, childIndex);
                        },
                      ),
                    ),

                    ///本次练习分析(文字)
                    SliverToBoxAdapter(
                        child: _buildAnalysis(model.reportEntity)),

                    ///章节分布
                    SliverList(
                      delegate: new SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return ReportChapterExercises(
                          data: model.reportEntity.chapters[index],
                          isExpanded: true,
                        );
                      }, childCount: model.reportEntity.chapters.length //30个列表项
                          ),
                    ),

                    ///防止被底部遮住
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: 42,
                    )),
                  ],
                ),

                ///底部的全部解析跟错误分析
                _buildBottomAnalysis()
              ],
            );
          },
        ),
      ),
    );
  }

  Future onModelReady(ReportViewModel model) async {
    String quesIds;
    if (questionChildIds != null) {
      quesIds = questionChildIds;
    } else {
      quesIds = widget.questionIds;
    }
    reportViewModel.viewState = ViewState.Loading;
    bool success =
        await model.getReportInfos(widget.recordId, widget.paperUuid, quesIds);
    if (success) {
      reportViewModel.viewState = ViewState.Idle;
    } else {
      reportViewModel.viewState = ViewState.Error;
    }
  }

  ///底部的全部解析跟错误分析
  Widget _buildBottomAnalysis() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: jumpAllAnalysis,
              child: Container(
                alignment: Alignment.center,
                height: 33,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(16.5)),
                  border: Border.all(
                    color: ColorUtils.color_text_theme,
                    width: 1,
                  ),
                ),
                child: Text(
                  '全部解析',
                  style: TextStyle(
                      fontSize: 14, color: ColorUtils.color_text_theme),
                ),
              ),
            ),
            SizedBox(width: 24),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: jumpErrorAnalysis,
              child: Container(
                alignment: Alignment.center,
                height: 33,
                width: 120,
                decoration: BoxDecoration(
                  color: ColorUtils.color_text_theme,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(16.5)),
                ),
                child: Text(
                  '错题解析',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///本次练习分析(文字)
  Widget _buildAnalysis(ReportEntity reportEntity) {
    double rightPercent;
    String rightPercentStr;
    if (reportEntity.questionNum == 0 || reportEntity.rightNum == 0) {
      rightPercent = 0;
    } else {
      rightPercent = reportEntity.rightNum / reportEntity.questionNum * 100;
    }
    rightPercentStr = rightPercent.toStringAsFixed(2);
    return Container(
      padding: EdgeInsets.only(left: 22, top: 15),
      alignment: Alignment.centerLeft,
      height: 55,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '本次练习分析',
            style: TextStyle(fontSize: 14, color: ColorUtils.color_text_level2),
          ),
          SizedBox(height: 4),
          Text(
            '共${reportEntity.questionNum}题，答对了${reportEntity.rightNum}道，正确率${rightPercentStr}%，用时${reportViewModel.useTime(reportEntity.totalExamTime)}',
            style:
                TextStyle(fontSize: 12, color: ColorUtils.color_text_need_do),
          )
        ],
      ),
    );
  }

  ///考试信息及个人信息
  Widget _buildReportInfo(ReportEntity reportEntity) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),

          ///题目
          Text(
            '${reportEntity.paperName}',
            style: TextStyle(color: ColorUtils.color_text_level1, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 5,
          ),

          ///交卷时间
          Text(
            '交卷时间：${reportEntity.submitTime}',
            style: TextStyle(color: ColorUtils.color_text_level1, fontSize: 12),
            maxLines: 1,
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 12),
            height: 0.5,
            width: double.infinity,
            color: ColorUtils.color_bg_splitLine,
          ),
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  Provider.of<Common>(context, listen: false)
                      .storageUserInfoEntity
                      .avatar,
                  fit: BoxFit.cover,
                  width: 42,
                  height: 42,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///名字
                  Text(
                    Provider.of<Common>(context, listen: false)
                        .storageUserInfoEntity
                        .nickname,
                    style: TextStyle(
                        fontSize: 15, color: ColorUtils.color_text_level1),
                  ),
                  SizedBox(
                    height: 2,
                  ),

                  ///答题用时
                  Text(
                    '总用时: ${reportViewModel.useTime(reportEntity.totalExamTime)}',
                    style: TextStyle(
                        fontSize: 12, color: ColorUtils.color_text_level1),
                  ),
                ],
              ),
              Spacer(),
              CircularPercentIndicator(
                radius: 67,
                lineWidth: 3,
                progressColor: ColorUtils.color_bg_theme,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: ColorUtils.color_bg_splitLine,
                percent: reportViewModel.getPercent(
                    reportEntity.rightNum.toDouble(),
                    reportEntity.questionNum.toDouble()),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${reportEntity.rightNum}',
                      style: TextStyle(
                          fontSize: 21, color: ColorUtils.color_text_level1),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '（共${reportEntity.questionNum}题）',
                      style: TextStyle(
                          fontSize: 10, color: ColorUtils.color_text_level3),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 33,
              )
            ],
          ),
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: jumpToExec,
              child: Container(
                  margin: EdgeInsets.only(top: 14, bottom: 23),
                  alignment: Alignment.center,
                  child: Text(
                    '继续练习',
                    style: TextStyle(
                        fontSize: 14, color: ColorUtils.color_text_theme),
                  ),
                  height: 26,
                  width: 94,
                  decoration: BoxDecoration(
                    color: Color(0x3322ACF9),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    border: Border.all(
                      color: ColorUtils.color_text_theme,
                      width: 1,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  ///标题
  String reportPaperName(ReportEntity reportEntity) {
    if (widget.mainTitle != null && widget.mainTitle.isNotEmpty) {
      return widget.mainTitle;
    }
    return reportEntity.paperName;
  }

  /* ///标题
  String reportName(ReportEntity reportEntity) {
    if (widget.mainTitle != null && widget.mainTitle.isNotEmpty) {
      return widget.mainTitle;
    }
    if (widget.subModuleName != null) {
      String modeStr = '';
      if (widget.mode == '1') {
        modeStr = '-背题';
      }
      return '${widget.subModuleName} ${reportEntity.paperName}$modeStr';
    } else {
      return reportEntity.paperName;
    }
  }*/

  ///跳转到练习
  void jumpToExec() {
    final bool isFirstSettings =
        Provider.of<Common>(context, listen: false).isFirstSettings;
    if (isFirstSettings) {
      showCustomBrushQuestionBottomSheet(context: context);
      return;
    }
    AppRouterNavigator.of(context).replace(
      EXAMINATION_PATH,
      params: {
        "type": PagerType.PRACTICE,
        "examId": widget.examId,
        // "origin": 3,
        "title": widget.title,
        "mainTitle": '${reportPaperName(reportViewModel.reportEntity)}',
        "paperUuid": widget.paperUuid,
        "subLibraryModuleId": widget.subModuleId.toString(),
        "subLibraryModuleName": widget.subModuleName,
        // "recordId": widget.recordId,
      },
    );
  }

  ///跳转到全部解析
  void jumpAllAnalysis() {
    final bool isFirstSettings =
        Provider.of<Common>(context, listen: false).isFirstSettings;
    if (isFirstSettings) {
      showCustomBrushQuestionBottomSheet(context: context);
      return;
    }
    AppRouterNavigator.of(context).push(
      EXAMINATION_PATH,
      params: {
        "type": 3,
        "examId": widget.examId,
        "title": widget.title,
        "mainTitle": '${reportPaperName(reportViewModel.reportEntity)}',
        "paperUuid": widget.paperUuid,
        "subLibraryModuleId": widget.subModuleId.toString(),
        "subLibraryModuleName": widget.subModuleName,
        "reportCardEntity": reportViewModel.reportCardEntity,
        "chooseQuestionIdList": reportViewModel.chooseQuestionIdList,
        "paperDataMap": reportViewModel.paperDataMap2,
        "showProblem": false
      },
    );
  }

  ///跳转到错题解析
  void jumpErrorAnalysis() {
    final bool isFirstSettings =
        Provider.of<Common>(context, listen: false).isFirstSettings;
    if (isFirstSettings) {
      showCustomBrushQuestionBottomSheet(context: context);
      return;
    }
    ReportCardEntity reportCardEntity =
        reportViewModel.arrangeCardEntity2(reportViewModel.reportCardEntity);
    if (reportViewModel.errorQuestionIdList.isEmpty) {
      ToastUtils.showText(text: '该报告没有错题,请继续保持');
      return;
    }
    AppRouterNavigator.of(context).push(
      EXAMINATION_PATH,
      params: {
        "type": 3,
        "examId": widget.examId,
        "title": widget.title,
        "mainTitle": '${reportPaperName(reportViewModel.reportEntity)}',
        "paperUuid": widget.paperUuid,
        "subLibraryModuleId": widget.subModuleId.toString(),
        "subLibraryModuleName": widget.subModuleName,
        "reportCardEntity": reportCardEntity,
        "errorQuestionIdList": reportViewModel.errorQuestionIdList,
        "chooseQuestionIdList": reportViewModel.chooseQuestionIdList,
        "paperDataMap": reportViewModel.paperDataMap2,
        "showProblem": false
      },
    );
  }

  ///跳转到单题
  void jumpSingleQuestion(String questionId, int childIndex) {
    final bool isFirstSettings =
        Provider.of<Common>(context, listen: false).isFirstSettings;
    if (isFirstSettings) {
      showCustomBrushQuestionBottomSheet(context: context);
      return;
    }
    AppRouterNavigator.of(context).push(
      EXAMINATION_PATH,
      params: {
        "type": 3,
        "examId": widget.examId,
        "title": widget.title,
        "mainTitle": '${reportPaperName(reportViewModel.reportEntity)}',
        "paperUuid": widget.paperUuid,
        "subLibraryModuleId": "",
        "subLibraryModuleName": widget.subModuleName,
        "defaultQuestionId": questionId,
        "reportCardEntity": reportViewModel.reportCardEntity,
        "chooseQuestionIdList": reportViewModel.chooseQuestionIdList,
        "paperDataMap": reportViewModel.paperDataMap2,
        "defaultQuestionChildIndex": childIndex,
      },
    );
  }
}
