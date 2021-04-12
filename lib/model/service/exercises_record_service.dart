import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/constants/network_path_constants.dart';
import 'package:question_bank/core/manager.dart';
import 'package:question_bank/core/network/http.dart';
import 'package:question_bank/em/pager_type.dart';
import 'package:question_bank/model/data/collect_module_entity.dart';
import 'package:question_bank/model/data/exercises_record_entity.dart';

///做题记录接口服务
class ExercisesRecordService {
  ///获取筛选模块
  static Future<List<FilterModuleEntity>> getSourceModule(
      int sublibraryId) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + childCollectModule,
        queryParameters: <String, dynamic>{"sublibraryId": sublibraryId},
      );
      return res.data["data"]
          .map<FilterModuleEntity>(
              (dynamic v) => FilterModuleEntity.fromJson(v))
          .toList();
    } catch (err) {
      print(err);
      return null;
    }
  }

  ///获取做题记录
  static Future<List<ExercisesRecordEntity>> getExercisesRecordEntity(
    int uid,
    int pageSize,
    int curPage, {
    int days,
    String typeId,
    String subModules,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "pid": BuildConfig.productLine,
        "uid": uid,
        "examId": "",
        "pageSize": pageSize,
        "curPage": curPage,
        "subModules": subModules,
      };
      if (days != null) {
        queryParameters.putIfAbsent("days", () => days);
      }
      if (typeId != null) {
        if (typeId == "PRACTICE") {
          queryParameters.putIfAbsent("typeId", () => PagerType.PRACTICE);
        } else if (typeId == "EXAM") {
          queryParameters.putIfAbsent("typeId", () => PagerType.EXAM);
        } else if (typeId == "ERROR") {
          queryParameters.putIfAbsent("typeId", () => PagerType.ERROR);
        }
      } else {
        queryParameters.putIfAbsent("typeId", () => 0);
      }

      /* ///测试参数
      Map<String, dynamic> queryParameters = {
        "pid": 2,
        "uid": 11136241,
        "examId": "",
        "pageSize": 10,
        "curPage": 1,
        "typeId": 1,
        "subModules": 239,
      };*/
      var res = await HttpNativeClient.shared.post<dynamic>(
        Manager.shared.getCoreHostUrl + exercisesRecord,
        queryParameters: queryParameters,
      );
      if (res.data["data"] != null &&
          res.data["data"]["pageInfo"] != null &&
          res.data["data"]["pageInfo"]['result'] != null) {
        if (res.data["data"]["pageInfo"]['result'] is List) {
          return res.data["data"]["pageInfo"]["result"]
              .map<ExercisesRecordEntity>(
                  (dynamic v) => ExercisesRecordEntity.fromJson(v))
              .toList();
        }
        return [];
      }
      return [];
    } catch (err) {
      print(err);
      return null;
    }
  }
}
