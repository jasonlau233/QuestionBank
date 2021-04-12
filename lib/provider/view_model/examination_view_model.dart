import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:question_bank/em/view_state_type.dart';
import 'package:question_bank/model/data/paper_answer_entity.dart';
import 'package:question_bank/model/data/report_entity.dart';
import '../../model/data/storage_question_settings_entity.dart';
import '../../model/service/collect_service.dart';
import '../../model/data/exam_info_entity.dart';
import '../../model/service/examination_service.dart';
import 'base_view_model.dart';

typedef List<QuestionItem> CustomFilterFunction(List<QuestionItem> items);

/// 存储做题目的时候退出又进来的实体数据，用于考试回传进来,然后解析到对应的数据字段里面
class ExamPaperInfo {
  /// 接口返回的实体信息
  final ExamInfoEntity examInfoEntity;

  /// 返回json对应的group用到答题卡中
  final List<Groups> groupInfoEntity;

  /// 题目信息
  final List<QuestionItem> questionItem;

  /// 题目id 索引map
  final Map<String, int> questionIdList;

  /// 试卷执行的时间
  final Duration timestamp;

  /// 收藏的所有状态组
  final List<bool> collectionStatus;

  /// 标记疑问
  final Map<String, int> problemStatus;

  /// 答案map
  final Map<String, QuestionAnswerBean> questAnswerMap;

  /// 收藏的index对应的
  final Map<int, String> collectIdMap;

  /// groupId => num 对应的已经做题的数目
  final Map<String, int> groupNum;

  /// 题目耗时
  final Map<String, double> questionTime;

  const ExamPaperInfo({
    this.examInfoEntity,
    this.groupInfoEntity,
    this.questionItem,
    this.questionIdList,
    this.timestamp,
    this.collectionStatus,
    this.problemStatus,
    this.questAnswerMap,
    this.collectIdMap,
    this.groupNum,
    this.questionTime,
  });
}

/// 解析答案的实体
class QuestionAnswerBean {
  /// 答案 A B C D
  final List<String> answer;

  /// 排除答案
  final List<String> eliminate;

  /// 是否做完了
  final bool isFinish;

  /// 确认答案是否正确
  final bool isAnswerTrue;

  const QuestionAnswerBean({
    this.answer = const [],
    this.eliminate = const [],
    this.isFinish = false,
    this.isAnswerTrue = false,
  });

  QuestionAnswerBean copyWith({
    List<dynamic> answer,
    List<dynamic> eliminate,
    Map<int, List<String>> unConfirmAnswer,
    bool isFinish,
    bool isAnswerTrue,
    Map<String, bool> moreIsFinish,
    Map<String, bool> moreIsAnswerTrue,
  }) {
    return QuestionAnswerBean(
      eliminate: eliminate ?? this.eliminate,
      answer: answer ?? this.answer,
      isFinish: isFinish ?? this.isFinish,
      isAnswerTrue: isAnswerTrue ?? this.isAnswerTrue,
    );
  }
}

class ExaminationViewModel extends BaseViewModel {
  /// 接口返回的实体信息
  ExamInfoEntity _examInfoEntity;

  ExamInfoEntity get examInfoEntity => _examInfoEntity;

  /// 返回json对应的group用到答题卡中
  List<Groups> _groupInfoEntity;

  List<Groups> get groupInfoEntity => _groupInfoEntity;

  /// 标题
  String _examinationTitle = "";

  String get examinationTitle => _examinationTitle;

  set examinationTitle(String title) {
    if (title == _examinationTitle) return;
    _examinationTitle = title;
    notifyListeners();
  }

  /// 当前序号(包含考试的引导页的)
  int _questionItemIndex = -1;

  int get questionItemIndex => _questionItemIndex;

  set questionItemIndex(int num) {
    _questionItemIndex = num;
    notifyListeners();
  }

  /// 当前序号(包含考试的引导页的)
  int _currentQuestionIndex = 0;

  int get currentQuestionIndex => _currentQuestionIndex;

  set currentQuestionIndex(int num) {
    if (num == _currentQuestionIndex) {
      return;
    }
    _currentQuestionIndex = num;
    notifyListeners();
  }

  /// 题目列表
  List<QuestionItem> _questionItem = [];

  List<QuestionItem> get questionItem => _questionItem;

  set questionItem(List<QuestionItem> items) {
    if (items == _questionItem) return;
    _questionItem = items;
    notifyListeners();
  }

  /// 删除题目
  removeQuestionItem(int index, int childIndex) {
    if (_questionItem.length <= 0) {
      return;
    }

    final List<QuestionItem> newQuestionItemList = List.from(_questionItem);
    if (newQuestionItemList[index].typeId != "23") {
      _questionIdList.remove(newQuestionItemList[index].id);
      newQuestionItemList
        ..removeAt(index)
        ..asMap().forEach((k, v) {
          _questionIdList[v.id] = k;
        });
    } else {
      if (childIndex <= -1) {
        return;
      }

      final QuestionItem item = newQuestionItemList[index];

      if (item.questionChildrenList == null || item.questionChildrenList.length <= 0) {
        return;
      }

      item.questionChildrenList.removeAt(childIndex);

      if (item.questionChildrenList.length <= 0) {
        _questionIdList.remove(newQuestionItemList[index].id);
        newQuestionItemList
          ..removeAt(index)
          ..asMap().forEach((k, v) {
            _questionIdList[v.id] = k;
          });
      } else {
        newQuestionItemList[index] = item;
      }
    }
    questionItem = newQuestionItemList;
  }

  /// 专门对题目进行id储存的，用来page_controller跳转或则来引用对应的按钮的选择项
  Map<String, int> _questionIdList = {};

  Map<String, int> get questionIdList => _questionIdList;

  /// 考点信息map
  Map<String, dynamic> _examPointMap = {};

  Map<String, dynamic> get examPointMap => _examPointMap;

  /// 易错项目map
  Map<String, dynamic> _statisticsMap = {};

  Map<String, dynamic> get statisticsMap => _statisticsMap;

  /// 来源信息map
  Map<String, dynamic> _originMap = {};

  Map<String, dynamic> get originMap => _originMap;

  /// 错了多少次map
  Map<String, dynamic> _errNumMap = {};

  Map<String, dynamic> get errNumMap => _errNumMap;

  /// 答题用时
  Map<String, double> _questionTime = {};

  Map<String, double> get questionTime => _questionTime;

  /// 考试存在对应的题目序号,因为考试多了引导页，做好一个题目index隐射
  Map<int, int> _examQuestionIndex = {};

  Map<int, int> get examQuestionIndex => _examQuestionIndex;

  /// 组合题目对应的index
  Map<String, int> _moreQuestionToIndex = {};

  Map<String, int> get moreQuestionToIndex => _moreQuestionToIndex;

  setMoreQuestionToIndex(String id, int index) {
    _moreQuestionToIndex[id] = index;
  }

  PaperAnswerEntity _recordAnswerEntity;

  PaperAnswerEntity get recordAnswerEntity => _recordAnswerEntity;

  /// 这个是做题历史记录数据
  Map<String, ExamDetails> _paperAnswerEntity = {};

  Map<String, ExamDetails> get paperAnswerMap => _paperAnswerEntity;

  setQuestionTime(String id) {
    if (_questionTime.containsKey(id)) {
      final double newTime = _questionTime[id] + 0.2;
      _questionTime[id] = double.parse(newTime.toStringAsFixed(2));
    } else {
      _questionTime[id] = 0.2;
    }
  }

  /// 控制对应的收藏按钮是否切换不同状态
  bool _isCollect = false;

  bool get isCollect => _isCollect;

  set isCollect(bool state) {
    _isCollect = state;
    notifyListeners();
  }

  /// 控制对应的收藏按钮是否切换不同状态
  double _offsetDistance = 312.0;

  double get offsetDistance => _offsetDistance;

  set offsetDistance(double num) {
    if (num <= 0) {
      _offsetDistance = 0;
    } else {
      if (num >= 580) {
        _offsetDistance = 580;
      } else {
        _offsetDistance = num;
      }
    }
    notifyListeners();
  }

  /// 计时器
  Duration _timestamp = Duration(seconds: 0);

  Duration get timestamp => _timestamp;

  set timestamp(Duration time) {
    if (_timestamp == time) {
      return;
    }
    _timestamp = time;
    notifyListeners();
  }

  /// 收藏的所有状态组
  List<bool> _collectionStatus = [];

  List<bool> get collectionStatus => _collectionStatus;

  set collectionStatus(List<bool> items) => _collectionStatus = items;

  updateCollectionStatus(int index, bool status) => _collectionStatus[index] = status;

  /// 标记疑问
  Map<String, int> _problemStatus = {};

  Map<String, int> get problemStatus => _problemStatus;

  set problemStatus(Map<String, int> items) {
    _problemStatus = items;
    notifyListeners();
  }

  updateProblemStatus(String id, int isProblem) {
    final Map<String, int> beanMap = Map.from(_problemStatus);
    beanMap[id] = isProblem;
    problemStatus = beanMap;
  }

  /// 存储对应的题目的答案
  Map<String, QuestionAnswerBean> _questAnswerMap = {};

  Map<String, QuestionAnswerBean> get questAnswerMap => _questAnswerMap;

  set questAnswerMap(Map<String, QuestionAnswerBean> state) {
    _questAnswerMap = state;
    notifyListeners();
  }

  void updateQuestAnswer(String id, QuestionAnswerBean bean, {bool remove: false}) {
    final Map<String, QuestionAnswerBean> beanMap = Map.from(_questAnswerMap);
    if (remove) {
      beanMap.remove(id);
    } else {
      beanMap[id] = bean;
    }
    questAnswerMap = beanMap;
  }

  /// 对应的收藏map是可能不存在collectId字段用于存储index对应collectId
  Map<int, String> _collectIdMap = Map();

  Map<int, String> get collectIdMap => _collectIdMap;

  void addCollectId(Map<int, String> collectIdMap) {
    _collectIdMap.addAll(collectIdMap);
  }

  /// 统一用来控制下面的按钮
  set actionButtonStatus(bool status) {
    actionCollectStatus = status;
    actionTimerStatus = status;
    actionCardStatus = status;
  }

  /// 收藏按钮的隐藏
  bool _actionCollectStatus = true;

  bool get actionCollectStatus => _actionCollectStatus;

  set actionCollectStatus(bool status) {
    _actionCollectStatus = status;
    notifyListeners();
  }

  /// 暂停按钮的隐藏
  bool _actionTimerStatus = true;

  bool get actionTimerStatus => _actionTimerStatus;

  set actionTimerStatus(bool status) {
    _actionTimerStatus = status;
    notifyListeners();
  }

  /// 暂停按钮的隐藏
  bool _actionCardStatus = true;

  bool get actionCardStatus => _actionCardStatus;

  set actionCardStatus(bool status) {
    _actionCardStatus = status;
    notifyListeners();
  }

  /// 标题是否显示
  bool _titleStatus = false;

  bool get titleStatus => _titleStatus;

  set titleStatus(bool status) {
    if (status == _titleStatus) {
      return;
    }
    _titleStatus = status;
    notifyListeners();
  }

  /// 标题是否显示
  Map<String, PageController> _groupPageController = {};

  Map<String, PageController> get groupPageController => _groupPageController;

  clearAllGroupController() {
    if (_groupPageController.length > 0) {
      _groupPageController.forEach((k, element) => element.dispose());
    }
  }

  /// 保存当前的行为记录
  ExamPaperInfo get saveCurrentRecord {
    final Map<String, int> groupNum = {};

    /// 做的题目数统计
    _groupInfoEntity.forEach(
      (element) {
        int num = 0;
        if (element.questionsItem != null && element.questionsItem.length > 0) {
          element.questionsItem.forEach(
            (element) {
              if (element.questionChildrenList != null && element.questionChildrenList.length > 0) {
                if (_questAnswerMap.containsKey(element.questionChildrenList[0].id)) {
                  num++;
                }
              } else {
                if (_questAnswerMap.containsKey(element.id)) {
                  num++;
                }
              }
            },
          );
        }
        groupNum[element.id] = num;
      },
    );

    return ExamPaperInfo(
      timestamp: _timestamp,
      collectIdMap: _collectIdMap,
      questAnswerMap: _questAnswerMap,
      problemStatus: _problemStatus,
      collectionStatus: _collectionStatus,
      examInfoEntity: _examInfoEntity,
      groupInfoEntity: _groupInfoEntity,
      questionItem: _questionItem,
      questionIdList: _questionIdList,
      groupNum: groupNum,
    );
  }

  /// 获取试卷信息
  Future<bool> getPaperInfo(
    String paperUuid,
    String examId,
    int origin,
    String recordId,
    PaperAnswerEntity paperEntity,
    List<String> onlyNeedQuestionList,
    List<String> onlyChildQuestionList,
    StorageQuestionSettingsInfoEntity settingsInfoEntity,
    int uid,
  ) async {
    switch (origin) {

      /// 错题本
      case 2:
        {
          if (onlyNeedQuestionList != null && onlyNeedQuestionList.length > 0) {
            final List<String> shuffleList = [];
            onlyNeedQuestionList..shuffle()..shuffle();

            if (onlyNeedQuestionList.length >= settingsInfoEntity.numMode) {
              shuffleList.addAll(
                onlyNeedQuestionList.sublist(0, settingsInfoEntity.numMode),
              );
            } else if (onlyNeedQuestionList.length < settingsInfoEntity.numMode) {
              shuffleList.addAll(
                onlyNeedQuestionList.sublist(0, onlyNeedQuestionList.length),
              );
            }

            bool needPointInfo = false;
            bool needOriginInfo = false;
            bool needStatisticsInfo = false;
            bool showAnswerBean = false;
            bool needErrNumInfo = false;
            bool showBeanTime = false;

            /// 区分背题和做题
            if (settingsInfoEntity.mode == 1) {
              needPointInfo = true;
              needOriginInfo = true;
              needStatisticsInfo = true;
              needErrNumInfo = true;
            }

            return await getPaperQuestionData(
              paperUuid,
              examId: examId,
              uid: uid,
              needPointInfo: needPointInfo,
              needOriginInfo: needOriginInfo,
              needStatisticsInfo: needStatisticsInfo,
              needErrNumInfo: needErrNumInfo,
              showAnswerBean: showAnswerBean,
              showBeanTime: showBeanTime,
              needProblemInfo: false,
              needUserHistoryRecordInfo: true,
              customQuestionItemFunction: (key, value, _) {
                _questionTime[value.id] = 0.2;
              },
              customFilterFunction: (List<QuestionItem> items) {
                return _buildCustomGroupInfo(items);
              },
              filterFunction: (List<QuestionItem> items) {
                items.removeWhere(
                  (element) {
                    if (shuffleList.contains(element.id)) {
                      switch (element.typeId) {
                        case "23":
                          if (onlyChildQuestionList == null || onlyChildQuestionList.length <= 0) {
                            return true;
                          }

                          if (element.questionChildrenList != null || element.questionChildrenList.length > 0) {
                            element.questionChildrenList
                                .removeWhere((child) => !onlyChildQuestionList.contains(child.id));
                          }

                          if (element.questionChildrenList.length <= 0) {
                            return true;
                          }

                          return false;
                          break;

                        default:
                          return false;
                          break;
                      }
                    }
                    return true;
                  },
                );
                return items;
              },
            );
          }

          return false;
        }
        break;

      /// 做题记录
      case 3:
        {
          if (recordId != null && recordId.isNotEmpty) {
            PaperAnswerEntity entity;

            if (paperEntity != null) {
              entity = paperEntity;
            } else {
              /// 调用接口拿到这一次做题记录数据
              entity = await getSomeoneRecordInfo(recordId);

              /// 没有记录
              if (entity == null) {
                return false;
              }
            }

            _recordAnswerEntity = entity;
            bool isShowAnswer = false;

            if (entity.examDetail != null) {
              if (entity.examDetail.examRecord != null) {
                if (entity.examDetail.examRecord.param10.toString() == "1") {
                  isShowAnswer = true;
                }
              }
              if (entity.examDetail.examDetails != null) {
                if (entity.examDetail.examDetails is List) {
                  entity.examDetail.examDetails.forEach(
                    (value) {
                      _paperAnswerEntity[value.questionId] = value;
                    },
                  );
                }
              }
            }

            bool needPointInfo = false;
            bool needOriginInfo = false;
            bool needStatisticsInfo = false;
            bool needErrNumInfo = false;

            if (isShowAnswer) {
              needPointInfo = true;
              needOriginInfo = true;
              needStatisticsInfo = true;
              needErrNumInfo = true;
            }

            return await getPaperQuestionData(
              paperUuid,
              examId: examId,
              uid: uid,
              needPointInfo: needPointInfo,
              needOriginInfo: needOriginInfo,
              needStatisticsInfo: needStatisticsInfo,
              needErrNumInfo: needErrNumInfo,
              showAnswerBean: false,
              showBeanTime: false,
              needProblemInfo: false,
              needUserHistoryRecordInfo: false,
              customFilterFunction: (List<QuestionItem> items) {
                items = _buildCustomGroupInfo(items);
                Function businessFunction = (QuestionItem element) {
                  _questionTime[element.id] = _paperAnswerEntity[element.id].usedTime ?? 0.2;
                  _problemStatus[element.id] = int.parse(_paperAnswerEntity[element.id].isAnyQuestions.toString());
                  if (_paperAnswerEntity[element.id].userAnswer != null &&
                      _paperAnswerEntity[element.id].userAnswer.isNotEmpty) {
                    final List<String> userAnswer = _paperAnswerEntity[element.id].userAnswer.split(",");

                    /// 背题需要检查答案
                    if (isShowAnswer) {
                      final int len = _paperAnswerEntity[element.id].userAnswer.length;
                      bool success = false;
                      bool isOk = false;

                      if (len != element.answer.replaceAll(",", "").length) {
                        /// 判断答案
                        for (int i = 0; i < len; i++) {
                          if (!element.answer.contains(_paperAnswerEntity[element.id].userAnswer[i])) {
                            _questAnswerMap[element.id] = QuestionAnswerBean(
                              answer: userAnswer,
                              isFinish: true,
                              isAnswerTrue: false,
                            );
                            isOk = true;
                            break;
                          }
                        }

                        if (!isOk) {
                          _questAnswerMap[element.id] = QuestionAnswerBean(
                            answer: userAnswer,
                            isFinish: true,
                            isAnswerTrue: true,
                          );
                        }
                      } else {
                        /// 判断答案
                        for (int i = 0; i < len; i++) {
                          if (!element.answer.contains(_paperAnswerEntity[element.id].userAnswer[i])) {
                            _questAnswerMap[element.id] = QuestionAnswerBean(
                              answer: userAnswer,
                              isFinish: true,
                              isAnswerTrue: false,
                            );
                            success = true;
                            break;
                          }
                        }

                        if (!success) {
                          _questAnswerMap[element.id] = QuestionAnswerBean(
                            answer: userAnswer,
                            isFinish: true,
                            isAnswerTrue: true,
                          );
                        }
                      }
                    } else {
                      _questAnswerMap[element.id] = QuestionAnswerBean(answer: userAnswer);
                    }
                  }
                };

                items.removeWhere(
                  (element) {
                    if (element.typeId == "23") {
                      if (element.questionChildrenList != null && element.questionChildrenList.length > 0) {
                        for (var v in element.questionChildrenList) {
                          if (entity.examDetail.examRecord.praticeQids.contains(v.id)) {
                            return false;
                          }
                        }
                      }
                      return true;
                    } else {
                      return !entity.examDetail.examRecord.praticeQids.contains(element.id);
                    }
                  },
                );

                items.forEach(
                  (element) {
                    switch (element.typeId) {
                      case "23":
                        if (element.questionChildrenList != null && element.questionChildrenList.length > 0) {
                          element.questionChildrenList.forEach(
                            (childElement) {
                              businessFunction(childElement);
                            },
                          );
                        }
                        break;

                      default:
                        businessFunction(element);
                        break;
                    }
                  },
                );
                return items;
              },
            );
          }
          return false;
        }
        break;

      default:
        {
          bool needPointInfo = false;
          bool needOriginInfo = false;
          bool needStatisticsInfo = false;
          bool showAnswerBean = false;
          bool needErrNumInfo = false;
          bool showBeanTime = false;

          /// 区分背题和做题
          if (settingsInfoEntity.mode == 1) {
            needPointInfo = true;
            needOriginInfo = true;
            needStatisticsInfo = true;
            needErrNumInfo = true;
          }

          return await getPaperQuestionData(
            paperUuid,
            examId: examId,
            uid: uid,
            needPointInfo: needPointInfo,
            needOriginInfo: needOriginInfo,
            needStatisticsInfo: needStatisticsInfo,
            needErrNumInfo: needErrNumInfo,
            showAnswerBean: showAnswerBean,
            showBeanTime: showBeanTime,
            needProblemInfo: false,
            needUserHistoryRecordInfo: true,
            customQuestionItemFunction: (key, value, _) {
              _questionTime[value.id] = 0.2;
            },
            userHistoryRecordFunction: (List<QuestionItem> items, Map<String, dynamic> historyRecord) {
              if (historyRecord != null && items != null) {
                if (items.length <= 0) {
                  return _buildCustomGroupInfo(items);
                }

                List<QuestionItem> doneDataList = [];
                List<QuestionItem> notDoneDataList = [];

                items.forEach(
                  (element) {
                    if (historyRecord.containsKey(element.id)) {
                      doneDataList.add(element);
                    } else {
                      notDoneDataList.add(element);
                    }
                  },
                );

                final int notDoneDataListLen = notDoneDataList.length;

                /// 优先抽未做的题 未做的题做完抽已做的题
                if (notDoneDataListLen > 0) {
                  notDoneDataList..shuffle()..shuffle();

                  /// 判断越界问题
                  if (notDoneDataListLen >= settingsInfoEntity.numMode) {
                    notDoneDataList = notDoneDataList.sublist(0, settingsInfoEntity.numMode);
                  } else if (notDoneDataListLen < settingsInfoEntity.numMode) {
                    notDoneDataList = notDoneDataList.sublist(0, notDoneDataListLen);
                  }

                  /// 确认是否达到了题目数,没有就从做完的里面抽够为止
                  if (notDoneDataList.length != settingsInfoEntity.numMode) {
                    if (doneDataList.length > 0) {
                      doneDataList..shuffle();

                      /// 判断剩余多少个子元素了
                      final int less = settingsInfoEntity.numMode - notDoneDataList.length;
                      if (doneDataList.length >= less) {
                        notDoneDataList.addAll(
                          doneDataList.sublist(0, less),
                        );
                      } else if (doneDataList.length < less) {
                        notDoneDataList.addAll(
                          doneDataList.sublist(0, doneDataList.length),
                        );
                      }
                    }
                  }
                } else {
                  /// 只有未做的题目
                  doneDataList..shuffle()..shuffle();
                  if (doneDataList.length >= settingsInfoEntity.numMode) {
                    notDoneDataList.addAll(
                      doneDataList.sublist(0, settingsInfoEntity.numMode),
                    );
                  } else if (doneDataList.length < settingsInfoEntity.numMode) {
                    notDoneDataList.addAll(
                      doneDataList.sublist(0, doneDataList.length),
                    );
                  }
                }

                return _buildCustomGroupInfo(notDoneDataList);
              } else {
                return _buildCustomGroupInfo(items);
              }
            },
          );
        }
        break;
    }
  }

  /// 获取考试试卷内容
  Future<bool> getExamPaperInfo(
    String paperUuid,
    String examId,
    int uid,
    ExamPaperInfo info,
    int origin,
    String recordId,
    PaperAnswerEntity paperEntity,
  ) async {
    switch (origin) {
      case 2:
        return false;
        break;

      case 3:
        if (recordId != null && recordId.isNotEmpty) {
          PaperAnswerEntity entity;

          if (paperEntity != null) {
            entity = paperEntity;
          } else {
            /// 调用接口拿到这一次做题记录数据
            entity = await getSomeoneRecordInfo(recordId);
          }

          /// 没有记录
          if (entity == null) {
            return false;
          }

          _recordAnswerEntity = entity;

          if (entity.examDetail != null && entity.examDetail.examDetails != null) {
            if (entity.examDetail.examDetails is List) {
              entity.examDetail.examDetails.forEach(
                (value) {
                  _paperAnswerEntity[value.questionId] = value;
                },
              );
            }
          }

          return await getPaperQuestionData(
            paperUuid,
            examId: examId,
            uid: uid,
            needPointInfo: false,
            needOriginInfo: false,
            needStatisticsInfo: false,
            needErrNumInfo: false,
            showAnswerBean: false,
            showBeanTime: false,
            needProblemInfo: false,
            needUserHistoryRecordInfo: false,
            filterFunction: (List<QuestionItem> items) {
              items.sort((a, b) => a.id.compareTo(b.id));
              return items;
            },
            customFilterFunction: (List<QuestionItem> items) {
              Function businessFunction = (QuestionItem element) {
                if (_paperAnswerEntity.containsKey(element.id)) {
                  _questionTime[element.id] = _paperAnswerEntity[element.id].usedTime ?? 0.2;
                  _problemStatus[element.id] = _paperAnswerEntity[element.id].isAnyQuestions;

                  if (_paperAnswerEntity[element.id].userAnswer != null &&
                      _paperAnswerEntity[element.id].userAnswer.isNotEmpty) {
                    final List<String> userAnswer = _paperAnswerEntity[element.id].userAnswer.split(",");
                    _questAnswerMap[element.id] = QuestionAnswerBean(answer: userAnswer);
                  }
                }
              };
              items.forEach(
                (element) {
                  if (element.typeId == "23") {
                    if (element.questionChildrenList != null && element.questionChildrenList.length > 0) {
                      element.questionChildrenList.sort((a, b) => a.id.compareTo(b.id));
                      element.questionChildrenList.forEach(
                        (childElement) {
                          businessFunction(childElement);
                        },
                      );
                    }
                  } else {
                    businessFunction(element);
                  }
                },
              );

              /// 确认需要在那些位置插入对应的引导图
              if (groupInfoEntity != null) {
                int lastLength = 0;
                groupInfoEntity.asMap().forEach(
                  (k, element) {
                    if (element.questionsItem != null &&
                        element.questionsItem is List &&
                        element.questionsItem.length > 0) {
                      const List<String> splitString = ["#@#", "%@%"];

                      List<String> textString = [element.groupName, ""];
                      for (var v in splitString) {
                        if (element.groupName.contains(v)) {
                          textString = element.groupName.split(v);
                          break;
                        }
                      }

                      lastLength += k == 0 ? 0 : groupInfoEntity[k - 1].questionsItem.length + 1;
                      items.insert(
                        lastLength,
                        QuestionItem.fromJson(
                          {
                            "showIntroductionPage": true,
                            "titleName": textString.first,
                            "descName": textString.last,
                          },
                        ),
                      );
                    }
                  },
                );
              }
              return items;
            },
          );
        }
        return false;
        break;

      default:
        return await getPaperQuestionData(
          paperUuid,
          needPointInfo: false,
          needOriginInfo: false,
          needStatisticsInfo: false,
          needUserHistoryRecordInfo: false,
          showAnswerBean: false,
          filterFunction: (List<QuestionItem> items) {
            items.sort((a, b) => a.id.compareTo(b.id));
            return items;
          },
          customFilterFunction: (List<QuestionItem> items) {
            int lastLength = 0;

            /// 确认需要在那些位置插入对应的引导图
            if (groupInfoEntity != null) {
              groupInfoEntity.asMap().forEach(
                (k, element) {
                  if (element.questionsItem != null && element.questionsItem.length > 0) {
                    const List<String> splitString = ["#@#", "%@%"];

                    List<String> textString = [element.groupName, ""];
                    for (var v in splitString) {
                      if (element.groupName.contains(v)) {
                        textString = element.groupName.split(v);
                        break;
                      }
                    }

                    lastLength += k == 0 ? 0 : groupInfoEntity[k - 1].questionsItem.length + 1;
                    items.insert(
                      lastLength,
                      QuestionItem.fromJson(
                        {
                          "showIntroductionPage": true,
                          "titleName": textString.first,
                          "descName": textString.last,
                        },
                      ),
                    );
                  }
                },
              );
            }
            return items;
          },
          customQuestionItemFunction: (key, value, _) {
            _questionTime[value.id] = 0.2;
          },
        );
        break;
    }
  }

  /// 只展示某一个或则多个题目的数据解析后的答案
  Future<bool> getSomeQuestionItemAnalysis(
    int uid,
    String paperUuid,
    String examId,
    List<String> questionItemIdList,
  ) async {
    if (questionItemIdList == null || questionItemIdList.length <= 0) {
      return true;
    }
    return await getPaperQuestionData(
      paperUuid,
      uid: uid,
      customFilterFunction: (List<QuestionItem> items) {
        return items;
      },
      filterFunction: (List<QuestionItem> items) {
        items.removeWhere(
          (element) {
            return !questionItemIdList.contains(element.id);
          },
        );
        return items;
      },
    );
  }

  /// 解析报告数据
  Future<bool> getAnalysisReport(
    int uid,
    String paperUuid,
    String examId,
    List<String> errorIdList,
    List<String> chooseQuestionIdList,
    Map<String, QuestionsReport> paperDataMap,
  ) async {
    Function businessFunction = (QuestionItem value) {
      final List<String> userAnswer = [];
      bool isAnswerTrue = false;
      int problemStatus = 0;

      if (paperDataMap != null && paperDataMap.containsKey(value.id)) {
        problemStatus = paperDataMap[value.id].isAnyQuestions;
        isAnswerTrue = paperDataMap[value.id].isCorrect == 2;

        _questionTime[value.id] = paperDataMap[value.id].usedTime.toDouble();

        if (paperDataMap[value.id].userAnswer != null && paperDataMap[value.id].userAnswer.isNotEmpty) {
          userAnswer.addAll(
            paperDataMap[value.id].userAnswer.split(","),
          );
        }
      }

      _problemStatus[value.id] = problemStatus;
      _questAnswerMap[value.id] = QuestionAnswerBean(isFinish: true, isAnswerTrue: isAnswerTrue, answer: userAnswer);
    };

    return await getPaperQuestionData(
      paperUuid,
      examId: examId,
      uid: uid,
      showAnswerBean: false,
      needUserHistoryRecordInfo: false,
      filterFunction: (List<QuestionItem> items) {
        if (chooseQuestionIdList != null && chooseQuestionIdList.length > 0) {
          items.removeWhere(
            (element) {
              if (element.typeId == "23") {
                if (element.questionChildrenList != null && element.questionChildrenList.length > 0) {
                  for (var v in element.questionChildrenList) {
                    if (chooseQuestionIdList.contains(v.id)) {
                      element.questionChildrenList.sort((a, b) => a.id.compareTo(b.id));
                      return false;
                    }
                  }
                }
                return true;
              } else {
                return !chooseQuestionIdList.contains(element.id);
              }
            },
          );
        }
        if (errorIdList != null && errorIdList.length > 0) {
          items.removeWhere(
            (element) {
              if (element.typeId == "23") {
                if (element.questionChildrenList != null && element.questionChildrenList.length > 0) {
                  element.questionChildrenList.removeWhere((childElement) => !errorIdList.contains(childElement.id));
                  if (element.questionChildrenList.length > 0) {
                    element.questionChildrenList.sort((a, b) => a.id.compareTo(b.id));
                    return false;
                  }
                }
                return true;
              } else {
                return !errorIdList.contains(element.id);
              }
            },
          );
        }
        items.sort((a, b) => a.id.compareTo(b.id));
        return items;
      },
      customQuestionItemFunction: (key, value, historyRecordMap) {
        final int typeId = int.parse(value.typeId);
        if (typeId == 23) {
          if (value.questionChildrenList != null && value.questionChildrenList.length > 0) {
            value.questionChildrenList.forEach(
              (c) {
                businessFunction(c);
              },
            );
          }
        } else {
          businessFunction(value);
        }
      },
    );
  }

  /// 新增收藏
  Future<bool> addCollectQuestionItem(
    int index,
    String paperUuid,
    int userId,
    String subModuleId,
    int questionId,
    String chapterCode,
  ) async {
    final String collectId = await CollectService.addCollectQuestionItem(
      paperUuid,
      questionId,
      userId,
      subModuleId,
      chapterCode,
    );
    if (collectId != null) {
      _collectIdMap.addAll({index: collectId});
      return true;
    }
    return false;
  }

  /// 取消收藏
  Future<bool> cancelCollectQuestionItem(String collectId, int userId) async {
    return await CollectService.cancelCollectQuestionItem(collectId, userId);
  }

  /// 获取考点信息
  Future<void> getExamPointInfo(List<String> idList) async {
    if (idList.length <= 0) {
      return;
    }
    final Map<String, dynamic> info = await ExaminationService.getExamPoint(idList.join(","));
    if (info != null) {
      _examPointMap = info;
    }
  }

  /// 收藏接口
  Future<Map<String, dynamic>> getCollectInfo(String paperUUid) async {
    return await ExaminationService.getCollectInfo(paperUUid);
  }

  /// 获取来源实体信息
  Future<void> getOriginInfo() async {
    final Map<String, dynamic> info = await ExaminationService.getOrigin();
    if (info != null) {
      _originMap = info;
    }
  }

  /// 获取易错项目 正确率
  Future<void> getStatisticsInfo(String paperUuid, List<String> questionIds, String examId) async {
    final Map<String, dynamic> info = await ExaminationService.getOptionStatisticsByUuidQids(
      paperUuid,
      questionIds.join(","),
      examId,
    );
    if (info != null) {
      _statisticsMap = info;
    }
  }

  /// 获取题目错了多少次了
  Future<void> getErrNumInfo(String paperUuid, String examId) async {
    final Map<String, dynamic> info = await ExaminationService.getQuestionErrNumInfo(
      paperUuid,
      examId,
    );
    if (info != null) {
      _errNumMap = info;
    }
  }

  /// 构建自定义的custom
  List<QuestionItem> _buildCustomGroupInfo(List<QuestionItem> items) {
    final List<QuestionItem> oneAnswerList = [];
    final List<QuestionItem> moreAnswerList = [];
    final List<QuestionItem> trueFalseAnswerList = [];
    final List<QuestionItem> groupAnswerList = [];
    final List<QuestionItem> groupInfoAnswerList = [];

    items.forEach(
      (element) {
        switch (element.typeId) {

          /// 单选
          case "1":
            oneAnswerList.add(element);
            break;

          /// 判断
          case "3":
            trueFalseAnswerList.add(element);
            break;

          /// 多选
          case "2":
            moreAnswerList.add(element);
            break;

          case "7":
            groupInfoAnswerList.add(element);
            break;

          /// 不定项
          case "23":
            groupAnswerList.add(element);
            break;
        }
      },
    );

    oneAnswerList.sort((a, b) => a.id.compareTo(b.id));
    trueFalseAnswerList.sort((a, b) => a.id.compareTo(b.id));
    moreAnswerList.sort((a, b) => a.id.compareTo(b.id));
    groupInfoAnswerList.sort((a, b) => a.id.compareTo(b.id));
    groupAnswerList.sort((a, b) => a.id.compareTo(b.id));

    _groupInfoEntity = [
      if (trueFalseAnswerList.length > 0) Groups(groupName: "判断题", questions: trueFalseAnswerList),
      if (oneAnswerList.length > 0) Groups(groupName: "单项题", questions: oneAnswerList),
      if (moreAnswerList.length > 0) Groups(groupName: "多选题", questions: moreAnswerList),
      if (groupInfoAnswerList.length > 0) Groups(groupName: "不定项选择题", questions: groupInfoAnswerList),
      if (groupAnswerList.length > 0) Groups(groupName: "不定项选择题", questions: groupAnswerList),
    ];

    return []
      ..addAll(trueFalseAnswerList)
      ..addAll(oneAnswerList)
      ..addAll(moreAnswerList)
      ..addAll(groupInfoAnswerList)
      ..addAll(groupAnswerList);
  }

  /// 获取答题的历史记录
  Future<Map<String, dynamic>> getHistoryRecordInfo(int uid, String paperUuid, String examId) async {
    return await ExaminationService.getHistoryExamRecord(uid, paperUuid, examId);
  }

  /// 获取做题记录中的某个记录数据
  Future<PaperAnswerEntity> getSomeoneRecordInfo(String recordId) async {
    return await ExaminationService.getSomeoneRecordInfo(recordId);
  }

  /// 删除错题
  Future<bool> removeErrorQuestion(Map<String, dynamic> params) async {
    return await ExaminationService.removeErrorQuestionItem(params);
  }

  /// 解析里面所有的题目以及对应的所需数据项目
  Future<bool> getPaperQuestionData(
    String paperUuid, {
    String examId,
    int uid,
    bool needPointInfo = true,
    bool needOriginInfo = true,
    bool needStatisticsInfo = true,
    bool needErrNumInfo = false,
    bool needUserHistoryRecordInfo = true,
    bool needProblemInfo = true,
    bool showAnswerBean = true,
    bool showBeanTime = true,
    CustomFilterFunction filterFunction,
    CustomFilterFunction customFilterFunction,
    Function customQuestionItemFunction,
    Function userHistoryRecordFunction,
  }) async {
    viewState = ViewState.Loading;
    final ExamInfoEntity entity = await ExaminationService.getDefaultPaperInfo(paperUuid);

    if (entity == null) {
      viewState = ViewState.Error;
      return false;
    }

    entity.groups.removeWhere((element) => element.questionsItem == null || element.questionsItem.isEmpty);
    _examInfoEntity = entity;

    /// 检查是什么类型显示不同的名字
    if (entity.groups == null || entity.groups.length <= 0) {
      viewState = ViewState.Error;
      return false;
    }

    _groupInfoEntity = entity.groups;

    List<QuestionItem> questionItemList = [];
    final List<String> questionIdList = [];
    final List<String> pointIdList = [];

    entity.groups.forEach(
      (e) {
        if (e.questionsItem != null && e.questionsItem.length > 0) {
          final List<QuestionItem> items =
              filterFunction != null ? filterFunction.call(e.questionsItem) : e.questionsItem;

          /// 看下需要过滤不
          questionItemList.addAll(items);

          /// 循环取 id
          items.forEach(
            (element) {
              final int typeId = int.parse(element.typeId);
              if (typeId == 23) {
                if (element.questionChildrenList != null && element.questionChildrenList.length > 0) {
                  element.questionChildrenList.forEach(
                    (c) {
                      questionIdList.add(c.id);
                    },
                  );
                }
              } else {
                questionIdList.add(element.id);
              }
              pointIdList.add(element.mpKnowledge);
            },
          );
        }
      },
    );

    if (questionIdList.length <= 0) {
      viewState = ViewState.Error;
      return false;
    }

    if (customFilterFunction != null) {
      /// 用于自定义循环过滤用的
      questionItemList = customFilterFunction.call(questionItemList);
    }

    /// 获取收藏接口
    final Map<String, dynamic> collectMap = await getCollectInfo(paperUuid);

    Map<String, dynamic> historyRecordMap;

    /// 全站正确率,易错项目
    if (needStatisticsInfo) {
      await getStatisticsInfo(paperUuid, questionIdList, examId);
    }

    /// 需要知道错了多少次
    if (needErrNumInfo) {
      await getErrNumInfo(paperUuid, examId);
    }

    /// 根据学生uid，试卷uuid获取历史的已做题记录
    if (needUserHistoryRecordInfo) {
      historyRecordMap = await getHistoryRecordInfo(uid, paperUuid, examId);
      if (userHistoryRecordFunction != null) {
        questionItemList = userHistoryRecordFunction.call(questionItemList, historyRecordMap);
      }
    }

    /// 考点接口
    if (needPointInfo) {
      await getExamPointInfo(pointIdList);
    }

    /// 来源接口
    if (needOriginInfo) {
      await getOriginInfo();
    }

    int i = 0;

    questionItemList.asMap().forEach(
      (key, value) {
        if (value.showIntroductionPage == true) {
          _collectionStatus.add(false);
          return;
        }

        _examQuestionIndex[key] = i;

        final int typeId = int.parse(value.typeId);

        if (typeId == 23) {
          if (value.questionChildrenList != null && value.questionChildrenList.length > 0) {
            value.questionChildrenList.forEach(
              (element) {
                _questionIdList[element.id] = key;
                _groupPageController[value.id] = new PageController();
                if (needUserHistoryRecordInfo && needProblemInfo) {
                  final List<String> userAnswer = [];
                  bool isAnswerTrue = false;
                  if (historyRecordMap != null && historyRecordMap["answers"] != null) {
                    if (historyRecordMap["answers"].containsKey(element.id)) {
                      isAnswerTrue = historyRecordMap["answers"][element.id]["isCorrect"].toString() == "1";
                      userAnswer.addAll(historyRecordMap["answers"][element.id]["userAnswer"].toString().split(","));
                      _problemStatus[element.id] =
                          historyRecordMap["answers"][element.id]["isAnyQuestions"].toString() == "1" ? 1 : 0;

                      if (showBeanTime) {
                        if (historyRecordMap["answers"][element.id]["usedTime"] != null &&
                            historyRecordMap["answers"][element.id]["usedTime"] != "") {
                          _questionTime[element.id] = double.tryParse(
                            historyRecordMap["answers"][element.id]["usedTime"].toString(),
                          );
                        }
                      }
                    } else {
                      _problemStatus[element.id] = 0;
                    }
                  } else {
                    _problemStatus[element.id] = 0;
                  }

                  if (showAnswerBean) {
                    _questAnswerMap[element.id] = QuestionAnswerBean(
                      isFinish: true,
                      isAnswerTrue: isAnswerTrue,
                      answer: userAnswer,
                    );
                  }
                }
                customQuestionItemFunction?.call(key, element, historyRecordMap);
              },
            );
          }
        } else {
          if (needUserHistoryRecordInfo && needProblemInfo) {
            final List<String> userAnswer = [];
            bool isAnswerTrue = false;
            if (historyRecordMap != null && historyRecordMap["answers"] != null) {
              if (historyRecordMap["answers"].containsKey(value.id)) {
                isAnswerTrue = historyRecordMap["answers"][value.id]["isCorrect"].toString() == "1";
                userAnswer.addAll(historyRecordMap["answers"][value.id]["userAnswer"].toString().split(","));

                _problemStatus[value.id] =
                    historyRecordMap["answers"][value.id]["isAnyQuestions"].toString() == "1" ? 1 : 0;

                if (showBeanTime) {
                  if (historyRecordMap["answers"][value.id]["usedTime"] != null &&
                      historyRecordMap["answers"][value.id]["usedTime"] != "") {
                    _questionTime[value.id] =
                        double.tryParse(historyRecordMap["answers"][value.id]["usedTime"].toString());
                  }
                }
              } else {
                _problemStatus[value.id] = 0;
              }
            } else {
              _problemStatus[value.id] = 0;
            }

            if (showAnswerBean) {
              _questAnswerMap[value.id] = QuestionAnswerBean(
                isFinish: true,
                isAnswerTrue: isAnswerTrue,
                answer: userAnswer,
              );
            }
          }
          customQuestionItemFunction?.call(key, value, historyRecordMap);
        }

        /// 题目index关系
        _questionIdList[value.id] = key;

        /// 是否收藏了
        if (collectMap != null && collectMap.containsKey(value.id)) {
          _collectionStatus.add(true);
          _collectIdMap[key] = collectMap[value.id];
        } else {
          _collectionStatus.add(false);
        }

        ++i;
      },
    );

    _groupInfoEntity.forEach(
      (element) => element.questionsItem.removeWhere(
        (element) => !_questionIdList.containsKey(element.id),
      ),
    );

    _questionItemIndex = 0;
    _questionItem = questionItemList;

    if (_collectionStatus.length > 0) {
      _isCollect = _collectionStatus.first;
    }

    viewState = ViewState.Idle;
    return true;
  }

  /// 提交试卷
  Future<String> submitPaperToServer(
    int type,
    String title,
    String subLibraryModuleId,
    String paperUuid,
    String examId,
    int userId,
    int redo,
    String subModuleId,
    String mode, {
    int param9,
    int memType,
  }) async {
    final Map<String, dynamic> answerMap = {};
    final int len = _questionItem.length;
    double seconds = 0;
    for (int i = 0; i < len; i++) {
      final QuestionItem questionItem = _questionItem[i];

      if (questionItem.showIntroductionPage == true) {
        continue;
      }

      /// 这个是不定项的
      if (questionItem.typeId == "23") {
        /// 里面题型比较多
        questionItem.questionChildrenList.asMap().forEach(
          (k, v) {
            final Map<String, dynamic> paperParamsMap = _paperParamsMap(type, v, i, k, redo);
            answerMap[v.id] = paperParamsMap;
            seconds += paperParamsMap["usedTime"];
          },
        );
        continue;
      } else {
        final Map<String, dynamic> paperParamsMap = _paperParamsMap(type, questionItem, i, 0, redo);
        answerMap[questionItem.id] = paperParamsMap;
        seconds += paperParamsMap["usedTime"];
      }
    }

    // return null;
    String examRecordId = "";

    if (_recordAnswerEntity != null && _recordAnswerEntity.examDetail != null) {
      examRecordId = _recordAnswerEntity.examDetail.examRecord.id;
    }

    return await ExaminationService.submitPaper(
      {
        "paperUuid": paperUuid,
        "uid": userId,
        "answersJson": jsonEncode(
          {
            "param1": _examInfoEntity.paper.param1,
            "param2": subLibraryModuleId,
            "param3": _examInfoEntity.paper.param3,
            "param4": _examInfoEntity.paper.param4,
            "param5": title,
            "param6": _examInfoEntity.paper.param6,
            "param7": _examInfoEntity.paper.param7,
            "param8": _questionItemIndex,
            "param9": param9,
            "param10": mode,
            "memType": memType,
            "uid": userId,
            "paperUuid": paperUuid,
            "examId": examId,
            "examRecordId": examRecordId,
            "totalExamTime": seconds.round(),
            "sublibraryId": subModuleId,
            "redo": redo,
            "answers": answerMap,
          },
        ),
      },
    );
  }

  /// 构建后台需要的参数字段
  Map<String, dynamic> _paperParamsMap(
    int type,
    QuestionItem questionItem,
    int pIndex,
    int childIndex,
    int redo,
  ) {
    Map<String, dynamic> paramsMap = {
      "typeId": questionItem.typeId,
      "userAnswer": "",
      "isCorrect": 0,
      "markStatus": 0,
      "score": "0",
      "usedTime": 0,
      "isAnyQuestions": _problemStatus[questionItem.id] == null ? 0 : _problemStatus[questionItem.id],
    };

    if (questionTime.containsKey(questionItem.id)) {
      paramsMap["usedTime"] = double.parse(questionTime[questionItem.id].toStringAsPrecision(2));
    }

    switch (questionItem.typeId) {

      /// 单选
      case "1":

      /// 多选
      case "2":
      case "7":

      /// 判断
      case "3":
        if (_questAnswerMap.containsKey(questionItem.id)) {
          final List<String> answerList = List.from(_questAnswerMap[questionItem.id].answer);
          answerList.sort((a, b) => a.compareTo(b));
          paramsMap["userAnswer"] = answerList.join(",");

          if (paramsMap["userAnswer"] == questionItem.answer) {
            paramsMap["isCorrect"] = 2;

            /// 计算分数
            if (type == 2) {
              paramsMap["score"] = questionItem.score;
            }
          }

          if (paperAnswerMap.containsKey(questionItem.id)) {
            paramsMap["recordDetailId"] = paperAnswerMap[questionItem.id].id;
          }
        } else {
          paramsMap["isCorrect"] = 3;
          if (paperAnswerMap.containsKey(questionItem.id)) {
            paramsMap["recordDetailId"] = paperAnswerMap[questionItem.id].id;
          }
        }
        break;
    }

    return paramsMap;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
