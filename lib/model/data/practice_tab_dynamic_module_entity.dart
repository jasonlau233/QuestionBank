/// id : 1
/// type : ""

/// 动态模块
class PracticeTabDynamicModuleEntity {
  int _id;

  /// 类型
  String _type;

  int get id => _id;
  String get type => _type;

  PracticeTabDynamicModuleEntity({int id, String type}) {
    _id = id;
    _type = type;
  }

  PracticeTabDynamicModuleEntity.fromJson(dynamic json) {
    _id = json["id"];
    _type = json["type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["type"] = _type;
    return map;
  }
}
