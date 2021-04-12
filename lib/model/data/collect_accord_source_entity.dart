///收藏按来源的题目
class CollectAccordSourceEntity {
  String paperUuid;
  String paperName;
  List<QuestionIdAndCollectionIds> questionIdAndCollectionIds;
  int collectionNumbers;
  String lastCollectionDateTime;

  CollectAccordSourceEntity(
      {this.paperUuid,
      this.paperName,
      this.questionIdAndCollectionIds,
      this.collectionNumbers,
      this.lastCollectionDateTime});

  CollectAccordSourceEntity.fromJson(dynamic json) {
    paperUuid = json["paperUuid"];
    paperName = json["paperName"];
    if (json["questionIdAndCollectionIds"] != null) {
      questionIdAndCollectionIds = [];
      json["questionIdAndCollectionIds"].forEach((v) {
        questionIdAndCollectionIds.add(QuestionIdAndCollectionIds.fromJson(v));
      });
    }
    collectionNumbers = json["collectionNumbers"];
    lastCollectionDateTime = json["lastCollectionDateTime"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["paperUuid"] = paperUuid;
    map["paperName"] = paperName;
    if (questionIdAndCollectionIds != null) {
      map["questionIdAndCollectionIds"] =
          questionIdAndCollectionIds.map((v) => v.toJson()).toList();
    }
    map["collectionNumbers"] = collectionNumbers;
    map["lastCollectionDateTime"] = lastCollectionDateTime;
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
