import 'package:flutter/foundation.dart';
import 'package:question_bank/em/filter_according_type.dart';
import 'package:question_bank/em/filter_time_type.dart';
import 'package:question_bank/em/view_state_type.dart';
import 'package:question_bank/model/data/collect_module_entity.dart';
import 'package:question_bank/model/service/collect_service.dart';
import 'package:question_bank/modules/widget/filter_controller.dart';
import 'package:question_bank/provider/view_model/base_view_model.dart';

class FilterControllerViewModel extends BaseViewModel with DiagnosticableTreeMixin implements FilterAction {
  //来源
  FilterComeFromType comeFromType;

  ///按照来源分类
  String _collectSourceType = '';

  ///按照时间分类
  FilterTimeType _collectTimeType = FilterTimeType.ALL;

  ///三个分类维度  按章节  按来源   按时间  默认按照章节
  FilterAccordingType _collectAccordingType = FilterAccordingType.ACCORDING_CHAPTER;

  ///时间筛选
  int _filterTime = FilterTimeType.ALL.index;

  ///按来源展开的模块
  List<FilterModuleEntity> _sourceModuleList = const [];

  ///已选来源模块id
  int _sourceSublibraryModuleId;

  ///已选章节模块id
  String chapterSublibraryModuleId = '';

  ///被选择的模块id
  String typeId = '';

  int get sourceSublibraryModuleId => _sourceSublibraryModuleId;

  set sourceSublibraryModuleId(int value) {
    _sourceSublibraryModuleId = value;
    notifyListeners();
  }

  List<FilterModuleEntity> get sourceModuleList => _sourceModuleList;

  set sourceModuleList(List<FilterModuleEntity> value) {
    _sourceModuleList = value;
    notifyListeners();
  }

  String get collectSourceType => _collectSourceType;

  set collectSourceType(String value) {
    _collectSourceType = value;
    notifyListeners();
  }

  FilterTimeType get collectTimeType => _collectTimeType;

  set collectTimeType(FilterTimeType value) {
    _collectTimeType = value;
    notifyListeners();
  }

  FilterAccordingType get collectAccordingType => _collectAccordingType;

  set collectAccordingType(FilterAccordingType value) {
    _collectAccordingType = value;
    if (value == FilterAccordingType.ACCORDING_CHAPTER) {
      getChapterExers();
    } else if (value == FilterAccordingType.ACCORDING_SOURCE) {
      getSourceExers();
    }
    notifyListeners();
  }

  /// 获取按来源展开的模块
  Future<bool> getSourceModuleList(int subLibraryId) async {
    viewState = ViewState.Loading;
    final List<FilterModuleEntity> data = await CollectService.getSourceModule(subLibraryId);
    if (data != null && data.isNotEmpty) {
      sourceModuleList = data;
      collectSourceType = sourceModuleList.first.name;
      sourceSublibraryModuleId = sourceModuleList.first.id;
      for (int i = 0; i < sourceModuleList.length; i++) {
        if (i == sourceModuleList.length - 1) {
          chapterSublibraryModuleId += sourceModuleList[i].id.toString();
        } else {
          chapterSublibraryModuleId += '${sourceModuleList[i].id},';
        }
      }
      if (collectAccordingType == FilterAccordingType.ACCORDING_CHAPTER) {
        getChapterExers();
      }
      return true;
    }
    return false;
  }

  @override
  Future<bool> getChapterExers() {
    // TODO: implement getChapterExers
    throw UnimplementedError();
  }

  @override
  Future<bool> getSourceExers() {
    // TODO: implement getSourceExers
    throw UnimplementedError();
  }

  int get filterTime => _filterTime;

  set filterTime(int value) {
    _filterTime = value;
    if (_collectAccordingType == FilterAccordingType.ACCORDING_CHAPTER) {
      getChapterExers();
    } else if (_collectAccordingType == FilterAccordingType.ACCORDING_SOURCE) {
      getSourceExers();
    }
  }
}

class FilterAction {
  /// 获取用户的收藏列表的信息(来源列表)
  Future<bool> getSourceExers() async {}

  /// 获取用户的收藏列表的信息(章节列表)
  Future<bool> getChapterExers() async {}
}
