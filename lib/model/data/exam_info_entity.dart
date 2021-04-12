import 'dart:convert';

/// groups : [{"productId":"1","questions":{"QuestionItem":[],"notQuestionItem":[{"title":"<p>自然界中，有&ldquo;智慧元素&rdquo;之称的是</p>","questionTypeName":"单选题","typeId":"1","questionOptions":[{"answerContent":"<p>钙</p>","id":"21412278","answerOption":"A"},null],"hash":"d89eb512d500330186541b1fa61b8854"},null]}}]

class ExamInfoEntity {
  List<Groups> _groups;
  Paper _paper;

  /// 试卷的对应的分数项目 易错项目
  Map<String, OptionStatisticsMap> _optionStatisticsMap;

  /// answers
  Map<String, AnswersMap> _answers;

  /// 题目数据
  List<Groups> get groups => _groups;

  /// 试卷信息
  Paper get paper => _paper;

  /// 试卷信息
  Map<String, AnswersMap> get answers => _answers;

  /// 解析正确率 易错项，不规则的不能用实体来做
  Map<String, OptionStatisticsMap> get optionStatisticsMap => _optionStatisticsMap;

  ExamInfoEntity({List<Groups> groups, Paper paper}) {
    _groups = groups;
    _paper = paper;
  }

  ExamInfoEntity.fromJson(dynamic json) {
    _paper = Paper.fromJson(json["paper"]);
    if (json["groups"] != null) {
      _groups = [];
      json["groups"].forEach((v) {
        _groups.add(Groups.fromJson(v));
      });
    }

    if (json["optionStatisticsMap"] != null) {
      _optionStatisticsMap = <String, OptionStatisticsMap>{};
      json["optionStatisticsMap"].forEach((k, v) {
        _optionStatisticsMap[k] = OptionStatisticsMap.fromJson(v);
      });
    }

    if (json["answers"] != null) {
      _answers = <String, AnswersMap>{};
      json["answers"].forEach((k, v) {
        _answers[k] = AnswersMap.fromJson(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_groups != null) {
      map["groups"] = _groups.map((v) => v.toJson()).toList();
    }
    map["paper"] = _paper.toJson();
    return map;
  }
}

class OptionStatisticsMap {
  /// 易错项
  String _highSelectOption;

  /// 全站正确率
  String _rightSelectRate;

  String get rightSelectRate => _rightSelectRate;

  String get highSelectOption => _highSelectOption;

  OptionStatisticsMap({
    String rightSelectRate,
    String highSelectOption,
  }) {
    _rightSelectRate = rightSelectRate;
    _highSelectOption = highSelectOption;
  }

  OptionStatisticsMap.fromJson(dynamic json) {
    _rightSelectRate = json["rightSelectRate"].toString();
    _highSelectOption = json["highSelectOption"].toString();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["rightSelectRate"] = _rightSelectRate;
    map["highSelectOption"] = _highSelectOption;
    return map;
  }
}

class AnswersMap {
  /// 是否标疑 1是
  int _isAnyQuestions;
  int get isAnyQuestions => _isAnyQuestions;

  AnswersMap({
    int isAnyQuestions,
  }) {
    _isAnyQuestions = isAnyQuestions;
  }

  AnswersMap.fromJson(dynamic json) {
    if (json['isAnyQuestions'] == null || json['isAnyQuestions'] == "") {
      _isAnyQuestions = 0;
    } else {
      _isAnyQuestions = int.parse(json['isAnyQuestions'].toString());
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["isAnyQuestions"] = _isAnyQuestions;
    return map;
  }
}

class Paper {
  String _name;
  String _jsonUrl;

  String get name => _name;

  String get jsonUrl => _jsonUrl;

  String _param1;
  String _param2;
  String _param3;
  String _param4;
  String _param5;
  String _param6;
  String _param7;
  String _param8;
  String _param9;
  String _param10;

  String get param1 => _param1;
  String get param2 => _param2;
  String get param3 => _param3;
  String get param4 => _param4;
  String get param5 => _param5;
  String get param6 => _param6;
  String get param7 => _param7;
  String get param8 => _param8;
  String get param9 => _param9;
  String get param10 => _param10;

  Paper({String name, String jsonUrl}) {
    _name = name;
    _jsonUrl = jsonUrl;
  }

  Paper.fromJson(dynamic json) {
    _name = json["name"];
    _jsonUrl = json["jsonUrl"];
    _param1 = json["param1"];
    _param2 = json["param2"];
    _param3 = json["param3"];
    _param4 = json["param4"];
    _param5 = json["param5"];
    _param6 = json["param6"];
    _param7 = json["param7"];
    _param8 = json["param8"];
    _param9 = json["param9"];
    _param10 = json["param10"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["jsonUrl"] = _jsonUrl;
    map["param1"] = _param1;
    map["param2"] = _param2;
    map["param3"] = _param3;
    map["param4"] = _param4;
    map["param5"] = _param5;
    map["param6"] = _param6;
    map["param7"] = _param7;
    map["param8"] = _param8;
    map["param9"] = _param9;
    map["param10"] = _param10;
    return map;
  }
}

/// productId : "1"
/// questions : {"QuestionItem":[],"notQuestionItem":[{"title":"<p>自然界中，有&ldquo;智慧元素&rdquo;之称的是</p>","questionTypeName":"单选题","typeId":"1","questionOptions":[{"answerContent":"<p>钙</p>","id":"21412278","answerOption":"A"},null],"hash":"d89eb512d500330186541b1fa61b8854"},null]}

class Groups {
  String _productId;
  Questions _questions;
  String _groupName;
  String _id;
  List<QuestionItem> _questionItem;

  String get productId => _productId;

  String get groupName => _groupName;
  String get id => _id;

  Questions get questions => _questions;

  List<QuestionItem> get questionsItem => _questionItem;

  Groups({String productId, String groupName, List<QuestionItem> questions}) {
    _productId = productId;
    _groupName = groupName;
    _questionItem = questions;
  }

  Groups.fromJson(dynamic json) {
    _productId = json["productId"];
    _groupName = json["groupName"];
    _id = json["id"];
    if (json["questions"] != null) {
      if (json["questions"] is List) {
        _questionItem = [];
        json["questions"].forEach((v) {
          _questionItem.add(QuestionItem.fromJson(v));
        });
      } else if (json["questions"] is Map) {
        _questions = json["questions"] != null ? Questions.fromJson(json["questions"]) : null;
      }
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["productId"] = _productId;
    map["groupName"] = _groupName;
    if (_questions != null) {
      map["questions"] = _questions.toJson();
    }
    return map;
  }
}

/// QuestionItem : []
/// notQuestionItem : [{"title":"<p>自然界中，有&ldquo;智慧元素&rdquo;之称的是</p>","questionTypeName":"单选题","typeId":"1","questionOptions":[{"answerContent":"<p>钙</p>","id":"21412278","answerOption":"A"},null],"hash":"d89eb512d500330186541b1fa61b8854"},null]

class Questions {
  List<QuestionItem> _questionItem;
  List<QuestionItem> _notQuestionItem;

  List<QuestionItem> get questionItem => _questionItem;

  List<QuestionItem> get notQuestionItem => _notQuestionItem;

  Questions({List<QuestionItem> questionItem, List<QuestionItem> notQuestionItem}) {
    questionItem = questionItem;
    _notQuestionItem = notQuestionItem;
  }

  Questions.fromJson(dynamic json) {
    if (json["done"] != null) {
      _questionItem = [];
      json["done"].forEach((v) {
        _questionItem.add(QuestionItem.fromJson(v));
      });
    }
    if (json["notDone"] != null) {
      _notQuestionItem = [];
      json["notDone"].forEach((v) {
        _notQuestionItem.add(QuestionItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (questionItem != null) {
      map["questItem"] = questionItem.map((v) => v.toJson()).toList();
    }
    if (_notQuestionItem != null) {
      map["notQuestionItem"] = _notQuestionItem.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// title : "<p>自然界中，有&ldquo;智慧元素&rdquo;之称的是</p>"
/// questionTypeName : "单选题"
/// typeId : "1"
/// questionOptions : [{"answerContent":"<p>钙</p>","id":"21412278","answerOption":"A"},null]
/// hash : "d89eb512d500330186541b1fa61b8854"

class QuestionItem {
  /// 自定义参数
  bool _showIntroductionPage;
  String _titleName;
  String _descName;

  bool get showIntroductionPage => _showIntroductionPage;

  String get descName => _descName;

  String get titleName => _titleName;

  List<QuestionItem> _questionChildrenList;
  String _title;
  String _answer;
  String _questionTypeName;
  String _showTypeName;
  String _typeId;
  bool _isCollection;
  String _score;
  String _collectionId;
  String _textAnalysis;
  String _source;
  String _mpKnowledge;
  String _spKnowledge;
  String _videoAnalysis;
  String _id;
  String _param1;
  String _param2;
  String _param3;
  String _param4;
  String _param5;
  String _param6;
  String _param7;
  String _param8;
  String _param9;
  String _param10;
  String _param11;
  String _param12;
  String _param13;
  String _param14;
  String _param15;

  String _parentId;
  int _isAnyQuestions;

  bool get isCollection => _isCollection;
  String get parentId => _parentId;

  List<QuestionItem> get questionChildrenList => _questionChildrenList;
  set questionChildrenList(List<QuestionItem> items) {
    _questionChildrenList = items;
  }

  String get score => _score;

  int get isAnyQuestions => _isAnyQuestions;

  String get id => _id;

  String get param1 => _param1;

  String get param2 => _param2;

  String get param3 => _param3;

  String get param4 => _param4;

  String get param5 => _param5;

  String get param6 => _param6;

  String get param7 => _param7;

  String get param8 => _param8;

  String get param9 => _param9;

  String get param10 => _param10;

  String get param11 => _param11;

  String get param12 => _param12;

  String get param13 => _param13;

  String get param14 => _param14;

  String get param15 => _param15;

  String get collectionId => _collectionId;

  String get mpKnowledge => _mpKnowledge;

  String get spKnowledge => _spKnowledge;

  String get textAnalysis => _textAnalysis;

  String get videoAnalysis => _videoAnalysis;

  String get source => _source;

  List<QuestionOptions> _questionOptions;
  String _hash;

  String get title => _title;

  String get answer => _answer;

  String get questionTypeName => _questionTypeName;

  String get showTypeName => _showTypeName;

  String get typeId => _typeId;

  List<QuestionOptions> get questionOptions => _questionOptions;

  String get hash => _hash;

  QuestionItem({
    String title,
    String answer,
    String questionTypeName,
    String showTypeName,
    String typeId,
    List<QuestionOptions> questionOptions,
    bool isCollection,
    String collectionId,
    String hash,
    String textAnalysis,
    String source,
    String mpKnowledge,
    String spKnowledge,
    String videoAnalysis,
    String id,
    int isAnyQuestions,
    String score,
    String param1,
    String param2,
    String param3,
    String param4,
    String param5,
    String param6,
    String param7,
    String param8,
    String param9,
    String param10,
    String param11,
    String param12,
    String param13,
    String param14,
    String param15,
    String parentId,
    bool showIntroductionPage,
    String titleName,
    String descName,
  }) {
    _title = title;
    _score = score;
    _id = id;
    _questionChildrenList = questionChildrenList;
    _isAnyQuestions = isAnyQuestions;
    _textAnalysis = textAnalysis;
    _mpKnowledge = mpKnowledge;
    _spKnowledge = spKnowledge;
    _parentId = parentId;
    _answer = answer;
    _questionTypeName = questionTypeName;
    _showTypeName = showTypeName;
    _typeId = typeId;
    _questionOptions = questionOptions;
    _hash = hash;
    _isCollection = isCollection;
    _collectionId = collectionId;
    _source = source;
    _videoAnalysis = videoAnalysis;
    _param1 = param1;
    _param2 = param2;
    _param3 = param3;
    _param4 = param4;
    _param5 = param5;
    _param6 = param6;
    _param7 = param7;
    _param8 = param8;
    _param9 = param9;
    _param10 = param10;
    _param11 = param11;
    _param12 = param12;
    _param13 = param13;
    _param14 = param14;
    _param15 = param15;
    _showIntroductionPage = showIntroductionPage;
    _titleName = titleName;
    _descName = descName;
  }

  QuestionItem.fromJson(dynamic json) {
    _showIntroductionPage = json["showIntroductionPage"] ?? false;
    _titleName = json["titleName"];
    _descName = json["descName"];

    if (_showIntroductionPage == true) {
      return;
    }

    _title = json["title"];
    _id = json["id"];
    _param1 = json["param1"];
    _parentId = json["parentId"];
    _param2 = json["param2"];
    _param3 = json["param3"];
    _param4 = json["param4"];
    _param5 = json["param5"];
    _param6 = json["param6"];
    _param7 = json["param7"];
    _param8 = json["param8"];
    _param9 = json["param9"];
    _param10 = json["param10"];
    _param11 = json["param11"];
    _param12 = json["param12"];
    _param13 = json["param13"];
    _param14 = json["param14"];
    _param15 = json["param15"];
    _isAnyQuestions = json["isAnyQuestions"];
    _answer = String.fromCharCodes(base64Decode(json["answer"]));
    _questionTypeName = json["questionTypeName"];
    _showTypeName = json["showTypeName"];
    _textAnalysis = json["textAnalysis"];
    _spKnowledge = json["spKnowledge"];
    _mpKnowledge = json["mpKnowledge"];
    _videoAnalysis = json["videoAnalysis"];
    _source = json["source"];
    _score = json["score"].toString();
    _typeId = json["typeId"];
    _isCollection = json["isCollection"];
    _collectionId = json["collectionId"];
    if (json["questionOptions"] != null) {
      _questionOptions = [];
      if (_questionOptions.length <= 0 && _typeId == "3") {
        _questionOptions = [
          QuestionOptions.fromJson({
            "answerContent": "<p>对</p>",
            "answerOption": "A",
          }),
          QuestionOptions.fromJson({
            "answerContent": "<p>错</p>",
            "answerOption": "B",
          }),
        ];
      } else {
        json["questionOptions"].forEach((v) {
          if (v["answerContent"] != null && !v["answerContent"].toString().contains("<p>")) {
            v["answerContent"] = "<p>" + v["answerContent"] + "</p>";
          }
          _questionOptions.add(QuestionOptions.fromJson(v));
        });
      }
    }

    if (json["questionChildrenList"] != null) {
      _questionChildrenList = [];
      json["questionChildrenList"].forEach((v) {
        _questionChildrenList.add(QuestionItem.fromJson(v));
      });
    }

    _hash = json["hash"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    map["id"] = _id;
    map["answer"] = _answer;
    map["score"] = _score;
    map["source"] = _source;
    map["param1"] = _param1;
    map["param2"] = _param2;
    map["param3"] = _param3;
    map["param4"] = _param4;
    map["param5"] = _param5;
    map["param6"] = _param6;
    map["param7"] = _param7;
    map["param8"] = _param8;
    map["param9"] = _param9;
    map["param10"] = _param10;
    map["param11"] = _param11;
    map["param12"] = _param12;
    map["param13"] = _param13;
    map["param14"] = _param14;
    map["param15"] = _param15;
    map["isAnyQuestions"] = _isAnyQuestions;
    map["questionTypeName"] = _questionTypeName;
    map["showTypeName"] = _showTypeName;
    map["textAnalysis"] = _textAnalysis;
    map["videoAnalysis"] = _videoAnalysis;
    map["typeId"] = _typeId;
    map["collectionId"] = _collectionId;
    map["isCollection"] = _isCollection;
    if (_questionOptions != null) {
      map["questionOptions"] = _questionOptions.map((v) => v.toJson()).toList();
    }
    map["hash"] = _hash;
    return map;
  }
}

/// answerContent : "<p>钙</p>"
/// id : "21412278"
/// answerOption : "A"

class QuestionOptions {
  String _answerContent;
  String _id;
  String _answerOption;

  String get answerContent => _answerContent;

  String get id => _id;

  String get answerOption => _answerOption;

  QuestionOptions({String answerContent, String id, String answerOption}) {
    _answerContent = answerContent;
    _id = id;
    _answerOption = answerOption;
  }

  QuestionOptions.fromJson(dynamic json) {
    _answerContent = json["answerContent"];
    _id = json["id"];
    _answerOption = json["answerOption"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["answerContent"] = _answerContent;
    map["id"] = _id;
    map["answerOption"] = _answerOption;
    return map;
  }
}
