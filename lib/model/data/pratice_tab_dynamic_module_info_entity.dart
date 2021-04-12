import 'chapter_practice_entity.dart';

/// appContentMaps : {"IndexModule":[{"name":"","content":"","juniorType":"1"}],"BannerList":[{"content":""}]}

class PracticeTabDynamicModuleInfoEntity {
  List<IndexModule> _indexModule;
  List<BannerList> _bannerList;

  List<IndexModule> get indexModule => _indexModule;
  List<BannerList> get bannerList => _bannerList;

  ChapterPracticeEntity _practice;
  ChapterPracticeEntity get practice => _practice;

  PracticeTabDynamicModuleInfoEntity(
      {List<IndexModule> indexModule, List<BannerList> bannerList, ChapterPracticeEntity practice}) {
    _indexModule = indexModule;
    _bannerList = bannerList;
    _practice = practice;
  }

  PracticeTabDynamicModuleInfoEntity.fromJson(dynamic json) {
    if (json["INDEX_MODULE"] != null) {
      _indexModule = [];
      json["INDEX_MODULE"].forEach((v) {
        _indexModule.add(IndexModule.fromJson(v));
      });
    }
    if (json["BANNER"] != null) {
      _bannerList = [];
      json["BANNER"].forEach((v) {
        _bannerList.add(BannerList.fromJson(v));
      });
    }

    if (json["practice"] != null) {
      _practice = practice;
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_indexModule != null) {
      map["IndexModule"] = _indexModule.map((v) => v.toJson()).toList();
    }
    if (_bannerList != null) {
      map["BannerList"] = _bannerList.map((v) => v.toJson()).toList();
    }
    return map;
  }

  PracticeTabDynamicModuleInfoEntity copyWith(
      {List<IndexModule> indexModule, List<BannerList> bannerList, ChapterPracticeEntity practice}) {
    return PracticeTabDynamicModuleInfoEntity(
        indexModule: indexModule ?? _indexModule,
        bannerList: bannerList ?? _bannerList,
        practice: practice ?? _practice);
  }
}

/// IndexModule : [{"name":"","content":"","juniorType":"1"}]
/// BannerList : [{"content":""}]
/// content : ""

class BannerList {
  /// 地址
  String _content;

  String get content => _content;

  BannerList({String content}) {
    _content = content;
  }

  BannerList.fromJson(dynamic json) {
    _content = json["content"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["content"] = _content;
    return map;
  }
}

/// name : ""
/// content : ""
/// juniorType : "1"

class IndexModule {
  /// 名字
  String _name;

  /// 地址
  String _content;

  /// 类型
  String _juniorType;

  /// moduleId
  int _subLibraryModuleId;
  int get subLibraryModuleId => _subLibraryModuleId;
  String get name => _name;
  String get content => _content;
  String get juniorType => _juniorType;

  IndexModule({String name, String content, String juniorType}) {
    _name = name;
    _content = content;
    _juniorType = juniorType;
  }

  IndexModule.fromJson(dynamic json) {
    _name = json["name"];
    _content = json["content"];
    _juniorType = json["juniorType"];
    _subLibraryModuleId = json["sublibraryModuleId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["content"] = _content;
    map["juniorType"] = _juniorType;
    return map;
  }
}
