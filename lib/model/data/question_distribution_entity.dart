///题目类型分布
class AppQuestionIdAndCountDtos {
  ///题目类型id
  int questionTypeId;

  ///该类型题目数量
  int count;

  AppQuestionIdAndCountDtos({this.questionTypeId, this.count});

  AppQuestionIdAndCountDtos.fromJson(dynamic json) {
    questionTypeId = json["questionTypeId"];
    count = json["count"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["questionTypeId"] = questionTypeId;
    map["count"] = count;
    return map;
  }
}
