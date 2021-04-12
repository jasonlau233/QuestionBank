import 'dart:async';

import 'package:flutter/material.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/constants/eventbus_key_constants.dart';
import 'package:question_bank/core/router/app_router_navigator.dart';
import 'package:question_bank/em/view_state_type.dart';
import 'package:question_bank/model/data/paper_answer_entity.dart';
import 'package:question_bank/model/service/examination_service.dart';
import 'package:question_bank/provider/view_model/common.dart';
import 'package:question_bank/route/path.dart';
import 'package:question_bank/utils/color.dart';
import 'package:question_bank/utils/event_bus.dart';
import 'package:question_bank/widget/lock_gesture_detector.dart';

import '../../../model/data/exam_list_item_entity.dart';
import '../../../provider/view_model/exam_list_view_model.dart';
import '../../../provider/widget/base_provider_widget.dart';
import '../../../utils/theme.dart';

/// 试卷列表
/// 创建者-v0.5版本-钟鹏飞
/// 更新者-v0.5版本-刘奥罕
class ExamListPage extends StatefulWidget {
  /// 标题
  final String title;

  final int subLibraryModuleId;

  const ExamListPage({Key key, this.title, this.subLibraryModuleId}) : super(key: key);

  @override
  _ExamListPageState createState() => _ExamListPageState();
}

class _ExamListPageState extends State<ExamListPage> {
  ExamListViewModel _viewModel;

  bool lock = false;

  /// 对应的页面退出刷新接口
  StreamSubscription _pageDestroyStreamSubscription;

  @override
  void initState() {
    super.initState();
    _viewModel = ExamListViewModel();

    /// 监听对应的回调方法
    _pageDestroyStreamSubscription = EventBus.instance.registerListen(
      EVENTBUS_PAGE_DESTROY_KEY,
      (dynamic data) async {
        _viewModel.getExamList(widget.subLibraryModuleId);
      },
    );
  }

  @override
  void dispose() {
    _pageDestroyStreamSubscription?.cancel();
    super.dispose();
  }

  /// 模型准备
  void _onModelReady(model) async {
    /// 解析一下为什么要延迟一下,就是动画太快的时候给人感觉有那种2个页面叠加凸显感觉
    model.viewState = ViewState.Loading;
    Future.delayed(
      const Duration(milliseconds: 250),
      () async => _viewModel.getExamList(widget.subLibraryModuleId),
    );
    // _viewModel.examList = await model.getExamList(122);
  }

  @override
  Widget build(BuildContext context) {
    return BaseProviderWidget<ExamListViewModel>(
      viewModel: _viewModel,
      onModelReady: _onModelReady,
      showHeader: true,
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
        body: Selector<ExamListViewModel, List<ExamListItemEntity>>(
          selector: (BuildContext context, ExamListViewModel model) {
            return model.examList;
          },
          shouldRebuild: (_, next) => true,
          builder: (BuildContext context, List<ExamListItemEntity> value, Widget child) {
            return Container(
              color: ColorUtils.color_bg_exam_list_page,
              padding: const EdgeInsets.symmetric(vertical: 4.5, horizontal: 12.0),
              child: ListView.builder(
                itemCount: value?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  var currentData = _viewModel.examList[index];
                  return LockGestureDetector(
                    onItemClickListenCallback: () async {
                      final int status = value[index]?.status;
                      if (status == 1) {
                        await checkIsContinueQuestion(value[index]);
                      } else {
                        if (Provider.of<Common>(context, listen: false).examMap.containsKey(currentData.examId)) {
                          await checkIsContinueQuestion(value[index]);
                        } else {
                          AppRouterNavigator.of(context).push(
                            EXAM_DESCRIPTION,
                            needLogin: true,
                            params: {
                              'instructions': currentData?.instructions,
                              'examList': currentData?.examGroupCountList,
                              'score': currentData?.score,
                              'questionNumber': currentData?.questionNumber,
                              'paperUuid': currentData?.paperUuid,
                              'examId': currentData?.examId,
                              'title': value[index]?.eaxmName,
                              'mainTitle': value[index]?.eaxmName,
                              'responseTime': value[index]?.responseTime,
                              'timeType': value[index]?.timeType,
                              "subLibraryModuleId": widget.subLibraryModuleId.toString(),
                            },
                          );
                        }
                      }
                      return true;
                    },
                    child: _buildExamItem(
                      examId: value[index]?.examId.toString(),
                      examName: value[index]?.eaxmName,
                      isNew: value[index]?.isNew == true,
                      finishedNum: value[index]?.finishAnswerNumber ?? 0,
                      examStatus: value[index]?.status,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// 获取对应的继续做题数据
  Future<void> checkIsContinueQuestion(ExamListItemEntity e) async {
    /// 请求一起
    /// GET /api/getExamedRecord
    final PaperAnswerEntity entity = await ExaminationService.getExamedRecordInfo(
      Provider.of<Common>(context, listen: false).storageUserInfoEntity.uid,
      e.paperUuid,
      e.examId.toString(),
      memType: 2,
    );
    if (entity != null) {
      if (entity.examDetail != null &&
          entity.examDetail.examRecord != null &&
          entity.examDetail.examRecord.param9.toString() == "0") {
        await Future.delayed(
          const Duration(milliseconds: 350),
          () {
            AppRouterNavigator.of(context).push(
              EXAMINATION_PATH,
              needLogin: true,
              params: {
                "type": 2,
                "origin": 3,
                "examId": e.examId.toString(),
                "mainTitle": e.eaxmName,
                "title": e.eaxmName,
                "paperUuid": e.paperUuid,
                "subLibraryModuleId": widget.subLibraryModuleId.toString(),
                "paperAnswerEntity": entity,
                "recordId": entity.examDetail.examRecord.id,
              },
            );
          },
        );
      }
    }
  }

  /// 参数说明：
  /// examName试卷名称，isNew：是否为新试卷，finishedNum：完成次数，examStatus：考试状态
  Container _buildExamItem({String examId, String examName, bool isNew, num finishedNum, num examStatus}) {
    // 默认显示空
    Widget finishedNumWidget = const Text(
      '',
      style: const TextStyle(
        fontSize: 10,
      ),
    );
    if (examStatus == 1) {
      finishedNumWidget = const Text(
        "未完成",
        style: const TextStyle(
          fontSize: 12,
          color: ColorUtils.color_text_need_do,
        ),
      );
    } else if (examStatus == 0 && (finishedNum ?? 0) > 0) {
      finishedNumWidget = Text(
        "已完成$finishedNum次",
        style: const TextStyle(fontSize: 12, color: ColorUtils.color_text_theme),
      );
    }
    final Map<String, String> examMap = Provider.of<Common>(context, listen: false).examMap;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.5, horizontal: 0),
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  examName ?? '',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: ColorUtils.color_text_exam_name,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 6),
                          finishedNumWidget
                        ],
                      ),
                    ),
                    Visibility(
                      child: Container(
                        height: 24,
                        width: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorUtils.color_bg_theme,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '继续做题',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      // child: Container(
                      //   constraints: BoxConstraints(
                      //     minWidth: 55
                      //   ),
                      //   height: 20,
                      //   child: IgnorePointer(
                      //     child: FlatButton(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 1, horizontal: 5),
                      //       color: ColorUtils.color_bg_theme,
                      //       highlightColor:
                      //       ColorUtils.color_bg_continue_btn,
                      //       colorBrightness: Brightness.dark,
                      //       splashColor: ColorUtils.color_bg_continue_btn,
                      //       child: Center(
                      //         child: Text(
                      //           "继续做题",
                      //           style: TextStyle(
                      //               fontSize: 12,
                      //               color: Colors.white,
                      //               height: 1.0),
                      //         ),
                      //       ),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10.0)),
                      //       onPressed: () {},
                      //     ),
                      //   ),
                      // ),
                      visible: examStatus == 1 || examMap.containsKey(examId),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Visibility(
              child: Material(
                color: ColorUtils.color_bg_choose_false,
                child: Container(
                  height: 14.0,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                  child: Center(
                    child:
                        Text("NEW", style: TextStyle(fontSize: 10.0, color: Colors.white, fontWeight: FontWeight.w400)),
                  ),
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(10.0)),
              ),
              visible: isNew == true,
            ),
          )
        ],
      ),
    );
  }
}
