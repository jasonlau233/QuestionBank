import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/constants/network_path_constants.dart';
import 'package:question_bank/core/manager.dart';
import 'package:question_bank/core/network/http.dart';
import 'package:question_bank/model/data/report_entity.dart';
import 'package:question_bank/utils/download.dart';

///做题报告跟练习报告的Service，因为是同一个接口所以直接公用一个service

class ReportService {
  ///获取做题记录
  static Future<ReportEntity> getReportInfos(
      String recordId, String paperUuid, String questionIds,
      {String examId, int memType}) async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + getReportInfo,
        queryParameters: <String, dynamic>{
          "memType": memType,
          "recordId": recordId,
          "paperUuid": paperUuid,
          "questionIds": questionIds,
          "examId": examId,
          "pid": BuildConfig.productLine,
        },
      );
      return ReportEntity.fromJson(res.data["data"]);
    } catch (err) {
      print(err);
      return null;
    }
  }

  ///获取题目分组详情
  static Future<String> getQuestionsGroupInfo(String pagerId) async {
    try {
      String url =
          '${Manager.shared.getCoreFileHostUrl}/p/${pagerId[0]}/${pagerId}.json';
      print('url: $url');
      String jsonStr = await DownloadUtils.downloadReadAsString(url);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        return jsonStr;
      }
      return null;
    } catch (err) {
      print(err);
      return null;
    }
  }
}
