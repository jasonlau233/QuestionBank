import 'package:question_bank/model/data/report_entity.dart';

///练习报告跟考试报告的答题卡
class ReportCardEntity {
  List<GroupsReport> groups;

  @override
  String toString() {
    return 'ReportCardEntity{groups: $groups}';
  }
}

class GroupsReport {
  ///组名
  String name;

  ///该组做对的题目数量
  int rightCount = 0;

  ///该组的题目数量
  int totalCount = 0;

  ///得分
  double score = 0.0;

  List<QuestionsReport> questionList;

  @override
  String toString() {
    return 'GroupsReport{name: $name, rightCount: $rightCount, totalCount: $totalCount, score: $score, questionList: $questionList}';
  }
}
