import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:question_bank/utils/color.dart';

/// 弹出底部选择弹窗
showBottomSheetChooser<T>(
    {@required BuildContext context,
    @required List<String> strList,
    @required String title,
    @required OnClick onClick,
    @required int selectedIndex}) {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: true,
    enableDrag: false,
    builder: (BuildContext context) {
      return BottomSheetChooser(
        strList: strList,
        title: title,
        onClick: onClick,
        selectedIndex: selectedIndex,
      );
    },
  );
}

typedef OnClick = Function(int index);

class BottomSheetChooser extends StatefulWidget {
  final List<String> strList;
  final String title;
  final OnClick onClick;

  ///已经被选中的index
  final int selectedIndex;

  const BottomSheetChooser(
      {Key key, this.strList, this.title, this.onClick, this.selectedIndex})
      : super(key: key);

  @override
  _BottomSheetChooserState createState() => _BottomSheetChooserState();
}

class _BottomSheetChooserState extends State<BottomSheetChooser> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      height: 60.5 * widget.strList.length + 63.5,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${widget.title}",
                  style: TextStyle(
                      fontSize: 16,
                      color: ColorUtils.color_text_level1,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  height: 0.5,
                  color: ColorUtils.color_bg_splitLine,
                  width: double.infinity,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return buildSourceExpandText(widget.strList[index], index);
                  },
                  itemCount: widget.strList.length,
                )
              ],
            ),
          ),
          Positioned(
              child: CloseButton(
            color: ColorUtils.color_bg_splitLine,
          )),
        ],
      ),
    );
  }

  Widget buildSourceExpandText(String itemStr, int index) {
    return Container(
      height: 60.5,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => {
              widget.onClick?.call(index),
              Navigator.pop(context),
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: Text(
                '$itemStr',
                style: TextStyle(
                  fontSize: 16,
                  color: widget.selectedIndex == index
                      ? ColorUtils.color_text_theme
                      : ColorUtils.color_text_level1,
                ),
              ),
            ),
          ),
          Container(
            height: 0.5,
            color: ColorUtils.color_bg_splitLine,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
