import '../../model/data/chapter_practice_entity.dart';
import '../../model/data/pratice_tab_dynamic_module_info_entity.dart';
import '../../model/data/practice_tab_entity.dart';
import '../../constants/network_path_constants.dart';
import '../../core/manager.dart';
import '../../core/network/http.dart';

class PracticeService {
  /// 获取字体库选项tab
  static Future<List<PracticeTabEntity>> getChapterList(int proId) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + childQuestionBankList,
        queryParameters: <String, dynamic>{"proId": proId},
      );
      return res.data["data"].map<PracticeTabEntity>((dynamic v) => PracticeTabEntity.fromJson(v)).toList();
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 获取动态模块下面的banner和导航按钮
  static Future<PracticeTabDynamicModuleInfoEntity> getSubLibraryModuleInfo(
      int subLibraryId, int proId, int productId) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + childSubLibraryModuleListItem,
        queryParameters: <String, dynamic>{"proId": proId, "productId": productId, "sublibraryId": subLibraryId},
      );
      return PracticeTabDynamicModuleInfoEntity.fromJson(res.data["data"]["appContentMaps"]);
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// app根据题库模块ID和科目ID获取练习信息
  static Future<ChapterPracticeEntity> getSubLibraryModulePractice(int courseId, int subLibraryModuleId) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + childPracticeItem,
        queryParameters: <String, dynamic>{"sublibraryModuleId": subLibraryModuleId, "courseId": courseId},
      );
      return ChapterPracticeEntity.fromJson(res.data["data"]);
    } catch (err) {
      print(err);
      return null;
    }
  }
}
