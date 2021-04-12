class ServerResponseEntity {
  int _code;
  String _msg;
  dynamic _data;

  int get code => _code;
  String get msg => _msg;
  dynamic get data => _data;

  ServerResponseEntity({
    int code,
    String msg,
    dynamic data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  ServerResponseEntity.fromJson(dynamic json) {
    _code = int.parse(json["code"].toString());
    _msg = json["msg"] ?? json["message"];
    _data = json["data"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["msg"] = _msg;
    map["data"] = _data;
    return map;
  }
}
