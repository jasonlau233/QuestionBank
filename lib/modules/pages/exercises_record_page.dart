import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/constants/eventbus_key_constants.dart';
import 'package:question_bank/core/router/app_router_navigator.dart';
import 'package:question_bank/em/filter_time_type.dart';
import 'package:question_bank/em/pager_type.dart';
import 'package:question_bank/model/data/collect_module_entity.dart';
import 'package:question_bank/model/data/exercises_record_entity.dart';
import 'package:question_bank/modules/widget/bottom_sheet_chooser.dart';
import 'package:question_bank/modules/widget/chapter_exercises.dart';
import 'package:question_bank/provider/view_model/common.dart';
import 'package:question_bank/provider/view_model/exercises_record_view_model.dart';
import 'package:question_bank/provider/widget/base_provider_widget.dart';
import 'package:question_bank/route/path.dart';
import 'package:question_bank/utils/color.dart';
import 'package:question_bank/utils/event_bus.dart';
import 'package:question_bank/widget/empty_data_container.dart';
import 'package:question_bank/widget/refresh/my_refresh.dart';

import '../../utils/theme.dart';

///做题记录
///创建者-v0.5版本-况韬
///更新者-xx版本-xx
class ExercisesRecordPage extends StatefulWidget {
  /// 标题
  final String title;

  final int subLibraryId;

  const ExercisesRecordPage({Key key, this.title, this.subLibraryId})
      : super(key: key);

  @override
  _ExercisesRecordPageState createState() => _ExercisesRecordPageState();
}

class _ExercisesRecordPageState extends State<ExercisesRecordPage>
    with RouteAware {
  ///view model
  ExercisesRecordViewModel _viewModel;

  List<String> byTimeStr = ['所有记录', '近三天记录', '近一周记录', '近一月记录'];

  GlobalKey<MyRefreshState> _appRefreshKey;

  /// 对应的页面退出刷新接口
  StreamSubscription _pageDestroyStreamSubscription;

  @override
  void initState() {
    super.initState();
    _viewModel = ExercisesRecordViewModel();
    _appRefreshKey = GlobalKey();

    /// 监听对应的回调方法
    _pageDestroyStreamSubscription = EventBus.instance.registerListen(
      EVENTBUS_PAGE_DESTROY_KEY,
      (dynamic data) async {
        _appRefreshKey.currentState.refresh();
      },
    );
  }

  @override
  void dispose() {
    _viewModel = null;
    _appRefreshKey = null;
    _pageDestroyStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseProviderWidget<ExercisesRecordViewModel>(
      viewModel: _viewModel,
      onModelReady: (model) {
        _viewModel.getSourceModuleList(widget.subLibraryId);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(BuildConfig.appBarHeight),
          child: AppBar(
            leading: ThemeUtils.getDefaultLeading(),
            centerTitle: true,
            title: Text(
              widget.title,
              style: ThemeUtils.getAppBarTitleTextStyle(context),
            ),
          ),
        ),
        body: Column(
          children: [
            ///筛选器
            Container(
              height: 43,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///类型筛选
                  _buildSortBySource(),

                  Spacer(),

                  ///时间筛选
                  _buildSortByTime(),
                ],
              ),
            ),

            ///做题记录列表
            Expanded(
              child: Selector<ExercisesRecordViewModel, bool>(
                selector: (_, model) {
                  return model.showList;
                },
                builder: (_, showList, __) {
                  if (showList) {
                    return MyRefresh<ExercisesRecordEntity>(
                      key: _appRefreshKey,
                      isSliver: true,
                      loadDataCallBack: _loadData,
                      buildListItemCallBack: _buildListItem,
                      emptyWidget: EmptyDataContainer(title: '做题记录为空'),
                    );
                  } else {
                    return EmptyDataContainer(title: '做题记录为空');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<ExercisesRecordEntity>> _loadData(int offset) async {
    return await _viewModel.getExamRecordByPage(

        ///用户id
        Provider.of<Common>(context, listen: false).storageUserInfoEntity.uid,
        offset);
  }

  Widget _buildListItem(
      BuildContext context, ExercisesRecordEntity entity, int index) {
    return _buildRecordItem(entity, index);
  }

  ///类型筛选
  _buildSortBySource() {
    return Container(
      margin: EdgeInsets.only(left: 12),
      height: 25,
      width: 93,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12.5)),
      ),
      child: Consumer<ExercisesRecordViewModel>(
        builder: (_, model, child) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: sourceExpandShow,
            child: Text(
              '${model.typeText}',
              style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.color_text_theme,
                  fontWeight: FontWeight.w600),
            ),
          );
        },
      ),
    );
  }

  ///时间筛选
  _buildSortByTime() {
    return Container(
      margin: EdgeInsets.only(right: 12),
      height: 25,
      width: 93,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12.5)),
      ),
      child: Consumer<ExercisesRecordViewModel>(
        builder: (_, model, child) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: timeExpandShow,
            child: Text(
              byTimeStr[model.recordTimeType.index],
              style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.color_text_theme,
                  fontWeight: FontWeight.w600),
            ),
          );
        },
      ),
    );
  }

  ///pos item的个数
  _buildRecordItem(ExercisesRecordEntity entity, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _itemTap(entity),
      child: Container(
          width: double.infinity,
          //只有第一个才有顶部的间距
          margin: EdgeInsets.only(
              left: 12, right: 12, top: index == 0 ? 9 : 0, bottom: 9),
          padding: EdgeInsets.only(left: 17, right: 17),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            //暂时没有圆角，先写好，怕后面加
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 9, bottom: 6),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        '${entity.param5}',
                        strutStyle: StrutStyle(
                            forceStrutHeight: true, height: 1, leading: 0.2),
                        style: TextStyle(
                            fontSize: 14,
                            color: ColorUtils.color_text_level1,
                            fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      children: [
                        Text(
                          '${entity.updateDate.split(' ')[0]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: ColorUtils.color_text_level3),
                        ),
                        SizedBox(width: 6),
                        Text(
                          (entity.param9 != '0')
                              ? '共${entity.selectNum}题，做对${entity.rightNum}题 ${entity.typeId == 2 ? '，共得${entity.examScore.toInt()}分' : ''}。'
                              : '未完成',
                          style: TextStyle(
                              fontSize: 12,
                              color: (entity.param9 != '0')
                                  ? ColorUtils.color_text_theme
                                  : ColorUtils.color_text_level3),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: _buildClickBtn(entity),
              ),
            ],
          )),
    );
  }

  /// 试查看记录还是继续做题的按钮(已做完显查看记录，未做完显示继续做题)
  /// questionNum 题目数量
  /// doneNum 已做数
  Widget _buildClickBtn(ExercisesRecordEntity entity) {
    bool isFinished = (entity.param9 != '0');
    return Container(
      height: 24,
      width: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isFinished
            ? ColorUtils.color_textBg_forTheme
            : ColorUtils.color_bg_theme,
        border: Border.all(color: ColorUtils.color_bg_theme, width: 1),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Consumer<ExercisesRecordViewModel>(
        builder: (_, model, child) {
          return Text(
            isFinished ? (entity.typeId == 2 ? '查看记录' : '查看报告') : '继续做题',
            style: TextStyle(
                fontSize: 12,
                color: isFinished ? ColorUtils.color_text_theme : Colors.white),
          );
        },
      ),
    );
  }

  ///记录时间底部展开
  void timeExpandShow() {
    showBottomSheetChooser<void>(
        context: context,
        strList: byTimeStr,
        selectedIndex: _viewModel.recordTimeType.index,
        title: '做题时间筛选',
        onClick: (index) {
          _viewModel.recordTimeType = FilterTimeType.values[index];
          _appRefreshKey.currentState.refresh();
        });
  }

  ///来源筛选底部展开
  void sourceExpandShow() {
    if (_viewModel.sourceModuleList != null &&
        _viewModel.sourceModuleList.isNotEmpty) {
      List<String> strList = [];
      int selectedIndex = -1;
      for (FilterModuleEntity entity in _viewModel.sourceModuleList) {
        strList.add(entity.name);
        if (entity.name == _viewModel.typeText) {
          selectedIndex = _viewModel.sourceModuleList.indexOf(entity);
        }
      }
      showBottomSheetChooser<void>(
          context: context,
          strList: strList,
          selectedIndex: selectedIndex,
          title: '做题类型筛选',
          onClick: (index) {
            _viewModel.typeText = _viewModel.sourceModuleList[index].name;
            _viewModel.typeId = _viewModel.sourceModuleList[index].type;
            _appRefreshKey.currentState.refresh();
          });
    }
  }

  ///做题记录item点击（查看统计或者继续做题）
  void _itemTap(ExercisesRecordEntity entity) {
    ///判断如果做完了，跳到做题报告
    if (entity.param9 != '0') {
      String router;
      if (entity.typeId == PagerType.PRACTICE ||
          entity.typeId == PagerType.ERROR) {
        ///练习报告
        router = EXEC_REPORT;
      } else if (entity.typeId == PagerType.EXAM) {
        ///考试报告
        router = TEST_EXEC_REPORT;
      }
      if (router != null && router.isNotEmpty) {
        String type = '';
        print('param5${entity.param5}');
        if (_viewModel.typeText != '所有类型') {
          type = _viewModel.typeText;
        } else if (entity.typeId == PagerType.PRACTICE) {
          type = '考点精练';
        }
        AppRouterNavigator.of(context).push(
          router,
          needLogin: true,
          params: {
            "title": entity.param5,
            "recordId": entity.id,
            "paperUuid": entity.paperUuid,
            "examId": entity.examId,
            "pid": BuildConfig.productLine,
            "questionIds": entity.praticeQids,
            "subModuleName": type,
            "mode": entity.param10
          },
        );
      }

      ///如果没做完，就继续做题
    } else {
      final bool isFirstSettings =
          Provider.of<Common>(context, listen: false).isFirstSettings;
      if (isFirstSettings) {
        showCustomBrushQuestionBottomSheet(context: context);
        return;
      }
      String type = '';
      if (_viewModel.typeText != '所有类型') {
        type = _viewModel.typeText;
      } else if (entity.typeId == PagerType.PRACTICE) {
        type = '考点精炼';
      } else if (entity.typeId == PagerType.ERROR) {
        type = '错题本';
      }
      int typeId = entity.typeId;
      if (typeId == 5) {
        typeId = PagerType.PRACTICE;
      }
      AppRouterNavigator.of(context).push(
        EXAMINATION_PATH,
        needLogin: true,
        params: {
          "type": typeId,
          "origin": 3,
          "examId": entity.examId,
          "title": entity.param5,
          "mainTitle": entity.param5,
          "paperUuid": entity.paperUuid,
          "recordId": entity.id,
          "subLibraryModuleName": type,
        },
      );
    }
  }

  /*String getTitle(String title, int typeId, dynamic mode) {
    if (mode == '') {
      if (typeId == PagerType.PRACTICE) {
        return '考点精练-$title';
      } else if (typeId == PagerType.ERROR) {
        return '错题本-$title';
      } else {
        return title;
      }
    }
    String modeStr = '';
    if (mode == '1') {
      modeStr = '-背题';
    }
    if (typeId == PagerType.PRACTICE) {
      return '考点精练-$title$modeStr';
    } else if (typeId == PagerType.ERROR) {
      return '错题本-$title$modeStr';
    } else {
      return title;
    }
  }*/
}
