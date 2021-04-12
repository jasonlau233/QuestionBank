class PaperEntity {
  Paper paper;
  List<GroupsAnswerCard> groups;

  PaperEntity({this.paper, this.groups});

  PaperEntity.fromJson(dynamic json) {
    paper = json["paper"] != null ? Paper.fromJson(json["paper"]) : null;
    if (json["groups"] != null) {
      groups = [];
      if (json["groups"] is List) {
        json["groups"].forEach((v) {
          groups.add(GroupsAnswerCard.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (paper != null) {
      map["paper"] = paper.toJson();
    }
    if (groups != null) {
      map["groups"] = groups.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class GroupsAnswerCard {
  String id;
  String groupName;
  String questionTypeId;
  String questionCount;
  String totalScore;
  String paperId;
  String remark;
  String productId;
  String status;
  String createDate;
  String param3;
  String param2;
  String param1;
  int mustDo;
  List<Questionss> questions;
  String questionVOList;
  String paperQuestionVOList;

  GroupsAnswerCard(
      {this.id,
      this.groupName,
      this.questionTypeId,
      this.questionCount,
      this.totalScore,
      this.paperId,
      this.remark,
      this.productId,
      this.status,
      this.createDate,
      this.param3,
      this.param2,
      this.param1,
      this.mustDo,
      this.questions,
      this.questionVOList,
      this.paperQuestionVOList});

  GroupsAnswerCard.fromJson(dynamic json) {
    id = json["id"];
    groupName = json["groupName"];
    questionTypeId = json["questionTypeId"];
    questionCount = json["questionCount"].toString();
    totalScore = json["totalScore"].toString();
    paperId = json["paperId"];
    remark = json["remark"];
    productId = json["productId"];
    status = json["status"];
    createDate = json["createDate"];
    param3 = json["param3"];
    param2 = json["param2"];
    param1 = json["param1"];
    mustDo = json["mustDo"];
    if (json["questions"] != null) {
      questions = [];
      if (json["questions"] is List) {
        json["questions"].forEach((v) {
          questions.add(Questionss.fromJson(v));
        });
      }
    }
    questionVOList = json["questionVOList"];
    paperQuestionVOList = json["paperQuestionVOList"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["groupName"] = groupName;
    map["questionTypeId"] = questionTypeId;
    map["questionCount"] = questionCount;
    map["totalScore"] = totalScore;
    map["paperId"] = paperId;
    map["remark"] = remark;
    map["productId"] = productId;
    map["status"] = status;
    map["createDate"] = createDate;
    map["param3"] = param3;
    map["param2"] = param2;
    map["param1"] = param1;
    map["mustDo"] = mustDo;
    if (questions != null) {
      map["questions"] = questions.map((v) => v.toJson()).toList();
    }
    map["questionVOList"] = questionVOList;
    map["paperQuestionVOList"] = paperQuestionVOList;
    return map;
  }
}

class Questionss {
  String id;
  String title;
  String answer;
  String diffculty;
  int isHasSon;
  String parentId;
  String typeId;
  String importance;
  int status;
  String source;
  String createBy;
  String updateDate;
  String updateBy;
  String productId;
  String mpKnowledge;
  String spKnowledge;
  String param1;
  String param2;
  String param3;
  String param4;
  String param5;
  String param6;
  String param7;
  String param8;
  String param9;
  String param10;
  String param11;
  String param12;
  String param13;
  String param14;
  String param15;
  String showTypeName;
  int usedType;
  String hash;
  String productName;
  String questionTypeName;
  String isScoreRule;
  String scoreRule;
  List<QuestionChildrenList> questionChildrenList;
  String paperId;
  bool keep = true;

  Questionss(
      {this.id,
      this.title,
      this.answer,
      this.isHasSon,
      this.parentId,
      this.typeId,
      this.importance,
      this.status,
      this.source,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.productId,
      this.mpKnowledge,
      this.spKnowledge,
      this.param1,
      this.param2,
      this.param3,
      this.param4,
      this.param5,
      this.param6,
      this.param7,
      this.param8,
      this.param9,
      this.param10,
      this.param11,
      this.param12,
      this.param13,
      this.param14,
      this.param15,
      this.showTypeName,
      this.usedType,
      this.hash,
      this.productName,
      this.questionTypeName,
      this.isScoreRule,
      this.scoreRule,
      this.questionChildrenList,
      this.paperId});

  Questionss.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    answer = json["answer"];
    diffculty = json["diffculty"];
    isHasSon = json["isHasSon"];
    parentId = json["parentId"];
    typeId = json["typeId"];
    importance = json["importance"];
    status = json["status"];
    source = json["source"];
    createBy = json["createBy"];
    updateDate = json["updateDate"];
    updateBy = json["updateBy"];
    productId = json["productId"];
    mpKnowledge = json["mpKnowledge"];
    spKnowledge = json["spKnowledge"];
    param1 = json["param1"];
    param2 = json["param2"];
    param3 = json["param3"];
    param4 = json["param4"];
    param5 = json["param5"];
    param6 = json["param6"];
    param7 = json["param7"];
    param8 = json["param8"];
    param9 = json["param9"];
    param10 = json["param10"];
    param11 = json["param11"];
    param12 = json["param12"];
    param13 = json["param13"];
    param14 = json["param14"];
    param15 = json["param15"];
    showTypeName = json["showTypeName"];
    usedType = json["usedType"];
    hash = json["hash"];
    productName = json["productName"];
    questionTypeName = json["questionTypeName"];
    isScoreRule = json["isScoreRule"];
    scoreRule = json["scoreRule"];
    if (json["questionChildrenList"] != null) {
      questionChildrenList = [];
      json["questionChildrenList"].forEach((v) {
        questionChildrenList.add(QuestionChildrenList.fromJson(v));
      });
    }
    paperId = json["paperId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["answer"] = answer;
    map["diffculty"] = diffculty;
    map["isHasSon"] = isHasSon;
    map["parentId"] = parentId;
    map["typeId"] = typeId;
    map["importance"] = importance;
    map["status"] = status;
    map["source"] = source;
    map["createBy"] = createBy;
    map["updateDate"] = updateDate;
    map["updateBy"] = updateBy;
    map["productId"] = productId;
    map["mpKnowledge"] = mpKnowledge;
    map["spKnowledge"] = spKnowledge;
    map["param1"] = param1;
    map["param2"] = param2;
    map["param3"] = param3;
    map["param4"] = param4;
    map["param5"] = param5;
    map["param6"] = param6;
    map["param7"] = param7;
    map["param8"] = param8;
    map["param9"] = param9;
    map["param10"] = param10;
    map["param11"] = param11;
    map["param12"] = param12;
    map["param13"] = param13;
    map["param14"] = param14;
    map["param15"] = param15;
    map["showTypeName"] = showTypeName;
    map["usedType"] = usedType;
    map["hash"] = hash;
    map["productName"] = productName;
    map["questionTypeName"] = questionTypeName;
    map["isScoreRule"] = isScoreRule;
    map["scoreRule"] = scoreRule;
    if (questionChildrenList != null) {
      map["questionChildrenList"] = questionChildrenList.map((v) => v.toJson()).toList();
    }
    map["paperId"] = paperId;
    return map;
  }
}

class QuestionChildrenList {
  String id;
  String title;
  String answer;
  String diffculty;
  String textAnalysis;
  String videoAnalysis;
  int isHasSon;
  String parentId;
  String typeId;
  String importance;
  int status;
  String source;
  String createDate;
  String createBy;
  String updateDate;
  String updateBy;
  String productId;
  String mpKnowledge;
  String spKnowledge;
  String param1;
  String param2;
  String param3;
  String param4;
  String param5;
  String param6;
  String param7;
  String param8;
  String param9;
  String param10;
  String param11;
  String param12;
  String param13;
  String param14;
  String param15;
  String showTypeName;
  int usedType;
  String hash;
  String productName;
  String questionTypeName;
  String isScoreRule;
  String scoreRule;
  List<QuestionOptions> questionOptions;
  List<dynamic> questionChildrenList;
  String paperId;
  bool keep = true;

  QuestionChildrenList(
      {this.id,
      this.title,
      this.answer,
      this.diffculty,
      this.textAnalysis,
      this.videoAnalysis,
      this.isHasSon,
      this.parentId,
      this.typeId,
      this.importance,
      this.status,
      this.source,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.productId,
      this.mpKnowledge,
      this.spKnowledge,
      this.param1,
      this.param2,
      this.param3,
      this.param4,
      this.param5,
      this.param6,
      this.param7,
      this.param8,
      this.param9,
      this.param10,
      this.param11,
      this.param12,
      this.param13,
      this.param14,
      this.param15,
      this.showTypeName,
      this.usedType,
      this.hash,
      this.productName,
      this.questionTypeName,
      this.isScoreRule,
      this.scoreRule,
      this.questionOptions,
      this.questionChildrenList,
      this.paperId});

  QuestionChildrenList.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    answer = json["answer"];
    diffculty = json["diffculty"];
    textAnalysis = json["textAnalysis"];
    videoAnalysis = json["videoAnalysis"];
    isHasSon = json["isHasSon"];
    parentId = json["parentId"];
    typeId = json["typeId"];
    importance = json["importance"];
    status = json["status"];
    source = json["source"];
    createDate = json["createDate"];
    createBy = json["createBy"];
    updateDate = json["updateDate"];
    updateBy = json["updateBy"];
    productId = json["productId"];
    mpKnowledge = json["mpKnowledge"];
    spKnowledge = json["spKnowledge"];
    param1 = json["param1"];
    param2 = json["param2"];
    param3 = json["param3"];
    param4 = json["param4"];
    param5 = json["param5"];
    param6 = json["param6"];
    param7 = json["param7"];
    param8 = json["param8"];
    param9 = json["param9"];
    param10 = json["param10"];
    param11 = json["param11"];
    param12 = json["param12"];
    param13 = json["param13"];
    param14 = json["param14"];
    param15 = json["param15"];
    showTypeName = json["showTypeName"];
    usedType = json["usedType"];
    hash = json["hash"];
    productName = json["productName"];
    questionTypeName = json["questionTypeName"];
    isScoreRule = json["isScoreRule"];
    scoreRule = json["scoreRule"];
    if (json["questionOptions"] != null) {
      questionOptions = [];
      json["questionOptions"].forEach((v) {
        questionOptions.add(QuestionOptions.fromJson(v));
      });
    }
    paperId = json["paperId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["answer"] = answer;
    map["diffculty"] = diffculty;
    map["textAnalysis"] = textAnalysis;
    map["videoAnalysis"] = videoAnalysis;
    map["isHasSon"] = isHasSon;
    map["parentId"] = parentId;
    map["typeId"] = typeId;
    map["importance"] = importance;
    map["status"] = status;
    map["source"] = source;
    map["createDate"] = createDate;
    map["createBy"] = createBy;
    map["updateDate"] = updateDate;
    map["updateBy"] = updateBy;
    map["productId"] = productId;
    map["mpKnowledge"] = mpKnowledge;
    map["spKnowledge"] = spKnowledge;
    map["param1"] = param1;
    map["param2"] = param2;
    map["param3"] = param3;
    map["param4"] = param4;
    map["param5"] = param5;
    map["param6"] = param6;
    map["param7"] = param7;
    map["param8"] = param8;
    map["param9"] = param9;
    map["param10"] = param10;
    map["param11"] = param11;
    map["param12"] = param12;
    map["param13"] = param13;
    map["param14"] = param14;
    map["param15"] = param15;
    map["showTypeName"] = showTypeName;
    map["usedType"] = usedType;
    map["hash"] = hash;
    map["productName"] = productName;
    map["questionTypeName"] = questionTypeName;
    map["isScoreRule"] = isScoreRule;
    map["scoreRule"] = scoreRule;
    if (questionOptions != null) {
      map["questionOptions"] = questionOptions.map((v) => v.toJson()).toList();
    }
    if (questionChildrenList != null) {
      map["questionChildrenList"] = questionChildrenList.map((v) => v.toJson()).toList();
    }
    map["paperId"] = paperId;
    return map;
  }
}

class QuestionOptions {
  String id;
  String questionId;
  String answerOption;
  String answerContent;
  String picUrl;
  String audioUrl;
  String videoUrl;
  String knowledge;

  QuestionOptions(
      {this.id,
      this.questionId,
      this.answerOption,
      this.answerContent,
      this.picUrl,
      this.audioUrl,
      this.videoUrl,
      this.knowledge});

  QuestionOptions.fromJson(dynamic json) {
    id = json["id"];
    questionId = json["questionId"];
    answerOption = json["answerOption"];
    answerContent = json["answerContent"];
    picUrl = json["picUrl"];
    audioUrl = json["audioUrl"];
    videoUrl = json["videoUrl"];
    knowledge = json["knowledge"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["questionId"] = questionId;
    map["answerOption"] = answerOption;
    map["answerContent"] = answerContent;
    map["picUrl"] = picUrl;
    map["audioUrl"] = audioUrl;
    map["videoUrl"] = videoUrl;
    map["knowledge"] = knowledge;
    return map;
  }
}

class Paper {
  String id;
  String uuid;
  String name;
  String jsonUrl;
  String score;
  String examDuration;
  String diffculty;
  String difficultyDegree;
  String examTimes;
  String beginDate;
  String endDate;
  String isAnalyLook;
  String remark;
  String status;
  String createDate;
  String createBy;
  String updateDate;
  String updateBy;
  String productId;
  String param1;
  String param2;
  String param3;
  String param4;
  String param5;
  String param6;
  String param7;
  String param8;
  String param9;
  String param10;
  String markMethod;
  String typeId;
  String questionList;
  String paperQuestionList;
  String paperGenerateRuleVOList;
  String questionIds;

  Paper(
      {this.id,
      this.uuid,
      this.name,
      this.jsonUrl,
      this.score,
      this.examDuration,
      this.diffculty,
      this.difficultyDegree,
      this.examTimes,
      this.beginDate,
      this.endDate,
      this.isAnalyLook,
      this.remark,
      this.status,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.productId,
      this.param1,
      this.param2,
      this.param3,
      this.param4,
      this.param5,
      this.param6,
      this.param7,
      this.param8,
      this.param9,
      this.param10,
      this.markMethod,
      this.typeId,
      this.questionList,
      this.paperQuestionList,
      this.paperGenerateRuleVOList,
      this.questionIds});

  Paper.fromJson(dynamic json) {
    id = json["id"];
    uuid = json["uuid"];
    name = json["name"];
    jsonUrl = json["jsonUrl"];
    score = json["score"];
    examDuration = json["examDuration"];
    diffculty = json["diffculty"];
    difficultyDegree = json["difficultyDegree"];
    examTimes = json["examTimes"];
    beginDate = json["beginDate"];
    endDate = json["endDate"];
    isAnalyLook = json["isAnalyLook"];
    remark = json["remark"];
    status = json["status"];
    createDate = json["createDate"];
    createBy = json["createBy"];
    updateDate = json["updateDate"];
    updateBy = json["updateBy"];
    productId = json["productId"];
    param1 = json["param1"];
    param2 = json["param2"];
    param3 = json["param3"];
    param4 = json["param4"];
    param5 = json["param5"];
    param6 = json["param6"];
    param7 = json["param7"];
    param8 = json["param8"];
    param9 = json["param9"];
    param10 = json["param10"];
    markMethod = json["markMethod"];
    typeId = json["typeId"];
    questionList = json["questionList"];
    paperQuestionList = json["paperQuestionList"];
    paperGenerateRuleVOList = json["paperGenerateRuleVOList"];
    questionIds = json["questionIds"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["uuid"] = uuid;
    map["name"] = name;
    map["jsonUrl"] = jsonUrl;
    map["score"] = score;
    map["examDuration"] = examDuration;
    map["diffculty"] = diffculty;
    map["difficultyDegree"] = difficultyDegree;
    map["examTimes"] = examTimes;
    map["beginDate"] = beginDate;
    map["endDate"] = endDate;
    map["isAnalyLook"] = isAnalyLook;
    map["remark"] = remark;
    map["status"] = status;
    map["createDate"] = createDate;
    map["createBy"] = createBy;
    map["updateDate"] = updateDate;
    map["updateBy"] = updateBy;
    map["productId"] = productId;
    map["param1"] = param1;
    map["param2"] = param2;
    map["param3"] = param3;
    map["param4"] = param4;
    map["param5"] = param5;
    map["param6"] = param6;
    map["param7"] = param7;
    map["param8"] = param8;
    map["param9"] = param9;
    map["param10"] = param10;
    map["markMethod"] = markMethod;
    map["typeId"] = typeId;
    map["questionList"] = questionList;
    map["paperQuestionList"] = paperQuestionList;
    map["paperGenerateRuleVOList"] = paperGenerateRuleVOList;
    map["questionIds"] = questionIds;
    return map;
  }
}
