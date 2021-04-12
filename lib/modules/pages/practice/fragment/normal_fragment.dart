import 'package:flutter/material.dart';

import '../../../../model/data/chapter_practice_entity.dart';
import '../../../../model/data/pratice_tab_dynamic_module_info_entity.dart';
import '../../../../modules/widget/chapter_exercises.dart';
import '../../../../utils/color.dart';
import '../../../../widget/banner_swiper.dart';

/// 点击事件定义
typedef void OnItemClickListener(ItemBean itemBean, int index);

/// itemType枚举类型
enum ItemTypeEnum {
  /// 宫格
  Grid,

  /// 轮播
  Banner,

  /// 卡片
  Card,
}

/// 定义列表对应的itemType以及对应的数据项
class ItemBean<T> {
  /// 对应的视图项目
  final ItemTypeEnum itemType;

  /// 使用动态类型决定最终的数据内容
  final T data;

  /// 只有Card才有用
  final bool showHeader;
  final bool isExpanded;
  final int subModuleId;
  final int subLibraryModuleId;

  const ItemBean(
    this.itemType,
    this.data, {
    this.isExpanded = false,
    this.showHeader = false,
    this.subModuleId = 0,
    this.subLibraryModuleId = 0,
  });
}

class NormalFragment extends StatefulWidget {
  /// 数据源
  final List<ItemBean> data;

  /// 点击事件
  final OnItemClickListener onItemClickListener;

  /// 对应的章节练习的标题
  final String title;

  NormalFragment({
    Key key,
    this.data = const [],
    this.onItemClickListener,
    this.title = "",
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NormalFragmentState();
  }
}

class _NormalFragmentState extends State<NormalFragment> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// 构建导航按钮
  Widget _buildGrid(BuildContext context, ItemBean item) {
    final double width = MediaQuery.of(context).size.width / 5;
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 18),
      child: Wrap(
        runSpacing: 12,
        children: List.generate(
          item.data.length,
          (index) {
            return GestureDetector(
              onTap: () => widget.onItemClickListener?.call(item, index),
              child: Container(
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      item.data[index].content,
                      width: 31,
                      height: 36,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      child: Text(
                        item.data[index].name,
                        style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level2),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ), //要显示的子控件集合
      ),
    );
  }

  /// 构建导航按钮
  Widget _buildBanner(BuildContext context, List<String> pictureList) {
    return Container(
      height: 165 * ((MediaQuery.of(context).size.width - 12 * 2) / 351),
      margin: const EdgeInsets.all(12),
      child: BannerSwiper(
        loop: false,
        autoPlay: false,
        data: pictureList,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 165,
            decoration: BoxDecoration(
              color: ColorUtils.color_textBg_forGray,
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: NetworkImage(pictureList[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建导航按钮
  Widget _buildPanel(BuildContext context, ItemBean<ChapterDTOList> item) {
    return ChapterExercises(
      showFirstHeader: item.showHeader,
      isExpanded: item.isExpanded,
      data: item.data,
      title: widget.title,
      subModuleId: item.subModuleId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorUtils.color_textBg_forGray,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.data.length,
        itemBuilder: (BuildContext ctx, int index) {
          final ItemBean item = widget.data[index];

          /// 构建视图
          switch (item.itemType) {
            case ItemTypeEnum.Grid:
              return _buildGrid(context, item);
              break;

            case ItemTypeEnum.Banner:
              final List<String> pictureList = item.data.map<String>((BannerList e) => e.content).toList();
              return _buildBanner(context, pictureList);
              break;

            case ItemTypeEnum.Card:
            default:
              return _buildPanel(context, item);
              break;
          }
        },
      ),
    );
  }
}
