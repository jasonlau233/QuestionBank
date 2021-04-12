import 'package:flutter/material.dart';
import 'package:question_bank/core/router/app_router_navigator.dart';
import 'package:question_bank/route/path.dart';
import 'package:question_bank/utils/color.dart';
import 'package:question_bank/widget/lock_gesture_detector.dart';
import 'package:question_bank/widget/my_image.dart';

class VideoIframe extends StatefulWidget {
  const VideoIframe({
    Key key,
    this.vid = const [],
    this.title,
    this.thumbnail,
  }) : super(key: key);

  /// 保利威视频vid
  final List<String> vid;

  /// 视频标题
  final String title;

  /// 视频缩略图
  final String thumbnail;

  @override
  _VideoIframeState createState() => _VideoIframeState();
}

class _VideoIframeState extends State<VideoIframe> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.93);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget get _buildVideoFrame {
    if (widget.vid.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: _buildVideoItem(widget.vid.first),
      );
    }
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.only(left: 4),
        child: PageView(
          controller: _pageController,
          children: List.generate(
            widget.vid.length,
            (index) => Container(
              height: 183,
              width: 200,
              margin: EdgeInsets.only(right: index == widget.vid.length - 1 ? 0 : 6),
              child: _buildVideoItem(widget.vid[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoItem(String vid) {
    return LockGestureDetector(
      onItemClickListenCallback: () async {
        AppRouterNavigator.of(context).push(
          POLY_V_FULL,
          params: {
            'vid': vid,
            // 'vid': 'a647f95e6ead0728ce57fc7d6c421952_a',
            'title': widget.title,
            'closeIcon': const MyAssetImage(
              'assets/images/base_arrow_left.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            'closePageCallBack': () => AppRouterNavigator.of(context).pop(),
          },
        );
        return true;
      },
      child: Container(
        height: 183,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 6),
        color: Colors.grey,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.thumbnail != null && widget.thumbnail.isNotEmpty)
              MyNetworkImage(
                widget.thumbnail ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            Container(color: Colors.black26),
            const MyAssetImage(
              'assets/images/playing_center_start.png',
              width: 54,
              height: 54,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 236,
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 14,
                margin: const EdgeInsets.only(right: 6, left: 16),
                decoration: BoxDecoration(
                  color: ColorUtils.color_bg_theme,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                "视频解析",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )
            ],
          ),
          _buildVideoFrame,
        ],
      ),
    );
  }
}
