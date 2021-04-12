///做题报告跟练习报告
class ReportEntity {
  String submitTime;
  double totalExamTime;
  int questionNum;
  int doneNum;
  int rightNum;
  int wrongNum;
  String paperName;
  List<QuestionsReport> questions;
  double paperScore;
  double examScore;
  double maxScore;
  double avgScore;
  double beatPersent;
  List<Chapters> chapters;

  ReportEntity(
      {this.submitTime,
      this.totalExamTime,
      this.questionNum,
      this.doneNum,
      this.rightNum,
      this.wrongNum,
      this.paperName,
      this.questions,
      this.paperScore,
      this.examScore,
      this.maxScore,
      this.avgScore,
      this.beatPersent,
      this.chapters});

  ReportEntity.fromJson(dynamic json) {
    submitTime = json["submitTime"];
    totalExamTime = json["totalExamTime"];
    questionNum = json["questionNum"];
    doneNum = json["doneNum"];
    rightNum = json["rightNum"];
    wrongNum = json["wrongNum"];
    paperName = json["paperName"];
    if (json["questions"] != null) {
      questions = [];
      json["questions"].forEach((v) {
        questions.add(QuestionsReport.fromJson(v));
      });
    }
    paperScore = json["paperScore"];
    examScore = json["examScore"];
    maxScore = json["maxScore"];
    avgScore = json["avgScore"];
    beatPersent = json["beatPersent"];
    if (json["chapters"] != null) {
      chapters = [];
      json["chapters"].forEach((v) {
        chapters.add(Chapters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["submitTime"] = submitTime;
    map["totalExamTime"] = totalExamTime;
    map["questionNum"] = questionNum;
    map["doneNum"] = doneNum;
    map["rightNum"] = rightNum;
    map["wrongNum"] = wrongNum;
    map["paperName"] = paperName;
    if (questions != null) {
      map["questions"] = questions.map((v) => v.toJson()).toList();
    }
    map["paperScore"] = paperScore;
    map["examScore"] = examScore;
    map["maxScore"] = maxScore;
    map["avgScore"] = avgScore;
    map["beatPersent"] = beatPersent;
    if (chapters != null) {
      map["chapters"] = chapters.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Chapters {
  String chapterName;
  int allNumber;
  int rightNumber;
  double totalTime;
  List<Sections> sections;

  Chapters(
      {this.chapterName,
      this.allNumber,
      this.rightNumber,
      this.totalTime,
      this.sections});

  Chapters.fromJson(dynamic json) {
    chapterName = json["chapterName"];
    allNumber = json["allNumber"];
    rightNumber = json["rightNumber"];
    totalTime = json["totalTime"];
    if (json["sections"] != null) {
      sections = [];
      json["sections"].forEach((v) {
        sections.add(Sections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["chapterName"] = chapterName;
    map["allNumber"] = allNumber;
    map["rightNumber"] = rightNumber;
    map["totalTime"] = totalTime;
    if (sections != null) {
      map["sections"] = sections.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Sections {
  String chapterName;
  String sectionName;
  int allNumber;
  int rightNumber;
  double totalTime;

  Sections(
      {this.chapterName,
      this.sectionName,
      this.allNumber,
      this.rightNumber,
      this.totalTime});

  Sections.fromJson(dynamic json) {
    chapterName = json["chapterName"];
    sectionName = json["sectionName"];
    allNumber = json["allNumber"];
    rightNumber = json["rightNumber"];
    totalTime = json["totalTime"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["chapterName"] = chapterName;
    map["sectionName"] = sectionName;
    map["allNumber"] = allNumber;
    map["rightNumber"] = rightNumber;
    map["totalTime"] = totalTime;
    return map;
  }
}

class QuestionsReport {
  String questionId;
  String userAnswer;
  int isAnyQuestions;
  double usedTime;
  int isCorrect;
  double score;
  int questionTypeId;

  ///显示在答题卡上面的题号
  String showNo = '';

  ///如果是小题对应的 大题id
  String extendId = '';

  QuestionsReport(
      {this.questionId,
      this.userAnswer,
      this.isAnyQuestions,
      this.usedTime,
      this.isCorrect,
      this.score,
      this.questionTypeId});

  QuestionsReport.fromJson(dynamic json) {
    questionId = json["questionId"];
    userAnswer = json["userAnswer"];
    isAnyQuestions = json["isAnyQuestions"];
    usedTime = json["usedTime"];
    isCorrect = json["isCorrect"];
    score = json["score"];
    questionTypeId = json["questionTypeId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["questionId"] = questionId;
    map["userAnswer"] = userAnswer;
    map["isAnyQuestions"] = isAnyQuestions;
    map["usedTime"] = usedTime;
    map["isCorrect"] = isCorrect;
    map["score"] = score;
    map["questionTypeId"] = questionTypeId;
    return map;
  }

  @override
  String toString() {
    return 'QuestionsReport{questionId: $questionId, userAnswer: $userAnswer, isAnyQuestions: $isAnyQuestions, usedTime: $usedTime, isCorrect: $isCorrect, score: $score, questionTypeId: $questionTypeId}';
  }
}
