import 'package:question_bank/model/data/question_distribution_entity.dart';

///错题本  按章节的列表  和头部信息
class ErrorAccordChapterEntity {
  List<AppQuestionIdAndCountDtos> appQuestionIdAndCountDtos;
  List<AppErrorQuestionBookChapterDtos> appErrorQuestionBookChapterDtos;

  ErrorAccordChapterEntity({this.appQuestionIdAndCountDtos, this.appErrorQuestionBookChapterDtos});

  ErrorAccordChapterEntity.fromJson(dynamic json) {
    if (json["appQuestionIdAndCountDtos"] != null) {
      appQuestionIdAndCountDtos = [];
      json["appQuestionIdAndCountDtos"].forEach((v) {
        appQuestionIdAndCountDtos.add(AppQuestionIdAndCountDtos.fromJson(v));
      });
    }
    if (json["appErrorQuestionBookChapterDtos"] != null) {
      appErrorQuestionBookChapterDtos = [];
      json["appErrorQuestionBookChapterDtos"].forEach((v) {
        appErrorQuestionBookChapterDtos.add(AppErrorQuestionBookChapterDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (appQuestionIdAndCountDtos != null) {
      map["appQuestionIdAndCountDtos"] = appQuestionIdAndCountDtos.map((v) => v.toJson()).toList();
    }
    if (appErrorQuestionBookChapterDtos != null) {
      map["appErrorQuestionBookChapterDtos"] = appErrorQuestionBookChapterDtos.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AppErrorQuestionBookChapterDtos {
  int id;
  String name;
  int sort;
  int allNumber;
  int errorNumbers;
  List<SectionList> sectionList;

  AppErrorQuestionBookChapterDtos({this.id, this.name, this.sort, this.allNumber, this.errorNumbers, this.sectionList});

  AppErrorQuestionBookChapterDtos.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    sort = json["sort"];
    allNumber = json["allNumber"];
    errorNumbers = json["errorNumbers"];
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
    map["errorNumbers"] = errorNumbers;
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
  int errorNumbers;
  String paperUuid;
  String subModuleId;
  List<ErrorRecordChapters> errorRecords;
  List<int> questionIds;

  SectionList(
      {this.id,
      this.name,
      this.sort,
      this.allNumbers,
      this.errorNumbers,
      this.paperUuid,
      this.subModuleId,
      this.errorRecords,
      this.questionIds});

  SectionList.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    sort = json["sort"];
    allNumbers = json["allNumbers"];
    errorNumbers = json["errorNumbers"];
    paperUuid = json["paperUuid"];
    subModuleId = json["subModuleId"];
    if (json["errorRecords"] != null) {
      errorRecords = [];
      json["errorRecords"].forEach((v) {
        errorRecords.add(ErrorRecordChapters.fromJson(v));
      });
    }
    questionIds = json["questionIds"] != null ? json["questionIds"].cast<int>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["sort"] = sort;
    map["allNumbers"] = allNumbers;
    map["errorNumbers"] = errorNumbers;
    map["paperUuid"] = paperUuid;
    map["subModuleId"] = subModuleId;
    map["questionIds"] = questionIds;
    if (errorRecords != null) {
      map["errorRecords"] = errorRecords.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ErrorRecordChapters {
  String createDate;
  String errorCount;
  String examId;
  int isAnyQuestions;
  String mpKnowledge;
  String paperName;
  String paperUuid;
  String productId;
  String questionId;
  dynamic questionParentId;
  int questionTypeId;
  int typeId;
  String updateDate;
  double usedTime;

  ErrorRecordChapters(
      {this.createDate,
      this.errorCount,
      this.examId,
      this.isAnyQuestions,
      this.mpKnowledge,
      this.paperName,
      this.paperUuid,
      this.productId,
      this.questionId,
      this.questionParentId,
      this.questionTypeId,
      this.typeId,
      this.updateDate,
      this.usedTime});

  ErrorRecordChapters.fromJson(dynamic json) {
    createDate = json["createDate"];
    errorCount = json["errorCount"];
    examId = json["examId"];
    isAnyQuestions = json["isAnyQuestions"];
    mpKnowledge = json["mpKnowledge"];
    paperName = json["paperName"];
    paperUuid = json["paperUuid"];
    productId = json["productId"];
    questionId = json["questionId"];
    questionParentId = json["questionParentId"];
    questionTypeId = json["questionTypeId"];
    typeId = json["typeId"];
    updateDate = json["updateDate"];
    usedTime = double.tryParse(json["usedTime"].toString());
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["createDate"] = createDate;
    map["errorCount"] = errorCount;
    map["examId"] = examId;
    map["isAnyQuestions"] = isAnyQuestions;
    map["mpKnowledge"] = mpKnowledge;
    map["paperName"] = paperName;
    map["paperUuid"] = paperUuid;
    map["productId"] = productId;
    map["questionId"] = questionId;
    map["questionParentId"] = questionParentId;
    map["questionTypeId"] = questionTypeId;
    map["typeId"] = typeId;
    map["updateDate"] = updateDate;
    map["usedTime"] = usedTime;
    return map;
  }
}
