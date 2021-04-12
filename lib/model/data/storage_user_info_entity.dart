/// nickname : ""
/// token : ""
/// avatar : ""

/// 存储个人信息实体
class StorageUserInfoEntity {
  /// 昵称
  String _nickname;

  /// token
  String token;

  /// 头像
  String _avatar;

  /// UID
  int _uid;

  String get nickname => _nickname;

  String get avatar => _avatar;

  int get uid => _uid;

  StorageUserInfoEntity(
      {String nickname, String token, String avatar, int uid}) {
    _nickname = nickname;
    token = token;
    _avatar = avatar;
    _uid = uid;
  }

  StorageUserInfoEntity.fromJson(dynamic json) {
    _nickname = json["nickname"] ?? json["nickName"];
    token = json["token"];
    _avatar = json["avatar"];
    _uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["nickname"] = _nickname;
    map["token"] = token;
    map["avatar"] = _avatar;
    map["uid"] = _uid;
    return map;
  }

  StorageUserInfoEntity copyWith(
      {String nickname, String token, String avatar, int uid}) {
    return StorageUserInfoEntity(
      nickname: nickname ?? this._nickname,
      token: token ?? this.token,
      avatar: avatar ?? this._avatar,
      uid: uid ?? this._uid,
    );
  }

  @override
  String toString() {
    return 'StorageUserInfoEntity{_nickname: $_nickname, _token: $token, _avatar: $_avatar, _uid: $_uid}';
  }
}
