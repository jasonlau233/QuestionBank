import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/model/data/paper_answer_entity.dart';
import 'package:question_bank/model/data/report_card_entity.dart';
import 'package:question_bank/model/data/report_entity.dart';
import 'package:question_bank/modules/pages/examination/widget/question_answer_info.dart';
import 'package:question_bank/modules/pages/examination/widget/video_iframe.dart';
import 'package:question_bank/modules/widget/answer_card_widget.dart';
import 'package:question_bank/widget/custom_widget.dart';

import '../../../core/router/app_router_navigator.dart';
import '../../../model/data/exam_info_entity.dart';
import '../../../model/data/storage_question_settings_entity.dart';
import '../../../provider/view_model/common.dart';
import '../../../provider/view_model/examination_view_model.dart';
import '../../../provider/widget/base_provider_widget.dart';
import '../../../route/path.dart';
import '../../../utils/color.dart';
import '../../../utils/icon.dart';
import '../../../utils/theme.dart';
import '../../../utils/toast.dart';
import '../../../widget/html_render_content.dart';
import '../../../widget/lock_gesture_detector.dart';
import 'widget/question_info.dart';
import 'widget/question_title.dart';

/// 提交试卷回调
typedef void _OnPaperConfirmListener(ExamPaperInfo examPaperInfo, String examRecordId);

class ExaminationPage extends StatefulWidget {
  /// 区分是否是考试还是练习, 1是练习 2是考试 3答题报告 4只展示某些题目使用,显示答案
  final int type;

  /// 考试id
  final String examId;

  /// 试卷id
  final String paperUuid;

  /// 课程id
  final int subModuleId;

  /// 动态模块ID
  final String subLibraryModuleId;

  /// 动态模块名字
  final String subLibraryModuleName;

  /// 标题
  final String title;

  /// 数据title名字，如带有后缀,没有就显示上面title
  final String mainTitle;

  /// 来源 1收藏来的 2错题本 3做题记录
  final int origin;

  /// origin等于3的时候 做题记录会传递的
  final String recordId;

  /// origin等于3的时候 可能是首页考试传递进来的
  final PaperAnswerEntity paperAnswerEntity;

  /// 对应的错题本 题目map id
  final Map<String, String> errorQuestionExamId;

  /// type == 1错题本对应的questionIds 和子题list
  final List<String> onlyNeedQuestionList;
  final List<String> onlyChildQuestionList;

  /// type == 2可选参数
  /// 组id
  final String groupId;

  /// 监听对应用户是否保存答题答案（一定要传递，不然用户提出在重新进来就凉了）
  final _OnPaperConfirmListener onPaperConfirmListener;

  /// 原版的存储考试数据的实体,(有存储就使用原版的，否则就解析试卷重新构建)
  final ExamPaperInfo examPaperInfo;

  /// 是否是正计时还是倒计时 1倒计时 2正计时
  final int timeType;

  /// 考试的时间（分钟级单位）
  final int responseTime;

  /// type == 3可选参数
  /// 错误的题目id列表
  final List<String> errorQuestionIdList;

  /// 指的随机的题目id
  final List<String> chooseQuestionIdList;

  /// 答题卡对应的视图数据
  final ReportCardEntity reportCardEntity;

  /// 默认的显示的问题id
  final String defaultQuestionId;

  /// 默认需要显示组合题下面的某个子题时候
  final int defaultQuestionChildIndex;

  /// 报告试卷数据
  final Map<String, QuestionsReport> paperDataMap;

  /// type == 4可选参数
  /// 题目的id集合
  final List<String> questionIdList;

  /// 收藏id map (收藏来的，需要传递收藏id)
  final Map<String, dynamic> collectIdMap;

  /// 是否显示标疑?号
  final bool showProblem;

  const ExaminationPage({
    Key key,
    @required this.type,
    this.examId = "",
    this.paperUuid = "",
    this.title = "",
    this.mainTitle = "",
    this.timeType = 2,
    this.responseTime = 15,
    this.subModuleId = 0,
    this.subLibraryModuleName,
    this.errorQuestionIdList = const [],
    this.chooseQuestionIdList = const [],
    this.reportCardEntity,
    this.groupId = "",
    this.examPaperInfo,
    this.onPaperConfirmListener,
    this.questionIdList = const [],
    this.origin = 1,
    this.collectIdMap = const {},
    this.paperDataMap,
    this.errorQuestionExamId = const {},
    this.defaultQuestionId,
    this.defaultQuestionChildIndex,
    this.showProblem = true,
    this.onlyNeedQuestionList = const [],
    this.onlyChildQuestionList = const [],
    this.recordId = "",
    this.paperAnswerEntity,
    this.subLibraryModuleId = "",
  }) : super(key: key);

  @override
  _ExaminationPageState createState() => _ExaminationPageState();
}

class _ExaminationPageState extends State<ExaminationPage> with WidgetsBindingObserver {
  /// view_model
  ExaminationViewModel _viewModel;

  /// 等待接口响应刷新界面
  bool isWait = true;

  /// page controller
  PageController _pageController;

  /// 开启定时器
  Timer _timestampTimer;

  /// 毫秒定时器
  Timer _timeMillTimer;

  /// 2分钟未操作锁定对应的
  Timer _twoMinuteTimer;

  /// 是否暂停了
  bool isPauseTimer = false;

  double offsetDistance = 312.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
    _viewModel = ExaminationViewModel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        switch (widget.type) {
          case 1:
          case 2:
            if (!isPauseTimer) {
              createTimer();
            }
            break;
        }
        break;
      case AppLifecycleState.paused:
        switch (widget.type) {
          case 1:
          case 2:
            if (!isPauseTimer) {
              clearTimer();
            }
            break;
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    clearTwoMinuteTime();
    clearTimer();
    _pageController.dispose();
    _viewModel.clearAllGroupController();
    _viewModel = null;
    super.dispose();
  }

  void createTimer() {
    if (_timestampTimer == null) {
      _timestampTimer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) async {
          if (mounted) {
            if (_viewModel != null) {
              switch (widget.type) {
                case 2:
                  if (widget.timeType == 1) {
                    /// 倒计时到点了，直接提交卷子
                    if (_viewModel.timestamp == Duration(seconds: 0)) {
                      timer.cancel();
                      clearTwoMinuteTime();
                      await _sendPaperDataToServer(unCheckModal: true);
                    } else {
                      _viewModel.timestamp = Duration(seconds: _viewModel.timestamp.inSeconds - 1);
                    }
                  } else {
                    _viewModel.timestamp = Duration(seconds: _viewModel.timestamp.inSeconds + 1);
                  }
                  break;
                default:
                  _viewModel.timestamp = Duration(seconds: _viewModel.timestamp.inSeconds + 1);
                  break;
              }
            }
          }
        },
      );

      createMillTimer();
    }
  }

  void clearTimer() {
    if (_timestampTimer != null) {
      _timestampTimer.cancel();
      _timestampTimer = null;
      clearMillTimer();
    }
  }

  void createTwoMinuteTime() {
    if (_twoMinuteTimer == null) {
      _twoMinuteTimer = Timer.periodic(
        const Duration(minutes: 2),
        (timer) {
          if (mounted) {
            if (_viewModel == null || isPauseTimer) {
              return;
            }
            final int page = _pageController.page.toInt();
            if (page != _viewModel.questionItem.length + 1 &&
                _viewModel.questAnswerMap[_viewModel.questionItem[page].id] == null) {
              if (_viewModel.timestamp.inSeconds.isOdd) {
                _viewModel.timestamp = Duration(seconds: _viewModel.timestamp.inSeconds + 1);
              }
              timer.cancel();
              _twoMinuteTimer = null;
              pauseTimer();
            }
          }
        },
      );
    }
  }

  void clearTwoMinuteTime() {
    if (_twoMinuteTimer != null) {
      _twoMinuteTimer.cancel();
      _twoMinuteTimer = null;
    }
  }

  void createMillTimer() {
    if (_timeMillTimer == null) {
      _timeMillTimer = Timer.periodic(
        const Duration(milliseconds: 200),
        (timer) {
          if (mounted && _viewModel != null) {
            /// 判断当前的page
            final int page = _pageController.page.toInt();
            if (page > _viewModel.questionItem.length - 1) {
              return;
            }
            if (_viewModel.questionItem[page] == null) {
              return;
            }

            /// 确认练习是否背题模式
            switch (widget.type) {
              case 1:
                {
                  final QuestionItem item = _viewModel.questionItem[page];
                  switch (item.typeId) {
                    case "23":
                      if (_viewModel.moreQuestionToIndex.containsKey(item.id)) {
                        final int childIndex = _viewModel.moreQuestionToIndex[_viewModel.questionItem[page].id];
                        if (childIndex > item.questionChildrenList.length - 1) {
                          return;
                        }
                        final String childId = item.questionChildrenList[childIndex].id;
                        if (_viewModel.questAnswerMap.containsKey(childId)) {
                          if (_viewModel.questAnswerMap[childId].isFinish) {
                            return;
                          }
                        }

                        _viewModel.setQuestionTime(childId);
                        return;
                      }

                      if (item.questionChildrenList != null && item.questionChildrenList.length > 0) {
                        final String childId = item.questionChildrenList.first.id;
                        if (_viewModel.questAnswerMap.containsKey(childId)) {
                          if (_viewModel.questAnswerMap[childId].isFinish) {
                            return;
                          }
                        }
                        _viewModel.setQuestionTime(childId);
                      }

                      break;

                    default:

                      /// 只要显示答案为finish就不在计时了
                      if (_viewModel.questAnswerMap.containsKey(item.id)) {
                        if (_viewModel.questAnswerMap[item.id].isFinish) {
                          return;
                        }
                      }
                      _viewModel.setQuestionTime(item.id);
                      break;
                  }
                }
                break;

              /// 考试的
              case 2:
                {
                  final QuestionItem item = _viewModel.questionItem[page];
                  switch (item.typeId) {
                    case "23":

                      /// 检查对应的子类page_controller对应的index
                      if (_viewModel.groupPageController.containsKey(item.id)) {
                        final PageController childPageController = _viewModel.groupPageController[item.id];
                        final int childIndex = childPageController.page.toInt();
                        _viewModel.setQuestionTime(
                          _viewModel.questionItem[page].questionChildrenList[childIndex].id,
                        );
                      }
                      break;

                    /// 普通的题目
                    default:
                      _viewModel.setQuestionTime(_viewModel.questionItem[page].id);
                      break;
                  }
                }
                break;
            }
          }
        },
      );
    }
  }

  void clearMillTimer() {
    if (_timeMillTimer != null) {
      _timeMillTimer.cancel();
      _timeMillTimer = null;
    }
  }

  /// 暂停做题定时器
  void pauseTimer() {
    isPauseTimer = true;
    clearTimer();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildTimerModal;
      },
    );
  }

  /// 模型准备
  void _onModelReady(ExaminationViewModel model) async {
    if (widget.mainTitle != null && widget.mainTitle.isNotEmpty) {
      _viewModel.examinationTitle = widget.mainTitle;
    } else {
      _viewModel.examinationTitle = widget.title;
    }

    final Common common = Provider.of<Common>(context, listen: false);

    switch (widget.type) {

      /// 练习
      case 1:
        {
          final bool isSuccess = await model.getPaperInfo(
            widget.paperUuid,
            widget.examId,
            widget.origin,
            widget.recordId,
            widget.paperAnswerEntity,
            widget.onlyNeedQuestionList,
            widget.onlyChildQuestionList,
            widget.origin == 2 ? common.settingsErrorQuestionInfoEntity : common.settingsInfoEntity,
            common.storageUserInfoEntity.uid,
          );

          if (!isSuccess || !mounted) return;

          /// 开启定时器
          createTimer();
          createTwoMinuteTime();

          setState(() => isWait = false);

          if (widget.origin == 3) {
            if (_viewModel.recordAnswerEntity != null && _viewModel.recordAnswerEntity.examDetail != null) {
              if (_viewModel.recordAnswerEntity.examDetail.examRecord != null &&
                  _viewModel.recordAnswerEntity.examDetail.examRecord.param8 != "") {
                Future.delayed(
                  const Duration(milliseconds: 300),
                  () async {
                    if (mounted) {
                      _pageController.jumpToPage(
                        int.parse(_viewModel.recordAnswerEntity.examDetail.examRecord.param8),
                      );
                    }
                  },
                );
              }
            }
          }
        }
        break;

      /// 考试
      case 2:
        {
          final bool isSuccess = await model.getExamPaperInfo(
            widget.paperUuid,
            widget.examId,
            common.storageUserInfoEntity.uid,
            widget.examPaperInfo,
            widget.origin,
            widget.recordId,
            widget.paperAnswerEntity,
          );

          if (!isSuccess || !mounted) return;

          if (widget.timeType == 1) {
            _viewModel.timestamp = Duration(seconds: widget.responseTime * 60);
          }

          /// 开启定时器
          createTimer();
          createTwoMinuteTime();
          setState(() => isWait = false);

          if (widget.groupId != null) {
            final int length = _viewModel.groupInfoEntity.length;

            /// 首个索引的长度的位置
            for (var i = 0; i < length; i++) {
              final Groups element = _viewModel.groupInfoEntity[i];
              if (element.id == widget.groupId) {
                if (element.questionsItem != null && element.questionsItem.length > 0) {
                  Future.delayed(
                    const Duration(milliseconds: 250),
                    () async {
                      if (mounted) {
                        _pageController.jumpToPage(
                          i == 0 ? 0 : _viewModel.questionIdList[element.questionsItem.first.id] - 1,
                        );
                      }
                    },
                  );
                  break;
                }
              }
            }
          }

          if (widget.origin == 3) {
            if (_viewModel.recordAnswerEntity != null && _viewModel.recordAnswerEntity.examDetail != null) {
              if (_viewModel.recordAnswerEntity.examDetail.examRecord != null &&
                  _viewModel.recordAnswerEntity.examDetail.examRecord.param8 != "") {
                Future.delayed(
                  const Duration(milliseconds: 250),
                  () async {
                    if (mounted) {
                      _pageController.jumpToPage(
                        int.parse(_viewModel.recordAnswerEntity.examDetail.examRecord.param8),
                      );
                    }
                  },
                );
              }
            }
          }
        }
        break;

      /// 做题报告的兄弟
      case 3:
        {
          final bool isSuccess = await model.getAnalysisReport(
            common.storageUserInfoEntity.uid,
            widget.paperUuid,
            widget.examId,
            widget.errorQuestionIdList,
            widget.chooseQuestionIdList,
            widget.paperDataMap,
          );

          if (!isSuccess || !mounted) return;

          setState(() => isWait = false);

          Future.delayed(
            const Duration(milliseconds: 300),
            () async {
              if (!mounted) return;

              if (widget.defaultQuestionId == null || widget.defaultQuestionId.isEmpty) {
                return;
              }

              _pageController.jumpToPage(_viewModel.questionIdList[widget.defaultQuestionId]);

              if (widget.defaultQuestionChildIndex == null ||
                  widget.defaultQuestionId.isEmpty ||
                  widget.defaultQuestionChildIndex <= -1) {
                return;
              }

              if (_viewModel.groupPageController.containsKey(widget.defaultQuestionId)) {
                Future.delayed(
                  const Duration(milliseconds: 300),
                  () {
                    _viewModel.groupPageController[widget.defaultQuestionId].jumpToPage(
                      widget.defaultQuestionChildIndex,
                    );
                  },
                );
              }
            },
          );
        }
        break;

      /// 看收藏的 错题的数据，仅限对应的题目数据
      case 4:
        {
          await model.getSomeQuestionItemAnalysis(
            common.storageUserInfoEntity.uid,
            widget.paperUuid,
            widget.examId,
            widget.questionIdList,
          );

          if (mounted) {
            setState(() => isWait = false);
          }
        }
        break;
    }
  }

  /// 答案点击事件
  Future<bool> _onQuestionButtonClickListener(
    QuestionItem item,
    String answer,
    int childIndex, {
    bool forward: true,
  }) async {
    /// 确定是否做题模式或则背题模式
    final Common common = Provider.of<Common>(context, listen: false);
    final StorageQuestionSettingsInfoEntity settingsInfoEntity =
        widget.origin == 2 ? common.settingsErrorQuestionInfoEntity : common.settingsInfoEntity;

    final QuestionAnswerBean bean = _viewModel.questAnswerMap[item.id];

    switch (item.typeId) {

      /// 单选
      case "1":
        bool isFinish = false;
        bool isAnswerTrue = answer == item.answer;
        bool isPauseForward = false;

        /// 练习和对应的背题模式要检查是否弄了答案
        switch (widget.type) {
          case 1:
            if (widget.origin == null || widget.origin == 2) {
              if (settingsInfoEntity.mode == 1) {
                if (bean != null && bean.isFinish == true) {
                  return true;
                }

                isPauseForward = true;

                /// 背题就直接完成了
                isFinish = true;
              }
            } else if (widget.origin == 3) {
              if (_viewModel.recordAnswerEntity != null && _viewModel.recordAnswerEntity.examDetail != null) {
                if (_viewModel.recordAnswerEntity.examDetail.examRecord.param10 == "1") {
                  if (bean != null && bean.isFinish == true) {
                    return true;
                  }

                  isPauseForward = true;

                  /// 背题就直接完成了
                  isFinish = true;
                }
              }
            }
            break;
        }

        _viewModel.updateQuestAnswer(
          item.id,
          QuestionAnswerBean(answer: [answer], isFinish: isFinish, isAnswerTrue: isAnswerTrue),
        );

        if (forward) {
          if (isPauseForward) {
            return true;
          }
          await _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
        }
        break;

      /// 多选
      /// 不定项
      case "2":
      case "7":
        if (bean == null) {
          /// 直接过滤
          _viewModel.updateQuestAnswer(
            item.id,
            QuestionAnswerBean(answer: [answer]),
          );
          return true;
        }

        final List<String> newAnswerData = List.from(bean.answer);

        if (!newAnswerData.contains(answer)) {
          newAnswerData.add(answer);
        } else {
          newAnswerData.remove(answer);
        }

        if (newAnswerData.length <= 0) {
          _viewModel.updateQuestAnswer(item.id, null, remove: true);
          return true;
        }

        /// 没点中
        _viewModel.updateQuestAnswer(
          item.id,
          bean.copyWith(answer: newAnswerData),
        );
        break;

      /// 判断
      case "3":
        bool isFinish = false;
        bool isAnswerTrue = answer == item.answer;

        bool isPauseForward = false;

        /// 练习和对应的背题模式要检查是否弄了答案
        switch (widget.type) {
          case 1:
            if (widget.origin == null || widget.origin == 2) {
              if (settingsInfoEntity.mode == 1) {
                isPauseForward = true;
                if (bean != null && bean.isFinish == true) {
                  return true;
                }

                /// 背题就直接完成了
                isFinish = true;
              }
            } else if (widget.origin == 3) {
              if (_viewModel.recordAnswerEntity != null && _viewModel.recordAnswerEntity.examDetail != null) {
                if (_viewModel.recordAnswerEntity.examDetail.examRecord.param10 == "1") {
                  isPauseForward = true;
                  if (bean != null && bean.isFinish == true) {
                    return true;
                  }

                  /// 背题就直接完成了
                  isFinish = true;
                }
              }
            }
            break;
        }

        _viewModel.updateQuestAnswer(
          item.id,
          QuestionAnswerBean(
            answer: [answer],
            isFinish: isFinish,
            isAnswerTrue: isAnswerTrue,
          ),
        );

        if (forward) {
          if (isPauseForward) {
            return true;
          }
          await _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
        }
        break;
    }
    return true;
  }

  /// 长安排除答案事件
  bool _onLongQuestionButtonClickListener(QuestionItem item, String answer, int childIndex) {
    final QuestionAnswerBean bean = _viewModel.questAnswerMap[item.id];

    switch (item.typeId) {

      /// 单选
      case "1":

      /// 多选
      case "2":
      case "7":

        /// 直接排除正确答案
        if (bean == null) {
          _viewModel.updateQuestAnswer(
            item.id,
            QuestionAnswerBean(eliminate: [answer]),
          );
          return true;
        }

        final List<String> eliminate = List.of(bean.eliminate);

        /// 排除进行反向取消
        if (bean.eliminate.contains(answer)) {
          eliminate.remove(answer);
          _viewModel.updateQuestAnswer(
            item.id,
            bean.copyWith(eliminate: eliminate),
          );
          return true;
        }

        /// 单选已经排除到临街
        eliminate.add(answer);
        _viewModel.updateQuestAnswer(
          item.id,
          bean.copyWith(eliminate: eliminate),
        );
        break;
    }
    return true;
  }

  /// 对应的item收藏
  Future<bool> _sendCollectStatusToServer() async {
    final int i = _pageController.page.toInt();
    String toastText;
    bool isSuccess = false;
    if (_viewModel.isCollect) {
      toastText = "取消收藏";
      String collectId;
      if (_viewModel.collectIdMap.containsKey(i)) {
        collectId = _viewModel.collectIdMap[i];
      } else {
        collectId = _viewModel.questionItem[i].collectionId;
      }

      /// 新增收藏
      isSuccess = await _viewModel.cancelCollectQuestionItem(
        collectId,
        Provider.of<Common>(context, listen: false).storageUserInfoEntity.uid,
      );
    } else {
      toastText = "收藏成功";

      /// 新增收藏
      isSuccess = await _viewModel.addCollectQuestionItem(
        i,
        widget.paperUuid,
        Provider.of<Common>(context, listen: false).storageUserInfoEntity.uid,
        widget.subModuleId.toString(),
        int.tryParse(_viewModel.questionItem[i].id),
        _viewModel.questionItem[i].param4,
      );
    }
    if (isSuccess) {
      _viewModel.isCollect = !_viewModel.isCollect;
      _viewModel.updateCollectionStatus(i, _viewModel.isCollect);
      if (toastText != null) {
        ToastUtils.showText(text: toastText);
      }
    }
    return true;
  }

  /// 提交试卷答案到后台
  Future<void> _sendPaperDataToServer({
    int redo: 0,
    bool isForwardReport: true,
    bool unCheckModal: false,
    int param9 = 1,
  }) async {
    if (!unCheckModal) {
      final List<QuestionItem> nullAnswer = _viewModel.questionItem.where(
        (element) {
          if (element.showIntroductionPage) {
            return false;
          }

          if (element.typeId == "23") {
            for (var v in element.questionChildrenList) {
              if (_viewModel.questAnswerMap.containsKey(v.id)) {
                return false;
              }
            }
            return true;
          } else {
            return !_viewModel.questAnswerMap.containsKey(element.id);
          }
        },
      ).toList();

      /// 到底需要开启modal还是说直接调用接口
      if (nullAnswer.length > 0) {
        final bool result = await showConfirmPaperDialog(nullAnswer.length);
        if (!result) {
          return;
        }
      }
    }

    int memType = 0;
    String mode = Provider.of<Common>(context, listen: false).settingsInfoEntity.mode.toString();

    if (widget.type == 1 || widget.type == 2) {
      if (widget.type == 2) {
        memType = 2;
      }

      if (widget.origin == 3) {
        redo = 1;
        if (_viewModel.recordAnswerEntity != null && _viewModel.recordAnswerEntity.examDetail != null) {
          mode = _viewModel.recordAnswerEntity.examDetail.examRecord.param10.toString();
        }
      } else if (widget.origin == 2) {
        /// 错题本啊
        redo = 3;
        // redo = 1;
        memType = 1;
      }
    }

    String subLibraryModuleId = widget.subLibraryModuleId;

    if (subLibraryModuleId == null || subLibraryModuleId.isEmpty) {
      if (_viewModel.recordAnswerEntity != null && _viewModel.recordAnswerEntity.examDetail != null) {
        subLibraryModuleId = _viewModel.recordAnswerEntity.examDetail.examRecord.param2;
      }
    }

    final String examRecordId = await _viewModel.submitPaperToServer(
      widget.type,
      widget.mainTitle,
      subLibraryModuleId,
      widget.paperUuid,
      widget.examId,
      Provider.of<Common>(context, listen: false).storageUserInfoEntity.uid,
      redo,
      Provider.of<Common>(context, listen: false).subLibraryId,
      mode,
      param9: param9,
      memType: memType,
    );
    if (examRecordId != null) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          if (!mounted) {
            return;
          }

          if (isForwardReport) {
            /// 考试要回调当前填写的 可能用户还会继续 直到交卷
            widget.onPaperConfirmListener?.call(null, examRecordId);

            switch (widget.type) {
              case 1:
                Provider.of<Common>(context, listen: false).removeSectionMap(widget.paperUuid);
                break;
              case 2:
                Provider.of<Common>(context, listen: false).removeExamMap(widget.examId);
                break;
            }

            AppRouterNavigator.of(context).replace(
              widget.type == 1 ? EXEC_REPORT : TEST_EXEC_REPORT,
              needNotifyEventBus: true,
              params: {
                "title": _viewModel.examInfoEntity.paper.name,
                "mainTitle": widget.mainTitle,
                "paperUuid": widget.paperUuid,
                "examId": widget.examId,
                "pid": BuildConfig.productLine,
                "questionIds": _viewModel.questionIdList.keys.toList().join(","),
                "subModuleId": widget.subModuleId,
                "subModuleName": widget.subLibraryModuleName,
                "mode": _viewModel.examInfoEntity.paper.param10,
                "groupInfo": _viewModel.groupInfoEntity,
                "memType": memType,
              },
            );
            return;
          }

          ToastUtils.showText(text: "保存成功");
          switch (widget.type) {
            case 1:
              if (widget.origin == null) {
                Provider.of<Common>(context, listen: false).setSectionMap(widget.paperUuid, examRecordId);
              }
              break;
            case 2:
              if (widget.origin == null) {
                Provider.of<Common>(context, listen: false).setExamMap(widget.examId, examRecordId);
              }
              break;
          }

          /// 考试要回调当前填写的 可能用户还会继续 直到交卷
          widget.onPaperConfirmListener?.call(_viewModel.saveCurrentRecord, examRecordId);
          AppRouterNavigator.of(context).pop(needNotifyEventBus: true);
        },
      );
    }
  }

  /// 删除错题
  Future<void> _removeErrorQuestionItem() async {
    final int page = _pageController.page.toInt();

    if (_viewModel.questionItem[page] == null) {
      return;
    }

    String examId = "";
    String questionId = "";
    int childIndex = -1;
    final QuestionItem item = _viewModel.questionItem[page];

    switch (item.typeId) {
      case "23":
        final PageController childPageController = _viewModel.groupPageController[item.id];
        childIndex = childPageController.page.toInt();
        questionId = item.questionChildrenList[childIndex].id;
        break;

      default:
        questionId = item.id;
        break;
    }

    if (widget.errorQuestionExamId != null && widget.errorQuestionExamId.containsKey(questionId)) {
      examId = widget.errorQuestionExamId[questionId];
    }

    final bool isSuccess = await _viewModel.removeErrorQuestion(
      {
        "examId": examId,
        "paperUuid": widget.paperUuid,
        "productId": BuildConfig.productLine,
        "questionId": questionId,
        "userId": Provider.of<Common>(context, listen: false).storageUserInfoEntity.uid,
      },
    );
    // final bool isSuccess = true;

    if (!isSuccess) return;
    ToastUtils.showText(text: "删除成功");
    switch (item.typeId) {
      case "23":
        _viewModel.removeQuestionItem(page, childIndex);
        break;

      default:
        _viewModel.removeQuestionItem(page, -1);
        break;
    }

    if (_viewModel.questionItem.length <= 0) {
      AppRouterNavigator.of(context).pop(needNotifyEventBus: true);
      return;
    }

    if (_viewModel.questionItemIndex != 0) {
      _viewModel.questionItemIndex--;
    }

    if (_pageController.page.toInt() + 1 == _viewModel.questionItem.length + 1) {
      _viewModel.actionButtonStatus = false;
      _viewModel.titleStatus = true;
    }
  }

  /// 退出弹窗
  void showExitConfirmDialog() async {
    final bool isSuccess = await showIosTipsDialog(
      context,
      '确定退出',
      '未完成的记录会保存在做题记录中。',
      cancel: () {
        Navigator.of(context).pop();
      },
      confirm: () {
        Navigator.of(context).pop(true);
      },
    );

    if (isSuccess == true) {
      _sendPaperDataToServer(unCheckModal: true, isForwardReport: false, param9: 0);
    }
  }

  /// 提交试卷
  Future<bool> showConfirmPaperDialog(int lessNum) async {
    return await showIosTipsDialog(
      context,
      '确定交卷',
      '你还有$lessNum题未做完，确认交卷吗？',
      cancel: () {
        Navigator.of(context).pop(false);
      },
      confirm: () {
        Navigator.of(context).pop(true);
      },
    );
  }

  /// 答题卡
  void showScantronDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return _buildScantron();
      },
    );
  }

  /// 构建答题卡页面
  Widget _buildScantron({bool showHeader: true, bool isModal: true}) {
    Widget bodyLayout;
    Widget headerLayout;
    Widget bottomLayout;

    if (showHeader) {
      headerLayout = AppBar(
        elevation: 0.5,
        leading: CloseButton(),
        centerTitle: true,
        title: const Text(
          "答题卡",
          style: TextStyle(fontSize: 16, color: ColorUtils.color_text_level1),
        ),
      );
    }

    /// 区分是做题的答题卡还是报告的答题卡
    /// 不一样的答题卡,这个是做题报告的
    switch (widget.type) {

      /// 做题报告的答题卡视图，诡异
      case 3:
        bodyLayout = AnswerCardWidget(
          widget.reportCardEntity,
          clickable: true,
          comeFrom: 1,
          onItemClickListen: (String id, int childIndex) async {
            if (isModal) {
              Navigator.of(context).pop();
            }

            final int index = _viewModel.questionIdList[id];
            _pageController.jumpToPage(index);

            if (_viewModel.questionItem[index].parentId == null || _viewModel.questionItem[index].parentId.isEmpty) {
              return true;
            }

            if (childIndex <= -1) {
              return true;
            }

            if (_viewModel.groupPageController.containsKey(id)) {
              Future.delayed(
                const Duration(milliseconds: 300),
                () {
                  if (childIndex == _viewModel.groupPageController[id].page.toInt()) {
                    return true;
                  }
                  _viewModel.groupPageController[id].jumpToPage(
                    childIndex,
                  );
                },
              );
            }
          },
        );
        break;

      /// 默认的
      default:

        /// 下面是做题的答题卡
        final List<Widget> childList = [
          Container(
            margin: const EdgeInsets.only(top: 21, bottom: 21),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ColorUtils.color_textBg_text_choose_true,
                      ),
                      margin: const EdgeInsets.only(right: 3),
                    ),
                    const Text(
                      "已答",
                      style: TextStyle(fontSize: 10, color: ColorUtils.color_text_level1, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorUtils.color_bg_splitLine),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "未答",
                      style: TextStyle(fontSize: 10, color: ColorUtils.color_text_level1, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ];

        final List<Groups> group = _viewModel.groupInfoEntity;

        if (group != null) {
          int length = 0;
          group.asMap().forEach(
            (k, element) {
              if (element.questionsItem.length > 0) {
                if (k != 0) {
                  length += group[k - 1].questionsItem.length;
                }
                childList.add(
                  _buildScantronItem(element.groupName, element.questionsItem, isModal, length),
                );
              }
            },
          );
        }

        bodyLayout = Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 10, right: 10),
          margin: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 12),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: childList,
          ),
        );

        bottomLayout = PreferredSize(
          preferredSize: const Size.fromHeight(43),
          child: SafeArea(
            child: GestureDetector(
              onTap: _sendPaperDataToServer,
              child: Container(
                height: 43,
                alignment: Alignment.center,
                color: ColorUtils.color_bg_theme,
                child: Text(
                  "交卷并查看结果",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ),
        );
        break;
    }

    return Scaffold(
      appBar: headerLayout,
      body: bodyLayout,
      bottomNavigationBar: bottomLayout,
    );
  }

  /// 答题卡子项
  Widget _buildScantronItem(String title, List<QuestionItem> data, bool isModal, int lastLength) {
    /// 检查对应的title特殊字符
    const List<String> splitString = ["#@#", "%@%"];
    for (var v in splitString) {
      if (title.contains(v) == true) {
        final List<String> splitArray = title.split(v);
        title = splitArray.first;
        break;
      }
    }

    final Map<String, dynamic> groupInfo = {};

    /// 确认一下是否是对应的组合题目
    if (data.first.typeId == "23") {
      final List<QuestionItem> newGroupList = [];
      data.asMap().forEach(
        (pK, element) {
          element.questionChildrenList.asMap().forEach(
            (k, childElement) {
              groupInfo[childElement.id] = {
                "index": k,
                "name": "${lastLength + pK + 1}-${k + 1}",
              };
            },
          );
          newGroupList.addAll(element.questionChildrenList);
        },
      );
      data = newGroupList;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Text(
              title,
              style: TextStyle(fontSize: 14, color: ColorUtils.color_text_level1, fontWeight: FontWeight.w500),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 30.0,
            mainAxisSpacing: 12.0,
            crossAxisCount: 5,
            children: List.generate(
              data.length,
              (index) {
                Border border = Border.all(color: ColorUtils.color_bg_splitLine);
                Color bgColor = Colors.white;
                Color textColor = ColorUtils.color_text_level1;

                if (_viewModel.questAnswerMap.containsKey(data[index].id)) {
                  bgColor = ColorUtils.color_textBg_text_choose_true;
                  border = null;
                  textColor = ColorUtils.color_text_choose_true;
                }

                final Widget baseChild = Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: bgColor,
                    border: border,
                  ),
                  child: Text(
                    groupInfo.length > 0 ? groupInfo[data[index].id]["name"] : "${lastLength + index + 1}",
                    style: TextStyle(fontSize: 9, color: textColor, fontWeight: FontWeight.w500),
                  ),
                );

                return LockGestureDetector(
                  onItemClickListenCallback: () async {
                    if (isModal) {
                      Navigator.of(context).pop();
                    }

                    _pageController.jumpToPage(
                      _viewModel.questionIdList[data[index].id],
                    );

                    if (data[index].parentId == null || data[index].parentId.isEmpty) {
                      return true;
                    }

                    final String parentId = data[index].parentId;
                    if (_viewModel.groupPageController.containsKey(parentId)) {
                      Future.delayed(
                        const Duration(milliseconds: 300),
                        () {
                          _viewModel.groupPageController[parentId].jumpToPage(
                            groupInfo[data[index].id]["index"],
                          );
                        },
                      );
                    }

                    return true;
                  },
                  child: Stack(
                    children: [
                      baseChild,
                      if (_viewModel.problemStatus[data[index].id] == 1)
                        Positioned(
                          left: 22,
                          child: const Icon(problem, color: ColorUtils.color_bg_colAndQs, size: 13),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建leading
  Widget get _buildLeading {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(back, size: 15, color: ColorUtils.color_text_level1),
          onPressed: () {
            if ([3, 4].contains(widget.type)) {
              return Navigator.of(context).pop();
            }
            showExitConfirmDialog();
          },
        );
      },
    );
  }

  /// 构建计时文字
  Widget get _buildTimestampText {
    return Selector<ExaminationViewModel, Duration>(
      builder: (BuildContext context, Duration timestamp, _) {
        final List<String> parts = timestamp.toString().split(':');
        return Text(
          parts[0] == "0"
              ? "${parts[1]}:${parts[2].substring(0, 2)}"
              : "${parts[0]}:${parts[1]}:${parts[2].substring(0, 2)}",
          style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
        );
      },
      selector: (BuildContext context, ExaminationViewModel model) {
        return model.timestamp;
      },
    );
  }

  /// 构建收藏按钮
  Widget get _buildCollectButton {
    return Selector<ExaminationViewModel, bool>(
      builder: (BuildContext context, bool status, Widget child) {
        if (!status) {
          return child;
        }
        return LockGestureDetector(
          onItemClickListenCallback: _sendCollectStatusToServer,
          child: Container(
            color: Colors.white,
            width: 48,
            child: Selector<ExaminationViewModel, bool>(
              selector: (BuildContext context, ExaminationViewModel model) {
                return model.isCollect;
              },
              builder: (BuildContext context, bool isCollect, Widget child) {
                return isCollect
                    ? Icon(
                        collect,
                        size: 24,
                        color: ColorUtils.color_bg_colAndQs,
                      )
                    : child;
              },
              child: const Icon(unCollect, size: 24, color: Colors.black),
            ),
          ),
        );
      },
      selector: (BuildContext context, ExaminationViewModel model) {
        return model.actionCollectStatus;
      },
      child: SizedBox(width: 0, height: 0),
    );
  }

  /// 构建收藏按钮
  Widget get _buildDeleteButton {
    return Selector<ExaminationViewModel, bool>(
      builder: (BuildContext context, bool status, Widget child) {
        if (!status) {
          return child;
        }
        return LockGestureDetector(
          onItemClickListenCallback: () async {
            await _removeErrorQuestionItem();
            return true;
          },
          child: Container(
            color: Colors.white,
            width: 48,
            child: const Icon(delete, size: 24, color: Colors.black),
          ),
        );
      },
      selector: (BuildContext context, ExaminationViewModel model) {
        return model.actionCollectStatus;
      },
      child: SizedBox(width: 0, height: 0),
    );
  }

  /// 构建收藏按钮
  Widget get _buildNumButton {
    return Selector<ExaminationViewModel, bool>(
      builder: (BuildContext context, bool status, Widget child) {
        if (!status) {
          return child;
        }
        return LockGestureDetector(
          onItemClickListenCallback: () async {
            showScantronDialog();
            return true;
          },
          child: Container(
            width: 48,
            color: Colors.white,
            child: const Icon(finish, size: 24, color: Colors.black),
          ),
        );
      },
      selector: (BuildContext context, ExaminationViewModel model) {
        return model.actionCardStatus;
      },
      child: SizedBox(width: 0, height: 0),
    );
  }

  /// 构建定时器按钮
  Widget get _buildTimerButton {
    return Selector<ExaminationViewModel, bool>(
      builder: (BuildContext context, bool status, Widget child) {
        if (!status) {
          return child;
        }
        return LockGestureDetector(
          onItemClickListenCallback: () async {
            pauseTimer();
            return true;
          },
          child: Container(
            color: Colors.white,
            width: 48,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                  child: const Icon(
                    timerPause,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
                _buildTimestampText,
              ],
            ),
          ),
        );
      },
      selector: (BuildContext context, ExaminationViewModel model) {
        return model.actionTimerStatus;
      },
      child: SizedBox(width: 0, height: 0),
    );
  }

  /// 构建时间modal
  Widget get _buildTimerModal {
    return LockGestureDetector(
      onItemClickListenCallback: () async {
        isPauseTimer = false;
        createTimer();
        createTwoMinuteTime();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "答题计时已暂停",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Container(
                margin: const EdgeInsets.only(top: 31, bottom: 31),
                child: const Text(
                  "点击任意位置",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const Text(
                "继续开始做题",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///构建题目答案
  Widget _buildQuestionOptions(QuestionItem item, int i, int childIndex) {
    /// 确定是否做题模式或则背题模式
    final Common common = Provider.of<Common>(context, listen: false);
    StorageQuestionSettingsInfoEntity settingsInfoEntity;

    switch (widget.origin) {
      case 2:
        settingsInfoEntity = common.settingsErrorQuestionInfoEntity;
        break;

      /// 做题记录
      case 3:
        settingsInfoEntity = common.settingsInfoEntity.copyWith(
          mode: int.tryParse(
            _viewModel.recordAnswerEntity.examDetail.examRecord.param10.toString(),
          ),
        );
        break;

      default:
        settingsInfoEntity = common.settingsInfoEntity;
        break;
    }

    return Selector<ExaminationViewModel, Map<String, QuestionAnswerBean>>(
      selector: (BuildContext context, ExaminationViewModel model) {
        return model.questAnswerMap;
      },
      builder: (BuildContext context, Map<String, QuestionAnswerBean> bean, Widget child) {
        final List<Widget> childList = [];

        bool checkAnswer = false;
        bool isAnswerTrue = false;
        bool isNotAnswer = false;

        childList.addAll(
          List.generate(
            item.questionOptions.length,
            (index) {
              Color defaultBgColor = ColorUtils.color_textBg_forGray;
              Color defaultDividerColor = ColorUtils.color_bg_noChoose_splitLine;
              Color textColor = ColorUtils.color_text_level2;
              Border containerBorder;
              int iconType = 1;
              final QuestionAnswerBean questionAnswerBean = bean[item.id];

              /// 判断做题了没有，是否完成，在更新是否考试来操作对应的颜色
              if (questionAnswerBean != null) {
                /// 练习下,
                /// 先确认是不是背题模式

                switch (widget.type) {

                  /// 练习
                  case 1:
                    switch (settingsInfoEntity.mode) {
                      case 1:
                        {
                          /// 判定是否完成了
                          if (questionAnswerBean.isFinish) {
                            /// 作对了
                            if (questionAnswerBean.isAnswerTrue) {
                              /// 说明选中了
                              if (item.answer.contains(item.questionOptions[index].answerOption)) {
                                /// 判断是否用户选中的
                                if (questionAnswerBean.answer.contains(item.questionOptions[index].answerOption)) {
                                  defaultBgColor = ColorUtils.color_textBg_text_choose_true;
                                  defaultDividerColor = ColorUtils.color_bg_choose_true;
                                  textColor = ColorUtils.color_text_choose_true;
                                  iconType = 3;
                                } else {
                                  defaultBgColor = ColorUtils.color_textBg_text_choose_true;
                                  defaultDividerColor = ColorUtils.color_bg_choose_true;
                                  textColor = ColorUtils.color_text_level2;
                                  iconType = 6;
                                }
                              }
                            } else {
                              /// 判断打开是不是存在answer中
                              if (item.answer.contains(item.questionOptions[index].answerOption)) {
                                defaultBgColor = ColorUtils.color_textBg_text_choose_true;
                                defaultDividerColor = ColorUtils.color_bg_choose_true;
                                textColor = ColorUtils.color_text_choose_true;
                                iconType = 3;
                              } else {
                                if (questionAnswerBean.answer.contains(item.questionOptions[index].answerOption)) {
                                  defaultBgColor = ColorUtils.color_textBg_text_choose_false;
                                  defaultDividerColor = ColorUtils.color_bg_choose_false;
                                  textColor = ColorUtils.color_text_choose_fasle;
                                  iconType = 2;
                                }
                              }
                              break;
                            }
                          } else {
                            if (questionAnswerBean.answer.contains(item.questionOptions[index].answerOption)) {
                              defaultBgColor = ColorUtils.color_textBg_choose_select_choose;
                              defaultDividerColor = ColorUtils.color_bg_theme;
                              textColor = ColorUtils.color_text_theme;
                              iconType = 5;
                            }

                            /// 可能是排除了
                            if (questionAnswerBean.eliminate.length > 0 &&
                                questionAnswerBean.eliminate.contains(
                                  item.questionOptions[index].answerOption,
                                )) {
                              defaultBgColor = ColorUtils.color_bg_exclude;
                              defaultDividerColor = ColorUtils.color_bg_choose_false;
                              textColor = ColorUtils.color_text_need_do;
                              iconType = 4;
                              containerBorder = Border.all(width: 1, color: ColorUtils.color_text_choose_exclude);
                            }
                          }
                        }
                        break;

                      default:
                        {
                          /// 除了背题模式下其他都直接标记蓝色
                          /// 可能多选下标记蓝色
                          if (questionAnswerBean.answer.contains(item.questionOptions[index].answerOption)) {
                            defaultBgColor = ColorUtils.color_textBg_choose_select_choose;
                            defaultDividerColor = ColorUtils.color_bg_theme;
                            textColor = ColorUtils.color_text_theme;
                            iconType = 5;
                          }

                          /// 可能是排除了
                          if (questionAnswerBean.eliminate.length > 0 &&
                              questionAnswerBean.eliminate.contains(
                                item.questionOptions[index].answerOption,
                              )) {
                            defaultBgColor = ColorUtils.color_textBg_forGray;
                            defaultDividerColor = ColorUtils.color_bg_choose_false;
                            textColor = ColorUtils.color_text_need_do;
                            iconType = 4;
                          }
                        }
                        break;
                    }
                    break;

                  /// 考试
                  case 2:

                    /// 除了背题模式下其他都直接标记蓝色
                    /// 可能多选下标记蓝色
                    if (questionAnswerBean.answer.contains(item.questionOptions[index].answerOption)) {
                      defaultBgColor = ColorUtils.color_textBg_choose_select_choose;
                      defaultDividerColor = ColorUtils.color_bg_theme;
                      textColor = ColorUtils.color_text_theme;
                      iconType = 5;
                    }

                    /// 可能是排除了
                    if (questionAnswerBean.eliminate.length > 0 &&
                        questionAnswerBean.eliminate.contains(
                          item.questionOptions[index].answerOption,
                        )) {
                      defaultBgColor = ColorUtils.color_textBg_forGray;
                      defaultDividerColor = ColorUtils.color_bg_choose_false;
                      textColor = ColorUtils.color_bg_choose_exclude;
                      iconType = 4;
                    }
                    break;

                  /// 报告解析,直接显示
                  case 3:
                  case 4:

                    /// 判断是多选还是单选
                    switch (item.typeId) {
                      case "2":
                      case "7":
                        if (checkAnswer != true) {
                          final int len = questionAnswerBean.answer.length;
                          bool success = false;

                          if (len == 0) {
                            checkAnswer = true;
                            isAnswerTrue = false;
                            isNotAnswer = true;
                          } else {
                            if (len != item.answer.replaceAll(",", "").length) {
                              bool isOk = false;

                              /// 判断答案
                              for (int i = 0; i < len; i++) {
                                if (!item.answer.contains(questionAnswerBean.answer[i])) {
                                  checkAnswer = true;
                                  isAnswerTrue = false;
                                  isOk = true;
                                  break;
                                }
                              }

                              if (!isOk) {
                                checkAnswer = true;
                                isAnswerTrue = true;
                              }
                            } else {
                              /// 判断答案
                              for (int i = 0; i < len; i++) {
                                if (!item.answer.contains(questionAnswerBean.answer[i])) {
                                  checkAnswer = true;
                                  isAnswerTrue = false;
                                  success = true;
                                  break;
                                }
                              }

                              if (!success) {
                                checkAnswer = true;
                                isAnswerTrue = true;
                              }
                            }
                          }
                        }

                        if (isNotAnswer) {
                        } else {
                          /// 作对了
                          if (isAnswerTrue) {
                            /// 说明选中了
                            if (item.answer.contains(item.questionOptions[index].answerOption)) {
                              /// 判断是否用户选中的
                              if (questionAnswerBean.answer.contains(item.questionOptions[index].answerOption)) {
                                defaultBgColor = ColorUtils.color_textBg_text_choose_true;
                                defaultDividerColor = ColorUtils.color_bg_choose_true;
                                textColor = ColorUtils.color_text_choose_true;
                                iconType = 3;
                              } else {
                                defaultBgColor = ColorUtils.color_textBg_text_choose_true;
                                defaultDividerColor = ColorUtils.color_bg_choose_true;
                                textColor = ColorUtils.color_text_level2;
                                iconType = 6;
                              }
                            }
                          } else {
                            /// 判断打开是不是存在answer中
                            if (item.answer.contains(item.questionOptions[index].answerOption)) {
                              defaultBgColor = ColorUtils.color_textBg_text_choose_true;
                              defaultDividerColor = ColorUtils.color_bg_choose_true;
                              textColor = ColorUtils.color_text_choose_true;
                              iconType = 3;
                            } else {
                              if (questionAnswerBean.answer.contains(item.questionOptions[index].answerOption)) {
                                defaultBgColor = ColorUtils.color_textBg_text_choose_false;
                                defaultDividerColor = ColorUtils.color_bg_choose_false;
                                textColor = ColorUtils.color_text_choose_fasle;
                                iconType = 2;
                              }
                            }
                          }
                        }

                        break;

                      default:
                        if (questionAnswerBean.isFinish) {
                          /// 作对了
                          if (questionAnswerBean.isAnswerTrue) {
                            if (questionAnswerBean.answer.contains(item.questionOptions[index].answerOption)) {
                              defaultBgColor = ColorUtils.color_textBg_text_choose_true;
                              defaultDividerColor = ColorUtils.color_bg_choose_true;
                              textColor = ColorUtils.color_text_choose_true;
                              iconType = 3;
                            }
                          } else {
                            /// 判断打开是不是存在answer中
                            if (item.answer.contains(item.questionOptions[index].answerOption)) {
                              defaultBgColor = ColorUtils.color_textBg_text_choose_true;
                              defaultDividerColor = ColorUtils.color_bg_choose_true;
                              textColor = ColorUtils.color_text_choose_true;
                              iconType = 3;
                            } else {
                              if (questionAnswerBean.answer.contains(item.questionOptions[index].answerOption)) {
                                defaultBgColor = ColorUtils.color_textBg_text_choose_false;
                                defaultDividerColor = ColorUtils.color_bg_choose_false;
                                textColor = ColorUtils.color_text_choose_fasle;
                                iconType = 2;
                              }
                            }
                          }
                        } else {
                          if (questionAnswerBean.answer.contains(item.questionOptions[index].answerOption)) {
                            defaultBgColor = ColorUtils.color_textBg_choose_select_choose;
                            defaultDividerColor = ColorUtils.color_bg_theme;
                            textColor = ColorUtils.color_text_theme;
                            iconType = 5;
                          }
                        }
                        break;
                    }
                    break;
                }
              }
              return LockGestureDetector(
                onItemClickListenCallback: () async {
                  if (questionAnswerBean == null) {
                    _onQuestionButtonClickListener(
                      item,
                      item.questionOptions[index].answerOption,
                      childIndex,
                      forward: childIndex == -1,
                    );
                  } else if (!questionAnswerBean.isFinish) {
                    switch (item.typeId) {
                      case "1":
                      case "2":
                      case "7":
                        if (questionAnswerBean.eliminate.contains(item.questionOptions[index].answerOption)) {
                          _onLongQuestionButtonClickListener(
                            item,
                            item.questionOptions[index].answerOption,
                            childIndex,
                          );
                        } else {
                          _onQuestionButtonClickListener(
                            item,
                            item.questionOptions[index].answerOption,
                            childIndex,
                            forward: childIndex == -1,
                          );
                        }
                        break;

                      case "3":
                      default:
                        _onQuestionButtonClickListener(
                          item,
                          item.questionOptions[index].answerOption,
                          childIndex,
                          forward: childIndex == -1,
                        );
                        break;
                    }
                  }
                  return true;
                },
                onItemLongClickListenCallback: () async {
                  if (questionAnswerBean == null) {
                    _onLongQuestionButtonClickListener(item, item.questionOptions[index].answerOption, childIndex);
                  } else if (!questionAnswerBean.isFinish) {
                    switch (item.typeId) {
                      case "1":
                      case "2":
                      case "7":
                        if (questionAnswerBean.answer.contains(item.questionOptions[index].answerOption)) {
                          return true;
                        }
                        _onLongQuestionButtonClickListener(item, item.questionOptions[index].answerOption, childIndex);
                        break;
                    }
                  }
                  return true;
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  decoration: BoxDecoration(
                    color: defaultBgColor,
                    borderRadius: BorderRadius.circular(5),
                    border: containerBorder,
                  ),
                  child: iconType == 4
                      ? Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 40, right: 12, top: 5.5, bottom: 5.5),
                              child: HtmlRenderContent(
                                htmlData: item.questionOptions[index].answerContent,
                                htmlStyle: {
                                  "html": Style(
                                    fontSize: FontSize(14),
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                    padding: EdgeInsets.zero,
                                    margin: EdgeInsets.zero,
                                  ),
                                },
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              bottom: 0,
                              child: _buildQuestionOptionsIcon(
                                iconType,
                                item.questionOptions[index].answerOption,
                                circular: ["2", "7"].contains(item.typeId) ? 6 : 10,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            _buildQuestionOptionsIcon(
                              iconType,
                              item.questionOptions[index].answerOption,
                              circular: ["2", "7"].contains(item.typeId) ? 6 : 10,
                            ),
                            Container(height: 21, width: 1.3, color: defaultDividerColor),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: 5.5,
                                  top: 5.5,
                                ),
                                child: HtmlRenderContent(
                                  htmlData: item.questionOptions[index].answerContent,
                                  htmlStyle: {
                                    "html": Style(
                                      fontSize: FontSize(14),
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                    ),
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        );

        if (widget.type == 1 && settingsInfoEntity.mode == 1 && ["2", "7"].contains(item.typeId)) {
          if (bean[item.id] != null && bean[item.id].isFinish != true) {
            childList.add(
              Center(
                child: LockGestureDetector(
                  onItemClickListenCallback: () async {
                    final QuestionAnswerBean questionAnswerBean = bean[item.id];
                    if (questionAnswerBean != null) {
                      final int len = questionAnswerBean.answer.length;
                      bool success = false;

                      if (len != item.answer.replaceAll(",", "").length) {
                        bool isOk = false;

                        /// 判断答案
                        for (int i = 0; i < len; i++) {
                          if (!item.answer.contains(questionAnswerBean.answer[i])) {
                            _viewModel.updateQuestAnswer(
                              item.id,
                              questionAnswerBean.copyWith(isFinish: true, isAnswerTrue: false),
                            );
                            isOk = true;
                            break;
                          }
                        }

                        if (!isOk) {
                          _viewModel.updateQuestAnswer(
                            item.id,
                            questionAnswerBean.copyWith(isFinish: true, isAnswerTrue: true),
                          );
                        }
                        return true;
                      }

                      /// 判断答案
                      for (int i = 0; i < len; i++) {
                        if (!item.answer.contains(questionAnswerBean.answer[i])) {
                          _viewModel.updateQuestAnswer(
                            item.id,
                            questionAnswerBean.copyWith(isFinish: true, isAnswerTrue: false),
                          );
                          success = true;
                          break;
                        }
                      }

                      if (!success) {
                        _viewModel.updateQuestAnswer(
                          item.id,
                          questionAnswerBean.copyWith(isFinish: true, isAnswerTrue: true),
                        );
                      }
                    }
                    return true;
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 319,
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: ColorUtils.color_bg_theme,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "确认",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: childList,
        );
      },
    );
  }

  /// 构建答案对应的icon
  Widget _buildQuestionOptionsIcon(
    int type,
    String text, {
    double circular: 6,
  }) {
    switch (type) {

      /// 正常的情况
      case 1:
        return Container(
          alignment: Alignment.center,
          width: 40,
          child: Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circular),
              border: Border.all(color: ColorUtils.color_textBg_choose_select_noChoose, width: 2),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: ColorUtils.color_textBg_choose_select_noChoose,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        break;

      /// 多选选中情况
      case 5:
        return Container(
          alignment: Alignment.center,
          width: 40,
          child: Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circular),
              border: Border.all(color: ColorUtils.color_bg_theme, width: 2),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: ColorUtils.color_text_theme, fontWeight: FontWeight.bold),
            ),
          ),
        );
        break;

      /// 错误
      case 2:
        return Container(
          alignment: Alignment.center,
          width: 40,
          child: Icon(error, size: 20, color: ColorUtils.color_bg_choose_false),
        );
        break;

      /// 正确
      case 3:
        return Container(
          alignment: Alignment.center,
          width: 40,
          child: Icon(success, size: 20, color: ColorUtils.color_bg_choose_true),
        );

      /// 排除
      case 4:
        return Container(
          alignment: Alignment.center,
          width: 40,
          decoration: BoxDecoration(
            color: ColorUtils.color_bg_choose_exclude,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
          ),
          child: Icon(unChooseQuestion, size: 28, color: Colors.white),
        );
        break;

      /// 答案正确但是漏选,
      case 6:
        return Container(
          alignment: Alignment.center,
          width: 40,
          child: Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circular),
              border: Border.all(color: ColorUtils.color_bg_choose_select, width: 2),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: ColorUtils.color_bg_choose_select, fontWeight: FontWeight.bold),
            ),
          ),
        );
        break;

      default:
        return Container(color: Colors.red, width: 50, height: 50);
    }
  }

  /// 构建questionTitle
  Widget _buildQuestionTitle(QuestionItem item) {
    return Selector<ExaminationViewModel, Map<String, QuestionAnswerBean>>(
      shouldRebuild: (Map<String, QuestionAnswerBean> previous, Map<String, QuestionAnswerBean> next) {
        if (previous[item.id] != next[item.id]) {
          return true;
        }
        return false;
      },
      selector: (BuildContext context, ExaminationViewModel model) {
        return model.questAnswerMap;
      },
      builder: (BuildContext context, Map<String, QuestionAnswerBean> answerMap, Widget child) {
        if (answerMap[item.id] == null || !answerMap[item.id].isFinish) {
          return QuestionTitle(typeName: item.showTypeName, title: item.title);
        }
        return QuestionTitle(
          typeName: item.showTypeName,
          title: item.title,
          errorNum: _viewModel.errNumMap.containsKey(item.id) ? _viewModel.errNumMap[item.id].toString() : null,
        );
      },
    );
  }

  /// 构建题目
  Widget _buildQuestion(QuestionItem item, int index, int childIndex) {
    if (item.typeId == "23") {
      return _buildUnConfirmQuestionOptions(item, index, childIndex);
    }

    final List<Widget> childList = [
      _buildQuestionTitle(item),
    ];

    if (item.questionOptions != null && item.questionOptions.length > 0) {
      childList.add(
        _buildQuestionOptions(item, index, childIndex),
      );
    }

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: childList,
      ),
    );
  }

  /// 不定向选择
  Widget _buildUnConfirmQuestionOptions(QuestionItem item, int pIndex, int childIndex) {
    final Common common = Provider.of<Common>(context, listen: false);
    StorageQuestionSettingsInfoEntity settingsInfoEntity;

    switch (widget.origin) {
      case 2:
        settingsInfoEntity = common.settingsErrorQuestionInfoEntity;
        break;

      /// 做题记录
      case 3:
        settingsInfoEntity = common.settingsInfoEntity.copyWith(
          mode: int.tryParse(
            _viewModel.recordAnswerEntity.examDetail.examRecord.param10.toString(),
          ),
        );
        break;

      default:
        settingsInfoEntity = common.settingsInfoEntity;
        break;
    }

    return Expanded(
      child: Column(
        children: [
          Selector<ExaminationViewModel, double>(
            shouldRebuild: (double previous, double next) {
              if (previous != next) {
                return true;
              }
              return false;
            },
            selector: (BuildContext context, ExaminationViewModel model) {
              return model.offsetDistance;
            },
            builder: (BuildContext context, double num, Widget child) {
              return Container(
                color: Colors.white,
                height: num,
                child: child,
              );
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: QuestionTitle(
                typeName: "资料",
                title: item.title,
              ),
            ),
          ),
          GestureDetector(
            onVerticalDragUpdate: (e) {
              _viewModel.offsetDistance = _viewModel.offsetDistance += e.delta.dy;
            },
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Container(
                height: 23,
                width: 58,
                padding: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  color: ColorUtils.color_textBg_choose_select_noChoose,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      color: Colors.white,
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(top: 6, bottom: 6),
                      color: Colors.white,
                    ),
                    Container(
                      height: 1,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _viewModel.groupPageController.length > 0 ? _viewModel.groupPageController[item.id] : null,
              onPageChanged: (int i) {
                _viewModel.setMoreQuestionToIndex(item.id, i);
              },
              itemBuilder: (BuildContext context, int index) {
                final List<Widget> childList = [
                  Container(
                    width: double.infinity,
                    height: 30,
                    color: ColorUtils.color_bg_splitBlock,
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "本组题共有${item.questionChildrenList.length}道小题",
                          style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level2),
                        ),
                        LockGestureDetector(
                          onItemClickListenCallback: () async {
                            if (widget.showProblem) {
                              _viewModel.updateProblemStatus(
                                item.questionChildrenList[index].id,
                                _viewModel.problemStatus[item.questionChildrenList[index].id] == 1 ? 0 : 1,
                              );
                            }
                            return true;
                          },
                          child: Container(
                            height: 30,
                            color: ColorUtils.color_bg_splitBlock,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (widget.showProblem)
                                  Selector<ExaminationViewModel, Map<String, int>>(
                                    shouldRebuild: (Map<String, int> previous, Map<String, int> next) {
                                      if (previous[item.questionChildrenList[index].id] !=
                                          next[item.questionChildrenList[index].id]) {
                                        return true;
                                      }
                                      return false;
                                    },
                                    selector: (BuildContext context, ExaminationViewModel model) {
                                      return model.problemStatus;
                                    },
                                    builder: (BuildContext context, Map<String, int> problemList, Widget child) {
                                      return _buildProblem(
                                        problemList[item.questionChildrenList[index].id] == 1
                                            ? ColorUtils.color_bg_colAndQs
                                            : ColorUtils.color_text_level1,
                                        15.0,
                                      );
                                    },
                                  ),
                                Row(
                                  children: [
                                    Selector<ExaminationViewModel, int>(
                                      selector: (BuildContext context, ExaminationViewModel model) =>
                                          model.questionItemIndex,
                                      builder: (BuildContext context, int value, Widget child) {
                                        int questionIndex;

                                        if (widget.type == 2) {
                                          questionIndex = _viewModel.examQuestionIndex[value] + 1;
                                        } else {
                                          questionIndex = value + 1;
                                        }

                                        return Text(
                                          questionIndex.toString(),
                                          style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level2),
                                        );
                                      },
                                    ),
                                    const Text(
                                      "-",
                                      style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level2),
                                    ),
                                    Text(
                                      "(${index + 1})",
                                      style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level2),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildQuestion(item.questionChildrenList[index], pIndex, index),
                ];

                /// 从不同页面进来又他吗的逻辑不一样，简直就是偷袭
                switch (widget.type) {
                  case 1:
                    if (settingsInfoEntity.mode == 1) {
                      childList.addAll(
                        [
                          /// 构建回答了问题显示做题易错项目等等信息
                          _buildAnswerContentView(
                            item.questionChildrenList[index],
                          ),

                          /// 狗日的需要判断一波是不是有视频数据,不然坑死你
                          if (item.questionChildrenList[index].videoAnalysis != null &&
                              item.questionChildrenList[index].videoAnalysis.isNotEmpty)
                            _buildVideoView(item.questionChildrenList[index]),

                          /// 直接构建对应的解析后的文本那些内容
                          _buildInfoView(item.questionChildrenList[index], pIndex: pIndex),
                        ],
                      );
                    }
                    break;

                  case 3:
                  case 4:
                    childList.addAll(
                      [
                        /// 构建回答了问题显示做题易错项目等等信息
                        _buildAnswerContentView(item.questionChildrenList[index], childIndex: index),

                        /// 狗日的需要判断一波是不是有视频数据,不然坑死你
                        if (item.questionChildrenList[index].videoAnalysis != null &&
                            item.questionChildrenList[index].videoAnalysis.isNotEmpty)
                          _buildVideoView(item.questionChildrenList[index], childIndex: index),

                        /// 直接构建对应的解析后的文本那些内容
                        _buildInfoView(item.questionChildrenList[index], pIndex: pIndex),
                      ],
                    );
                    break;
                }

                return ListView(children: childList);
              },
              itemCount: item.questionChildrenList.length,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建解析后的答案
  Widget _buildAnswerContentView(
    QuestionItem item, {
    childIndex: 0,
  }) {
    return Selector<ExaminationViewModel, Map<String, QuestionAnswerBean>>(
      selector: (
        BuildContext context,
        ExaminationViewModel model,
      ) {
        return model.questAnswerMap;
      },
      shouldRebuild: (Map<String, QuestionAnswerBean> previous, Map<String, QuestionAnswerBean> next) {
        if (previous[item.id] != next[item.id]) {
          return true;
        }
        return false;
      },
      builder: (
        BuildContext context,
        Map<String, QuestionAnswerBean> bean,
        Widget child,
      ) {
        /// 检查map是否有答案呢
        if (!bean.containsKey(item.id)) {
          return child;
        }

        /// 并且要确认一定有那一项,特别是多项目那种
        if (!bean[item.id].isFinish) {
          return child;
        }

        /// 易错项目和对应的全站正确率
        String errorItem = "";
        String percentNum = "0";

        if (_viewModel.statisticsMap.containsKey(item.id)) {
          errorItem = _viewModel.statisticsMap[item.id]["highSelectOption"];
          percentNum = _viewModel.statisticsMap[item.id]["rightSelectRate"].toString();
        }

        String userAnswerText;
        String speedText = "—";

        final QuestionAnswerBean questionAnswerBean = bean[item.id];
        final List<String> answer = List.from(questionAnswerBean.answer);

        answer.sort((a, b) => a.compareTo(b));
        userAnswerText = answer.join(",");
        if (_viewModel.questionTime.containsKey(item.id)) {
          speedText = _viewModel.questionTime[item.id].toStringAsFixed(1) + "秒";
        } else {
          speedText = "—";
        }

        if (errorItem.isEmpty) {
          errorItem = "—";
        }

        return QuestionAnswerInfo(
          type: int.parse(item.typeId),
          errorItemText: errorItem,
          percentText: percentNum + "%",
          speedText: speedText,
          rightAnswerText: item.answer,
          userAnswerText: userAnswerText,
          userAnswerTrue: questionAnswerBean.isAnswerTrue,
        );
      },
      child: SizedBox(width: 0, height: 0),
    );
  }

  /// 构建视频解析
  Widget _buildVideoView(
    QuestionItem item, {
    childIndex: 0,
  }) {
    return Selector<ExaminationViewModel, Map<String, QuestionAnswerBean>>(
      selector: (
        BuildContext context,
        ExaminationViewModel model,
      ) {
        return model.questAnswerMap;
      },
      shouldRebuild: (Map<String, QuestionAnswerBean> previous, Map<String, QuestionAnswerBean> next) {
        if (previous[item.id] != next[item.id]) {
          return true;
        }
        return false;
      },
      builder: (
        BuildContext context,
        Map<String, QuestionAnswerBean> bean,
        Widget child,
      ) {
        /// 检查map是否有答案呢
        if (!bean.containsKey(item.id)) {
          return child;
        }

        /// 并且要确认一定有那一项,特别是多项目那种
        if (!bean[item.id].isFinish) {
          return child;
        }

        final List<String> vidList = item.videoAnalysis.split(",");

        if (vidList.length == 0) {
          return child;
        }
        return VideoIframe(
          vid: vidList,
          thumbnail: "http://download.hqjy.com/kaoba/chuji/img/exam_video_bg.png",
        );
      },
      child: SizedBox(width: 0, height: 0),
    );
  }

  /// 题目解析
  Widget _buildInfoView(QuestionItem item, {int pIndex = 0}) {
    return Selector<ExaminationViewModel, Map<String, QuestionAnswerBean>>(
      selector: (
        BuildContext context,
        ExaminationViewModel model,
      ) {
        return model.questAnswerMap;
      },
      shouldRebuild: (Map<String, QuestionAnswerBean> previous, Map<String, QuestionAnswerBean> next) {
        if (previous[item.id] != next[item.id]) {
          return true;
        }
        return false;
      },
      builder: (
        BuildContext context,
        Map<String, QuestionAnswerBean> bean,
        Widget child,
      ) {
        /// 检查map是否有答案呢
        if (!bean.containsKey(item.id)) {
          return child;
        }

        /// 并且要确认一定有那一项,特别是多项目那种
        if (!bean[item.id].isFinish) {
          return child;
        }

        return QuestionInfo(
          textAnalysis: item.textAnalysis,
          originText: _viewModel.originMap.containsKey(
            _viewModel.questionItem[pIndex].source,
          )
              ? _viewModel.originMap[_viewModel.questionItem[pIndex].source]
              : "",
          knowledge: _viewModel.examPointMap.containsKey(
            _viewModel.questionItem[pIndex].mpKnowledge,
          )
              ? _viewModel.examPointMap[_viewModel.questionItem[pIndex].mpKnowledge]
              : null,
        );
      },
      child: SizedBox(width: 0, height: 0),
    );
  }

  /// 题目解析
  Widget get _buildTitle {
    return Selector<ExaminationViewModel, bool>(
      selector: (
        BuildContext context,
        ExaminationViewModel model,
      ) {
        return model.titleStatus;
      },
      shouldRebuild: (bool previous, bool next) {
        if (previous != next) {
          return true;
        }
        return false;
      },
      builder: (
        BuildContext context,
        bool state,
        Widget child,
      ) {
        if (!state) {
          return child;
        }
        return Text(
          "答题卡",
          style: TextStyle(fontSize: 16, color: ColorUtils.color_text_level1, fontWeight: FontWeight.w500),
        );
      },
      child: SizedBox(width: 0, height: 0),
    );
  }

  /// 构建标疑icon
  Widget _buildProblem(Color color, double size) {
    return Icon(problem, color: color, size: size);
  }

  /// 构建标题
  Widget _buildBottomTitle(int index) {
    final List<Widget> childList = [
      Expanded(
        child: Selector<ExaminationViewModel, String>(
          selector: (BuildContext context, ExaminationViewModel model) {
            return model.examinationTitle;
          },
          builder: (BuildContext context, String value, Widget child) {
            return Text(
              value,
              style: TextStyle(fontSize: 14, color: ColorUtils.color_text_level2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
      ),
    ];

    childList.add(
      Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Selector<ExaminationViewModel, int>(
          selector: (BuildContext context, ExaminationViewModel model) => model.questionItemIndex,
          builder: (BuildContext context, int value, Widget child) {
            if (_viewModel.questionItem[value].showIntroductionPage) {
              return SizedBox(height: 0, width: 0);
            }
            return Row(
              children: [
                Selector<ExaminationViewModel, int>(
                  selector: (BuildContext context, ExaminationViewModel model) => model.questionItemIndex,
                  builder: (BuildContext context, int value, Widget child) {
                    int questionIndex;

                    if (widget.type == 2) {
                      questionIndex = _viewModel.examQuestionIndex[value] + 1;
                    } else {
                      questionIndex = value + 1;
                    }

                    return Text(
                      questionIndex.toString(),
                      style: TextStyle(fontSize: 15, color: ColorUtils.color_text_level1),
                    );
                  },
                ),
                const Text(
                  "/",
                  style: TextStyle(fontSize: 15, color: ColorUtils.color_text_level3),
                ),
                Selector<ExaminationViewModel, List<QuestionItem>>(
                  selector: (BuildContext context, ExaminationViewModel model) => model.questionItem,
                  builder: (BuildContext context, List<QuestionItem> value, Widget child) {
                    int length = value.length;
                    if (widget.type == 2) {
                      length -= _viewModel.groupInfoEntity.length;
                    }
                    return Text(
                      length.toString(),
                      style: TextStyle(fontSize: 15, color: ColorUtils.color_text_level3),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );

    /// 判断是否我的收藏
    if (widget.showProblem && _viewModel.questionItem[index].typeId != "23") {
      childList.add(
        LockGestureDetector(
          onItemClickListenCallback: () async {
            final String id = _viewModel.questionItem[index].id;
            _viewModel.updateProblemStatus(
              id,
              _viewModel.problemStatus[id] == 1 ? 0 : 1,
            );
            return true;
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 5),
            height: 36,
            child: Selector<ExaminationViewModel, Map<String, int>>(
              shouldRebuild: (Map<String, int> previous, Map<String, int> next) {
                if (previous[_viewModel.questionItem[index].id] != next[_viewModel.questionItem[index].id]) {
                  return true;
                }
                return false;
              },
              selector: (BuildContext context, ExaminationViewModel model) {
                return model.problemStatus;
              },
              builder: (BuildContext context, Map<String, int> problemList, Widget child) {
                return _buildProblem(
                  problemList[_viewModel.questionItem[index].id] == 1
                      ? ColorUtils.color_bg_colAndQs
                      : ColorUtils.color_text_level1,
                  15.0,
                );
              },
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: childList,
      ),
    );
  }

  /// 构建考试引导页
  Widget _buildExamLaunchScreen(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 53,
            child: Text(
              title,
              style: TextStyle(fontSize: 16, color: ColorUtils.color_text_level1),
            ),
          ),
          Divider(color: ColorUtils.color_bg_splitLine),
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: Text(
              desc,
              style: TextStyle(fontSize: 14, color: ColorUtils.color_text_need_do),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 31),
            child: Image.asset(
              "assets/images/review.png",
              width: 63,
              height: 89,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 19),
            child: Text(
              "向左滑动",
              style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level3),
            ),
          )
        ],
      ),
    );
  }

  /// 构建题目page view
  Widget get _buildPageView {
    /// 需要判断是否是背题 做题等需要的
    final Common common = Provider.of<Common>(context, listen: false);

    StorageQuestionSettingsInfoEntity settingsInfoEntity;

    switch (widget.origin) {
      case 2:
        settingsInfoEntity = common.settingsErrorQuestionInfoEntity;
        break;

      /// 做题记录
      case 3:
        settingsInfoEntity = common.settingsInfoEntity.copyWith(
          mode: int.tryParse(
            _viewModel.recordAnswerEntity.examDetail.examRecord.param10.toString(),
          ),
        );
        break;

      default:
        settingsInfoEntity = common.settingsInfoEntity;
        break;
    }

    return Listener(
      onPointerMove: (movePointEvent) {
        if ([1, 2].contains(widget.type)) {
          clearTwoMinuteTime();
        }
      },
      onPointerUp: (upPointEvent) {
        if ([1, 2].contains(widget.type)) {
          createTwoMinuteTime();
        }
      },
      child: Selector<ExaminationViewModel, List<QuestionItem>>(
        shouldRebuild: (List<QuestionItem> previous, List<QuestionItem> next) {
          if (previous != next) {
            return true;
          }
          return false;
        },
        selector: (BuildContext context, ExaminationViewModel model) => model.questionItem,
        builder: (BuildContext context, List<QuestionItem> value, Widget child) {
          int itemLength = value.length;
          if (widget.type != 4 && itemLength > 0) {
            ++itemLength;
          }
          return PageView.builder(
            itemBuilder: (BuildContext context, int index) {
              /// 如果是最后一页
              if (widget.type != 4) {
                if (index + 1 == value.length + 1) {
                  return _buildScantron(showHeader: false, isModal: false);
                }
              }

              /// 狗日的问题
              final QuestionItem item = value[index];

              if (item.showIntroductionPage == true) {
                return _buildExamLaunchScreen(item.titleName, item.descName);
              }

              final List<Widget> defaultChildren = [
                _buildBottomTitle(index),
                _buildQuestion(item, index, -1),
              ];

              /// 不定项的诡异结构不同,外层没有listview
              switch (item.typeId) {
                case "23":
                  return Column(
                    children: defaultChildren,
                  );
                  break;

                /// 普通 单项 多项以及 判断和对应的不定项选择
                default:

                  /// 从不同页面进来又他吗的逻辑不一样，简直就是偷袭
                  switch (widget.type) {
                    case 1:
                      if (settingsInfoEntity.mode == 1) {
                        defaultChildren.addAll(
                          [
                            /// 构建回答了问题显示做题易错项目等等信息
                            _buildAnswerContentView(item),

                            /// 狗日的需要判断一波是不是有视频数据,不然坑死你
                            if (value[index].videoAnalysis != null && value[index].videoAnalysis.isNotEmpty)
                              _buildVideoView(item),

                            /// 直接构建对应的解析后的文本那些内容
                            _buildInfoView(item),
                          ],
                        );
                      }
                      break;

                    case 3:
                    case 4:
                      defaultChildren.addAll(
                        [
                          /// 构建回答了问题显示做题易错项目等等信息
                          _buildAnswerContentView(item),

                          /// 狗日的需要判断一波是不是有视频数据,不然坑死你
                          if (value[index].videoAnalysis != null && value[index].videoAnalysis.isNotEmpty)
                            _buildVideoView(item),

                          /// 直接构建对应的解析后的文本那些内容
                          _buildInfoView(item),
                        ],
                      );
                      break;
                  }

                  return ListView(children: defaultChildren);
              }
            },
            onPageChanged: (int i) {
              if (i != _viewModel.questionItemIndex) {
                if (i + 1 != _viewModel.questionItem.length + 1) {
                  /// 可能是考试的引导页
                  if (widget.type == 2 && _viewModel.questionItem[i].showIntroductionPage) {
                    _viewModel.actionCollectStatus = false;
                  } else {
                    _viewModel.actionButtonStatus = true;
                  }
                  _viewModel.isCollect = _viewModel.collectionStatus[i];
                  _viewModel.questionItemIndex = i;
                  _viewModel.titleStatus = false;
                  return;
                }

                _viewModel.actionButtonStatus = false;
                _viewModel.titleStatus = true;
                return;
              }

              _viewModel.actionButtonStatus = true;
              _viewModel.titleStatus = false;
            },
            controller: _pageController,
            itemCount: itemLength,
            dragStartBehavior: DragStartBehavior.start,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    final List<Widget> actionWidgetList = [];

    if (isWait) {
      child = Scaffold(
        backgroundColor: ColorUtils.color_bg_splitBlock,
        appBar: AppBar(
          elevation: 0.5,
          toolbarHeight: BuildConfig.appBarHeight,
          leading: ThemeUtils.getDefaultLeading(),
        ),
      );
    } else {
      actionWidgetList.addAll(
        [
          if (widget.type == 1 && widget.origin == 2) _buildDeleteButton,
          _buildCollectButton,
          if (![3, 4].contains(widget.type)) _buildTimerButton,
          if (widget.type != 4) _buildNumButton,
        ],
      );

      child = WillPopScope(
        onWillPop: () async {
          ToastUtils.cleanAllLoading();
          if (![3, 4].contains(widget.type)) {
            showExitConfirmDialog();
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: ColorUtils.color_bg_splitBlock,
          appBar: AppBar(
            elevation: 0.5,
            centerTitle: true,
            title: _buildTitle,
            leading: _buildLeading,
            actions: actionWidgetList,
            toolbarHeight: 45,
          ),
          body: _buildPageView,
        ),
      );
    }

    return BaseProviderWidget<ExaminationViewModel>(
      viewModel: _viewModel,
      onModelReady: _onModelReady,
      child: child,
      showHeader: true,
    );
  }
}
