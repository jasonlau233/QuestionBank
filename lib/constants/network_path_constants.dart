/// ===========================================================================
/// 主模块
/// ===========================================================================
///
/// 获取app当前产品线下的子题库信息
const String childQuestionBankList = "/tkApp/app/v1/userDefaultCourse/list";

/// 获取app题库模块信息以及布局图片等信息
const String childSubLibraryModuleListItem =
    "/tkApp/app/v1/baseInfo/getAppContent";

/// app根据题库模块ID和科目ID获取练习信息
const String childPracticeItem = "/tkApp/app/v1/sublibrary/practice";

///获取我的收藏该子题库下的模块信息
const String childCollectModule =
    '/tkApp/app/v1/sublibrary/listSublibraryModule';

///获取用户的收藏列表的信息(来源列表)
const String childCollectAccordSource =
    '/tkApp/app/v1/baseInfo/getCollectionInfoBySource';

///获取用户的收藏列表的信息(章节列表)
const String childCollectAccordChapter =
    '/tkApp/app/v1/baseInfo/getCollectionInfoByChapterSection';

///获取用户的收藏列表的信息(来源列表)
const String childErrorAccordSource =
    '/tkApp/app/v1/baseInfo/errorQuestionBook/listBySource';

///获取用户的错题本的错题列表信息(章节列表)
const String childErrorAccordChapter =
    '/tkApp/app/v1/baseInfo/errorQuestionBook/listByChapterSection';

/// app获取试卷信息
const String exampPagerInfo = "/tkApp/app/v1/baseInfo/getPaperInfo";

/// 用户信息
const String getUserInfo = "/tkApp/app/v1/baseInfo/getUserInfo";

///做题报告跟练习报告
const String getReportInfo = '/tkApp/app/v1/baseInfo/getReport';

/// 考点信息接口
const String getExamPointInfo = '/tkApp/app/v1/courseQuestion/findKnowByIds';

/// 收藏信息接口
const String getCollectionsBypaperUuid =
    '/tkApp/app/v1/baseInfo/getCollectionsBypaperUuid';

/// 来源接口信息
const String getOriginInfo = '/tkApp/app/v1/baseInfo/getSourceDictionaryData';

/// 获取易错项目
const String getOptionStatistics =
    "/tkApp/app/v1/baseInfo/getOptionStatisticsByUuidQids";

/// 获取题目错了多少次
const String getErrorQuestionNum =
    "/tkApp/app/v1/baseInfo//getErrorQuestionBookByUidPaperUuidsExamIds";

/// ===========================================================================
/// 蓝鲸nc接口
/// ===========================================================================
/// 获取短信验证码
const String ncSMSCaptcha = "/api/getOtp";

/// 用户登录（包含新用户无感注册）
const String ncSMSLogin = "/api/loginAndRegister";

/// 用户退出登录
const String ncUserLogout = "/api/logout";

/// ===========================================================================
/// 核心层接口地址
/// ===========================================================================
/// 收藏题目,raw提交方式
const String addCollect = "/api/myCollection/saveOrUpdate";

/// 取消题目收藏
const String cancelCollect = "/api/myCollection/cancel";

/// 提交试卷
const String coreSubmitPaper = "/api/submitPaper";

/// app获取试卷列表
const String testExercisesList = "/tkApp/app/v1/sublibrary/exam";

/// 获取某试卷的已做题数
const String examGetExamGroupStatus =
    "/tkApp/app/v1/baseInfo/getExamGroupStatus";

/// 标识当前考试状态为继续
const String updateExamStatus = "/tkApp/app/v1/sublibrary/updateExamStatus";

/// 获取做题记录
const String exercisesRecord = '/api/getExamRecordByPage';

/// 获取历史已做题记录
const String getHistoryExamedRecord = '/api/getHistoryExamedRecord';

/// 获取最近一次做题记录
const String getExamedRecord = '/api/getExamedRecord';

/// 根据做题记录ID，获取做题明细
const String getExamDetailByRecordId = '/api/getExamDetailByRecordId';

/// 移除错题
const String removeErrorQuestion = '/api/errorQuestionBook/delete';

///获取学情分析预测分
const String forecastScore =
    '/tkApp/app/v1/studyAnalysisInfo/getPredictionScore';

///获取学情报告章节分数
const String studyAnalysisChapterAndSection =
    '/tkApp/app/v1/studyAnalysisInfo/getChapterIdSectionIdKnowledgeIdCountInfo';

/// ===========================================================================
/// Html5项目地址
/// ===========================================================================
/// 隐私协议
const String privacy = "/pages/singleApp/kaobaPrivacy.html";

/// 用户使用协议
const String userPrivacy = "/pages/singleApp/kaobaAgreement.html";

/// ===========================================================================
/// 通知项目接口地址
/// ===========================================================================
/// 注册极光推送id
const String registerPushTokenToServer = "/stage-api/push/register";
