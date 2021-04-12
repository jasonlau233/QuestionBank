import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/constants/eventbus_key_constants.dart';
import 'package:question_bank/core/router/app_router_navigator.dart';
import 'package:question_bank/em/filter_according_type.dart';
import 'package:question_bank/em/question_type.dart';
import 'package:question_bank/model/data/error_accord_source_entity.dart';
import 'package:question_bank/model/data/question_distribution_entity.dart';
import 'package:question_bank/model/data/storage_question_settings_entity.dart';
import 'package:question_bank/modules/widget/chapter_exercises.dart';
import 'package:question_bank/modules/widget/error_chapter_exercises.dart';
import 'package:question_bank/modules/widget/filter_controller.dart';
import 'package:question_bank/provider/view_model/common.dart';
import 'package:question_bank/provider/view_model/error_exercises_model.dart';
import 'package:question_bank/provider/widget/base_provider_widget.dart';
import 'package:question_bank/route/path.dart';
import 'package:question_bank/utils/color.dart';
import 'package:question_bank/utils/event_bus.dart';
import 'package:question_bank/widget/empty_data_container.dart';

import '../../utils/theme.dart';

class ErrorExercisesRecordPage extends StatefulWidget {
  /// 标题
  final String title;

  ///动态id
  final int subLibraryId;

  ///课程id
  final int courseId;

  const ErrorExercisesRecordPage({Key key, @required this.title, @required this.subLibraryId, @required this.courseId})
      : super(key: key);

  @override
  _ErrorExercisesRecordPageState createState() => _ErrorExercisesRecordPageState();
}

class _ErrorExercisesRecordPageState extends State<ErrorExercisesRecordPage> {
  ///view model
  ErrorExercisesModel _viewModel;

  /// 对应的页面退出刷新接口
  StreamSubscription _pageDestroyStreamSubscription;

  @override
  void initState() {
    super.initState();
    _viewModel = ErrorExercisesModel();
    _viewModel.comeFromType = FilterComeFromType.Error_Exec;
    _viewModel.courseId = widget.courseId;

    /// 监听对应的回调方法
    _pageDestroyStreamSubscription = EventBus.instance.registerListen(
      EVENTBUS_PAGE_DESTROY_KEY,
      (dynamic data) async {
        if (_viewModel.collectAccordingType == FilterAccordingType.ACCORDING_SOURCE) {
          _viewModel.getSourceExers();
        } else if (_viewModel.collectAccordingType == FilterAccordingType.ACCORDING_CHAPTER) {
          _viewModel.getChapterExers();
        }
      },
    );
  }

  @override
  void dispose() {
    _viewModel = null;
    _pageDestroyStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseProviderWidget<ErrorExercisesModel>(
      viewModel: _viewModel,
      showHeader: true,
      onModelReady: (model) async {
        ///获取按来源展开的模块
        await model.getSourceModuleList(widget.subLibraryId);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: ThemeUtils.getDefaultLeading(),
          centerTitle: true,
          toolbarHeight: BuildConfig.appBarHeight,
          title: Text(
            widget.title,
            style: ThemeUtils.getAppBarTitleTextStyle(context),
          ),
        ),
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              ///列表筛选器
              child: FilterController(
                ///筛选器来源自错题（收藏跟错题的筛选器有差异性）
                comeFromType: FilterComeFromType.Error_Exec,
                viewModel: _viewModel,
                body:

                    ///列表或者树状图
                    _buildList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///头部错题信息
  Widget _buildHeader() {
    return Selector<ErrorExercisesModel, List<AppQuestionIdAndCountDtos>>(
      selector: (_, model) {
        return model.appQuestionIdAndCountDtos;
      },
      builder: (_, appQuestionIdAndCountDtos, child) {
        Map<int, int> questionDistribution = Map();
        int totalCount = 0;
        for (AppQuestionIdAndCountDtos entity in appQuestionIdAndCountDtos) {
          questionDistribution[entity.questionTypeId] = entity.count;
          totalCount += entity.count;
        }
        return Container(
          color: Colors.white,
          width: double.infinity,
          height: 235,
          margin: EdgeInsets.only(left: 12, right: 12, top: 14),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    width: 4,
                    height: 13,
                    decoration: BoxDecoration(
                      color: ColorUtils.color_bg_theme,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                  Text(
                    '错题分布',
                    style: TextStyle(fontSize: 16, color: ColorUtils.color_text_level1, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              SizedBox(
                height: 14,
              ),

              ///头部的饼状图

              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          centerSpaceRadius: 40,
                          sectionsSpace: 0,
                          sections: showingSections(appQuestionIdAndCountDtos)),
                    ),
                  ),
                  Text(
                    '共$totalCount题',
                    style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level1),
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuestionsNum(
                      '单选题', ColorUtils.color_bg_theme, questionDistribution, QuestionType.SINGLE_CHOICE),
                  _buildQuestionsNum(
                      '多选题', ColorUtils.color_multi_choice, questionDistribution, QuestionType.MULTI_CHOICE),
                  _buildQuestionsNum('判断题', ColorUtils.color_judgement, questionDistribution, QuestionType.JUDGEMENT),
                  _buildQuestionsNum('不定项选择题', ColorUtils.color_uncertainty_choice, questionDistribution,
                      QuestionType.UNCERTAINTY_CHOICE),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestionsNum(String title, Color pointColor, Map<int, int> quesDistribution, int questionType) {
    ///把材料题算到不定项题头上
    int sourceCount = quesDistribution[QuestionType.SOURCE_CHOICE];
    int count = quesDistribution[questionType];
    if (sourceCount == null) {
      sourceCount = 0;
    }
    if (count == null) {
      count = 0;
    }
    if (questionType == QuestionType.UNCERTAINTY_CHOICE) {
      count = count + sourceCount;
    }
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: pointColor,
              radius: 3.5,
            ),
            SizedBox(width: 3),
            Text(
              '$title',
              style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level3),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          '${count ?? 0}题',
          style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level1),
        )
      ],
    );
  }

  ///错题列表记录
  _buildList() {
    return Expanded(
      child: SafeArea(
        child: Consumer<ErrorExercisesModel>(
          builder: (_, model, child) {
            ///按来源的错题
            if (model.collectAccordingType == FilterAccordingType.ACCORDING_SOURCE) {
              if (model.sourceExers.isNotEmpty) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return _buildAccordingItem(model.sourceExers[index]);
                  },
                  itemCount: model.sourceExers.length,
                );
              } else {
                return EmptyDataContainer(title: '我的错题为空');
              }

              ///按章节的错题
            } else if (model.collectAccordingType == FilterAccordingType.ACCORDING_CHAPTER) {
              if (model.chapterExers.isNotEmpty) {
                return Container(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return ErrorChapterExercises(
                        data: model.chapterExers[index],
                        examIdMap: _viewModel.examIdMap,
                      );
                    },
                    itemCount: model.chapterExers.length,
                  ),
                );
              } else {
                return EmptyDataContainer(title: '我的错题为空');
              }
            }
            return EmptyDataContainer(title: '我的错题为空');
          },
        ),
      ),
    );
  }

  ///按来源列表的item
  _buildAccordingItem(AppErrorPaperDtos entity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final bool isFirstSettings = Provider.of<Common>(context, listen: false).isFirstSettings;
        if (isFirstSettings) {
          showCustomBrushErrorQuestionBottomSheet(context: context);
          return;
        }

        List<String> questionIdList = <String>[];
        for (int id in entity.questionIds) {
          questionIdList.add(id.toString());
        }
        List<String> questionIdChildList = <String>[];
        for (ErrorRecords errorRecords in entity.errorRecords) {
          questionIdChildList.add(errorRecords.questionId);
        }
        /*int type;
        if (_viewModel.typeId == 'PRACTICE') {
          type = 1;
        } else if (_viewModel.typeId == 'EXAM') {
          type = 2;
        }*/
        final StorageQuestionSettingsInfoEntity info =
            Provider.of<Common>(context, listen: false).settingsErrorQuestionInfoEntity;

        ///错题本只跳练习报告
        AppRouterNavigator.of(context).push(
          EXAMINATION_PATH,
          needLogin: true,
          params: {
            "type": 1,
            "origin": 2,
            "examId": "",
            "title": getPaperName3(entity),
            "mainTitle": "错题本-${getPaperName2(entity)}${info.mode == 1 ? "-背题" : ""}",
            "paperUuid": entity.paperUuid,
            // _viewModel.sourceSublibraryModuleId.toString()
            "subLibraryModuleId": BuildConfig.ERROR_ID,
            "onlyNeedQuestionList": questionIdList,
            "onlyChildQuestionList": questionIdChildList,
            "errorQuestionExamId": _viewModel.examIdMap,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 9, horizontal: 16),
        height: 60,
        width: double.infinity,
        margin: EdgeInsets.only(left: 12, right: 12, bottom: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 60),
              child: Text(
                '${getPaperName(entity)}',
                strutStyle: StrutStyle(forceStrutHeight: true, height: 1, leading: 0.2),
                style: TextStyle(fontSize: 14, color: ColorUtils.color_text_level1, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
                child: Container(
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
                          text: entity.errorNumbers.toString(),
                          style: TextStyle(fontSize: 11, color: ColorUtils.color_text_level1)),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: ColorUtils.color_bg_theme)
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  ///整理标题
  String getPaperName(AppErrorPaperDtos entity) {
    if (entity.paperName.contains(' ')) {
      entity.paperName = entity.paperName.replaceFirst(' ', '-');
    }
    entity.paperName = entity.paperName.replaceAll('章节练习', '考点精练');
    return entity.paperName;
  }

  ///整理标题跳转进练习题
  String getPaperName2(AppErrorPaperDtos entity) {
    entity.paperName = entity.paperName.replaceAll('考点精练-', '');
    return entity.paperName;
  }

  String getPaperName3(AppErrorPaperDtos entity) {
    entity.paperName = entity.paperName.replaceAll('考点精练', '');
    entity.paperName = entity.paperName.replaceAll('章节练习', '');
    entity.paperName = entity.paperName.replaceAll(' ', '');
    entity.paperName = entity.paperName.replaceAll('-', '');
    return entity.paperName;
  }
}

///饼图的数据
List<PieChartSectionData> showingSections(List<AppQuestionIdAndCountDtos> appQuestionIdAndCountDtos) {
  List<PieChartSectionData> pieChartSectionDatas = [];
  Color color = ColorUtils.color_bg_splitLine;
  final double radius = 20;
  if (appQuestionIdAndCountDtos == null || appQuestionIdAndCountDtos.isEmpty) {
    pieChartSectionDatas.add(PieChartSectionData(
      showTitle: false,
      color: color,
      value: 1,
      radius: radius,
    ));
  }
  for (AppQuestionIdAndCountDtos entity in appQuestionIdAndCountDtos) {
    switch (entity.questionTypeId) {
      case QuestionType.SINGLE_CHOICE:
        color = ColorUtils.color_bg_theme;
        break;
      case QuestionType.MULTI_CHOICE:
        color = ColorUtils.color_multi_choice;
        break;
      case QuestionType.JUDGEMENT:
        color = ColorUtils.color_judgement;
        break;
      case QuestionType.UNCERTAINTY_CHOICE:
      case QuestionType.SOURCE_CHOICE:
        color = ColorUtils.color_uncertainty_choice;
        break;
      default:
        color = ColorUtils.color_bg_splitLine;
        break;
    }
    pieChartSectionDatas.add(PieChartSectionData(
      showTitle: false,
      color: color,
      value: entity.count.toDouble(),
      radius: radius,
    ));
  }
  return pieChartSectionDatas;
}
