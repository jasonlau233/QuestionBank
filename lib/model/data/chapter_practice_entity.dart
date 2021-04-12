/// courseId : 1
/// chapterDTOList : [{"id":"ut non reprehenderit mollit","name":"dolor aute","sort":null,"sectionDTOList":[{"id":-77270444.14362432,"name":"exercitation aute","sort":null,"finishNumber":1,"allNumber":1,"coreId":1}],"successRate":0.5}]

class ChapterPracticeEntity {
  int _courseId;
  List<ChapterDTOList> _chapterDTOList;

  int get courseId => _courseId;
  List<ChapterDTOList> get chapterDTOList => _chapterDTOList;

  ChapterPracticeEntity({int courseId, List<ChapterDTOList> chapterDTOList}) {
    _courseId = courseId;
    _chapterDTOList = chapterDTOList;
  }

  ChapterPracticeEntity.fromJson(dynamic json) {
    _courseId = json["courseId"];
    if (json["chapterDTOList"] != null) {
      _chapterDTOList = [];
      json["chapterDTOList"].forEach((v) {
        _chapterDTOList.add(ChapterDTOList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["courseId"] = _courseId;
    if (_chapterDTOList != null) {
      map["chapterDTOList"] = _chapterDTOList.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "ut non reprehenderit mollit"
/// name : "dolor aute"
/// sort : null
/// sectionDTOList : [{"id":-77270444.14362432,"name":"exercitation aute","sort":null,"finishNumber":1,"allNumber":1,"coreId":1}]
/// successRate : 0.5

class ChapterDTOList {
  int _id;
  String _name;
  int _sort;
  List<SectionDTOList> _sectionDTOList;
  double _successRate;

  int _finishNumber;
  int _doneNumber;
  int _allNumber;
  int get finishNumber => _finishNumber;
  int get allNumber => _allNumber;

  int get id => _id;
  String get name => _name;
  int get doneNumber => _doneNumber;
  int get sort => _sort;
  List<SectionDTOList> get sectionDTOList => _sectionDTOList;
  double get successRate => _successRate;

  ChapterDTOList({
    int id,
    String name,
    dynamic sort,
    List<SectionDTOList> sectionDTOList,
    double successRate,
    int finishNumber,
    int doneNumber,
    int allNumber,
  }) {
    _id = id;
    _name = name;
    _sort = sort;
    _sectionDTOList = sectionDTOList;
    _successRate = successRate;
    _finishNumber = finishNumber;
    _allNumber = allNumber;
    _doneNumber = doneNumber;
  }

  ChapterDTOList.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _sort = json["sort"];
    if (json["sectionDTOList"] != null) {
      _sectionDTOList = [];
      json["sectionDTOList"].forEach((v) {
        _sectionDTOList.add(SectionDTOList.fromJson(v));
      });
    }
    _finishNumber = json["finishNumber"];
    _doneNumber = json["doneNumber"];
    _allNumber = json["allNumber"];
    _successRate = json["successRate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["sort"] = _sort;
    map["finishNumber"] = _finishNumber;
    map["allNumber"] = _allNumber;
    map["doneNumber"] = _doneNumber;
    if (_sectionDTOList != null) {
      map["sectionDTOList"] = _sectionDTOList.map((v) => v.toJson()).toList();
    }
    map["successRate"] = _successRate;
    return map;
  }
}

/// id : -77270444.14362432
/// name : "exercitation aute"
/// sort : null
/// finishNumber : 1
/// allNumber : 1
/// coreId : 1

class SectionDTOList {
  int _id;
  String _subLibraryModuleId;
  String _name;
  int _doneNumber;
  int _sort;
  int _finishNumber;
  int _allNumber;
  int _coreId;
  String _paperUuid;

  /// 0没有 1是有
  int _status;
  int get finishNumber => _finishNumber;
  int get doneNumber => _doneNumber;
  int get allNumber => _allNumber;
  int get id => _id;
  String get subLibraryModuleId => _subLibraryModuleId;
  String get name => _name;
  String get paperUuid => _paperUuid;
  int get status => _status;
  int get sort => _sort;
  int get coreId => _coreId;

  SectionDTOList({
    int id,
    String name,
    int sort,
    int finishNumber,
    int doneNumber,
    int allNumber,
    int coreId,
    String paperUuid,
    String subLibraryModuleId,
  }) {
    _id = id;
    _subLibraryModuleId = subLibraryModuleId;
    _name = name;
    _sort = sort;
    _finishNumber = finishNumber;
    _allNumber = allNumber;
    _doneNumber = doneNumber;
    _coreId = coreId;
    _paperUuid = paperUuid;
  }

  SectionDTOList.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _subLibraryModuleId = json["sublibraryModuleId"];
    _sort = json["sort"];
    _finishNumber = json["finishNumber"];
    _allNumber = json["allNumber"];
    _doneNumber = json["doneNumber"];
    _coreId = json["coreId"];
    _paperUuid = json["paperUuid"];
    _status = json["status"] ?? 0;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["sort"] = _sort;
    map["subLibraryModuleId"] = _subLibraryModuleId;
    map["finishNumber"] = _finishNumber;
    map["allNumber"] = _allNumber;
    map["coreId"] = _coreId;
    map["paperUuid"] = _paperUuid;
    map["status"] = _status;
    return map;
  }
}
