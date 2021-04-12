///学情分析章节数据
class StudyAnalysisChapterSectionEntity {
  ///做题总数
  int doneCounts;

  ///正确数
  int corrects;

  ///总做题时间
  double doneTimes;

  ///预测分
  double predictionScore = 0;

  ///随机头像
  String teacherAvatar;

  int effectiveCount;
  List<StudyAnalysisInfoChapterDTOList> studyAnalysisInfoChapterDTOList = [];

  ///全部章的名字
  List<String> returnsChapterComments;

  ///全部节的名字
  List<String> returnsSectionComments;

  ///全部知识点的名字
  List<String> returnsKnowledgeComments;

  StudyAnalysisChapterSectionEntity(
      {this.doneCounts,
      this.corrects,
      this.doneTimes,
      this.predictionScore,
      this.teacherAvatar,
      this.effectiveCount,
      this.studyAnalysisInfoChapterDTOList,
      this.returnsChapterComments,
      this.returnsSectionComments,
      this.returnsKnowledgeComments});

  StudyAnalysisChapterSectionEntity.fromJson(dynamic json) {
    doneCounts = json["doneCounts"];
    corrects = json["corrects"];
    doneTimes = json["doneTimes"];
    predictionScore = json["predictionScore"];
    teacherAvatar = json["teacherAvatar"];
    effectiveCount = json["effectiveCount"];
    if (json["studyAnalysisInfoChapterDTOList"] != null) {
      studyAnalysisInfoChapterDTOList = [];
      json["studyAnalysisInfoChapterDTOList"].forEach((v) {
        studyAnalysisInfoChapterDTOList.add(StudyAnalysisInfoChapterDTOList.fromJson(v));
      });
    }
    returnsChapterComments =
        json["returnsChapterComments"] != null ? json["returnsChapterComments"].cast<String>() : [];
    returnsSectionComments =
        json["returnsSectionComments"] != null ? json["returnsSectionComments"].cast<String>() : [];
    returnsKnowledgeComments =
        json["returnsKnowledgeComments"] != null ? json["returnsKnowledgeComments"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["doneCounts"] = doneCounts;
    map["corrects"] = corrects;
    map["doneTimes"] = doneTimes;
    map["predictionScore"] = predictionScore;
    map["teacherAvatar"] = teacherAvatar;
    map["effectiveCount"] = effectiveCount;
    if (studyAnalysisInfoChapterDTOList != null) {
      map["studyAnalysisInfoChapterDTOList"] = studyAnalysisInfoChapterDTOList.map((v) => v.toJson()).toList();
    }
    map["returnsChapterComments"] = returnsChapterComments;
    map["returnsSectionComments"] = returnsSectionComments;
    map["returnsKnowledgeComments"] = returnsKnowledgeComments;
    return map;
  }
}

class StudyAnalysisInfoChapterDTOList {
  ///章的名字
  String chapterName;
  int chapterId;
  int chapterSort;
  int chapterCount;

  ///章的正确率
  int chapterCorrect;
  List<StudyAnalysisInfoChapterSectionDTOS> studyAnalysisInfoChapterSectionDTOS;

  StudyAnalysisInfoChapterDTOList(
      {this.chapterName,
      this.chapterId,
      this.chapterSort,
      this.chapterCount,
      this.chapterCorrect,
      this.studyAnalysisInfoChapterSectionDTOS});

  StudyAnalysisInfoChapterDTOList.fromJson(dynamic json) {
    chapterName = json["chapterName"];
    chapterId = json["chapterId"];
    chapterSort = json["chapterSort"];
    chapterCount = json["chapterCount"];
    chapterCorrect = json["chapterCorrect"];
    if (json["studyAnalysisInfoChapterSectionDTOS"] != null) {
      studyAnalysisInfoChapterSectionDTOS = [];
      json["studyAnalysisInfoChapterSectionDTOS"].forEach((v) {
        studyAnalysisInfoChapterSectionDTOS.add(StudyAnalysisInfoChapterSectionDTOS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["chapterName"] = chapterName;
    map["chapterId"] = chapterId;
    map["chapterSort"] = chapterSort;
    map["chapterCount"] = chapterCount;
    map["chapterCorrect"] = chapterCorrect;
    if (studyAnalysisInfoChapterSectionDTOS != null) {
      map["studyAnalysisInfoChapterSectionDTOS"] = studyAnalysisInfoChapterSectionDTOS.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class StudyAnalysisInfoChapterSectionDTOS {
  int sectionId;

  ///节的名字
  String sectionName;

  ///节的正确率
  int sectionCorrect;
  int sectionCount;
  int sectionSort;

  StudyAnalysisInfoChapterSectionDTOS(
      {this.sectionId, this.sectionName, this.sectionCorrect, this.sectionCount, this.sectionSort});

  StudyAnalysisInfoChapterSectionDTOS.fromJson(dynamic json) {
    sectionId = json["sectionId"];
    sectionName = json["sectionName"];
    sectionCorrect = json["sectionCorrect"];
    sectionCount = json["sectionCount"];
    sectionSort = json["sectionSort"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["sectionId"] = sectionId;
    map["sectionName"] = sectionName;
    map["sectionCorrect"] = sectionCorrect;
    map["sectionCount"] = sectionCount;
    map["sectionSort"] = sectionSort;
    return map;
  }
}
