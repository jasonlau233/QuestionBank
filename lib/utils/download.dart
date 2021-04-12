import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

///下载工具类
class DownloadUtils {
  ///下载文件并转化为String
  static Future<String> downloadReadAsString(String url,
      {String folderName = 'pager', String suffix = '.json'}) async {
    try {
      Dio dio = Dio();
      Directory dir = await getApplicationSupportDirectory();
      String savePath =
          '${dir.path}/$folderName/${DateTime.now().millisecondsSinceEpoch}$suffix';
      Response response = await dio.download(url, savePath);
      print(response.statusCode);
      print(response.statusMessage);
      if (response.statusCode == 200) {
        return File(savePath).readAsStringSync();
      } else {
        print(response.statusMessage);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
