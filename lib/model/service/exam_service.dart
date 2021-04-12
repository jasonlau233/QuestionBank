import 'package:dio/dio.dart';
import 'package:question_bank/model/data/exam_topic_finish_number_entity.dart';
import '../../model/data/exam_list_item_entity.dart';

import '../../constants/network_path_constants.dart';
import '../../core/manager.dart';
import '../../core/network/http.dart';

///
/// 试卷模块的数据服务类
///
class ExamService {
  /// 获取试卷信息
  static Future<List<ExamListItemEntity>> getTestExercisesList(int sublibraryModuleId, {showLoading = true}) async {
    var res = await HttpNativeClient.shared.get<dynamic>(
      Manager.shared.getMainHostUrl + testExercisesList,
      queryParameters: <String, dynamic>{"sublibraryModuleId": sublibraryModuleId},
      options: Options(),
    );
    return res.data["data"]?.map<ExamListItemEntity>((v) => ExamListItemEntity.fromJson(v))?.toList();
  }

  /// 获取某试卷的已做题数
  static Future<List<ExamTopicFinishNumberEntity>> getExamGroupStatus(
    String paperUuid,
    int examId,
  ) async {
    var res = await HttpNativeClient.shared.get<dynamic>(
      Manager.shared.getMainHostUrl + examGetExamGroupStatus,
      queryParameters: {'paperUuid': paperUuid, 'examId': examId},
      options: Options(
          // extra: {"x-request-loading": true, "x-request-message": "正在加载..."},
          ),
    );
    return res.data["data"]?.map<ExamTopicFinishNumberEntity>((v) => ExamTopicFinishNumberEntity.fromJson(v))?.toList();
  }

  /// 标识当前考试状态为继续
  static Future<bool> doUpdateExamStatus(int examId) async {
    var res = await HttpNativeClient.shared.get<dynamic>(
      Manager.shared.getMainHostUrl + updateExamStatus,
      queryParameters: {'examId': examId},
      options: Options(
        extra: {"x-request-loading": true, "x-request-message": "正在加载..."},
      ),
    );
    return true;
  }
}
