import 'package:flutter/material.dart';
import 'package:flutter_poly_v_plugin/widget/poly_v_full_screen_page.dart';
import 'package:question_bank/modules/pages/examination_paper/exam_description_page.dart';
import 'package:question_bank/modules/pages/examination_paper/exam_list_page.dart';
import 'package:question_bank/modules/pages/exercises_report_page.dart';
import 'package:question_bank/modules/pages/guide_page.dart';
import 'package:question_bank/modules/pages/study_analysis_page.dart';
import 'package:question_bank/modules/pages/test_exercises_report_page.dart';

import '../modules/pages/captcha_page.dart';
import '../modules/pages/error_exercises_record_page.dart';
import '../modules/pages/examination/examination_page.dart';
import '../modules/pages/exercises_page.dart';
import '../modules/pages/exercises_record_page.dart';
import '../modules/pages/login_page.dart';
import '../modules/pages/my_collect_page.dart';
import '../modules/pages/root/root_page.dart';
import '../modules/pages/user_manal_page.dart';
import '../modules/pages/user_privacy_agreement_page.dart';
import 'path.dart';

/// 获取路由组
Page<dynamic> getRoute(
  String path, {
  Map<String, dynamic> params,
}) {
  Widget child;
  switch (path) {

    /// 首页
    /// 登录
    /// 验证码
    /// 用户手册协议
    /// 隐私协议
    case ROOT_PATH:
      child = RootPage();
      break;
    case LOGIN_PATH:
      child = LoginPage();
      break;
    case CAPTCHA_PATH:
      child = CaptchaPage(phone: params["phone"]);
      break;
    case USER_MANUAL_PATH:
      child = UserManualPage(url: params["url"]);
      break;
    case USER_PRIVACY_AGREEMENT_PATH:
      child = UserPrivacyAgreementPage(url: params["url"]);
      break;

    /// 练习页面
    /// 考试页面
    /// 错误管理页面
    /// 我的收藏
    /// 做题记录
    /// title都是后台给到的
    case EXEC_PATH:
      child = ExercisesPage(
        title: params["title"],
        model: params["model"],
        index: params["index"],
      );
      break;
    case EXAM_LIST:
      child = ExamListPage(
        title: params["title"],
        subLibraryModuleId: params["subLibraryModuleId"],
      );
      break;
    case ERR_EXEC_RECORD_PATH:
      child = ErrorExercisesRecordPage(
        title: params["title"],
        subLibraryId: params['subLibraryId'],
        courseId: params['courseId'],
      );
      break;
    case MY_COLLECTION_PATH:
      child = MyCollectPage(
        title: params["title"],
        subLibraryId: params['subLibraryId'],
        courseId: params['courseId'],
      );
      break;
    case EXEC_RECORD_PATH:
      child = ExercisesRecordPage(
        title: params["title"],
        subLibraryId: params['subLibraryId'],
      );
      break;

    /// 做题页面
    case EXAMINATION_PATH:
      child = ExaminationPage(
        type: params["type"],
        paperUuid: params["paperUuid"],
        examId: params["examId"],
        title: params["title"],
        mainTitle: params["mainTitle"],
        timeType: params["timeType"],
        responseTime: params["responseTime"],
        subModuleId: params["subModuleId"],
        subLibraryModuleId: params["subLibraryModuleId"],
        subLibraryModuleName: params["subLibraryModuleName"],
        errorQuestionIdList: params["errorQuestionIdList"],
        chooseQuestionIdList: params["chooseQuestionIdList"],
        reportCardEntity: params["reportCardEntity"],
        groupId: params['groupId'],
        onPaperConfirmListener: params['onPaperConfirmListener'],
        examPaperInfo: params['examPaperInfo'],
        questionIdList: params['questionIdList'],
        origin: params['origin'],
        collectIdMap: params['collectIdMap'],
        defaultQuestionId: params["defaultQuestionId"],
        defaultQuestionChildIndex: params["defaultQuestionChildIndex"],
        paperDataMap: params["paperDataMap"],
        showProblem: params["showProblem"] ?? true,
        onlyNeedQuestionList: params["onlyNeedQuestionList"],
        onlyChildQuestionList: params["onlyChildQuestionList"],
        recordId: params["recordId"],
        paperAnswerEntity: params["paperAnswerEntity"],
        errorQuestionExamId: params["errorQuestionExamId"],
      );
      break;

//      sublibraryModuleId: params["sublibraryModuleId"],
//  title: params["历年真题"]

    ///做题报告页面
    case EXEC_REPORT:
      child = ExercisesReportPage(
          title: params['title'],
          mainTitle: params['mainTitle'],
          recordId: params['recordId'],
          paperUuid: params['paperUuid'],
          examId: params['examId'],
          pid: params['pid'],
          questionIds: params['questionIds'],
          subModuleId: params['subModuleId'],
          subModuleName: params['subModuleName'],
          mode: params['mode'],
          groupInfo: params['groupInfo'],
          memType: params['memType']);
      break;

    ///考试报告页面
    case TEST_EXEC_REPORT:
      child = TestExercisesReportPage(
          title: params['title'],
          mainTitle: params['mainTitle'],
          recordId: params['recordId'],
          paperUuid: params['paperUuid'],
          examId: params['examId'],
          pid: params['pid'],
          questionIds: params['questionIds'],
          subModuleId: params['subModuleId'],
          groupInfo: params['groupInfo'],
          memType: params['memType']);
      break;

    /// 试卷说明页面
    case EXAM_DESCRIPTION:
      child = ExamDescriptionPage(
        instructions: params['instructions'],
        examList: params['examList'],
        score: params['score'],
        questionNumber: params['questionNumber'],
        paperUuid: params['paperUuid'],
        examId: params['examId'],
        subLibraryModuleId: params['subLibraryModuleId'],
        title: params['title'],
        timeType: params['timeType'],
        responseTime: params['responseTime'],
        refreshCallback: params['refreshCallback'],
      );
      break;

    /// 保利威全屏播放页面
    case POLY_V_FULL:
      child = PolyVFullScreenPage(
        vid: params['vid'],
        title: params['title'],
        closeIcon: params['closeIcon'],
        closePageCallBack: params['closePageCallBack'],
      );
      break;

    ///学情分析页面
    case STUDY_ANALYSIS_PATH:
      child = StudyAnalysisPage(
        subLibraryId: params['subLibraryId'],
      );
      break;

    ///引导页
    case GUIDE_PATH:
      child = GuidePage();
      break;

    /// 断言child不能为空
    default:
      assert(child != null);
      break;
  }

  return MaterialPage(name: path, key: ValueKey(path), child: child);
}
