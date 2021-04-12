///做题记录-列表item实体类
///创建者-v0.5版本-况韬
///更新者-xx版本-xx
class ExercisesRecordEntity {
  String updateDate; //记录时间
  int doneNum; //已做数
  int selectNum; //题目数
  int rightNum; // 做对数
  String param5; // 标题
  String param2; //subModuleId
  String param10; //做题模式
  String param9; // 标题
  double examScore; // 得分
  String paperUuid; //试卷id
  String examId; //考试id
  String id; //记录id
  String praticeQids; //题目id
  int typeId; //类型id 试卷类型:1为练习,2为试卷，3为测评，4为调研，5为高频错题
  String paperName; //题目名字

  ExercisesRecordEntity(
      {this.updateDate,
      this.doneNum,
      this.selectNum,
      this.rightNum,
      this.param5,
      this.param2,
      this.param10,
      this.param9,
      this.examScore,
      this.paperUuid,
      this.examId,
      this.id,
      this.praticeQids,
      this.typeId,
      this.paperName});

  ExercisesRecordEntity.fromJson(Map<String, dynamic> json) {
    updateDate = json['updateDate'];
    doneNum = json['doneNum'];
    selectNum = json['selectNum'];
    rightNum = json['rightNum'];
    param5 = json['param5'];
    param2 = json['param2'];
    param10 = json['param10'];
    param9 = json['param9'];
    examScore = json['examScore'];
    paperUuid = json['paperUuid'];
    examId = json['examId'];
    id = json['id'];
    praticeQids = json['praticeQids'];
    typeId = json['typeId'];
    paperName = json['paperName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updateDate'] = this.updateDate;
    data['doneNum'] = this.doneNum;
    data['selectNum'] = this.selectNum;
    data['rightNum'] = this.rightNum;
    data['param5'] = this.param5;
    data['param2'] = this.param2;
    data['param10'] = this.param10;
    data['param9'] = this.param9;
    data['examScore'] = this.examScore;
    data['paperUuid'] = this.paperUuid;
    data['examId'] = this.examId;
    data['id'] = this.id;
    data['praticeQids'] = this.praticeQids;
    data['typeId'] = this.typeId;
    data['paperName'] = this.paperName;
    return data;
  }
}
