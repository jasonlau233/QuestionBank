import 'package:question_bank/model/data/question_distribution_entity.dart';

///错题本  按来源的列表  和头部信息
class ErrorAccordSourceEntity {
  ///头部错题分布信息
  List<AppQuestionIdAndCountDtos> appQuestionIdAndCountDtos;

  ///按来源列表
  List<AppErrorPaperDtos> appErrorPaperDtos;

  ErrorAccordSourceEntity({this.appQuestionIdAndCountDtos, this.appErrorPaperDtos});

  ErrorAccordSourceEntity.fromJson(dynamic json) {
    if (json["appQuestionIdAndCountDtos"] != null) {
      appQuestionIdAndCountDtos = [];
      json["appQuestionIdAndCountDtos"].forEach((v) {
        appQuestionIdAndCountDtos.add(AppQuestionIdAndCountDtos.fromJson(v));
      });
    }
    if (json["appErrorPaperDtos"] != null) {
      appErrorPaperDtos = [];
      json["appErrorPaperDtos"].forEach((v) {
        appErrorPaperDtos.add(AppErrorPaperDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (appQuestionIdAndCountDtos != null) {
      map["appQuestionIdAndCountDtos"] = appQuestionIdAndCountDtos.map((v) => v.toJson()).toList();
    }
    if (appErrorPaperDtos != null) {
      map["appErrorPaperDtos"] = appErrorPaperDtos.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AppErrorPaperDtos {
  String paperUuid;
  String paperName;
  List<ErrorRecords> errorRecords;
  List<int> questionIds;
  int errorNumbers;

  AppErrorPaperDtos({this.paperUuid, this.paperName, this.errorRecords, this.errorNumbers, this.questionIds});

  AppErrorPaperDtos.fromJson(dynamic json) {
    paperUuid = json["paperUuid"];
    paperName = json["paperName"];
    if (json["errorRecords"] != null) {
      errorRecords = [];
      json["errorRecords"].forEach((v) {
        errorRecords.add(ErrorRecords.fromJson(v));
      });
    }
    questionIds = json["questionIds"] != null ? json["questionIds"].cast<int>() : [];
    errorNumbers = json["errorNumbers"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["paperUuid"] = paperUuid;
    map["paperName"] = paperName;
    if (errorRecords != null) {
      map["errorRecords"] = errorRecords.map((v) => v.toJson()).toList();
    }
    map["questionIds"] = questionIds;
    map["errorNumbers"] = errorNumbers;
    return map;
  }
}

class ErrorRecords {
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

  ErrorRecords(
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

  ErrorRecords.fromJson(dynamic json) {
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
    usedTime = double.parse(json["usedTime"].toString());
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
