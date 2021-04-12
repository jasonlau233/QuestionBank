import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_bank/em/filter_according_type.dart';
import 'package:question_bank/em/filter_time_type.dart';
import 'package:question_bank/model/data/collect_module_entity.dart';
import 'package:question_bank/provider/view_model/filter_controller_model.dart';
import 'package:question_bank/provider/widget/base_provider_widget.dart';
import 'package:question_bank/utils/color.dart';

import 'bottom_sheet_chooser.dart';
import 'chapter_exercises.dart';

///答题情况
enum FilterComeFromType {
  ///来自收藏页
  Collect_Exec,

  ///来自错题本
  Error_Exec,
}

///题目筛选器（用于错题管理跟收藏页）
class FilterController extends StatefulWidget {
  final Widget body;
  final FilterControllerViewModel viewModel;
  final FilterComeFromType comeFromType;

  const FilterController({Key key, this.body, this.viewModel, this.comeFromType}) : super(key: key);

  @override
  _FilterControllerState createState() => _FilterControllerState();
}

class _FilterControllerState extends State<FilterController> {
  //List bySourceStr = ['章节练习', '历年真题', '模拟考试'];
  List<String> byTimeStr = ['所有收藏', '近三天收藏', '近一周收藏', '近一月收藏'];

  @override
  Widget build(BuildContext context) {
    return BaseProviderWidget<FilterControllerViewModel>(
      autoDispose: false,
      viewModel: widget.viewModel,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///根据章节或者来源进行分类
                    _buildSortBySource(),

                    Spacer(),

                    ///筛选器右边部分
                    _buildRightPart(),
                  ],
                ),
              ),

              ///列表或者树状图
              widget.body,
            ],
          ),
        ],
      ),
    );
  }

  ///根据章节或者来源进行分类
  _buildSortBySource() {
    return Container(
      margin: EdgeInsets.only(left: 12),
      height: 28,
      padding: EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(11)),
      ),
      child: Consumer<FilterControllerViewModel>(
        builder: (_, model, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => {
                  widget.viewModel.collectAccordingType = FilterAccordingType.ACCORDING_CHAPTER,
                },
                child: Text(
                  '按章节',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: model.collectAccordingType == FilterAccordingType.ACCORDING_CHAPTER
                          ? ColorUtils.color_text_theme
                          : ColorUtils.color_text_level3),
                ),
              ),
              buildVerticalLine(10, width: 1, margin: EdgeInsets.only(left: 5, right: 5)),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: sourceExpandShow,
                child: Text(
                  '按来源-${model.collectSourceType}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: model.collectAccordingType == FilterAccordingType.ACCORDING_SOURCE
                          ? ColorUtils.color_text_theme
                          : ColorUtils.color_text_level3),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ///来源筛选底部展开
  void sourceExpandShow() {
    if (widget.viewModel.sourceModuleList != null && widget.viewModel.sourceModuleList.isNotEmpty) {
      List<String> strList = [];
      int selectedIndex = -1;
      for (FilterModuleEntity entity in widget.viewModel.sourceModuleList) {
        strList.add(entity.name);
        if (entity.name == widget.viewModel.collectSourceType &&
            widget.viewModel.collectAccordingType == FilterAccordingType.ACCORDING_SOURCE) {
          selectedIndex = widget.viewModel.sourceModuleList.indexOf(entity);
        }
      }
      showBottomSheetChooser<void>(
          context: context,
          strList: strList,
          selectedIndex: selectedIndex,
          title: '${widget.comeFromType == FilterComeFromType.Collect_Exec ? '收藏' : '错题'}来源筛选',
          onClick: (index) {
            widget.viewModel.collectSourceType = widget.viewModel.sourceModuleList[index].name;
            widget.viewModel.sourceSublibraryModuleId = widget.viewModel.sourceModuleList[index].id;
            widget.viewModel.collectAccordingType = FilterAccordingType.ACCORDING_SOURCE;
            widget.viewModel.typeId = widget.viewModel.sourceModuleList[index].type;
          });
    }
  }

  ///根据时间进行分类
  _buildSortByTime() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: timeExpandShow,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 12),
        height: 28,
        width: 93,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(11)),
        ),
        child: Consumer<FilterControllerViewModel>(
          builder: (_, model, child) {
            return Text(
              byTimeStr[model.collectTimeType.index],
              style: TextStyle(fontSize: 14, color: ColorUtils.color_text_theme, fontWeight: FontWeight.w600),
            );
          },
        ),
      ),
    );
  }

  ///收藏时间底部展开
  void timeExpandShow() {
    showBottomSheetChooser<void>(
        context: context,
        strList: byTimeStr,
        selectedIndex: widget.viewModel.filterTime,
        title: '收藏时间筛选',
        onClick: (index) {
          widget.viewModel.collectTimeType = FilterTimeType.values[index];
          widget.viewModel.filterTime = index;
        });
  }

  ///筛选器右边部分
  _buildRightPart() {
    if (widget.comeFromType == FilterComeFromType.Collect_Exec) {
      ///按照时间筛选
      return _buildSortByTime();
    } else if (widget.comeFromType == FilterComeFromType.Error_Exec) {
      ///自定义刷题
      return _buildCustomBrushQuestionMode();
    }
  }

  ///自定义刷题
  _buildCustomBrushQuestionMode() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {
        showCustomBrushErrorQuestionBottomSheet(context: context),
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 12),
        height: 28,
        width: 93,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(11)),
        ),
        child: Text(
          '自定义刷题',
          style: TextStyle(
            fontSize: 14,
            color: ColorUtils.color_text_level1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

///默认的线条（纵向）
Container buildVerticalLine(double height, {double width = 0.5, Color color, EdgeInsetsGeometry margin}) {
  return Container(
    margin: margin ?? EdgeInsets.all(0),
    width: width,
    height: height,
    color: color ?? ColorUtils.color_text_level1,
  );
}
