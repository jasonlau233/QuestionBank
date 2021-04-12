import 'dart:math';

import 'package:question_bank/em/view_state_type.dart';
import 'package:question_bank/model/data/forecast_score_entity.dart';
import 'package:question_bank/model/data/study_analysis_entity.dart';
import 'package:question_bank/model/service/study_analysis_service.dart';
import 'package:question_bank/provider/view_model/base_view_model.dart';

///学情分析的model
class StudyAnalysisModel extends BaseViewModel {
  final int subLibraryId;

  StudyAnalysisModel(this.subLibraryId);

  ///预测分
  ForecastScoreEntity _forecastScoreEntity;

  ///学情报告信息
  StudyAnalysisChapterSectionEntity _studyAnalysisChapterSectionEntity;

  int _selectedChapterIndex = 0;

  int get selectedChapterIndex => _selectedChapterIndex;

  set selectedChapterIndex(int value) {
    _selectedChapterIndex = value;
    notifyListeners();
  }

  ForecastScoreEntity get forecastScoreEntity => _forecastScoreEntity;

  set forecastScoreEntity(ForecastScoreEntity value) {
    _forecastScoreEntity = value;
    notifyListeners();
  }

  StudyAnalysisChapterSectionEntity get studyAnalysisChapterSectionEntity =>
      _studyAnalysisChapterSectionEntity;

  set studyAnalysisChapterSectionEntity(
      StudyAnalysisChapterSectionEntity value) {
    _studyAnalysisChapterSectionEntity = value;
    notifyListeners();
  }

  ///获取预测分
  Future<bool> getForcastScore() async {
    viewState = ViewState.Loading;
    try {
      forecastScoreEntity =
          await StudyAnalysisService.getForcastScore(subLibraryId, 9);
      if (studyAnalysisChapterSectionEntity != null) {
        viewState = ViewState.Idle;
      }
    } catch (e) {
      viewState = ViewState.Error;
    }
  }

  ///获取学情报告信息
  Future<bool> getStudyAnalysisChapterSection() async {
    viewState = ViewState.Loading;
    try {
      studyAnalysisChapterSectionEntity =
          await StudyAnalysisService.getStudyAnalysisChapterSection(
              subLibraryId, false);
      if (forecastScoreEntity != null) {
        viewState = ViewState.Idle;
      }
    } catch (e) {
      viewState = ViewState.Error;
    }
  }

  ///用时
  String useTime(double seconds) {
    if (seconds < 60 && seconds >= 0) {
      return '$seconds\'\'';
    } else {
      if (seconds ~/ 60 > 0 && seconds ~/ 60 < 60) {
        return '${seconds ~/ 60}\'${getScore(seconds % 60)}\"';
      } else {
        if (seconds ~/ 3600 > 99) {
          return '99+ 小时';
        }
        return '${seconds ~/ 3600}:${seconds ~/ 60 % 60}\'${getScore(seconds % 60)}\"';
      }
    }
  }

  ///list转为String
  String listToStr(List<String> list) {
    if (list.length > 10) {
      final _random = new Random();
      List<String> listRandom = [];
      for (int i = 1; i <= 6; i++) {
        listRandom.add(list[_random.nextInt(list.length - 1)]);
      }
      list = listRandom;
    }
    String str = '';
    for (int i = 0; i < list.length; i++) {
      if (i != list.length - 1) {
        str += '${list[i]},';
      } else {
        str += '${list[i]}';
      }
    }
    return str;
  }

  ///如果是.0取整
  String getScore(double score) {
    String scoreStr = score.toString();
    if (scoreStr.contains('.')) {
      List<String> sqlit = scoreStr.split('.');
      if (sqlit[1] == '0') {
        return score.toInt().toString();
      } else {
        return score.toStringAsFixed(1);
      }
    } else {
      score.toStringAsFixed(1);
    }
  }
}
