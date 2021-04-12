import 'dart:convert';

import 'package:question_bank/em/answer_situation_type.dart';
import 'package:question_bank/em/pager_type.dart';
import 'package:question_bank/em/question_type.dart';
import 'package:question_bank/model/data/paperEntity.dart';
import 'package:question_bank/model/data/report_card_entity.dart';
import 'package:question_bank/model/data/report_entity.dart';
import 'package:question_bank/model/service/report_service.dart';
import 'package:question_bank/provider/view_model/base_view_model.dart';

class ReportViewModel extends BaseViewModel {
  ReportViewModel(this.memType);

  final int memType;

  ///从练习过来还是从考试过来
  int pagerType;

  ///题目编号
  int questionNo = 0;

  ///不定项(组合题)选择题的id(大题id)
  List<String> uCerQuestionIds = [];

  ///存储不定项小题后缀
  Map<String, int> uCerSuffixMap = Map();

  ///做题记录
  ReportEntity _reportEntity;

  ReportEntity get reportEntity => _reportEntity;

  set reportEntity(ReportEntity value) {
    _reportEntity = value;
    notifyListeners();
  }

  ///学生练习或者试卷的详情
  PaperEntity paperAnswerEntity;

  ///练习报告跟考试报告的答题卡
  ReportCardEntity _reportCardEntity;

  ReportCardEntity get reportCardEntity => _reportCardEntity;

  set reportCardEntity(ReportCardEntity value) {
    _reportCardEntity = value;
    notifyListeners();
  }

  ///练习json信息
  String paperJsonString;

  ///错题id集合
  List<String> errorQuestionIdList = <String>[];

  ///题目id集合
  List<String> chooseQuestionIdList = <String>[];

  ///做题数据
  Map<String, QuestionsReport> paperDataMap2 = Map();

  ///获取答题报告和整理答题卡信息
  Future<bool> getReportInfos(String recordId, String paperUuid, String questionIds, {String examId}) async {
    reportEntity =
        await ReportService.getReportInfos(recordId, paperUuid, questionIds, examId: examId, memType: memType);

    if (reportEntity != null) {
      ///把错题id整理成List
      for (QuestionsReport questionsReport in reportEntity.questions) {
        paperDataMap2[questionsReport.questionId] = questionsReport;
        chooseQuestionIdList.add(questionsReport.questionId);
        if (questionsReport.isCorrect != 2 && questionsReport.userAnswer.isNotEmpty) {
          errorQuestionIdList.add(questionsReport.questionId);
        }
      }

      paperJsonString = await ReportService.getQuestionsGroupInfo(paperUuid);
      paperAnswerEntity = PaperEntity.fromJson(jsonDecode(paperJsonString));

      ///先把试卷的信息通过报告详情筛选出来,再把无用的题删除并排序
      screenAndSortPaperInfo();

      if (pagerType == PagerType.EXAM) {
        ///根据试卷的组来整理答题卡（组合题单独放到不定项这一个分类）(组合题的小题独立抽出来显示成'1-1  1-2这样')
        sortByPaperGroups2();
      } else if (pagerType == PagerType.PRACTICE) {
        ///根据题目类型来整理答题卡（组合题单独放到不定项这一个分类）(组合题的小题独立抽出来显示成'1-1  1-2这样')
        sortByPaperQuestionCategory2();
      }

      return true;
    }

    return false;
  }

  ///根据试卷的组来整理答题卡
  void sortByPaperGroups() {
    ReportCardEntity reportCard = ReportCardEntity();
    List<GroupsReport> reportCardGroups = [];
    for (GroupsAnswerCard groupAnswerCard in paperAnswerEntity.groups) {
      GroupsReport groups = GroupsReport();
      groups.name = groupAnswerCard.groupName;
      List<QuestionsReport> questionList = [];

      ///以试卷信息为标准筛选
      for (Questionss questions in groupAnswerCard.questions) {
        for (QuestionsReport questionsReport in reportEntity.questions) {
          ///如果有组合题
          if (questions.questionChildrenList != null &&
              questions.questionChildrenList.isNotEmpty &&
              questions.param11.contains(questionsReport.questionId)) {
            List<String> userAnswers = [];
            List<int> isCorrects = [];

            ///把组合题的小题筛出来，再做答题情况判断
            for (QuestionChildrenList questionItem in questions.questionChildrenList) {
              for (QuestionsReport questionsReport in reportEntity.questions) {
                if (questionItem.id == questionsReport.questionId) {
                  userAnswers.add(questionsReport.userAnswer);
                  isCorrects.add(questionsReport.isCorrect);
                }
              }
            }

            ///判断几个小题的答题情况总结出此道组合题的答题情况
            AnswerSituationType situationType;
            bool answer = false;
            bool right = true;
            for (String answers in userAnswers) {
              if (answers.isNotEmpty) {
                answer = true;
              }
            }
            for (int corrects in isCorrects) {
              if (corrects != 2) {
                right = false;
              }
            }
            if (!answer) {
              situationType = AnswerSituationType.UN_ANSWER;
              questionsReport.userAnswer = '';
              questionsReport.isCorrect = 0;
            } else if (right) {
              situationType = AnswerSituationType.RIGHT_ANSWER;
              questionsReport.userAnswer = '1';
              questionsReport.isCorrect = 2;
            } else {
              situationType = AnswerSituationType.WRONG_ANSWER;
              questionsReport.userAnswer = '1';
              questionsReport.isCorrect = 0;
            }

            questionList.add(questionsReport);
            break;
          } else {
            if (questionsReport.questionId == questions.id) {
              questionList.add(questionsReport);
              break;
            }
          }
        }
      }
      groups.questionList = questionList;
      reportCardGroups.add(groups);
    }
    reportCard.groups = reportCardGroups;
    reportCardEntity = reportCard;
  }

  ///根据试卷的组来整理答题卡（组合题单独放到不定项这一个分类）(组合题的小题独立抽出来显示成'1-1  1-2这样')
  void sortByPaperGroups2() {
    ReportCardEntity reportCard = ReportCardEntity();
    List<GroupsReport> reportCardGroups = [];
    // paperAnswerEntity.groups.sort((a, b) => a.id.compareTo(b.id));
    for (GroupsAnswerCard groupAnswerCard in paperAnswerEntity.groups) {
      GroupsReport groups = GroupsReport();
      groups.name = groupAnswerCard.groupName;
      List<QuestionsReport> questionList = [];

      ///以试卷信息为标准筛选
      groupAnswerCard.questions.sort((a, b) => a.id.compareTo(b.id));

      for (Questionss questions in groupAnswerCard.questions) {
        for (QuestionsReport questionsReport in reportEntity.questions) {
          ///如果有组合题
          if (questions.questionChildrenList != null && questions.questionChildrenList.isNotEmpty) {
            uCerQuestionIds.add(questions.id);
            uCerSuffixMap[questions.id] = 1;

            ///把组合题的小题筛出来，再做答题情况判断
            questions.questionChildrenList.sort((a, b) => a.id.compareTo(b.id));
            for (QuestionChildrenList questionItem in questions.questionChildrenList) {
              for (QuestionsReport questionsReport in reportEntity.questions) {
                if (questionItem.id == questionsReport.questionId) {
                  questionsReport.extendId = questions.id;
                  questionList.add(questionsReport);
                }
              }
            }
            break;
          } else {
            if (questionsReport.questionId == questions.id) {
              questionList.add(questionsReport);
              break;
            }
          }
        }
      }
      calculateShowNo2(questionList);
      groups.questionList = questionList;
      reportCardGroups.add(groups);
    }
    reportCard.groups = reportCardGroups;
    reportCardEntity = reportCard;
  }

  ///根据题目类型来整理答题卡（组合题单独放到不定项这一个分类）(组合题的小题不独立抽出来)
  void sortByPaperQuestionCategory() {
    ReportCardEntity reportCard = ReportCardEntity();
    List<GroupsReport> reportCardGroups = [];

    GroupsReport singleGroups = GroupsReport();
    singleGroups.name = '单选题';
    List<QuestionsReport> singleQuestionList = [];

    GroupsReport multiGroups = GroupsReport();
    multiGroups.name = '多选题';
    List<QuestionsReport> multiQuestionList = [];

    GroupsReport judgeGroups = GroupsReport();
    judgeGroups.name = '判断题';
    List<QuestionsReport> judgeQuestionList = [];

    GroupsReport unCerGroups = GroupsReport();
    unCerGroups.name = '不定项选择题';
    List<QuestionsReport> unCerQuestionList = [];

    for (GroupsAnswerCard groupAnswerCard in paperAnswerEntity.groups) {
      ///以试卷信息为标准筛选
      for (Questionss questions in groupAnswerCard.questions) {
        for (QuestionsReport questionsReport in reportEntity.questions) {
          ///如果有组合题
          if (questions.questionChildrenList != null &&
              questions.questionChildrenList.isNotEmpty &&
              questions.param11.contains(questionsReport.questionId)) {
            List<String> userAnswers = [];
            List<int> isCorrects = [];

            ///把组合题的小题筛出来，再做答题情况判断
            for (QuestionChildrenList questionItem in questions.questionChildrenList) {
              for (QuestionsReport questionsReport in reportEntity.questions) {
                if (questionItem.id == questionsReport.questionId) {
                  userAnswers.add(questionsReport.userAnswer);
                  isCorrects.add(questionsReport.isCorrect);
                }
              }
            }

            ///判断几个小题的答题情况总结出此道组合题的答题情况
            AnswerSituationType situationType;
            bool answer = false;
            bool right = true;
            for (String answers in userAnswers) {
              if (answers.isNotEmpty) {
                answer = true;
              }
            }
            for (int corrects in isCorrects) {
              if (corrects != 2) {
                right = false;
              }
            }
            if (!answer) {
              situationType = AnswerSituationType.UN_ANSWER;
              questionsReport.userAnswer = '';
              questionsReport.isCorrect = 0;
            } else if (right) {
              situationType = AnswerSituationType.RIGHT_ANSWER;
              questionsReport.userAnswer = '1';
              questionsReport.isCorrect = 2;
            } else {
              situationType = AnswerSituationType.WRONG_ANSWER;
              questionsReport.userAnswer = '1';
              questionsReport.isCorrect = 0;
            }

            unCerQuestionList.add(questionsReport);
            break;
          } else {
            if (questionsReport.questionId == questions.id) {
              if (questionsReport.questionTypeId == QuestionType.SINGLE_CHOICE) {
                singleQuestionList.add(questionsReport);
              } else if (questionsReport.questionTypeId == QuestionType.MULTI_CHOICE) {
                multiQuestionList.add(questionsReport);
              } else if (questionsReport.questionTypeId == QuestionType.JUDGEMENT) {
                judgeQuestionList.add(questionsReport);
              } else if (questionsReport.questionTypeId == QuestionType.UNCERTAINTY_CHOICE) {
                unCerQuestionList.add(questionsReport);
              }
              break;
            }
          }
        }
      }
    }
    if (singleQuestionList.isNotEmpty) {
      singleGroups.questionList = singleQuestionList;
      reportCardGroups.add(singleGroups);
    }
    if (multiQuestionList.isNotEmpty) {
      multiGroups.questionList = multiQuestionList;
      reportCardGroups.add(multiGroups);
    }
    if (judgeQuestionList.isNotEmpty) {
      judgeGroups.questionList = judgeQuestionList;
      reportCardGroups.add(judgeGroups);
    }
    if (unCerQuestionList.isNotEmpty) {
      unCerGroups.questionList = unCerQuestionList;
      reportCardGroups.add(unCerGroups);
    }
    reportCard.groups = reportCardGroups;
    reportCardEntity = reportCard;
  }

  ///根据题目类型来整理答题卡（组合题单独放到不定项这一个分类）(组合题的小题独立抽出来显示成'1-1  1-2这样')
  void sortByPaperQuestionCategory2() {
    ReportCardEntity reportCard = ReportCardEntity();
    List<GroupsReport> reportCardGroups = [];

    GroupsReport singleGroups = GroupsReport();
    singleGroups.name = '单选题';
    List<QuestionsReport> singleQuestionList = [];

    GroupsReport judgeGroups = GroupsReport();
    judgeGroups.name = '判断题';
    List<QuestionsReport> judgeQuestionList = [];

    GroupsReport multiGroups = GroupsReport();
    multiGroups.name = '多选题';
    List<QuestionsReport> multiQuestionList = [];

    GroupsReport unCerGroups = GroupsReport();
    unCerGroups.name = '不定项选择题';
    List<QuestionsReport> unCerQuestionList = [];

    for (GroupsAnswerCard groupAnswerCard in paperAnswerEntity.groups) {
      ///以试卷信息为标准筛选
      for (Questionss questions in groupAnswerCard.questions) {
        for (QuestionsReport questionsReport in reportEntity.questions) {
          ///如果有组合题
          if (questions.questionChildrenList != null &&
              questions.questionChildrenList.isNotEmpty &&
              questions.param11.contains(questionsReport.questionId)) {
            uCerQuestionIds.add(questions.id);
            uCerSuffixMap[questions.id] = 1;

            ///把组合题的小题筛出来，再做答题情况判断
            for (QuestionChildrenList questionItem in questions.questionChildrenList) {
              for (QuestionsReport questionsReport in reportEntity.questions) {
                if (questionItem.id == questionsReport.questionId) {
                  questionsReport.extendId = questions.id;
                  unCerQuestionList.add(questionsReport);
                  if (!reportCardGroups.contains(unCerGroups)) {
                    reportCardGroups.add(unCerGroups);
                  }
                }
              }
            }
            break;
          } else {
            if (questionsReport.questionId == questions.id) {
              if (questionsReport.questionTypeId == QuestionType.SINGLE_CHOICE) {
                singleQuestionList.add(questionsReport);
                if (!reportCardGroups.contains(singleGroups)) {
                  reportCardGroups.add(singleGroups);
                }
              } else if (questionsReport.questionTypeId == QuestionType.JUDGEMENT) {
                judgeQuestionList.add(questionsReport);
                if (!reportCardGroups.contains(judgeGroups)) {
                  reportCardGroups.add(judgeGroups);
                }
              } else if (questionsReport.questionTypeId == QuestionType.MULTI_CHOICE) {
                multiQuestionList.add(questionsReport);
                if (!reportCardGroups.contains(multiGroups)) {
                  reportCardGroups.add(multiGroups);
                }
              } else if (questionsReport.questionTypeId == QuestionType.UNCERTAINTY_CHOICE) {
                unCerQuestionList.add(questionsReport);
                uCerQuestionIds.add(questionsReport.questionId);
                uCerSuffixMap[questionsReport.questionId] = 1;
                if (!reportCardGroups.contains(unCerGroups)) {
                  reportCardGroups.add(unCerGroups);
                }
              }
              break;
            }
          }
        }
      }
    }
    if (singleQuestionList.isNotEmpty) {
      singleQuestionList.sort((a, b) => a.questionId.compareTo(b.questionId));
      singleGroups.questionList = singleQuestionList;
    }
    if (multiQuestionList.isNotEmpty) {
      multiQuestionList.sort((a, b) => a.questionId.compareTo(b.questionId));
      multiGroups.questionList = multiQuestionList;
    }
    if (judgeQuestionList.isNotEmpty) {
      judgeQuestionList.sort((a, b) => a.questionId.compareTo(b.questionId));
      judgeGroups.questionList = judgeQuestionList;
    }
    if (unCerQuestionList.isNotEmpty) {
      unCerQuestionList.sort((a, b) => a.questionId.compareTo(b.questionId));
      unCerGroups.questionList = unCerQuestionList;
    }
    reportCard.groups = reportCardGroups;
    for (GroupsReport groupsReport in reportCard.groups) {
      calculateShowNo(groupsReport.questionList);
    }
    reportCardEntity = reportCard;
  }

  ///计算要显示的答题卡No(练习专用)
  void calculateShowNo(List<QuestionsReport> singleQuestionList) {
    for (QuestionsReport questionsReport in singleQuestionList) {
      String suffix = '';
      if (questionsReport.extendId.isNotEmpty) {
        suffix = '${uCerSuffixMap[questionsReport.extendId]}';
        if (uCerSuffixMap[questionsReport.extendId] == 1) {
          questionNo += 1;
        }
        questionsReport.showNo = '${(questionNo).toString()}-$suffix';
        uCerSuffixMap[questionsReport.extendId] = uCerSuffixMap[questionsReport.extendId] + 1;
      } else {
        questionsReport.showNo = '${(++questionNo).toString()}';
      }
    }
  }

  List<String> extendIds = [];

  ///计算要显示的答题卡No(考试专用)
  void calculateShowNo2(List<QuestionsReport> singleQuestionList) {
    for (QuestionsReport questionsReport in singleQuestionList) {
      String suffix = '';
      if (questionsReport.extendId.isNotEmpty) {
        suffix = '${uCerSuffixMap[questionsReport.extendId]}';
        uCerSuffixMap[questionsReport.extendId] = uCerSuffixMap[questionsReport.extendId] + 1;
        if (!extendIds.contains(questionsReport.extendId)) {
          questionNo += 1;
          extendIds.add(questionsReport.extendId);
        }
        questionsReport.showNo = '${questionNo.toString()}-$suffix';
      } else {
        questionsReport.showNo = '${(++questionNo).toString()}';
      }
    }
  }

  ///先把试卷的信息通过报告详情筛选出来,再把无用的题删除并排序
  void screenAndSortPaperInfo() {
    ///先把试卷的信息通过报告详情筛选出来
    for (GroupsAnswerCard groupAnswerCard in paperAnswerEntity.groups) {
      ///是否有抽题的小题
      bool hasChild = false;
      for (Questionss questionss in groupAnswerCard.questions) {
        ///是否保留该小题
        bool keepChild = false;

        for (QuestionChildrenList questionChildrenList in questionss.questionChildrenList) {
          for (QuestionsReport questionsReport in reportEntity.questions) {
            if (questionChildrenList.id == questionsReport.questionId) {
              hasChild = true;
              keepChild = true;
            }
          }
          if (!keepChild) {
            questionChildrenList.keep = false;
          }
        }

        if (!hasChild) {
          ///是否有该大题
          bool hasBig = false;
          for (QuestionsReport questionsReport in reportEntity.questions) {
            if (questionss.id == questionsReport.questionId) {
              hasBig = true;
            }
          }
          if (!hasBig) {
            questionss.keep = false;
          }
        }
      }
    }

    ///把无用的题删除并排序
    for (GroupsAnswerCard groupAnswerCard in paperAnswerEntity.groups) {
      groupAnswerCard.questions.removeWhere((element) => element.keep == false);
      groupAnswerCard.questions.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
      if (groupAnswerCard.questions.isNotEmpty) {
        for (Questionss questionss in groupAnswerCard.questions) {
          questionss.questionChildrenList.removeWhere((element) => element.keep == false);
          questionss.questionChildrenList.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
        }
      }
    }
  }

  ///获取完进度百分比
  double getPercent(double doneNum, double totalNum) {
    if (doneNum == null || totalNum == null || doneNum == 0 || totalNum == 0) {
      return 0;
    }
    double percent = doneNum / totalNum;
    if (percent < 0) {
      return 0;
    }
    if (percent > 1) {
      return 1;
    }
    return percent;
  }

  ///整理计算答题卡数据（用于答题分布）
  ReportCardEntity arrangeCardEntity(ReportCardEntity cardEntity) {
    if (cardEntity == null || cardEntity.groups == null || cardEntity.groups.isEmpty) {
      return null;
    }
    for (GroupsReport groupReport in cardEntity.groups) {
      int total = 0;
      int right = 0;
      double score = 0;
      for (QuestionsReport questionsReport in groupReport.questionList) {
        total += 1;
        if (questionsReport.isCorrect != 0 &&
            questionsReport.userAnswer != null &&
            questionsReport.userAnswer.isNotEmpty) {
          right += 1;
        }
        if (questionsReport.score != null && questionsReport.score != 0) {
          score += questionsReport.score;
          print('score:$score');
        }
      }
      groupReport.rightCount = right;
      groupReport.totalCount = total;
      groupReport.score = score;
    }
    return cardEntity;
  }

  ///整理计算答题卡数据（把错题筛选出来）
  ReportCardEntity arrangeCardEntity2(ReportCardEntity cardEntity) {
    if (cardEntity == null || cardEntity.groups == null || cardEntity.groups.isEmpty) {
      return null;
    }
    ReportCardEntity arrangeCardEntity = ReportCardEntity();
    List<GroupsReport> groups = [];
    for (GroupsReport groupReport in cardEntity.groups) {
      GroupsReport arrangeGroupReport = GroupsReport();
      List<QuestionsReport> arrangeQuestionReport = [];
      for (QuestionsReport questionsReport in groupReport.questionList) {
        if (questionsReport.userAnswer != null &&
            questionsReport.userAnswer.isNotEmpty &&
            questionsReport.isCorrect == 0) {
          arrangeQuestionReport.add(questionsReport);
        }
      }
      arrangeGroupReport.name = groupReport.name;
      arrangeGroupReport.questionList = arrangeQuestionReport;
      groups.add(arrangeGroupReport);
    }
    arrangeCardEntity.groups = groups;
    return arrangeCardEntity;
  }

  ///用时
  String useTime(double seconds) {
    if (seconds < 60 && seconds >= 0) {
      return '$seconds秒';
    } else {
      if (seconds % 60 > 0) {
        return '${seconds ~/ 60}分${seconds % 60}秒';
      } else {
        return '${seconds ~/ 60}分';
      }
    }
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
