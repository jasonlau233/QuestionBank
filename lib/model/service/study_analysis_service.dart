import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/constants/network_path_constants.dart';
import 'package:question_bank/core/manager.dart';
import 'package:question_bank/core/network/http.dart';
import 'package:question_bank/model/data/forecast_score_entity.dart';
import 'package:question_bank/model/data/study_analysis_entity.dart';

///学情分析service
class StudyAnalysisService {
  ///获取预测分
  static Future<ForecastScoreEntity> getForcastScore(
    int subLibraryId,
    int days,
  ) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + forecastScore,
        queryParameters: <String, dynamic>{
          "productId": BuildConfig.productLine,
          "subLibraryId": subLibraryId,
          "day": days,
        },
      );
      return ForecastScoreEntity.fromJson(res.data["data"]);
    } catch (err) {
      print(err);
      return null;
    }
  }

  ///获取学情报告信息
  static Future<StudyAnalysisChapterSectionEntity>
      getStudyAnalysisChapterSection(
    int subLibraryId,
    bool refresh,
  ) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + studyAnalysisChapterAndSection,
        queryParameters: <String, dynamic>{
          "productId": BuildConfig.productLine,
          "subLibraryId": subLibraryId,
          "refresh": refresh,
        },
      );
      return StudyAnalysisChapterSectionEntity.fromJson(res.data["data"]);
    } catch (err) {
      print(err);
      return null;
    }
  }
}
