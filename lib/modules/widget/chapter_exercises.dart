import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:question_bank/model/data/paper_answer_entity.dart';
import 'package:question_bank/model/service/examination_service.dart';
import 'package:question_bank/widget/lock_gesture_detector.dart';

import '../../constants/storage_key_constants.dart';
import '../../core/router/app_router_navigator.dart';
import '../../flutter/custom_expansion_panel.dart';
import '../../model/data/chapter_practice_entity.dart';
import '../../model/data/storage_question_settings_entity.dart';
import '../../provider/view_model/common.dart';
import '../../provider/widget/base_provider_widget.dart';
import '../../route/path.dart';
import '../../utils/color.dart';
import '../../utils/icon.dart';
import '../../utils/storage.dart';
import '../../utils/toast.dart';
import '../../widget/rating_bar/rating_bar.dart';

const List<Map<String, dynamic>> _starList = [
  {
    "star": 0.5,
    "scope": [0, 10]
  },
  {
    "star": 1.0,
    "scope": [10, 20]
  },
  {
    "star": 1.5,
    "scope": [20, 30]
  },
  {
    "star": 2.0,
    "scope": [30, 40]
  },
  {
    "star": 2.5,
    "scope": [40, 50]
  },
  {
    "star": 3.0,
    "scope": [50, 60]
  },
  {
    "star": 3.5,
    "scope": [60, 70]
  },
  {
    "star": 4.0,
    "scope": [70, 80]
  },
  {
    "star": 4.5,
    "scope": [80, 90]
  },
  {
    "star": 5.0,
    "scope": [90, 100]
  }
];

/// 弹出自定义刷新的弹出层
showCustomBrushQuestionBottomSheet<T>({@required BuildContext context, Function onSuccessCallback}) {
  final StorageQuestionSettingsInfoEntity entity = Provider.of<Common>(context, listen: false).settingsInfoEntity;
  showModalBottomSheet<T>(
    context: context,
    isDismissible: true,
    enableDrag: false,
    builder: (BuildContext context) {
      return ChapterChooseModal();
    },
  ).then(
    (value) {
      if (value == null) {
        Provider.of<Common>(context, listen: false).resetSettingsInfoEntity(
          entity.mode,
          entity.numMode,
          entity.scope,
        );
      } else if (value == true) {
        onSuccessCallback?.call();
      }
    },
  );
}

/// 弹出自定义刷新的弹出层（错题本专用）
showCustomBrushErrorQuestionBottomSheet<T>({@required BuildContext context, Function onSuccessCallback}) {
  final StorageQuestionSettingsInfoEntity entity =
      Provider.of<Common>(context, listen: false).settingsErrorQuestionInfoEntity;
  showModalBottomSheet<T>(
    context: context,
    isDismissible: true,
    enableDrag: false,
    builder: (BuildContext context) {
      return ChapterChooseModal(isErrorQuestion: true);
    },
  ).then(
    (value) {
      if (value == null) {
        Provider.of<Common>(context, listen: false).resetSettingsErrorQuestionInfoEntity(
          entity.mode,
          entity.numMode,
          entity.scope,
        );
      } else if (value == true) {
        onSuccessCallback?.call();
      }
    },
  );
}

/// 练习业务ui
class ChapterExercises extends StatelessWidget {
  /// 显示头部按钮组
  final bool showFirstHeader;

  final ChapterDTOList data;

  /// 标题
  final String title;

  /// 是否需要展开
  final bool isExpanded;

  /// 参数课程id
  final int subModuleId;

  const ChapterExercises({
    Key key,
    this.showFirstHeader = false,
    this.data,
    this.isExpanded = false,
    this.title = "",
    this.subModuleId,
  }) : super(key: key);

  /// 投建头部
  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      height: 23,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 14,
                width: 4,
                decoration: BoxDecoration(
                  color: ColorUtils.color_bg_theme,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.only(right: 6),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: ColorUtils.color_text_level1, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              showCustomBrushQuestionBottomSheet<void>(context: context);
            },
            child: Container(
              alignment: Alignment.center,
              height: 23,
              width: 93,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    offset: const Offset(0, 1),
                    color: ColorUtils.color_border_shadow,
                  ),
                ],
              ),
              child: Text(
                "自定义刷题",
                style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level1, fontWeight: FontWeight.w500),
              ),
              padding: const EdgeInsets.only(bottom: 2),
            ),
          )
        ],
      ),
    );
  }

  /// 构建统一item样式
  Widget _buildPanelChildItem({
    String chapterName: "",
    String paperUuid: "",
    int finishNumber: 0,
    int doneNumber: 0,
    int allNumber: 0,
    EdgeInsets padding: const EdgeInsets.only(left: 43, right: 12),
    bool isHeader: true,
    bool showIcon: true,
    int status: 0,
    BuildContext context,
  }) {
    double initialRating = 0;
    if (finishNumber != 0 && allNumber != 0) {
      final double percent = finishNumber / allNumber * 100;

      final int existIndex = _starList.indexWhere((element) {
        if (percent > element["scope"][0] && percent <= element["scope"][1]) {
          return true;
        }
        return false;
      });

      if (existIndex != -1) {
        initialRating = _starList[existIndex]["star"];
      }
    }

    return Container(
      alignment: Alignment.centerLeft,
      height: 55,
      color: Colors.white,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapterName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: ColorUtils.color_text_level1,
                    fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatingBar(
                      initialRating: initialRating,
                      minRating: 0,
                      ignoreGestures: true,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 12,
                      onRatingUpdate: (double value) {},
                      ratingWidget: RatingWidget(
                        half: Image.asset("assets/images/common/halt_star.png"),
                        empty: Image.asset("assets/images/common/empty_star.png"),
                        full: Image.asset("assets/images/common/full_star.png"),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 4, top: 1.5),
                      child: Text.rich(
                        TextSpan(
                          text: doneNumber.toString(),
                          style: TextStyle(fontSize: 11, color: ColorUtils.color_text_level1), // default text style
                          children: <TextSpan>[
                            const TextSpan(
                              text: '/',
                              style: TextStyle(color: ColorUtils.color_text_level3),
                            ),
                            TextSpan(
                              text: allNumber.toString(),
                              style: TextStyle(color: ColorUtils.color_text_level3, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          if (!isHeader && showIcon)
            Container(
              margin: const EdgeInsets.only(left: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (status == 1 || Provider.of<Common>(context).sectionMap.containsKey(paperUuid))
                    Text(
                      "继续做题",
                      style: TextStyle(fontSize: 10, color: ColorUtils.color_bg_theme),
                    ),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: ColorUtils.color_bg_theme),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 获取对应的继续做题数据
  Future<void> checkIsContinueQuestion(BuildContext context, SectionDTOList e) async {
    /// 请求一起
    /// GET /api/getExamedRecord
    final PaperAnswerEntity entity = await ExaminationService.getExamedRecordInfo(
      Provider.of<Common>(context, listen: false).storageUserInfoEntity.uid,
      e.paperUuid,
      "",
    );
    if (entity != null) {
      if (entity.examDetail != null &&
          entity.examDetail.examRecord != null &&
          entity.examDetail.examRecord.param9.toString() == "0") {
        await Future.delayed(const Duration(milliseconds: 350), () {
          AppRouterNavigator.of(context).push(
            EXAMINATION_PATH,
            needLogin: true,
            params: {
              "type": 1,
              "origin": 3,
              "examId": "",
              "mainTitle": entity.examDetail.examRecord.param5.toString(),
              "title": entity.examDetail.examRecord.param5.toString(),
              "paperUuid": e.paperUuid,
              "subLibraryModuleId": e.subLibraryModuleId,
              "paperAnswerEntity": entity,
              "recordId": entity.examDetail.examRecord.id,
            },
          );
        });
      }
    }
  }

  /// 构建panelList
  Widget _buildPanelList(BuildContext context) {
    if (data != null) {
      int initialOpenPanelValue = 0;
      if (isExpanded) {
        initialOpenPanelValue = data.id;
      }
      return CustomExpansionPanelList.radio(
        elevation: 0,
        expandedHeaderPadding: const EdgeInsets.all(0),
        initialOpenPanelValue: initialOpenPanelValue,
        expansionCallback: (int index, bool isExpanded) {},
        children: [
          CustomExpansionPanelRadio(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return _buildPanelChildItem(
                chapterName: data.name,
                allNumber: data.allNumber,
                finishNumber: data.finishNumber,
                doneNumber: data.doneNumber,
                padding: const EdgeInsets.only(left: 0, right: 12),
                showIcon: false,
              );
            },
            body: Column(
              children: data.sectionDTOList != null && data.sectionDTOList.length > 0
                  ? data.sectionDTOList.map<Widget>(
                      (e) {
                        return LockGestureDetector(
                          onItemClickListenCallback: () async {
                            if (e.status == 1) {
                              await checkIsContinueQuestion(context, e);
                            } else {
                              /// 本地刷新是有一套卷子
                              if (Provider.of<Common>(context, listen: false).sectionMap.containsKey(e.paperUuid)) {
                                await checkIsContinueQuestion(context, e);
                              } else {
                                final bool isFirstSettings =
                                    Provider.of<Common>(context, listen: false).isFirstSettings;
                                if (isFirstSettings) {
                                  await showCustomBrushQuestionBottomSheet(
                                    context: context,
                                    onSuccessCallback: () {
                                      final StorageQuestionSettingsInfoEntity info =
                                          Provider.of<Common>(context, listen: false).settingsInfoEntity;
                                      AppRouterNavigator.of(context).push(
                                        EXAMINATION_PATH,
                                        needLogin: true,
                                        params: {
                                          "type": 1,
                                          "examId": "",
                                          "mainTitle": "${title}-" + e.name + (info.mode == 1 ? "-背题" : ""),
                                          "title": e.name,
                                          "paperUuid": e.paperUuid,
                                          "subModuleId": subModuleId,
                                          "subLibraryModuleId": e.subLibraryModuleId,
                                        },
                                      );
                                    },
                                  );
                                  return true;
                                }
                                final StorageQuestionSettingsInfoEntity info =
                                    Provider.of<Common>(context, listen: false).settingsInfoEntity;
                                AppRouterNavigator.of(context).push(
                                  EXAMINATION_PATH,
                                  needLogin: true,
                                  params: {
                                    "type": 1,
                                    "examId": "",
                                    "mainTitle": "${title}-" + e.name + (info.mode == 1 ? "-背题" : ""),
                                    "title": e.name,
                                    "paperUuid": e.paperUuid,
                                    "subModuleId": subModuleId,
                                    "subLibraryModuleId": e.subLibraryModuleId,
                                  },
                                );
                              }
                            }
                            return true;
                          },
                          child: _buildPanelChildItem(
                            paperUuid: e.paperUuid,
                            chapterName: e.name,
                            allNumber: e.allNumber,
                            finishNumber: e.finishNumber,
                            doneNumber: e.doneNumber,
                            isHeader: false,
                            status: e.status,
                            context: context,
                          ),
                        );
                      },
                    ).toList()
                  : [],
            ),
            value: data.id,
          ),
        ],
      );
    }
    return Container();
  }

  /// 构建展开
  Widget _buildPanelItem(BuildContext context) {
    if (data == null) {
      return Container(width: 0, height: 0);
    }

    if (showFirstHeader) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildPanelList(context),
        ],
      );
    }

    return _buildPanelList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: _buildPanelItem(context),
    );
  }
}

/// 弹出层ui
class ChapterChooseModal extends StatefulWidget {
  final bool isErrorQuestion;

  const ChapterChooseModal({Key key, this.isErrorQuestion = false}) : super(key: key);

  @override
  _ChapterChooseModalState createState() => _ChapterChooseModalState();
}

class _ChapterChooseModalState extends State<ChapterChooseModal> {
  /// picker滚动组
  FixedExtentScrollController _questionFixedNumController;
  // FixedExtentScrollController _questionFixedModeController;

  /// 确认锁
  bool confirmLock = false;

  @override
  void initState() {
    super.initState();
    _createController();
  }

  @override
  void dispose() {
    _clearController();
    super.dispose();
  }

  /// 创建控制器
  void _createController() {
    /// 获取全局存储的题目规则,并且初始化
    const List<int> itemList = [5, 10, 15, 20, 25, 30, 35, 40];
    final StorageQuestionSettingsInfoEntity entity = widget.isErrorQuestion
        ? Provider.of<Common>(context, listen: false).settingsErrorQuestionInfoEntity
        : Provider.of<Common>(context, listen: false).settingsInfoEntity;

    _questionFixedNumController = FixedExtentScrollController(
      initialItem: itemList.indexWhere((element) => element == entity.numMode),
    );
    // _questionFixedModeController = FixedExtentScrollController(initialItem: entity.scope);
  }

  /// 销毁控制器
  void _clearController() {
    _questionFixedNumController.dispose();
    // _questionFixedModeController.dispose();
  }

  /// 构建出题模式
  Widget get _buildQuestionMode {
    const List<String> titleList = ["做题模式", "背题模式"];
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: const Text(
              "设置出题模式",
              style: TextStyle(fontSize: 14, color: ColorUtils.color_text_level2, fontWeight: FontWeight.w500),
            ),
          ),
          Selector<Common, int>(
            builder: (BuildContext context, int mode, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  titleList.length,
                  (index) {
                    Color bgColor = ColorUtils.color_textBg_forGray;
                    Border border;
                    if (mode == index) {
                      bgColor = ColorUtils.color_textBg_choose_select_choose;
                      border = Border.all(color: ColorUtils.color_bg_theme, width: 1.2);
                    }
                    return GestureDetector(
                      onTap: () {
                        if (widget.isErrorQuestion) {
                          Provider.of<Common>(
                            context,
                            listen: false,
                          ).settingsErrorQuestionInfoEntity = Provider.of<Common>(
                            context,
                            listen: false,
                          ).settingsErrorQuestionInfoEntity.copyWith(mode: index);
                        } else {
                          Provider.of<Common>(
                            context,
                            listen: false,
                          ).settingsInfoEntity = Provider.of<Common>(
                            context,
                            listen: false,
                          ).settingsInfoEntity.copyWith(mode: index);
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 43,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(5),
                              border: border,
                            ),
                            width: 152,
                            child: Text(
                              titleList[index],
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorUtils.color_text_level2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ]..addAll(
                            mode == index
                                ? [
                                    Positioned(
                                      right: 0,
                                      child: Icon(questionModeBadge, color: ColorUtils.color_bg_theme),
                                    ),
                                    Positioned(
                                      right: 4,
                                      top: 4,
                                      child: Icon(questionModeBadgeGou, color: Colors.white, size: 6),
                                    )
                                  ]
                                : [],
                          ),
                      ),
                    );
                  },
                ),
              );
            },
            selector: (BuildContext context, Common model) {
              return widget.isErrorQuestion
                  ? model.settingsErrorQuestionInfoEntity.mode
                  : model.settingsInfoEntity.mode;
            },
          ),
        ],
      ),
    );
  }

  /// 构建选择器
  Widget get _buildQuestionModeNumChoose {
    const List<int> numList = [5, 10, 15, 20, 25, 30, 35, 40];
    const List<String> title2List = ["设置每组题出题数量"];
    // const List<String> modeList = ["全部", "未做", "已做"];
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              title2List.length,
              (index) {
                return Container(
                  alignment: Alignment.centerLeft,
                  width: 152,
                  child: Text(
                    title2List[index],
                    style: TextStyle(fontSize: 14, color: ColorUtils.color_text_level2, fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 115,
                  width: 191,
                  margin: const EdgeInsets.only(right: 58),
                  child: Selector<Common, int>(
                    builder: (BuildContext context, int numMode, _) {
                      return CupertinoPicker(
                        itemExtent: 43,
                        scrollController: _questionFixedNumController,
                        onSelectedItemChanged: (position) {
                          if (numList[position] != numMode) {
                            if (widget.isErrorQuestion) {
                              Provider.of<Common>(context, listen: false).settingsErrorQuestionInfoEntity =
                                  Provider.of<Common>(context, listen: false)
                                      .settingsErrorQuestionInfoEntity
                                      .copyWith(numMode: numList[position]);
                            } else {
                              Provider.of<Common>(context, listen: false).settingsInfoEntity =
                                  Provider.of<Common>(context, listen: false)
                                      .settingsInfoEntity
                                      .copyWith(numMode: numList[position]);
                            }
                          }
                        },
                        children: List.generate(
                          numList.length,
                          (index) {
                            return Center(
                              child: numList[index] == numMode
                                  ? Text(
                                      numList[index].toString(),
                                      style: TextStyle(fontSize: 18, color: ColorUtils.color_text_theme),
                                    )
                                  : Text(
                                      numList[index].toString(),
                                      style: TextStyle(fontSize: 12, color: ColorUtils.color_text_level1),
                                    ),
                            );
                          },
                        ),
                      );
                    },
                    selector: (BuildContext context, Common model) {
                      return widget.isErrorQuestion
                          ? model.settingsErrorQuestionInfoEntity.numMode
                          : model.settingsInfoEntity.numMode;
                    },
                  ),
                ),
                const Text(
                  "道",
                  style: TextStyle(fontSize: 16, color: ColorUtils.color_text_level1, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 确认按钮
  Widget get _buildConfirmButton {
    return GestureDetector(
      onTap: () async {
        if (confirmLock) {
          return;
        }
        confirmLock = true;
        ToastUtils.showGeneralLoading(title: "正在保存设置");

        if (widget.isErrorQuestion) {
        } else {
          final StorageQuestionSettingsInfoEntity entity =
              Provider.of<Common>(context, listen: false).settingsInfoEntity;
          await StorageUtils.setString(STORAGE_QUESTION_SCOPE_KEY, jsonEncode(entity.toJson()));
        }
        Future.delayed(
          const Duration(milliseconds: 550),
          () {
            if (mounted) {
              confirmLock = false;
              ToastUtils.cleanAllLoading();
              Provider.of<Common>(context, listen: false).isFirstSettings = false;
              Navigator.of(context).pop(true);
            }
          },
        );
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: ColorUtils.color_bg_theme,
            borderRadius: BorderRadius.circular(22),
          ),
          margin: const EdgeInsets.only(top: 24),
          alignment: Alignment.center,
          height: 44,
          width: 230,
          child: Text(
            "确认",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final StorageQuestionSettingsInfoEntity entity = widget.isErrorQuestion
        ? Provider.of<Common>(context, listen: false).settingsErrorQuestionInfoEntity
        : Provider.of<Common>(context, listen: false).settingsInfoEntity;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "自定义刷题规则",
          style: TextStyle(
            fontSize: 16,
            color: ColorUtils.color_text_level2,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          CloseButton(
            color: ColorUtils.color_bg_theme,
            onPressed: () {
              Navigator.maybePop(context).then(
                (dynamic result) {
                  if (widget.isErrorQuestion) {
                    Provider.of<Common>(context, listen: false).resetSettingsErrorQuestionInfoEntity(
                      entity.mode,
                      entity.numMode,
                      entity.scope,
                    );
                  } else {
                    Provider.of<Common>(context, listen: false).resetSettingsInfoEntity(
                      entity.mode,
                      entity.numMode,
                      entity.scope,
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionMode,
          _buildQuestionModeNumChoose,
          _buildConfirmButton,
        ],
      ),
    );
  }
}
