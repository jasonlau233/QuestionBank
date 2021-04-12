import 'package:question_bank/em/view_state_type.dart';
import 'package:question_bank/model/data/error_accord_chapter_entity.dart';
import 'package:question_bank/model/data/error_accord_source_entity.dart';
import 'package:question_bank/model/data/question_distribution_entity.dart';
import 'package:question_bank/model/service/error_exec_service.dart';

import 'filter_controller_model.dart';

class ErrorExercisesModel extends FilterControllerViewModel {
  ///获取用户的错题列表的信息(章节列表)
  List<AppErrorQuestionBookChapterDtos> _chapterExers = const [];

  ///获取用户的错题列表的信息(来源列表)
  List<AppErrorPaperDtos> _sourceExers = const [];

  ///题目类型分布
  List<AppQuestionIdAndCountDtos> _appQuestionIdAndCountDtos = [];

  ///章节id
  int courseId;

  List<AppQuestionIdAndCountDtos> get appQuestionIdAndCountDtos => _appQuestionIdAndCountDtos;

  ///存错题id 跟examId的map
  Map<String, String> examIdMap = Map();

  set appQuestionIdAndCountDtos(List<AppQuestionIdAndCountDtos> value) {
    _appQuestionIdAndCountDtos = value;
    notifyListeners();
  }

  List<AppErrorPaperDtos> get sourceExers => _sourceExers;

  set sourceExers(List<AppErrorPaperDtos> value) {
    _sourceExers = value;
    notifyListeners();
  }

  List<AppErrorQuestionBookChapterDtos> get chapterExers => _chapterExers;

  set chapterExers(List<AppErrorQuestionBookChapterDtos> value) {
    _chapterExers = value;
    notifyListeners();
  }

  /// 获取用户的错题列表的信息(来源列表)
  @override
  Future<bool> getSourceExers() async {
    final ErrorAccordSourceEntity data = await ErrorExecService.getSourceExers(sourceSublibraryModuleId);
    sourceExers = data.appErrorPaperDtos;
    for (AppErrorPaperDtos appErrorPaperDtos in data.appErrorPaperDtos) {
      for (ErrorRecords errorRecords in appErrorPaperDtos.errorRecords) {
        examIdMap[errorRecords.questionId] = errorRecords.examId;
      }
    }
    if (data.appErrorPaperDtos != null && data.appErrorPaperDtos.isNotEmpty) {
      appQuestionIdAndCountDtos = data.appQuestionIdAndCountDtos;
      return true;
    }
    return false;
  }

  /// 获取用户的错题列表的信息(章节列表)
  @override
  Future<bool> getChapterExers() async {
    final ErrorAccordChapterEntity data = await ErrorExecService.getChapterExers(chapterSublibraryModuleId, courseId);
    viewState = ViewState.Idle;
    if (data.appErrorQuestionBookChapterDtos != null && data.appErrorQuestionBookChapterDtos.isNotEmpty) {
      chapterExers = data.appErrorQuestionBookChapterDtos;
      appQuestionIdAndCountDtos = data.appQuestionIdAndCountDtos;
      for (AppErrorQuestionBookChapterDtos chapterDtos in data.appErrorQuestionBookChapterDtos) {
        for (SectionList sectionList in chapterDtos.sectionList) {
          for (ErrorRecordChapters errorRecords in sectionList.errorRecords) {
            examIdMap[errorRecords.questionId] = errorRecords.examId;
          }
        }
      }
      return true;
    }
    return false;
  }
}
