///收藏按来源的题目
class CollectAccordChapterEntity {
  List<AppCollectionChapterList> appCollectionChapterList;

  CollectAccordChapterEntity({this.appCollectionChapterList});

  CollectAccordChapterEntity.fromJson(dynamic json) {
    if (json["appCollectionChapterList"] != null) {
      appCollectionChapterList = [];
      json["appCollectionChapterList"].forEach((v) {
        appCollectionChapterList.add(AppCollectionChapterList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (appCollectionChapterList != null) {
      map["appCollectionChapterList"] =
          appCollectionChapterList.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AppCollectionChapterList {
  int id;
  String name;
  int sort;
  int allNumber;
  int collectionNumbers;
  List<SectionList> sectionList;

  AppCollectionChapterList(
      {this.id,
      this.name,
      this.sort,
      this.allNumber,
      this.collectionNumbers,
      this.sectionList});

  AppCollectionChapterList.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    sort = json["sort"];
    allNumber = json["allNumber"];
    collectionNumbers = json["collectionNumbers"];
    if (json["sectionList"] != null) {
      sectionList = [];
      json["sectionList"].forEach((v) {
        sectionList.add(SectionList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["sort"] = sort;
    map["allNumber"] = allNumber;
    map["collectionNumbers"] = collectionNumbers;
    if (sectionList != null) {
      map["sectionList"] = sectionList.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SectionList {
  int id;
  String name;
  int sort;
  int allNumbers;
  int collectionNumbers;
  String paperUuid;
  int subModuleId;
  List<QuestionIdAndCollectionIds> questionIdAndCollectionIds;

  SectionList(
      {this.id,
      this.name,
      this.sort,
      this.allNumbers,
      this.collectionNumbers,
      this.paperUuid,
      this.questionIdAndCollectionIds,
      this.subModuleId});

  SectionList.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    sort = json["sort"];
    allNumbers = json["allNumbers"];
    collectionNumbers = json["collectionNumbers"];
    paperUuid = json["paperUuid"];
    subModuleId = json["subModuleId"];
    if (json["questionIdAndCollectionIds"] != null) {
      questionIdAndCollectionIds = [];
      json["questionIdAndCollectionIds"].forEach((v) {
        questionIdAndCollectionIds.add(QuestionIdAndCollectionIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["sort"] = sort;
    map["allNumbers"] = allNumbers;
    map["collectionNumbers"] = collectionNumbers;
    map["paperUuid"] = paperUuid;
    map["subModuleId"] = subModuleId;
    if (questionIdAndCollectionIds != null) {
      map["questionIdAndCollectionIds"] =
          questionIdAndCollectionIds.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class QuestionIdAndCollectionIds {
  String questionId;
  String collectionId;

  QuestionIdAndCollectionIds({this.questionId, this.collectionId});

  QuestionIdAndCollectionIds.fromJson(dynamic json) {
    questionId = json["questionId"];
    collectionId = json["collectionId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["questionId"] = questionId;
    map["collectionId"] = collectionId;
    return map;
  }
}
