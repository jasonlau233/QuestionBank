import 'package:flutter/foundation.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/em/view_state_type.dart';

import '../../model/data/chapter_practice_entity.dart';
import '../../model/data/pratice_tab_dynamic_module_info_entity.dart';
import '../../model/data/practice_tab_entity.dart';
import '../../model/service/practice_service.dart';
import 'base_view_model.dart';

class PracticeViewModel extends BaseViewModel {
  /// 对应的tabbar选项
  List<PracticeTabEntity> _sectionList = const [];
  List<PracticeTabEntity> get sectionList => _sectionList;
  set sectionList(List<PracticeTabEntity> data) {
    if (data == _sectionList) return;
    _sectionList = data;
    notifyListeners();
  }

  /// 对应的tabView视图下的数据
  List<PracticeTabDynamicModuleInfoEntity> _sectionViewList = const [];
  List<PracticeTabDynamicModuleInfoEntity> get sectionViewList => _sectionViewList;
  set sectionViewList(List<PracticeTabDynamicModuleInfoEntity> data) {
    if (data == _sectionViewList) {
      return;
    }
    _sectionViewList = data;
    notifyListeners();
  }

  /// 初始化对应的数据并且是第一次初始化的哪一种
  Future<bool> get initTab async {
    viewState = ViewState.Loading;
    final List<PracticeTabEntity> tabEntity = await PracticeService.getChapterList(BuildConfig.productLine);
    if (tabEntity == null || tabEntity.length <= 0) {
      viewState = ViewState.Empty;
      return false;
    }

    /// 这里不刷新监听是给到第一次初始化在来刷新
    _sectionList = tabEntity;
    _sectionViewList = tabEntity.map((e) => null).toList();

    /// 拿去默认第一个的数据
    await initTabItem(tabEntity.first.id, tabEntity.first.courseId, 0, notify: false);
    viewState = ViewState.Idle;
    return true;
  }

  /// 初始化对应的tabItem数据
  Future<void> initTabItem(int id, int courseId, int index, {bool notify: true}) async {
    /// 在获取banner图和导航按钮,(后端叫写死的)
    final PracticeTabDynamicModuleInfoEntity dynamicModuleInfoEntity = await PracticeService.getSubLibraryModuleInfo(
      id,
      1,
      1,
    );
    if (dynamicModuleInfoEntity != null) {
      ChapterPracticeEntity chapterPracticeEntity;

      /// 查询练习模块,去查询章节练习
      if (dynamicModuleInfoEntity.indexModule != null && dynamicModuleInfoEntity.indexModule.length > 0) {
        final int practiceIndex = dynamicModuleInfoEntity.indexModule.indexWhere((element) => element.juniorType == "PRACTICE");

        /// 检查对应的moduleId是否有设置 有设置就进行查询章节练习
        if (practiceIndex != -1) {
          /// 获取章节练习id+课程id进行练习信息
          chapterPracticeEntity = await PracticeService.getSubLibraryModulePractice(
            courseId,
            dynamicModuleInfoEntity.indexModule[practiceIndex].subLibraryModuleId,
          );
        }
      }

      final List<PracticeTabDynamicModuleInfoEntity> dataList = List.of(sectionViewList);
      dataList[index] = dynamicModuleInfoEntity.copyWith(practice: chapterPracticeEntity);
      if (notify) {
        sectionViewList = dataList;
      } else {
        _sectionViewList = dataList;
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
