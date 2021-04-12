/// id : 1
/// kmcode : ""
/// proId : 1
/// name : ""
/// courseId : ""
/// labelId : 1

class PracticeTabEntity {
  /// ID
  int _id;
  String _kmcode;

  /// 产品线
  int _proId;

  /// 标题
  String _name;

  /// 课程id
  int _courseId;

  int _labelId;

  int get id => _id;
  String get kmcode => _kmcode;
  int get proId => _proId;
  String get name => _name;
  int get courseId => _courseId;
  int get labelId => _labelId;

  PracticeTabEntity({int id, String kmcode, int proId, String name, int courseId, int labelId}) {
    _id = id;
    _kmcode = kmcode;
    _proId = proId;
    _name = name;
    _courseId = courseId;
    _labelId = labelId;
  }

  PracticeTabEntity.fromJson(dynamic json) {
    _id = json["id"];
    _kmcode = json["kmcode"];
    _proId = json["proId"];
    _name = json["name"];
    _courseId = json["courseId"];
    _labelId = json["labelId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["kmcode"] = _kmcode;
    map["proId"] = _proId;
    map["name"] = _name;
    map["courseId"] = _courseId;
    map["labelId"] = _labelId;
    return map;
  }
}
