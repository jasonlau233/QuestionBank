///按来源筛选的模块
class FilterModuleEntity {
  int updateBy;
  int sublibraryId;
  int id;
  String name;
  String type;
  String status;
  String createTime;
  int createBy;
  String updateTime;
  String code;
  String number;

  FilterModuleEntity(
      {this.updateBy,
      this.sublibraryId,
      this.id,
      this.name,
      this.type,
      this.status,
      this.createTime,
      this.createBy,
      this.updateTime,
      this.code,
      this.number});

  FilterModuleEntity.fromJson(dynamic json) {
    updateBy = json["updateBy"];
    sublibraryId = json["sublibraryId"];
    id = json["id"];
    name = json["name"];
    type = json["type"];
    status = json["status"];
    createTime = json["createTime"];
    createBy = json["createBy"];
    updateTime = json["updateTime"];
    code = json["code"];
    number = json["number"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["updateBy"] = updateBy;
    map["sublibraryId"] = sublibraryId;
    map["id"] = id;
    map["name"] = name;
    map["type"] = type;
    map["status"] = status;
    map["createTime"] = createTime;
    map["createBy"] = createBy;
    map["updateTime"] = updateTime;
    map["code"] = code;
    map["number"] = number;
    return map;
  }
}
