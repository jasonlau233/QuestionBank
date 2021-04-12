class StorageQuestionSettingsInfoEntity {
  /// 选中的做题模式 0做题 1背题
  int _mode;

  /// 做题模式数量
  int _numMode;

  /// 出题范围
  int _scope;

  int get mode => _mode;
  int get numMode => _numMode;
  int get scope => _scope;

  StorageQuestionSettingsInfoEntity({int mode, int numMode, int scope}) {
    _mode = mode;
    _numMode = numMode;
    _scope = scope;
  }

  StorageQuestionSettingsInfoEntity.fromJson(dynamic json) {
    _mode = json["mode"];
    _numMode = json["numMode"];
    _scope = json["scope"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["mode"] = _mode;
    map["numMode"] = _numMode;
    map["scope"] = _scope;
    return map;
  }

  StorageQuestionSettingsInfoEntity copyWith({int mode, int numMode, int scope}) {
    return StorageQuestionSettingsInfoEntity(
      mode: mode ?? _mode,
      numMode: numMode ?? _numMode,
      scope: scope ?? _scope,
    );
  }
}
