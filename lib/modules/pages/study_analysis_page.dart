import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_bank/core/router/app_router_navigator.dart';
import 'package:question_bank/model/data/forecast_score_entity.dart';
import 'package:question_bank/model/data/study_analysis_entity.dart';
import 'package:question_bank/provider/view_model/study_analysis_model.dart';
import 'package:question_bank/provider/widget/base_provider_widget.dart';
import 'package:question_bank/utils/color.dart';
import 'package:question_bank/utils/date_convert.dart';
import 'package:question_bank/utils/icon.dart';
import 'package:question_bank/utils/number_trans.dart';
import 'package:question_bank/widget/expand_text/expanded_text.dart';
import 'package:question_bank/widget/percent_indicator/linear_percent_indicator.dart';
import 'package:question_bank/widget/radar_chart.dart';

///学情报告
class StudyAnalysisPage extends StatefulWidget {
  ///模块id
  final int subLibraryId;

  const StudyAnalysisPage({Key key, this.subLibraryId}) : super(key: key);

  @override
  _StudyAnalysisPageState createState() => _StudyAnalysisPageState();
}

class _StudyAnalysisPageState extends State<StudyAnalysisPage> {
  final BoxDecoration shadowBoxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.0),
      boxShadow: [
        BoxShadow(
          color: ColorUtils.color_bg_noChoose_splitLine,
          offset: Offset(0, 0), //阴影xy轴偏移量
        )
      ]);

  final BoxDecoration shadowBoxDecoration2 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.0),
      boxShadow: [
        BoxShadow(
            color: ColorUtils.color_bg_splitLine,
            offset: Offset(0, 0), //阴影xy轴偏移量
            blurRadius: 5.0, //阴影模糊程度
            spreadRadius: 1)
      ]);

  BoxDecoration actionBoxDecoration = BoxDecoration(
    shape: BoxShape.rectangle,
    color: ColorUtils.color_bg_theme,
    borderRadius: BorderRadius.all(Radius.circular(2)),
  );

  BoxDecoration actionBoxDecoration2 = BoxDecoration(
    shape: BoxShape.rectangle,
    color: Color(0xFFECF5FF),
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );

  StudyAnalysisModel _model;

  @override
  void initState() {
    _model = StudyAnalysisModel(widget.subLibraryId);
    super.initState();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseProviderWidget<StudyAnalysisModel>(
      viewModel: _model,
      autoDispose: false,
      showHeader: true,
      onModelReady: (model) async {
        _model.getForcastScore();
        _model.getStudyAnalysisChapterSection();
      },
      child: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ///头部圆弧阴影跟预测分
            Column(
              children: [
                buildTopScore(context),
                SizedBox(
                  height: 200,
                ),
              ],
            ),

            Positioned(
              child: Padding(
                padding: const EdgeInsets.only(top: 85),
                child: SingleChildScrollView(
                  physics: Platform.isAndroid
                      ? ClampingScrollPhysics()
                      : BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ///名师点评
                      buildTeacherComment(),

                      ///预测分
                      buildForecastScore(),

                      ///掌控度分析
                      buildMasterAnalysis(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///章节的掌握度进度
  Widget buildChapterMaster(
      StudyAnalysisInfoChapterDTOList chapterDTOList, int index) {
    if (chapterDTOList.studyAnalysisInfoChapterSectionDTOS == null ||
        chapterDTOList.studyAnalysisInfoChapterSectionDTOS.isEmpty) {
      return SizedBox();
    }
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 17, right: 17, top: 40, bottom: 30),
          padding: EdgeInsets.only(top: 15, bottom: 38, left: 17, right: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.color_text_level1),
              ),
              SizedBox(height: 14),
              Text(
                '',
                style: TextStyle(
                    fontSize: 12, color: ColorUtils.color_text_level1),
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return buildSectionMasterProgress(
                      index,
                      chapterDTOList
                          .studyAnalysisInfoChapterSectionDTOS[index]);
                },
                itemCount:
                    chapterDTOList.studyAnalysisInfoChapterSectionDTOS.length,
              ),
            ],
          ),
        ),
        buildColorMark2(),
        buildTitle(chapterDTOList, index),
      ],
    );
  }

  ///单节的进度
  Widget buildSectionMasterProgress(
      int index, StudyAnalysisInfoChapterSectionDTOS sectionDTOS) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}.${sectionDTOS.sectionName}',
            style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level1),
          ),
          SizedBox(height: 4),
          LinearPercentIndicator(
            percent: getSectionProgress(sectionDTOS),
            target: 0.6,
            lineHeight: 10,
            padding: EdgeInsets.symmetric(horizontal: 4),
            width: MediaQuery.of(context).size.width - 17 * 3 - 22,
            backgroundColor: ColorUtils.color_bg_choose_exclude,
            progressColor: ColorUtils.color_bg_theme,
            linearStrokeCap: LinearStrokeCap.circle,
            showTarget: true,
            targetColor: ColorUtils.color_judgement,
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '我的 : ${sectionDTOS.sectionCorrect}%',
                style:
                    TextStyle(fontSize: 10, color: ColorUtils.color_text_theme),
              ),
              Text(
                '目标 : 60%',
                style:
                    TextStyle(fontSize: 10, color: ColorUtils.color_judgement),
              ),
              Text(
                '100',
                style:
                    TextStyle(fontSize: 10, color: ColorUtils.color_text_theme),
              ),
            ],
          )
        ],
      ),
    );
  }

  double getSectionProgress(StudyAnalysisInfoChapterSectionDTOS sectionDTOS) {
    int progress = sectionDTOS.sectionCorrect ?? 0;
    if (progress < 0) {
      progress = 0;
    }
    if (progress > 100) {
      progress = 100;
    }
    return progress / 100;
  }

  ///章节进度'目标' 跟 '我的' 颜色标记
  buildColorMark2() {
    return Positioned(
        top: 45,
        right: 40,
        child: Column(
          children: [
            buildColorMarkItem(ColorUtils.color_judgement, '目标'),
            SizedBox(height: 10),
            buildColorMarkItem(ColorUtils.color_bg_theme, '我的')
          ],
        ));
  }

  ///节的掌握度title
  buildTitle(StudyAnalysisInfoChapterDTOList chapterDTOList, int index) {
    return Positioned(
        top: 45,
        left: 30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'第${ConvertNumberToChinese.toChinese((index + 1).toString())}章'} : ${chapterDTOList.chapterName}',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: ColorUtils.color_text_level1),
            ),
            SizedBox(height: 14),
            Text(
              '掌握度（%）',
              style:
                  TextStyle(fontSize: 12, color: ColorUtils.color_text_level1),
            )
          ],
        ));
  }

  ///掌控度分析
  buildMasterAnalysis() {
    List<int> ticks = [25, 50, 75, 100];

    return Consumer<StudyAnalysisModel>(
      builder: (_, model, __) {
        if (model.forecastScoreEntity == null ||
            model.studyAnalysisChapterSectionEntity == null) {
          return SizedBox();
        }
        if (model.studyAnalysisChapterSectionEntity
                    .studyAnalysisInfoChapterDTOList ==
                null ||
            model.studyAnalysisChapterSectionEntity
                .studyAnalysisInfoChapterDTOList.isEmpty) {
          model.studyAnalysisChapterSectionEntity
              .studyAnalysisInfoChapterDTOList = [];
          for (int i = 0; i < 6; i++) {
            model.studyAnalysisChapterSectionEntity
                .studyAnalysisInfoChapterDTOList
                .add(StudyAnalysisInfoChapterDTOList(
                    chapterCorrect: 30, chapterName: ''));
          }
        }
        List<String> features = [];
        List<String> featuresReal = [];
        List<int> avgScore = [];
        List<int> score = [];
        List<List<int>> data = [];
        for (int i = 0;
            i <
                model.studyAnalysisChapterSectionEntity
                    .studyAnalysisInfoChapterDTOList.length;
            i++) {
          features
              .add('第${ConvertNumberToChinese.toChinese((i + 1).toString())}章');
          featuresReal.add(model.studyAnalysisChapterSectionEntity
              .studyAnalysisInfoChapterDTOList[i].chapterName);
          avgScore.add(60);
          int scoreChapter = model.studyAnalysisChapterSectionEntity
              .studyAnalysisInfoChapterDTOList[i].chapterCorrect;
          if (scoreChapter == null) {
            scoreChapter = 0;
          }
          score.add(scoreChapter);
        }
        data.add(avgScore);
        data.add(score);

        print('avgScore:$avgScore.toString()');
        print('score:$score.toString()');

        return Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: EdgeInsets.only(top: 9),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Image.asset(
                        'assets/images/title_decorate.png',
                        width: 90,
                      ),
                      Positioned(
                        child: Center(
                          child: Text(
                            '掌握度分析',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 220,
                    height: 220,
                    child: RadarChart(
                        //默认选中的第几章
                        selectedFeature: 0,

                        ///第几章点击回调
                        onItemClickListen: (index) {
                          _model.selectedChapterIndex = index;
                        },

                        ///多边图内到外递增的提示分级
                        ticks: ticks,

                        ///外层的第几章
                        features: features,

                        ///外层真实章名
                        featuresReal: featuresReal,
                        data: data,
                        reverseAxis: false,
                        sides: features.length,

                        ///能力图颜色 第一个是平均色  第二个是我的颜色
                        graphColors: [
                          ColorUtils.color_learning_situation_target_bg,
                          ColorUtils.color_learning_situation_bg
                        ],

                        ///多边图最外面的线的颜色
                        outlineColor: ColorUtils
                            .color_learning_situation_radar_chart_line,

                        ///多边图放射线的颜色
                        axisColor: ColorUtils
                            .color_learning_situation_radar_chart_line,

                        ///多边图内到外递增的提示分级字体风格
                        ticksTextStyle: TextStyle(
                            fontSize: 11, color: ColorUtils.color_text_theme),

                        ///外层章名字体风格
                        featuresTextStyle: TextStyle(
                            fontSize: 12, color: ColorUtils.color_text_level1),

                        ///外层选中的章名的字体风格
                        selectedFeaturesTextStyle: TextStyle(
                          fontSize: 15,
                          color: ColorUtils.color_text_theme,
                          fontWeight: FontWeight.w600,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                              color:
                                  ColorUtils.color_text_theme.withOpacity(0.7),
                            ),
                          ],
                        )),
                  ),

                  ///章节的掌握度进度
                  buildChapterMaster(
                      model.studyAnalysisChapterSectionEntity
                              .studyAnalysisInfoChapterDTOList[
                          model.selectedChapterIndex],
                      model.selectedChapterIndex)
                ],
              ),
            ),

            ///'目标' 跟 '我的' 颜色标记
            buildColorMark(),
          ],
        );
      },
    );
  }

  ///'目标' 跟 '我的' 颜色标记
  buildColorMark() {
    return Positioned(
        top: 60,
        right: 22,
        child: Column(
          children: [
            buildColorMarkItem(
                ColorUtils.color_learning_situation_target_bg, '目标'),
            SizedBox(height: 10),
            buildColorMarkItem(ColorUtils.color_learning_situation_bg, '我的')
          ],
        ));
  }

  ///颜色标记
  Widget buildColorMarkItem(Color bg, String content) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: bg,
        ),
        SizedBox(width: 5),
        Text(
          content,
          style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level1),
        )
      ],
    );
  }

  ///预测分趋势
  buildForecastScore() {
    return Selector<StudyAnalysisModel, ForecastScoreEntity>(
      selector: (_, model) {
        return model.forecastScoreEntity;
      },
      builder: (_, entity, __) {
        if (entity == null) {
          return SizedBox();
        }
        return Container(
          margin: EdgeInsets.only(top: 9),
          height: 328,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Image.asset(
                  'assets/images/title_decorate.png',
                  width: 90,
                ),
              ),
              Positioned(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        '预测分趋势',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        '预测分',
                        style: TextStyle(
                            fontSize: 11, color: ColorUtils.color_text_level1),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 18.0, bottom: 12),
                          child: LineChart(
                            forecastScoreData(entity),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///做题总数，正确率，总做题时间，刷题天数
  Widget buildInformation(StudyAnalysisModel model) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildInformationItem(
              count: '${model.studyAnalysisChapterSectionEntity.doneCounts}',
              suffix: '道',
              content: '做题总数'),
          buildLine(),
          buildInformationItem(
              count:
                  '${model.studyAnalysisChapterSectionEntity.corrects ?? 0 / model.studyAnalysisChapterSectionEntity.doneCounts ?? 0 * 100}',
              suffix: '%',
              content: '正确率'),
          buildLine(),
          buildInformationItem(
              count:
                  '${model.useTime(model.studyAnalysisChapterSectionEntity.doneTimes)}',
              content: '总做题时间'),
          buildLine(),
          buildInformationItem(
              count: '${buildDaysShow(model)}', suffix: '天', content: '刷题天数'),
        ],
      ),
    );
  }

  String buildDaysShow(StudyAnalysisModel model) {
    int days = model.forecastScoreEntity.effectiveDayCount;
    if (days > 999) {
      return '999+ ';
    }
    return days.toString();
  }

  ///线
  Widget buildLine() {
    return Container(
      width: 0.5,
      height: 21,
      color: ColorUtils.color_bg_splitLine,
    );
  }

  ///每个信息数据的item
  Widget buildInformationItem({String count, String suffix, String content}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$count',
              style:
                  TextStyle(fontSize: 14, color: ColorUtils.color_text_theme),
            ),
            Text(
              '${suffix ?? ''}',
              style:
                  TextStyle(fontSize: 11, color: ColorUtils.color_text_theme),
            ),
          ],
        ),
        SizedBox(height: 3),
        Text(
          '$content',
          style: TextStyle(
              fontSize: 11,
              color: ColorUtils.color_text_level1,
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  ///名师点评
  Widget buildTeacherComment() {
    return Consumer<StudyAnalysisModel>(
      builder: (_, model, __) {
        if (model.forecastScoreEntity == null ||
            model.studyAnalysisChapterSectionEntity == null) {
          return SizedBox();
        }
        return Container(
          width: MediaQuery.of(context).size.width - 24,
          decoration: shadowBoxDecoration,
          margin: EdgeInsets.only(left: 12, right: 12, top: 125),
          child: Column(
            children: [
              SizedBox(
                height: 42,
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    Container(
                      width: 4,
                      height: 14,
                      decoration: actionBoxDecoration,
                    ),
                    SizedBox(width: 6),
                    Text('名师点评',
                        style: TextStyle(
                            color: ColorUtils.color_text_level1,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 23),
                width: double.infinity,
                decoration: actionBoxDecoration2,
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 10),
                      child: ClipOval(
                        child: Image.network(
                          '${model.studyAnalysisChapterSectionEntity.teacherAvatar}',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: ExpandableText(
                        '${getFirstText()}${needBetweenText() ? '${model.getScore(60 - model.studyAnalysisChapterSectionEntity.predictionScore ?? 0)}就可以达到及格分了，其中，' : ''}${getMiddleText()}${getLastText()}',
                        firstText: '${getFirstText()}',
                        needBetweenText: needBetweenText(),
                        firstText2:
                            '${model.getScore(60 - model.studyAnalysisChapterSectionEntity.predictionScore ?? 0)}分',
                        middleText2: '就可以达到及格分了，其中，',
                        middleText: '${getMiddleText()}',
                        lastText: TextSpan(text: getLastText()),
                        expandText: getExpand(),
                        collapseText: getCollapse(),
                        maxMiddleCount: getMiddleCount(),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        linkColor: ColorUtils.color_bg_theme,
                        onExpandedChanged: (value) => print(value),
                      ),
                    ),
                  ],
                ),
              ),

              ///做题总数，正确率，总做题时间，刷题天数
              buildInformation(model),
            ],
          ),
        );
      },
    );
  }

  bool needBetweenText() {
    double predictionScore =
        _model.studyAnalysisChapterSectionEntity.predictionScore;
    if (predictionScore == null) {
      return false;
    }
    return _model.studyAnalysisChapterSectionEntity.predictionScore >= 30 &&
        _model.studyAnalysisChapterSectionEntity.predictionScore < 60;
  }

  String getFirstText() {
    double predictionScore =
        _model.studyAnalysisChapterSectionEntity.predictionScore;
    if (predictionScore == null) {
      predictionScore = 0;
    }
    if (predictionScore >= 0 && predictionScore < 30) {
      return '刷题量太少，正确率有点不忍直视哦。建议重视核心考点，理解重点考点，重视刷基础题目，反复刷历年真题。';
    } else if (predictionScore >= 30 && predictionScore < 60) {
      return '再提升';
    } else if (predictionScore >= 60 && predictionScore < 80) {
      return '继续保持就可以过线了哦。再重点注意';
    } else {
      return '很棒哦！继续保持冲刺全国会计考试金银榜。就目前看你';
    }
  }

  String getMiddleText() {
    double predictionScore =
        _model.studyAnalysisChapterSectionEntity.predictionScore;
    if (predictionScore == null) {
      predictionScore = 0;
    }
    if (predictionScore >= 0 && predictionScore < 30) {
      return '';
    } else if (predictionScore >= 30 && predictionScore < 60) {
      return '${_model.listToStr(_model.studyAnalysisChapterSectionEntity.returnsChapterComments)}';
    } else if (predictionScore >= 60 && predictionScore < 80) {
      return '${_model.listToStr(_model.studyAnalysisChapterSectionEntity.returnsSectionComments)}';
    } else {
      return '${_model.listToStr(_model.studyAnalysisChapterSectionEntity.returnsKnowledgeComments)}';
    }
  }

  String getLastText() {
    double predictionScore =
        _model.studyAnalysisChapterSectionEntity.predictionScore;
    if (predictionScore == null) {
      predictionScore = 0;
    }
    if (predictionScore >= 0 && predictionScore < 30) {
      return '';
    } else if (predictionScore >= 30 && predictionScore < 60) {
      return '这几章是你的薄弱点所在，需要重点提升';
    } else if (predictionScore >= 60 && predictionScore < 80) {
      return '这些是你的拉分项所在节，需要重点刷题。';
    } else {
      return '这些是你的需要你查漏补缺重点突破的知识点。';
    }
  }

  int getMiddleCount() {
    int count = 0;
    count = getMiddleText().length;
    if (count > 10) {
      return 10;
    }
    return count;
  }

  String getExpand() {
    if (getMiddleCount() == 10) {
      return '查看更多';
    } else {
      return '';
    }
  }

  String getCollapse() {
    if (getMiddleCount() == 10) {
      return '收起';
    } else {
      return '';
    }
  }

  ///头部圆弧阴影跟预测分
  Widget buildTopScore(BuildContext context) {
    return Selector<StudyAnalysisModel, StudyAnalysisChapterSectionEntity>(
      selector: (_, model) {
        return model.studyAnalysisChapterSectionEntity;
      },
      builder: (_, studyAnalysisChapterSectionEntity, __) {
        if (studyAnalysisChapterSectionEntity == null) {
          return SizedBox();
        }
        return Stack(
          children: [
            ///蓝色圆弧渐变阴影
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom:
                    Radius.elliptical(MediaQuery.of(context).size.width, 100),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 301,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      //渐变位置
                      begin: Alignment.topCenter, //右上
                      end: Alignment.bottomCenter, //左下
                      stops: [
                        0.0,
                        1.0
                      ], //[渐变起始点, 渐变结束点]
                      //渐变颜色[始点颜色, 结束颜色]
                      colors: [
                        ColorUtils.color_bg_theme,
                        ColorUtils.color_shadow_remove_error_question
                      ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: IconButton(
                  tooltip: null,
                  icon: const Icon(back, size: 15, color: Colors.white),
                  onPressed: () {
                    AppRouterNavigator.of(context).pop();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 47),
                child: Column(
                  children: [
                    const Text(
                      '学情分析报告',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 29),
                    const Text(
                      '预测分',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),

                    ///预测分数
                    _buildScore(studyAnalysisChapterSectionEntity)
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  ///预测分显示
  Widget _buildScore(
      StudyAnalysisChapterSectionEntity studyAnalysisChapterSectionEntity) {
    if (studyAnalysisChapterSectionEntity.doneCounts >= 70) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${_model.getScore(studyAnalysisChapterSectionEntity.predictionScore)}',
            style: TextStyle(
                fontSize: 50, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '分/100分',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          )
        ],
      );
    } else {
      return Column(
        children: [
          Text(
            '做题量太少无法得出预测分',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            '继续加油做题哦～',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
      );
    }
  }

  List<Color> gradientColors = [
    ColorUtils.color_bg_theme,
  ];

  ///预测分趋势数据
  LineChartData forecastScoreData(ForecastScoreEntity entity) {
    List<String> dateStr = DateConvertUtil.getBeforeDatesStrList(9);
    List<String> dataStr2 = DateConvertUtil.getBeforeDatesStrList(9,
        format: DateFormat.MONTH_DAY, dateSeparate: '/');
    Map<String, double> scoreFromDate = Map();
    for (String date in dateStr) {
      scoreFromDate[date] = 0;
    }
    for (AppAnalysisRecords records in entity.appAnalysisRecords) {
      scoreFromDate[records.date] = records.predictionScore;
    }
    List<FlSpot> spots = [];
    for (int i = 0; i < dateStr.length; i++) {
      spots.add(FlSpot(i.toDouble(), scoreFromDate[dateStr[i]] / 10));
      //print('FlSpot:date${[dateStr[i]]} score${scoreFromDate[dateStr[i]] / 10}');
    }

    return LineChartData(
      ///点击曲线图的数据提示
      lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: defaultLineTooltipItem,
            tooltipBgColor: ColorUtils.color_bg_theme.withOpacity(0.11),
          ),
          handleBuiltInTouches: true),
      gridData: FlGridData(
        show: true,

        ///x轴的线显示间隔
        horizontalInterval: 2,

        ///y轴的线显示间隔
        verticalInterval: 2,

        ///是否绘制y轴的线
        drawVerticalLine: false,

        ///x轴的线绘制
        getDrawingHorizontalLine: (value) {
          return HorizontalLine(
            y: 0,
            color: ColorUtils.color_text_exclude,
            //虚线
            dashArray: [3, 4],
            strokeWidth: 1,
          );
        },
      ),

      ///x轴底部标题
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: ColorUtils.color_text_level1, fontSize: 11),
          getTitles: (value) {
            if (value == 8) {
              return '今天';
            } else if (value == 7) {
              return '昨天';
            } else if (value == 6) {
              return '前天';
            } else {
              return '${dataStr2[value.toInt()]}';
            }
          },
          margin: 8,
        ),

        ///y轴左侧标题
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: ColorUtils.color_text_level1,
            fontSize: 11,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 2:
                return '20';
              case 4:
                return '40';
              case 6:
                return '60';
              case 8:
                return '80';
              case 10:
                return '100';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),

      ///边框的线
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: ColorUtils.color_text_exclude,
            width: 0.5,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,

      ///x轴最大单位
      maxX: 8,
      minY: 0,

      ///y轴最大单位
      maxY: 12,
      lineBarsData: [
        LineChartBarData(
          spots: spots,

          ///曲线还是直线
          isCurved: false,

          ///线的颜色
          colors: gradientColors,

          ///趋势线宽
          barWidth: 3,

          ///线的尽头是否圆角
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),

          ///线下面的渐变颜色处理
          belowBarData: BarAreaData(
            show: true,
            colors: [
              ColorUtils.color_bg_theme.withOpacity(0.48),
              ColorUtils.color_bg_theme.withOpacity(0.11)
            ],
            gradientColorStops: [0.2, 1.0],
            gradientTo: const Offset(0, 1),
          ),
        ),
      ],
    );
  }

  /// Default implementation for [LineTouchTooltipData.getTooltipItems].
  List<LineTooltipItem> defaultLineTooltipItem(List<LineBarSpot> touchedSpots) {
    if (touchedSpots == null) {
      return null;
    }

    return touchedSpots.map((LineBarSpot touchedSpot) {
      if (touchedSpot == null) {
        return null;
      }
      final TextStyle textStyle = TextStyle(
        color: touchedSpot.bar.colors[0],
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      return LineTooltipItem(
          _model
              .getScore(double.parse((touchedSpot.y * 10).toStringAsFixed(1))),
          textStyle);
    }).toList();
  }
}
