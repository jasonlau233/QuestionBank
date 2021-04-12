import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/constants/eventbus_key_constants.dart';
import 'package:question_bank/core/router/app_router_navigator.dart';
import 'package:question_bank/em/filter_according_type.dart';
import 'package:question_bank/model/data/collect_accord_source_entity.dart';
import 'package:question_bank/modules/widget/chapter_exercises.dart';
import 'package:question_bank/modules/widget/collect_chapter_exercises.dart';
import 'package:question_bank/modules/widget/filter_controller.dart';
import 'package:question_bank/provider/view_model/collect_view_model.dart';
import 'package:question_bank/provider/view_model/common.dart';
import 'package:question_bank/provider/widget/base_provider_widget.dart';
import 'package:question_bank/route/path.dart';
import 'package:question_bank/utils/color.dart';
import 'package:question_bank/utils/event_bus.dart';
import 'package:question_bank/widget/empty_data_container.dart';

import '../../utils/theme.dart';

class MyCollectPage extends StatefulWidget {
  /// 标题
  final String title;

  ///动态id
  final int subLibraryId;

  ///课程id
  final int courseId;

  const MyCollectPage({Key key, @required this.title, @required this.subLibraryId, @required this.courseId})
      : super(key: key);

  @override
  _MyCollectPageState createState() => _MyCollectPageState();
}

class _MyCollectPageState extends State<MyCollectPage> {
  ///view model
  CollectViewModel _viewModel;

  /// 对应的页面退出刷新接口
  StreamSubscription _pageDestroyStreamSubscription;

  @override
  void initState() {
    super.initState();
    _viewModel = CollectViewModel();
    _viewModel.comeFromType = FilterComeFromType.Collect_Exec;
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
    _viewModel.dispose();
    _viewModel = null;
    _pageDestroyStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseProviderWidget<CollectViewModel>(
      autoDispose: false,
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

        ///列表筛选器
        body: FilterController(
          viewModel: _viewModel,

          ///筛选器来源自收藏（收藏跟错题的筛选器有差异性）
          comeFromType: FilterComeFromType.Collect_Exec,
          body:

              ///列表或者树状图
              _buildList(),
        ),
      ),
    );
  }

  ///收藏列表
  _buildList() {
    return Expanded(
      child: SafeArea(
        child: Consumer<CollectViewModel>(
          builder: (_, model, child) {
            ///按来源列表的item
            if (model.collectAccordingType == FilterAccordingType.ACCORDING_SOURCE) {
              if (model.sourceExers.isNotEmpty) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return _buildAccordingItem(model.sourceExers[index]);
                  },
                  itemCount: model.sourceExers.length,
                );
              } else {
                return EmptyDataContainer(title: '我的收藏为空');
              }
            } else if (model.collectAccordingType == FilterAccordingType.ACCORDING_CHAPTER) {
              ///按章节列表的item
              if (model.chapterExers.isNotEmpty) {
                return Container(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return CollectChapterExercises(
                        data: model.chapterExers[index],
                      );
                    },
                    itemCount: model.chapterExers.length,
                  ),
                );
              } else {
                return EmptyDataContainer(title: '我的收藏为空');
              }
            }
            return EmptyDataContainer(title: '我的收藏为空');
          },
        ),
      ),
    );
  }

  ///按来源列表的item
  _buildAccordingItem(CollectAccordSourceEntity entity) {
    List<String> questionIds = <String>[];
    Map<String, String> collectIdMap = Map<String, String>();
    for (QuestionIdAndCollectionIds questionIdAndCollectionIds in entity.questionIdAndCollectionIds) {
      questionIds.add(questionIdAndCollectionIds.questionId);
      collectIdMap[questionIdAndCollectionIds.questionId] = questionIdAndCollectionIds.collectionId;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final bool isFirstSettings = Provider.of<Common>(context, listen: false).isFirstSettings;
        if (isFirstSettings) {
          showCustomBrushQuestionBottomSheet(context: context);
          return;
        }
        String paperName = entity.paperName;
        paperName = paperName.replaceAll('考点精练 ', '');
        AppRouterNavigator.of(context).push(
          EXAMINATION_PATH,
          needLogin: true,
          params: {
            "type": 4,
            "origin": 1,
            "examId": "",
            "title": "${entity.paperName}",
            "mainTitle": "${_viewModel.collectSourceType}-$paperName-收藏",
            "paperUuid": entity.paperUuid,
            "subLibraryModuleId": _viewModel.sourceSublibraryModuleId.toString(),
            "questionIdList": questionIds,
            "collectIdMap": collectIdMap,
            "showProblem": false,
          },
        );
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
        width: double.infinity,
        margin: EdgeInsets.only(left: 12, right: 12, bottom: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
        ),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///题目
                  Text(
                    '${entity.paperName}',
                    strutStyle: StrutStyle(forceStrutHeight: true, height: 1, leading: 0.2),
                    style: TextStyle(fontSize: 14, color: ColorUtils.color_text_level1, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 6),

                  Text(
                    '收藏时间：${entity.lastCollectionDateTime}',
                    style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level3),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              height: 24,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorUtils.color_textBg_choose_select_choose,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '收藏${entity.collectionNumbers}题',
                style: TextStyle(fontSize: 12, color: ColorUtils.color_text_theme),
                maxLines: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
