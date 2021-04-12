/// groupId : 754
/// count : 0

///
/// 某试卷的已做题数
///
class ExamTopicFinishNumberEntity {
  int _groupId;
  /// 已做题数
  int _count;

  int get groupId => _groupId;
  int get count => _count;

  ExamTopicFinishNumberEntity({
      int groupId, 
      int count}){
    _groupId = groupId;
    _count = count;
}

  ExamTopicFinishNumberEntity.fromJson(dynamic json) {
    _groupId = json["groupId"];
    _count = json["count"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["groupId"] = _groupId;
    map["count"] = _count;
    return map;
  }

}