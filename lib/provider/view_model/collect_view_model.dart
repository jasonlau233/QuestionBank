import 'package:question_bank/em/view_state_type.dart';
import 'package:question_bank/model/data/collect_accord_chapter_entity.dart';
import 'package:question_bank/model/data/collect_accord_source_entity.dart';
import 'package:question_bank/model/service/collect_service.dart';

import 'filter_controller_model.dart';

class CollectViewModel extends FilterControllerViewModel {
  ///获取用户的收藏列表的信息(章节列表)
  List<AppCollectionChapterList> _chapterExers = const [];

  ///获取用户的收藏列表的信息(来源列表)
  List<CollectAccordSourceEntity> _sourceExers = const [];

  ///章节id
  int courseId;

  List<CollectAccordSourceEntity> get sourceExers => _sourceExers;

  set sourceExers(List<CollectAccordSourceEntity> value) {
    _sourceExers = value;
    notifyListeners();
  }

  List<AppCollectionChapterList> get chapterExers => _chapterExers;

  set chapterExers(List<AppCollectionChapterList> value) {
    _chapterExers = value;
    notifyListeners();
  }

  /// 获取用户的收藏列表的信息(来源列表)
  @override
  Future<bool> getSourceExers() async {
    sourceExers = [];
    viewState = ViewState.Loading;
    final List<CollectAccordSourceEntity> data =
        await CollectService.getSourceExers(
            sourceSublibraryModuleId, filterTime);
    viewState = ViewState.Idle;
    sourceExers = data;
    return true;
  }

  /// 获取用户的收藏列表的信息(章节列表)
  @override
  Future<bool> getChapterExers() async {
    chapterExers = [];
    viewState = ViewState.Loading;
    if (chapterExers != null && chapterExers.isNotEmpty) {
      viewState = ViewState.Idle;
    }
    final List<AppCollectionChapterList> data =
        await CollectService.getChapterExers(
            chapterSublibraryModuleId, courseId, filterTime);
    viewState = ViewState.Idle;
    chapterExers = data;
    return true;
  }
}
