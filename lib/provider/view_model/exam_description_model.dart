import 'package:flutter/foundation.dart';
import 'package:question_bank/model/data/exam_group_count_entity.dart';
import 'package:question_bank/model/data/exam_topic_finish_number_entity.dart';
import 'package:question_bank/utils/logger.dart';

import '../../model/service/exam_service.dart';
import 'package:question_bank/provider/view_model/base_view_model.dart';

///
/// 试卷说明-数据绑定
///
class ExamDescriptionModel extends BaseViewModel {
  ExamDescriptionModel(this.examList);

  final List<ExamGroupCountEntity> examList;

  /// 获取某试卷的已做题数
  void getExamGroupStatus(String paperUuid, int examId) async {
    List<ExamTopicFinishNumberEntity> finishNumberList;
    try {
      finishNumberList = await ExamService.getExamGroupStatus(paperUuid, examId);
      if (examList?.isNotEmpty != true || finishNumberList?.isNotEmpty != true) return;
      Map<String, int> groupNum = {};
      examList?.forEach((element) {
        groupNum['${element.groupId}'] = element.finishNumber;
      });
      updateFinishNumber(groupNum);
    } catch (e, s) {
      print('$e---$s');
    }
  }

  /// 更新已做题数
  void updateFinishNumber(Map<String, int> groupNum) {
    if (groupNum?.isNotEmpty != true || examList?.isNotEmpty != true) return;
    examList.forEach((i) {
      var finishNumber = groupNum['${i.groupId}'];
      if (finishNumber != null) {
        i.finishNumber = finishNumber;
      }
    });
  }

  /// 更新已做题数
  void defaultFinishNumber() {
    if (examList?.isNotEmpty != true) return;
    examList.forEach(
      (i) {
        i.finishNumber = 0;
      },
    );
  }

  /// 标识当前考试状态为继续
  Future<bool> doUpdateExamStatus(int examId) async {
    try {
      return await ExamService.doUpdateExamStatus(examId);
    } catch (e, s) {
      LogUtils.instance.d('$e---$s');
      return false;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
