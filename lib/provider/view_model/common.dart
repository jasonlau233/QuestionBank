import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:question_bank/constants/storage_key_constants.dart';
import 'package:question_bank/utils/storage.dart';

import '../../model/data/storage_question_settings_entity.dart';
import '../../model/data/storage_user_info_entity.dart';
import '../../model/service/login_service.dart';
import '../../model/service/user_service.dart';

class Common with ChangeNotifier, DiagnosticableTreeMixin {
  /// 是否登录
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  ///是否第一次进入
  bool isFirstIn = true;

  /// 伴随全局的刷新题目验证，验证是否第一次进行设置过setting
  bool _isFirstSettings = true;

  bool get isFirstSettings => _isFirstSettings;

  set isFirstSettings(bool state) => _isFirstSettings = state;

  /// 子题库id
  String _subLibraryId = "";
  String get subLibraryId => _subLibraryId;
  set subLibraryId(String subLibraryId) => _subLibraryId = subLibraryId;

  /// 伴随全局的刷新题目规则
  StorageQuestionSettingsInfoEntity _settingsInfoEntity = StorageQuestionSettingsInfoEntity(
    mode: 0,
    numMode: 15,
    scope: 1,
  );

  /// 伴随全局的刷新题目规则(错题本使用)
  StorageQuestionSettingsInfoEntity _settingsErrorQuestionInfoEntity = StorageQuestionSettingsInfoEntity(
    mode: 0,
    numMode: 15,
    scope: 1,
  );

  StorageQuestionSettingsInfoEntity get settingsInfoEntity => _settingsInfoEntity;
  StorageQuestionSettingsInfoEntity get settingsErrorQuestionInfoEntity => _settingsErrorQuestionInfoEntity;

  set settingsInfoEntity(StorageQuestionSettingsInfoEntity entity) {
    if (_settingsInfoEntity == entity) {
      return;
    }
    _settingsInfoEntity = entity;
    notifyListeners();
  }

  set settingsErrorQuestionInfoEntity(StorageQuestionSettingsInfoEntity entity) {
    if (_settingsErrorQuestionInfoEntity == entity) {
      return;
    }
    _settingsErrorQuestionInfoEntity = entity;
    notifyListeners();
  }

  /// 重置设置
  void resetSettingsInfoEntity(int mode, int numMode, int scope) {
    _settingsInfoEntity = StorageQuestionSettingsInfoEntity(mode: mode, numMode: numMode, scope: scope);
    notifyListeners();
  }

  /// 重置设置
  void resetSettingsErrorQuestionInfoEntity(int mode, int numMode, int scope) {
    _settingsErrorQuestionInfoEntity = StorageQuestionSettingsInfoEntity(mode: mode, numMode: numMode, scope: scope);
    notifyListeners();
  }

  /// 本地存储的用户信息
  StorageUserInfoEntity _storageUserInfoEntity;

  StorageUserInfoEntity get storageUserInfoEntity => _storageUserInfoEntity;

  /// 退出登录服务器
  Future<void> exitLoginToServer() async => await LoginService.exitUserLoginToServer();

  /// 获取用户信息
  Future<StorageUserInfoEntity> getUserInfo(String token) async {
    return await UserService.userInfo();
  }

  set storageUserInfoEntity(StorageUserInfoEntity entity) {
    if (_storageUserInfoEntity == entity) {
      return;
    }
    _storageUserInfoEntity = entity;
    notifyListeners();
  }

  /// 登录
  void setLogin(StorageUserInfoEntity entity) {
    _isLogin = true;
    storageUserInfoEntity = entity;
  }

  /// 登录
  void setLoginStatus() => _isLogin = true;

  /// 退出登录
  exitLogin() async {
    await StorageUtils.remove(STORAGE_USER_INFO_KEY);
    _isLogin = false;
  }

  /// 新增一个管理章节练习对应的map,用于本地生命周期内使用
  Map<String, String> _sectionMap = {};

  Map<String, String> get sectionMap => _sectionMap;

  /// 章节id => 临时的记录id
  setSectionMap(String key, String recordId) async {
    _sectionMap[key] = recordId;
  }

  /// 章节id => 临时的记录id
  removeSectionMap(String key) async {
    _sectionMap.remove(key);
  }

  /// 新增一个考试
  Map<String, String> _examMap = {};

  Map<String, String> get examMap => _examMap;

  /// 考试id => 提交返回的记录id
  setExamMap(String key, String recordId) async {
    _examMap[key] = recordId;
  }

  /// 考试id => 提交返回的记录id
  removeExamMap(String key) async {
    _examMap.remove(key);
  }

  /// Makes `Common` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
