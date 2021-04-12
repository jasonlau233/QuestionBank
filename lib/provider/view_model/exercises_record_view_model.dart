import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/em/filter_time_type.dart';
import 'package:question_bank/model/data/collect_module_entity.dart';
import 'package:question_bank/model/data/exercises_record_entity.dart';
import 'package:question_bank/model/service/exercises_record_service.dart';

import 'base_view_model.dart';

class ExercisesRecordViewModel extends BaseViewModel {
  ///选择的类型
  String _typeText = '';

  String get typeText => _typeText;

  set typeText(String value) {
    _typeText = value;
    notifyListeners();
  }

  ///选择的时间
  String _timeText = '';

  String get timeText => _timeText;

  set timeText(String value) {
    _timeText = value;
    notifyListeners();
  }

  ///按来源展开的模块
  List<FilterModuleEntity> _sourceModuleList = const [];

  List<FilterModuleEntity> get sourceModuleList => _sourceModuleList;

  ///试卷类型:1为练习,2为试卷，3为测评，4为调研，5为高频错题
  String typeId;

  ///是否显示列表
  bool _showList = false;

  bool get showList => _showList;

  set showList(bool value) {
    _showList = value;
    notifyListeners();
  }

  set sourceModuleList(List<FilterModuleEntity> value) {
    _sourceModuleList = value;
    notifyListeners();
  }

  ///按照时间分类
  FilterTimeType _recordTimeType = FilterTimeType.ALL;

  FilterTimeType get recordTimeType => _recordTimeType;

  set recordTimeType(FilterTimeType value) {
    _recordTimeType = value;
    switch (value) {
      case FilterTimeType.ALL:
        days = null;
        break;
      case FilterTimeType.THREE_DAYS:
        days = 3;
        break;
      case FilterTimeType.A_WEEK:
        days = 7;
        break;
      case FilterTimeType.A_MONTH:
        days = 30;
        break;
    }
    notifyListeners();
  }

  ///时间筛选
  int days;

  ///模块id集合
  String subModules = '';

  /// 获取按来源展开的模块
  Future<bool> getSourceModuleList(int subLibraryId) async {
    final List<FilterModuleEntity> data =
        await ExercisesRecordService.getSourceModule(subLibraryId);
    for (int i = 0; i < data.length; i++) {
      if (i == data.length - 1) {
        subModules += data[i].id.toString();
      } else {
        subModules += "${data[i].id.toString()},";
      }
    }

    ///拼上错题本的id
    subModules += ",${BuildConfig.ERROR_ID}";
    FilterModuleEntity errorFilter = FilterModuleEntity();
    errorFilter.name = '错题本';
    errorFilter.type = 'ERROR';
    data.add(errorFilter);
    showList = true;
    if (data != null && data.isNotEmpty) {
      ///插入一个所有类型
      data.insert(0, FilterModuleEntity(name: '所有类型', type: null));
      sourceModuleList = data;
      typeId = sourceModuleList.first.type;
      typeText = sourceModuleList.first.name;
      return true;
    }
    return false;
  }

  /// 获取个人练习、试卷做题记录
  Future<List<ExercisesRecordEntity>> getExamRecordByPage(
      int uid, int offset) async {
    return await ExercisesRecordService.getExercisesRecordEntity(
        uid, 20, offset,
        typeId: typeId, days: days, subModules: subModules);
  }
}
