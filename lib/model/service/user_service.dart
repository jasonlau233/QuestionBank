import '../../constants/network_path_constants.dart';
import '../../core/manager.dart';
import '../../core/network/http.dart';
import '../../model/data/storage_user_info_entity.dart';

class UserService {
  /// 获取用户数据
  static Future<StorageUserInfoEntity> userInfo() async {
    try {
      var res = await HttpNativeClient.shared.get<dynamic>(
        Manager.shared.getMainHostUrl + getUserInfo,
        queryParameters: <String, dynamic>{
          "token": Manager.shared.config.token,
        },
      );
      StorageUserInfoEntity storageUserInfoEntity =
          StorageUserInfoEntity.fromJson(res.data["data"]);
      storageUserInfoEntity.token = Manager.shared.config.token;
      return storageUserInfoEntity;
    } catch (err) {
      print(err);
      return null;
    }
  }
}
