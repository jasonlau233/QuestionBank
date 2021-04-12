import 'package:question_bank/constants/network_path_constants.dart';
import 'package:question_bank/core/manager.dart';
import 'package:question_bank/core/network/http.dart';
import 'package:question_bank/model/data/collect_accord_chapter_entity.dart';
import 'package:question_bank/model/data/collect_accord_source_entity.dart';
import 'package:question_bank/model/data/collect_module_entity.dart';

///收藏的接口服务
class CollectService {
  ///获取收藏按来源展开里面的模块
  static Future<List<FilterModuleEntity>> getSourceModule(int sublibraryId) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + childCollectModule,
        queryParameters: <String, dynamic>{
          "sublibraryId": sublibraryId,
        },
      );
      return res.data["data"].map<FilterModuleEntity>((dynamic v) => FilterModuleEntity.fromJson(v)).toList();
    } catch (err) {
      print(err);
      return null;
    }
  }

  ///获取按来源的收藏题目
  static Future<List<CollectAccordSourceEntity>> getSourceExers(int sublibraryModuleId, int filterTime) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + childCollectAccordSource,
        queryParameters: <String, dynamic>{
          "sublibraryModuleId": sublibraryModuleId,
          "filterTime": filterTime,
        },
      );
      return res.data["data"].map<CollectAccordSourceEntity>((dynamic v) => CollectAccordSourceEntity.fromJson(v)).toList();
    } catch (err) {
      print(err);
      return null;
    }
  }

  ///获取按章节的收藏题目
  static Future<List<AppCollectionChapterList>> getChapterExers(String sublibraryModuleId, int courseId, filterTime) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + childCollectAccordChapter,
        queryParameters: <String, dynamic>{
          "sublibraryModuleIds": sublibraryModuleId,
          "courseId": courseId,
          "filterTime": filterTime,
        },
      );
      return CollectAccordChapterEntity.fromJson(res.data["data"]).appCollectionChapterList;
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 收藏题目
  static Future<String> addCollectQuestionItem(String paperUuid, int questionId, int userId, String subModuleId, String chapterCode) async {
    try {
      var res = await HttpNativeClient.shared.post<dynamic>(
        Manager.shared.getCoreHostUrl + addCollect,
        data: <String, dynamic>{
          "paperUuid": paperUuid,
          "questionId": questionId,
          "userId": userId,
          "subModuleId": subModuleId,
          "chapterCode": subModuleId,
        },
      );
      return res.data["data"]["myCollection"]["id"];
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 取消收藏题目
  static Future<bool> cancelCollectQuestionItem(String collectId, int userId) async {
    try {
      await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getCoreHostUrl + cancelCollect,
        queryParameters: <String, dynamic>{"id": collectId, "uid": userId},
      );
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
