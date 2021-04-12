import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/constants/eventbus_key_constants.dart';
import 'package:question_bank/model/service/jpush_service.dart';
import 'package:question_bank/utils/event_bus.dart';
import 'package:question_bank/widget/custom_tab_indictor.dart';

import '../../../constants/storage_key_constants.dart';
import '../../../core/manager.dart';
import '../../../core/router/app_router_navigator.dart';
import '../../../flutter/custom_tabs.dart' as Custom;
import '../../../model/data/chapter_practice_entity.dart';
import '../../../model/data/pratice_tab_dynamic_module_info_entity.dart';
import '../../../model/data/storage_question_settings_entity.dart';
import '../../../model/data/storage_user_info_entity.dart';
import '../../../provider/view_model/common.dart';
import '../../../provider/view_model/pratice_view_model.dart';
import '../../../provider/widget/base_provider_widget.dart';
import '../../../route/path.dart';
import '../../../utils/color.dart';
import '../../../utils/storage.dart';
import '../practice/fragment/normal_fragment.dart';

class PracticePage extends StatefulWidget {
  @override
  _PracticePageState createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  /// view model
  PracticeViewModel _viewModel;

  /// tabView
  TabController _tabController;

  /// 设置
  List<bool> networkLockList = [];

  /// 是否首次渲染
  bool isFirstRender = true;

  /// 是否执行过一次检查权限
  bool isCheck = false;

  /// 对应的页面退出刷新接口
  StreamSubscription _pageDestroyStreamSubscription;

  /// 极光推送
  JPush jPush = JPush();

  @override
  void initState() {
    super.initState();
    _viewModel = PracticeViewModel();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await _checkUserTokenIsExists(),
    );

    /// 监听对应的回调方法
    _pageDestroyStreamSubscription = EventBus.instance.registerListen(
      EVENTBUS_PAGE_DESTROY_KEY,
      (dynamic data) async {
        final int i = _tabController.index;
        if (networkLockList[i] == true) {
          return;
        }

        networkLockList[i] = true;
        await _viewModel.initTabItem(_viewModel.sectionList[i].id, _viewModel.sectionList[i].courseId, i);
        networkLockList[i] = false;
      },
    );
  }

  @override
  void dispose() {
    _pageDestroyStreamSubscription?.cancel();
    _tabController?.dispose();
    _viewModel.dispose();
    jPush = null;
    _viewModel = null;
    super.dispose();
  }

  /// 准备数据阶段
  Future<void> _onReadyData() async {
    isFirstRender = true;
    final bool isSuccess = await _viewModel.initTab;
    if (!isSuccess) {
      return;
    }
    Provider.of<Common>(context, listen: false).subLibraryId = _viewModel.sectionList.first.id.toString();

    /// 这里是为了确认tabController和tabbarview的数量确定，而不控制selector重复刷新多次tabbar组合，使用setState控制最小颗粒度，
    /// 全局刷新一次一些controller
    _tabController = TabController(length: _viewModel.sectionList.length, vsync: this);
    networkLockList = List.filled(_viewModel.sectionList.length, null, growable: false);
    setState(() => isFirstRender = false);
  }

  /// 准备数据阶段
  void _onModalReady(viewModel) async {
    if (isCheck) {
      _onReadyData();
    }
  }

  /// 检查是否存储过用户凭证
  Future<void> _checkUserTokenIsExists() async {
    isCheck = true;
    final Common common = Provider.of<Common>(context, listen: false);
    final String userInfo = await StorageUtils.getString(STORAGE_USER_INFO_KEY);

    ///判断是否第一次登陆
    final bool isFirstIn = await StorageUtils.getBool(STORAGE_FIRST_IN);
    if (isFirstIn == null) {
      AppRouterNavigator.of(context).setRoot(GUIDE_PATH);
      return;
    }

    if (userInfo == null || userInfo.isEmpty) {
      AppRouterNavigator.of(context).setRoot(LOGIN_PATH);
      return;
    }

    final StorageUserInfoEntity entity = StorageUserInfoEntity.fromJson(jsonDecode(userInfo));
    common.setLogin(entity);
    Manager.shared.config = Manager.shared.config.copyWith(token: entity.token);
    Future.wait<void>(
      [
        _onReadyData(),
        _checkUserHasScopeSettings(),
        initPushPlatformSdk,
      ],
    );
  }

  /// 检查用户是否设置了题库规则
  Future<void> _checkUserHasScopeSettings() async {
    final String scopeSettings = await StorageUtils.getString(STORAGE_QUESTION_SCOPE_KEY);
    if (scopeSettings == null || scopeSettings.isEmpty) {
      Provider.of<Common>(context, listen: false).isFirstSettings = true;
      return;
    }
    final StorageQuestionSettingsInfoEntity entity = StorageQuestionSettingsInfoEntity.fromJson(
      jsonDecode(scopeSettings),
    );
    if (entity != null) {
      Provider.of<Common>(context, listen: false).isFirstSettings = false;
      Provider.of<Common>(context, listen: false).settingsInfoEntity = entity;
    }
  }

  /// 列表点击事件
  void _onNormalFragmentItemClickListener(ItemBean itemBean, int index) {
    switch (itemBean.itemType) {
      case ItemTypeEnum.Grid:

        /// 根据后台的数值来跳转
        /// 二级类型  默认为0/表示没有二级类型（1练习 2考试 3 错题管理 4 收藏 5做题记录 6学情分析）',
        const Map<String, String> pathMap = {
          "PRACTICE": EXEC_PATH,
          "EXAM": EXAM_LIST,
          "ERROR_RECORD": ERR_EXEC_RECORD_PATH,
          "MY_COLLECT": MY_COLLECTION_PATH,
          "DO_RECORD": EXEC_RECORD_PATH,
          "STUDY_ANALYSIS": STUDY_ANALYSIS_PATH,
        };

        /// 参数组
        final Map<String, Map<String, dynamic>> paramsMap = {
          "PRACTICE": {
            "model": _viewModel,
            "index": _tabController.index,
          },
          "EXAM": {
            "subLibraryModuleId": itemBean.data[index].subLibraryModuleId,
          },
          "ERROR_RECORD": {
            "subLibraryId": _viewModel.sectionList[_tabController.index].id,
            "courseId": _viewModel.sectionList[_tabController.index].courseId,
          },
          "MY_COLLECT": {
            "subLibraryId": _viewModel.sectionList[_tabController.index].id,
            "courseId": _viewModel.sectionList[_tabController.index].courseId,
          },
          "DO_RECORD": {
            "subLibraryId": _viewModel.sectionList[_tabController.index].id,
          },
          "STUDY_ANALYSIS": {
            "subLibraryId": _viewModel.sectionList[_tabController.index].id,
          }
        };

        final String pathKey = itemBean.data[index].juniorType;
        if (pathMap.containsKey(pathKey) != null) {
          AppRouterNavigator.of(context).push(
            pathMap[pathKey],
            needLogin: true,
            params: paramsMap[pathKey]..addAll({"title": itemBean.data[index].name}),
          );
        }
        break;
      case ItemTypeEnum.Banner:
        break;
      case ItemTypeEnum.Card:
        break;
    }
  }

  /// 初始化极光推送sdk
  Future<void> get initPushPlatformSdk async {
    final Common common = Provider.of<Common>(context, listen: false);

    jPush.addEventHandler(
      onReceiveNotification: (Map<String, dynamic> message) async {},
      onOpenNotification: (Map<String, dynamic> message) async {},
      onReceiveMessage: (Map<String, dynamic> message) async {},
      onReceiveNotificationAuthorization: (Map<String, dynamic> message) async {},
    );

    jPush.setup(
      appKey: Platform.isIOS ? BuildConfig.iosJPushAppKey : BuildConfig.androidJPushAppKey,
      channel: BuildConfig.jPushChannel,
      production: Manager.shared.config.env == HttpEnv.Production,
      debug: true,
    );

    jPush.applyPushAuthority(
      NotificationSettingsIOS(sound: true, alert: true, badge: true),
    );

    try {
      jPush.getRegistrationID().then(
        (String id) {
          JpushService.registerPushToken(
            common.storageUserInfoEntity.uid.toString(),
            id,
          );
        },
      );
    } on PlatformException {}
  }

  /// 构建tabbar
  Widget get _buildTab {
    return Custom.TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorWeight: 3.0,
      indicator: CustomTabIndictor(),
      labelColor: ColorUtils.color_text_level1,
      unselectedLabelColor: ColorUtils.color_text_level2,
      labelStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: ColorUtils.color_text_level1,
      ),
      unselectedLabelStyle: TextStyle(fontSize: 16, color: ColorUtils.color_text_level2),
      tabs: _viewModel.sectionList
          .map<Widget>(
            (e) => Custom.Tab(text: e.name),
          )
          .toList(),
      onTap: (int i) async {
        Provider.of<Common>(context, listen: false).subLibraryId = _viewModel.sectionList[i].id.toString();
        if (networkLockList[i] == true) {
          return;
        }
        networkLockList[i] = true;
        await _viewModel.initTabItem(_viewModel.sectionList[i].id, _viewModel.sectionList[i].courseId, i);
        networkLockList[i] = false;
      },
    );
  }

  /// 构建tabview列表项目
  Widget _buildTabItemList(int index) {
    /// 这里为了颗粒度减少所有页面重复刷新的问题
    return Selector<PracticeViewModel, PracticeTabDynamicModuleInfoEntity>(
      selector: (BuildContext context, PracticeViewModel model) {
        return model.sectionViewList[index];
      },
      builder: (BuildContext context, PracticeTabDynamicModuleInfoEntity data, Widget child) {
        final List<ItemBean> itemBeanList = [];
        String title = "";
        if (data != null) {
          if (data.bannerList != null && data.bannerList.length > 0) {
            itemBeanList.add(ItemBean<List<BannerList>>(ItemTypeEnum.Banner, data.bannerList));
          }

          if (data.indexModule != null && data.indexModule.length > 0) {
            final int index = data.indexModule.indexWhere((element) => element.juniorType == "PRACTICE");
            if (index != -1) {
              title = data.indexModule[index].name;
            }
            itemBeanList.add(ItemBean<List<IndexModule>>(ItemTypeEnum.Grid, data.indexModule));
          }

          if (data.practice != null &&
              data.practice.chapterDTOList != null &&
              data.practice.chapterDTOList.length > 0) {
            itemBeanList.addAll(
              List.generate(
                data.practice.chapterDTOList.length,
                (i) {
                  final bool isFirst = i == 0;
                  return ItemBean<ChapterDTOList>(
                    ItemTypeEnum.Card,
                    data.practice.chapterDTOList[i],
                    showHeader: isFirst,
                    isExpanded: isFirst,
                    subModuleId: _viewModel.sectionList[index].id,
                  );
                },
              ),
            );
          }
        }

        return NormalFragment(
          onItemClickListener: _onNormalFragmentItemClickListener,
          data: itemBeanList,
          title: title,
        );
      },
    );
  }

  /// 构建tabbar view
  Widget get _buildTabView {
    return TabBarView(
      children: List.generate(
        _viewModel.sectionViewList.length,
        (index) {
          return _buildTabItemList(index);
        },
      ),
      controller: _tabController,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseProviderWidget<PracticeViewModel>(
      viewModel: _viewModel,
      autoDispose: false,
      onModelReady: _onModalReady,
      child: isFirstRender
          ? SizedBox(width: 0, height: 0)
          : Scaffold(
              appBar: AppBar(title: _buildTab, titleSpacing: 0, toolbarHeight: 45),
              body: _buildTabView,
            ),
    );
  }
}
