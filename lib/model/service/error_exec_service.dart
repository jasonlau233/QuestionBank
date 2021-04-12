import 'package:question_bank/constants/network_path_constants.dart';
import 'package:question_bank/core/manager.dart';
import 'package:question_bank/core/network/http.dart';
import 'package:question_bank/model/data/collect_module_entity.dart';
import 'package:question_bank/model/data/error_accord_chapter_entity.dart';
import 'package:question_bank/model/data/error_accord_source_entity.dart';

///错题管理的接口服务
class ErrorExecService {
  ///获取收藏按来源展开里面的模块
  static Future<List<FilterModuleEntity>> getSourceModule(int sublibraryId) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + childCollectModule,
        queryParameters: <String, dynamic>{"sublibraryId": sublibraryId},
      );
      return res.data["data"].map<FilterModuleEntity>((dynamic v) => FilterModuleEntity.fromJson(v)).toList();
    } catch (err) {
      print(err);
      return null;
    }
  }

  ///获取按来源的错题题目
  static Future<ErrorAccordSourceEntity> getSourceExers(int sublibraryModuleId) async {
    // try {
    var res = await HttpNativeClient.shared.get<dynamic>(
      Manager.shared.getMainHostUrl + childErrorAccordSource,
      queryParameters: <String, dynamic>{
        "sublibraryModuleId": sublibraryModuleId,
      },
    );
    return ErrorAccordSourceEntity.fromJson(res.data["data"]);
    // } catch (err) {
    //   print(err);
    //   return null;
    // }
  }

  ///获取按章节的错题题目
  static Future<ErrorAccordChapterEntity> getChapterExers(String sublibraryModuleId, int courseId) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + childErrorAccordChapter,
        queryParameters: <String, dynamic>{
          "sublibraryModuleIds": sublibraryModuleId,
          "courseId": courseId,
        },
      );
      return ErrorAccordChapterEntity.fromJson(res.data["data"]);
    } catch (err) {
      print(err);
      return null;
    }
  }
}
