import 'package:flutter/foundation.dart';
import 'package:question_bank/em/view_state_type.dart';
import 'package:question_bank/utils/logger.dart';
import '../../model/data/exam_list_item_entity.dart';

import '../../model/service/exam_service.dart';
import 'package:question_bank/provider/view_model/base_view_model.dart';

///
/// 试卷列表-数据绑定
///
class ExamListViewModel extends BaseViewModel {
  /// 试卷列表
  List<ExamListItemEntity> _examList = [];

  List<ExamListItemEntity> get examList => _examList;

  set examList(List<ExamListItemEntity> items) {
    if (items == _examList) return;
    _examList = items;
    notifyListeners();
  }

  /// 获取试卷信息
  void getExamList(int sublibraryModuleId) async {
    try {
      examList = await ExamService.getTestExercisesList(sublibraryModuleId);
      if (examList?.isNotEmpty != true) {
        viewState = ViewState.Empty;
      } else {
        viewState = ViewState.Idle;
      }
    } catch (e, s) {
      LogUtils.instance.e('获取试卷列表发生错误', e, s);
      viewState = ViewState.Error;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
