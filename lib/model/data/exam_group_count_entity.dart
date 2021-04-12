/// paperUuid : "c16ddbcf55f14b7ea5313d5df5327785"
/// groupName : "一、单项选择题#@#（本类题共24小题，每小题1.5分，共36分。每小题备选答案中，只有一个符合题意的正确答案。多选、错选、不选均不得分。请使用计算机鼠标在计算机答题界面上点击试题答案备选项前的按钮“○”作答。）"
/// groupCount : 24
/// sort : 1

///
/// 试卷说明选择
///
class ExamGroupCountEntity {
  String _paperUuid;
  String _groupName;
  int _groupCount;
  int _sort;
  int _groupId;


  /// 自定义字段 已做题数
  int finishNumber;

  String get paperUuid => _paperUuid;

  String get groupName => _groupName;

  int get groupCount => _groupCount;

  int get sort => _sort;
  int get groupId => _groupId;

  ExamGroupCountEntity(
      {String paperUuid, String groupName, int groupCount, int sort,int groupId}) {
    _paperUuid = paperUuid;
    _groupName = groupName;
    _groupCount = groupCount;
    _sort = sort;
    _groupId = groupId;
  }

  ExamGroupCountEntity.fromJson(dynamic json) {
    _paperUuid = json["paperUuid"];
    _groupName = json["groupName"];
    _groupCount = json["groupCount"];
    _sort = json["sort"];
    _groupId = json["groupId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["paperUuid"] = _paperUuid;
    map["groupName"] = _groupName;
    map["groupCount"] = _groupCount;
    map["sort"] = _sort;
    map["groupId"] = _groupId;
    return map;
  }
}
