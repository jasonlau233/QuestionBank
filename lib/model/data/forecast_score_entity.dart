///预测分趋势跟刷题天数
class ForecastScoreEntity {
  ///刷题天数
  int effectiveDayCount;

  ///预测分趋势
  List<AppAnalysisRecords> appAnalysisRecords;

  ForecastScoreEntity({this.effectiveDayCount, this.appAnalysisRecords});

  ForecastScoreEntity.fromJson(dynamic json) {
    effectiveDayCount = json["effectiveDayCount"];
    if (json["appAnalysisRecords"] != null) {
      appAnalysisRecords = [];
      json["appAnalysisRecords"].forEach((v) {
        appAnalysisRecords.add(AppAnalysisRecords.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["effectiveDayCount"] = effectiveDayCount;
    if (appAnalysisRecords != null) {
      map["appAnalysisRecords"] =
          appAnalysisRecords.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AppAnalysisRecords {
  ///日期  2021-01-25
  String date;

  ///预测分
  double predictionScore;
  int effectiveCount;

  AppAnalysisRecords({this.date, this.predictionScore, this.effectiveCount});

  AppAnalysisRecords.fromJson(dynamic json) {
    date = json["date"];
    predictionScore = json["predictionScore"];
    effectiveCount = json["effectiveCount"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["date"] = date;
    map["predictionScore"] = predictionScore;
    map["effectiveCount"] = effectiveCount;
    return map;
  }
}
