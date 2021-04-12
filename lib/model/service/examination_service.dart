import 'package:dio/dio.dart';
import 'package:question_bank/model/data/paper_answer_entity.dart';

import '../../model/data/exam_info_entity.dart';
import '../../constants/network_path_constants.dart';
import '../../core/manager.dart';
import '../../core/network/http.dart';

class ExaminationService {
  /// 获取试卷信息
  static Future<ExamInfoEntity> getPaperInfo(String paperUuid, String examId) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + exampPagerInfo,
        queryParameters: <String, dynamic>{"paperUuid": paperUuid, "examId": examId},
        options: Options(
          extra: {"x-request-loading": true, "x-request-message": "正在加载..."},
        ),
      );
      return ExamInfoEntity.fromJson(res.data["data"]);
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取对应的考试试卷原始数据
  static Future<List<Groups>> getDefaultPaperGroupsInfo(String jsonUrl) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getCoreFileHostUrl + jsonUrl,
        options: Options(responseType: ResponseType.json),
      );
      return res.data["groups"].map<Groups>((dynamic v) => Groups.fromJson(v)).toList();
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取对应的考试试卷原始数据
  static Future<ExamInfoEntity> getDefaultPaperInfo(String pagerId) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getCoreFileHostUrl +
            "/p/${pagerId[0]}/$pagerId.json?v=" +
            DateTime.now().millisecondsSinceEpoch.toString(),
        options: Options(responseType: ResponseType.json),
      );
      return ExamInfoEntity.fromJson(res.data);
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 提交试卷信息
  static Future<String> submitPaper(Map<String, dynamic> params) async {
    try {
      var res = await HttpNativeClient.shared.post<dynamic>(
        Manager.shared.getCoreHostUrl + coreSubmitPaper,
        data: params,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          extra: {"x-request-loading": true, "x-request-message": "正在提交试卷"},
        ),
      );
      return res.data["data"]["examRecordId"];
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取考点信息
  static Future<Map<String, dynamic>> getExamPoint(String pointIds) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + getExamPointInfo,
        queryParameters: {"knowledgeIds": pointIds},
      );
      if (res.data["data"] != null) {
        return res.data["data"];
      }
      return null;
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取收藏信息
  static Future<Map<String, dynamic>> getCollectInfo(String paperId) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + getCollectionsBypaperUuid,
        queryParameters: {"paperUuid": paperId},
      );
      if (res.data["data"] != null) {
        return res.data["data"];
      }
      return null;
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取来源信息
  static Future<Map<String, dynamic>> getOrigin() async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + getOriginInfo,
      );
      if (res.data["data"] != null) {
        return res.data["data"];
      }
      return null;
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取正确率 易错项目
  static Future<Map<String, dynamic>> getOptionStatisticsByUuidQids(String paperId, String ids, String examId) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + getOptionStatistics,
        queryParameters: <String, dynamic>{
          "paperUuid": paperId,
          "questionIds": ids,
          "examId": examId,
        },
      );
      if (res.data["data"] != null) {
        return res.data["data"];
      }
      return null;
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取正确率 易错项目
  static Future<Map<String, dynamic>> getQuestionErrNumInfo(String paperId, String examId) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + getErrorQuestionNum,
        queryParameters: <String, dynamic>{"paperUuid": paperId, "examId": examId},
      );
      if (res.data["data"] != null) {
        return res.data["data"];
      }
      return null;
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取以前的答题记录
  static Future<Map<String, dynamic>> getHistoryExamRecord(int uid, String paperUuid, String examId) async {
    try {
      var res = await HttpNativeClient.shared.post<dynamic>(
        Manager.shared.getCoreHostUrl + getHistoryExamedRecord,
        queryParameters: <String, dynamic>{
          "paperUuid": paperUuid,
          "uid": uid,
          "examId": examId,
        },
      );
      if (res.data["data"] != null) {
        return res.data["data"]["examRecords"];
      }
      return null;
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取最近一次得做题记录,转化为最近一次得做题记录的recordID的实体
  static Future<PaperAnswerEntity> getExamedRecordInfo(
    int uid,
    String paperUuid,
    String examId, {
    int memType: 0,
  }) async {
    try {
      var res = await HttpNativeClient.shared.post<dynamic>(
        Manager.shared.getCoreHostUrl + getExamedRecord,
        queryParameters: <String, dynamic>{
          "paperUuid": paperUuid,
          "uid": uid,
          "examId": examId,
          "memType": memType,
        },
        options: Options(
          extra: {"x-request-loading": true, "x-request-message": "正在查找最近的记录"},
        ),
      );
      if (res.data["data"] == null) {
        return null;
      }

      if (res.data["data"]["examRecords"] != null) {
        final List<ExamDetails> examDetails = [];
        final List<String> questionId = [];

        if (res.data["data"]["examRecords"]["answers"] != null) {
          res.data["data"]["examRecords"]["answers"].forEach(
            (dynamic k, dynamic v) {
              questionId.add(k);
              examDetails.add(
                ExamDetails(
                  questionId: k,
                  isAnyQuestions: v["isAnyQuestions"],
                  userAnswer: v["userAnswer"],
                  usedTime: double.tryParse(v["usedTime"].toString()),
                  id: v["recordDetailId"],
                ),
              );
            },
          );
        }

        return PaperAnswerEntity(
          examDetail: ExamDetail(
            examRecord: ExamRecord(
              id: res.data["data"]["examRecords"]["examRecordId"],
              paperUuid: res.data["data"]["examRecords"]["paperUuid"],
              examId: res.data["data"]["examRecords"]["examId"],
              param1: res.data["data"]["examRecords"]["param1"],
              param2: res.data["data"]["examRecords"]["param2"],
              param3: res.data["data"]["examRecords"]["param3"],
              param4: res.data["data"]["examRecords"]["param4"],
              param5: res.data["data"]["examRecords"]["param5"],
              param6: res.data["data"]["examRecords"]["param6"],
              param7: res.data["data"]["examRecords"]["param7"],
              param8: res.data["data"]["examRecords"]["param8"],
              param9: res.data["data"]["examRecords"]["param9"],
              param10: res.data["data"]["examRecords"]["param10"],
              praticeQids: questionId.join(","),
            ),
            examDetails: examDetails,
          ),
        );
      }
      return null;
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取以前的答题记录
  static Future<PaperAnswerEntity> getSomeoneRecordInfo(String recordId) async {
    try {
      var res = await HttpNativeClient.shared.post<dynamic>(
        Manager.shared.getCoreHostUrl + getExamDetailByRecordId,
        queryParameters: <String, dynamic>{
          "recordId": recordId,
        },
      );

      return PaperAnswerEntity.fromJson(res.data["data"]);
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取以前的答题记录
  static Future<bool> removeErrorQuestionItem(Map<String, dynamic> params) async {
    try {
      await HttpNativeClient.shared.post<dynamic>(
        Manager.shared.getCoreHostUrl + removeErrorQuestion,
        queryParameters: params,
      );
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
