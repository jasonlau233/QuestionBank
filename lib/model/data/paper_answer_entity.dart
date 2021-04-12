/// examDetail : {"examRecord":{"id":"76044073932173313","userId":"18852600","paperUuid":"89c2dc984db24391b4be972765f2012a","typeId":1,"paperName":"练习专用","examId":"","paperScore":"","examScore":0,"questionNum":234,"selectNum":40,"doneNum":40,"rightNum":39,"wrongNum":1,"isFirstTime":0,"isComplete":0,"productId":"1","markMethod":"","praticeQids":"2453713,2457940,2457943,2457944,2457947,2458054,2458236,2458275,2458335,2458343,2458344,2458345,2458577,2458582,2458623,2458652,2458665,2458719,2458746,2458747,2458752,2458753,2458774,2458857,2458959,2459043,2459492,2459538,2459843,2459857,2459873,2459929,2460040,2460080,2460280,2460417,2460419,2460475,2460480,2460488","status":1,"createDate":"2021-01-12 14:38:31","updateDate":"2021-01-12 14:38:31","paperType":"","param1":"1","param2":"399","param3":"2020","param4":"","param5":"存货","param6":"","param7":"","param8":"","param9":"0","param10":"0","totalExamTime":46},"examDetails":[{"id":"76044074523570177","examRecordId":"76044073932173313","questionId":"2453713","userAnswer":"A","isCorrect":0,"isCorrectRedo":0,"score":0,"status":1,"markStatus":0,"mpKnowledge":"3188","mpKnowledgeCode":"CJKM0096K0131","questionParentId":"0","createDate":"2021-01-12 14:38:32","updateDate":"2021-01-12 14:38:32","usedTime":2,"isAnyQuestions":0,"scoringPoints":""}]}

class PaperAnswerEntity {
  ExamDetail _examDetail;

  ExamDetail get examDetail => _examDetail;

  PaperAnswerEntity({ExamDetail examDetail}) {
    _examDetail = examDetail;
  }

  PaperAnswerEntity.fromJson(dynamic json) {
    _examDetail = json["examDetail"] != null ? ExamDetail.fromJson(json["examDetail"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_examDetail != null) {
      map["examDetail"] = _examDetail.toJson();
    }
    return map;
  }
}

/// examRecord : {"id":"76044073932173313","userId":"18852600","paperUuid":"89c2dc984db24391b4be972765f2012a","typeId":1,"paperName":"练习专用","examId":"","paperScore":"","examScore":0,"questionNum":234,"selectNum":40,"doneNum":40,"rightNum":39,"wrongNum":1,"isFirstTime":0,"isComplete":0,"productId":"1","markMethod":"","praticeQids":"2453713,2457940,2457943,2457944,2457947,2458054,2458236,2458275,2458335,2458343,2458344,2458345,2458577,2458582,2458623,2458652,2458665,2458719,2458746,2458747,2458752,2458753,2458774,2458857,2458959,2459043,2459492,2459538,2459843,2459857,2459873,2459929,2460040,2460080,2460280,2460417,2460419,2460475,2460480,2460488","status":1,"createDate":"2021-01-12 14:38:31","updateDate":"2021-01-12 14:38:31","paperType":"","param1":"1","param2":"399","param3":"2020","param4":"","param5":"存货","param6":"","param7":"","param8":"","param9":"0","param10":"0","totalExamTime":46}
/// examDetails : [{"id":"76044074523570177","examRecordId":"76044073932173313","questionId":"2453713","userAnswer":"A","isCorrect":0,"isCorrectRedo":0,"score":0,"status":1,"markStatus":0,"mpKnowledge":"3188","mpKnowledgeCode":"CJKM0096K0131","questionParentId":"0","createDate":"2021-01-12 14:38:32","updateDate":"2021-01-12 14:38:32","usedTime":2,"isAnyQuestions":0,"scoringPoints":""}]

class ExamDetail {
  ExamRecord _examRecord;
  List<ExamDetails> _examDetails;

  ExamRecord get examRecord => _examRecord;
  List<ExamDetails> get examDetails => _examDetails;

  ExamDetail({ExamRecord examRecord, List<ExamDetails> examDetails}) {
    _examRecord = examRecord;
    _examDetails = examDetails;
  }

  ExamDetail.fromJson(dynamic json) {
    _examRecord = json["examRecord"] != null ? ExamRecord.fromJson(json["examRecord"]) : null;
    if (json["examDetails"] != null && json["examDetails"] is List) {
      _examDetails = [];
      json["examDetails"].forEach((v) {
        _examDetails.add(ExamDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_examRecord != null) {
      map["examRecord"] = _examRecord.toJson();
    }
    if (_examDetails != null) {
      map["examDetails"] = _examDetails.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "76044074523570177"
/// examRecordId : "76044073932173313"
/// questionId : "2453713"
/// userAnswer : "A"
/// isCorrect : 0
/// isCorrectRedo : 0
/// score : 0
/// status : 1
/// markStatus : 0
/// mpKnowledge : "3188"
/// mpKnowledgeCode : "CJKM0096K0131"
/// questionParentId : "0"
/// createDate : "2021-01-12 14:38:32"
/// updateDate : "2021-01-12 14:38:32"
/// usedTime : 2
/// isAnyQuestions : 0
/// scoringPoints : ""

class ExamDetails {
  String _id;
  String _examRecordId;
  String _questionId;
  String _userAnswer;
  int _isCorrect;
  int _isCorrectRedo;
  String _score;
  int _status;
  int _markStatus;
  String _mpKnowledge;
  String _mpKnowledgeCode;
  String _questionParentId;
  String _createDate;
  String _updateDate;
  double _usedTime;
  int _isAnyQuestions;
  String _scoringPoints;

  String get id => _id;
  String get examRecordId => _examRecordId;
  String get questionId => _questionId;
  String get userAnswer => _userAnswer;
  int get isCorrect => _isCorrect;
  int get isCorrectRedo => _isCorrectRedo;
  String get score => _score;
  int get status => _status;
  int get markStatus => _markStatus;
  String get mpKnowledge => _mpKnowledge;
  String get mpKnowledgeCode => _mpKnowledgeCode;
  String get questionParentId => _questionParentId;
  String get createDate => _createDate;
  String get updateDate => _updateDate;
  double get usedTime => _usedTime;
  int get isAnyQuestions => _isAnyQuestions;
  String get scoringPoints => _scoringPoints;

  ExamDetails(
      {String id,
      String examRecordId,
      String questionId,
      String userAnswer,
      int isCorrect,
      int isCorrectRedo,
      String score,
      int status,
      int markStatus,
      String mpKnowledge,
      String mpKnowledgeCode,
      String questionParentId,
      String createDate,
      String updateDate,
      double usedTime,
      int isAnyQuestions,
      String scoringPoints}) {
    _id = id;
    _examRecordId = examRecordId;
    _questionId = questionId;
    _userAnswer = userAnswer;
    _isCorrect = isCorrect;
    _isCorrectRedo = isCorrectRedo;
    _score = score;
    _status = status;
    _markStatus = markStatus;
    _mpKnowledge = mpKnowledge;
    _mpKnowledgeCode = mpKnowledgeCode;
    _questionParentId = questionParentId;
    _createDate = createDate;
    _updateDate = updateDate;
    _usedTime = usedTime;
    _isAnyQuestions = isAnyQuestions;
    _scoringPoints = scoringPoints;
  }

  ExamDetails.fromJson(dynamic json) {
    _id = json["id"];
    _examRecordId = json["examRecordId"];
    _questionId = json["questionId"];
    _userAnswer = json["userAnswer"];
    _isCorrect = json["isCorrect"];
    _isCorrectRedo = json["isCorrectRedo"];
    _score = json["score"].toString();
    _status = json["status"];
    _markStatus = json["markStatus"];
    _mpKnowledge = json["mpKnowledge"];
    _mpKnowledgeCode = json["mpKnowledgeCode"];
    _questionParentId = json["questionParentId"];
    _createDate = json["createDate"];
    _updateDate = json["updateDate"];
    _usedTime = json["usedTime"];
    _isAnyQuestions = json["isAnyQuestions"];
    _scoringPoints = json["scoringPoints"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["examRecordId"] = _examRecordId;
    map["questionId"] = _questionId;
    map["userAnswer"] = _userAnswer;
    map["isCorrect"] = _isCorrect;
    map["isCorrectRedo"] = _isCorrectRedo;
    map["score"] = _score;
    map["status"] = _status;
    map["markStatus"] = _markStatus;
    map["mpKnowledge"] = _mpKnowledge;
    map["mpKnowledgeCode"] = _mpKnowledgeCode;
    map["questionParentId"] = _questionParentId;
    map["createDate"] = _createDate;
    map["updateDate"] = _updateDate;
    map["usedTime"] = _usedTime;
    map["isAnyQuestions"] = _isAnyQuestions;
    map["scoringPoints"] = _scoringPoints;
    return map;
  }
}

/// id : "76044073932173313"
/// userId : "18852600"
/// paperUuid : "89c2dc984db24391b4be972765f2012a"
/// typeId : 1
/// paperName : "练习专用"
/// examId : ""
/// paperScore : ""
/// examScore : 0
/// questionNum : 234
/// selectNum : 40
/// doneNum : 40
/// rightNum : 39
/// wrongNum : 1
/// isFirstTime : 0
/// isComplete : 0
/// productId : "1"
/// markMethod : ""
/// praticeQids : "2453713,2457940,2457943,2457944,2457947,2458054,2458236,2458275,2458335,2458343,2458344,2458345,2458577,2458582,2458623,2458652,2458665,2458719,2458746,2458747,2458752,2458753,2458774,2458857,2458959,2459043,2459492,2459538,2459843,2459857,2459873,2459929,2460040,2460080,2460280,2460417,2460419,2460475,2460480,2460488"
/// status : 1
/// createDate : "2021-01-12 14:38:31"
/// updateDate : "2021-01-12 14:38:31"
/// paperType : ""
/// param1 : "1"
/// param2 : "399"
/// param3 : "2020"
/// param4 : ""
/// param5 : "存货"
/// param6 : ""
/// param7 : ""
/// param8 : ""
/// param9 : "0"
/// param10 : "0"
/// totalExamTime : 46

class ExamRecord {
  String _id;
  String _userId;
  String _paperUuid;
  int _typeId;
  String _paperName;
  String _examId;
  String _paperScore;
  String _examScore;
  int _questionNum;
  int _selectNum;
  int _doneNum;
  int _rightNum;
  int _wrongNum;
  int _isFirstTime;
  int _isComplete;
  String _productId;
  String _markMethod;
  String _praticeQids;
  int _status;
  String _createDate;
  String _updateDate;
  String _paperType;
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
  double _totalExamTime;

  String get id => _id;
  String get userId => _userId;
  String get paperUuid => _paperUuid;
  int get typeId => _typeId;
  String get paperName => _paperName;
  String get examId => _examId;
  String get paperScore => _paperScore;
  String get examScore => _examScore;
  int get questionNum => _questionNum;
  int get selectNum => _selectNum;
  int get doneNum => _doneNum;
  int get rightNum => _rightNum;
  int get wrongNum => _wrongNum;
  int get isFirstTime => _isFirstTime;
  int get isComplete => _isComplete;
  String get productId => _productId;
  String get markMethod => _markMethod;
  String get praticeQids => _praticeQids;
  int get status => _status;
  String get createDate => _createDate;
  String get updateDate => _updateDate;
  String get paperType => _paperType;
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
  double get totalExamTime => _totalExamTime;

  ExamRecord(
      {String id,
      String userId,
      String paperUuid,
      int typeId,
      String paperName,
      String examId,
      String paperScore,
      String examScore,
      int questionNum,
      int selectNum,
      int doneNum,
      int rightNum,
      int wrongNum,
      int isFirstTime,
      int isComplete,
      String productId,
      String markMethod,
      String praticeQids,
      int status,
      String createDate,
      String updateDate,
      String paperType,
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
      double totalExamTime}) {
    _id = id;
    _userId = userId;
    _paperUuid = paperUuid;
    _typeId = typeId;
    _paperName = paperName;
    _examId = examId;
    _paperScore = paperScore;
    _examScore = examScore;
    _questionNum = questionNum;
    _selectNum = selectNum;
    _doneNum = doneNum;
    _rightNum = rightNum;
    _wrongNum = wrongNum;
    _isFirstTime = isFirstTime;
    _isComplete = isComplete;
    _productId = productId;
    _markMethod = markMethod;
    _praticeQids = praticeQids;
    _status = status;
    _createDate = createDate;
    _updateDate = updateDate;
    _paperType = paperType;
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
    _totalExamTime = totalExamTime;
  }

  ExamRecord.fromJson(dynamic json) {
    _id = json["id"];
    _userId = json["userId"];
    _paperUuid = json["paperUuid"];
    _typeId = json["typeId"];
    _paperName = json["paperName"];
    _examId = json["examId"];
    _paperScore = json["paperScore"];
    _examScore = json["examScore"].toString();
    _questionNum = json["questionNum"];
    _selectNum = json["selectNum"];
    _doneNum = json["doneNum"];
    _rightNum = json["rightNum"];
    _wrongNum = json["wrongNum"];
    _isFirstTime = json["isFirstTime"];
    _isComplete = json["isComplete"];
    _productId = json["productId"];
    _markMethod = json["markMethod"];
    _praticeQids = json["praticeQids"];
    _status = json["status"];
    _createDate = json["createDate"];
    _updateDate = json["updateDate"];
    _paperType = json["paperType"];
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
    _totalExamTime = json["totalExamTime"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["userId"] = _userId;
    map["paperUuid"] = _paperUuid;
    map["typeId"] = _typeId;
    map["paperName"] = _paperName;
    map["examId"] = _examId;
    map["paperScore"] = _paperScore;
    map["examScore"] = _examScore;
    map["questionNum"] = _questionNum;
    map["selectNum"] = _selectNum;
    map["doneNum"] = _doneNum;
    map["rightNum"] = _rightNum;
    map["wrongNum"] = _wrongNum;
    map["isFirstTime"] = _isFirstTime;
    map["isComplete"] = _isComplete;
    map["productId"] = _productId;
    map["markMethod"] = _markMethod;
    map["praticeQids"] = _praticeQids;
    map["status"] = _status;
    map["createDate"] = _createDate;
    map["updateDate"] = _updateDate;
    map["paperType"] = _paperType;
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
    map["totalExamTime"] = _totalExamTime;
    return map;
  }
}
