import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/core/router/app_router_navigator.dart';
import 'package:question_bank/model/data/exam_group_count_entity.dart';
import 'package:question_bank/model/data/paper_answer_entity.dart';
import 'package:question_bank/model/service/examination_service.dart';
import 'package:question_bank/provider/view_model/common.dart';
import 'package:question_bank/provider/view_model/exam_description_model.dart';
import 'package:question_bank/provider/view_model/examination_view_model.dart';
import 'package:question_bank/route/path.dart';
import 'package:question_bank/utils/color.dart';
import 'package:question_bank/utils/icon.dart';
import 'package:question_bank/utils/theme.dart';
import 'package:question_bank/widget/my_image.dart';

import 'exam_description_selector.dart';

/// 试卷说明
/// 创建者-v0.5版本-况韬
/// 更新者-v0.5版本-刘奥罕
class ExamDescriptionPage extends StatefulWidget {
  /// 文本介绍
  final String instructions;

  /// 题目介绍列表 用于弹窗
  final List<ExamGroupCountEntity> examList;

  /// 总分数 用于弹窗
  final num score;

  /// 总题数 用于弹窗
  final num questionNumber;

  /// 获取已做题数的接口需要这两个参数
  final String paperUuid;
  final int examId;
  final String subLibraryModuleId;

  /// 试卷名称
  final String title;

  final int timeType;
  final int responseTime;

  /// 需要刷新调用方的数据 保存操作回调true,打开做题页面回调false
  final ValueChanged<bool> refreshCallback;

  const ExamDescriptionPage({
    Key key,
    @required this.instructions,
    @required this.examList,
    @required this.score,
    @required this.questionNumber,
    @required this.paperUuid,
    @required this.examId,
    @required this.subLibraryModuleId,
    @required this.title,
    @required this.timeType,
    @required this.responseTime,
    this.refreshCallback,
  }) : super(key: key);

  @override
  _ExamDescriptionPageState createState() => _ExamDescriptionPageState();
}

class _ExamDescriptionPageState extends State<ExamDescriptionPage> {
  ExamDescriptionModel _viewModel;

  ExamPaperInfo _examPaperInfo;
  String _examRecordId;

  @override
  void initState() {
    super.initState();
    _viewModel = ExamDescriptionModel(widget.examList);
    _viewModel.getExamGroupStatus(widget.paperUuid, widget.examId);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        showDialog();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 获取对应的继续做题数据
  Future<void> checkIsContinueQuestion() async {
    /// 请求一起
    /// GET /api/getExamedRecord
    final PaperAnswerEntity entity = await ExaminationService.getExamedRecordInfo(
      Provider.of<Common>(context, listen: false).storageUserInfoEntity.uid,
      widget.paperUuid,
      widget.examId.toString(),
    );
    if (entity != null) {
      if (entity.examDetail != null &&
          entity.examDetail.examRecord != null &&
          entity.examDetail.examRecord.param9 == "0") {
        AppRouterNavigator.of(context).push(
          EXAMINATION_PATH,
          needLogin: true,
          params: {
            "type": 2,
            "origin": 3,
            "examId": widget.examId.toString(),
            "mainTitle": widget.title,
            "title": widget.title,
            "paperUuid": widget.paperUuid,
            "subLibraryModuleId": widget.subLibraryModuleId.toString(),
            "paperAnswerEntity": entity,
            "recordId": entity.examDetail.examRecord.id,
            "onPaperConfirmListener": (ExamPaperInfo info, String examRecordId) {
              /// 说明完成提交试卷了 不在返回做题了多少
              this._examPaperInfo = info;
              if (info == null) {
                this._examRecordId = null;
              } else {
                this._examRecordId = examRecordId;
              }
              _viewModel?.defaultFinishNumber();
            },
            "timeType": widget.timeType,
            "responseTime": widget.responseTime,
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ThemeUtils.getDefaultLeading(),
        titleSpacing: 0,
        toolbarHeight: BuildConfig.appBarHeight,
        centerTitle: true,
        title: Container(
          width: 245,
          child: Text(
            widget.title ?? '',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ThemeUtils.getAppBarTitleTextStyle(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
            //const 申明变量，一旦赋值不许修改
            children: [
              const Padding(padding: const EdgeInsets.only(top: 15)),
              Text(
                '全国会计专业技术资格无纸化考试重要提示',
                style: const TextStyle(fontSize: 16, color: ColorUtils.color_text_level1),
              ),
              const Padding(padding: const EdgeInsets.only(top: 3.5)),
              Text(
                '财政部机考考试要求',
                style: const TextStyle(fontSize: 14, color: ColorUtils.color_exam_tip),
              ),
              const Padding(padding: const EdgeInsets.only(top: 10.5)),
              Text(
                widget.instructions ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorUtils.color_text_level2,
                ),
              ),
            ],
          ),
          Positioned(
            child: GestureDetector(
              onTap: showDialog,
              child: Image.asset(
                'assets/images/exam_des_selector.png',
                width: 50,
              ),
            ),
            bottom: 32,
            right: 16,
          ),
        ],
      ),
    );
  }

  String get _pageTitle =>
      // '${(widget.instructions?.length ?? 0) > 12 ? '${widget.instructions?.substring(0, 12)}...' : (widget.instructions ?? '')}';
      '${(widget.title?.length ?? 0) > 18 ? '${widget.title?.substring(0, 18)}...' : (widget.title ?? '')}';

  void showDialog() {
    ExamDescriptionSelector.showBottom(
      context: context,
      examList: _viewModel?.examList,
      questionNumber: widget.questionNumber,
      score: widget.score,
      onClick: (selectIndex) async {
        await _viewModel?.doUpdateExamStatus(widget.examId);
        // eg:消除试卷列表的new标签
        widget?.refreshCallback?.call(false);
        // 选中的数据
        ExamGroupCountEntity selectData = _viewModel?.examList[selectIndex];

        /// 跳转到做答页面
        /// 保存也返回这个 但是会默认取消这个，让他重新做，因为交卷了
        if (_examRecordId == null) {
          AppRouterNavigator.of(context).push(
            EXAMINATION_PATH,
            needLogin: true,
            params: {
              "type": 2,
              "examId": widget.examId.toString(),
              "title": widget.title,
              "mainTitle": widget.title,
              "paperUuid": selectData?.paperUuid.toString(),
              "groupId": selectData?.groupId.toString(),
              "examPaperInfo": _examPaperInfo,
              "subLibraryModuleId": widget.subLibraryModuleId,
              "onPaperConfirmListener": (ExamPaperInfo info, String examRecordId) {
                this._examPaperInfo = info;

                /// 说明完成提交试卷了 不在返回做题了多少
                if (info == null) {
                  this._examRecordId = null;
                } else {
                  this._examRecordId = examRecordId;
                }

                _viewModel?.updateFinishNumber(_examPaperInfo?.groupNum);
              },
              "timeType": widget.timeType,
              "responseTime": widget.responseTime,
            },
          );
        } else {
          await checkIsContinueQuestion();
        }
      },
    );
  }
}
