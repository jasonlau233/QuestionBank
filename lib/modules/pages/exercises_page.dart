import 'package:flutter/material.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/model/data/chapter_practice_entity.dart';
import 'package:question_bank/model/data/pratice_tab_dynamic_module_info_entity.dart';

import '../../modules/widget/chapter_exercises.dart';
import '../../provider/view_model/pratice_view_model.dart';
import '../../provider/widget/base_provider_widget.dart';
import '../../utils/color.dart';
import '../../utils/theme.dart';

class ExercisesPage extends StatefulWidget {
  /// 标题
  final String title;

  /// 从主页传递进来的_viewModel哪怕接口刷新也同步刷新首页数据
  final PracticeViewModel model;

  /// 来源于第几个章节练习
  final int index;

  const ExercisesPage({
    Key key,
    this.title,
    @required this.model,
    this.index,
  }) : super(key: key);

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (mounted) {
          Future.delayed(
            const Duration(milliseconds: 350),
            () {
              setState(
                () => isFirst = false,
              );
            },
          );
        }
      },
    );
  }

  /// 构建按钮
  Widget get _buildActionButton {
    return GestureDetector(
      onTap: () {
        showCustomBrushQuestionBottomSheet(context: context);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        alignment: Alignment.center,
        color: Colors.white,
        child: Text(
          "自定义刷题",
          style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ThemeUtils.getDefaultLeading(),
        centerTitle: true,
        toolbarHeight: BuildConfig.appBarHeight,
        title: Text(
          widget.title,
          style: ThemeUtils.getAppBarTitleTextStyle(context),
        ),
        actions: [
          _buildActionButton,
        ],
      ),
      body: BaseProviderWidget<PracticeViewModel>(
        viewModel: widget.model,
        autoDispose: false,
        child: isFirst
            ? SizedBox()
            : Container(
                child: Selector<PracticeViewModel, PracticeTabDynamicModuleInfoEntity>(
                  selector: (BuildContext context, PracticeViewModel model) {
                    return model.sectionViewList[widget.index];
                  },
                  builder: (BuildContext context, PracticeTabDynamicModuleInfoEntity data, Widget child) {
                    if (data == null || data.practice == null) {
                      return SizedBox(width: 0, height: 0);
                    }

                    final List<ChapterDTOList> itemData = data.practice.chapterDTOList;

                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 12),
                      itemBuilder: (BuildContext context, int index) {
                        return ChapterExercises(
                          title: widget.title,
                          showFirstHeader: false,
                          isExpanded: index == 0,
                          data: itemData[index],
                          subModuleId: widget.model.sectionList[widget.index].id,
                        );
                      },
                      itemCount: itemData.length,
                    );
                  },
                ),
              ),
      ),
    );
  }
}
