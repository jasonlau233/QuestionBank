import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_poly_v_plugin/demo/poly_v_portrait_demo.dart';
import 'package:flutter_poly_v_plugin/flutter_poly_v_plugin.dart';
import 'package:flutter_poly_v_plugin/widget/poly_v_full_screen_page.dart';

///
/// 保利威视demo例子
///
class PolyVDemo extends StatefulWidget {
  @override
  _PolyVDemoState createState() => _PolyVDemoState();
}

class _PolyVDemoState extends State<PolyVDemo> {
  /// 版本号
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    getPlatformVersion();
  }
  static const TEST_VID='a647f95e6ead0728ce57fc7d6c421952_a';

  Future<void> getPlatformVersion() async {
    String platformVersion;
    try {
      platformVersion = await FlutterPolyVPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('保利威视demo 版本=$_platformVersion'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RaisedButton(
                child: Text('全屏Demo'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (pageContext) => PolyVFullScreenPage(
                        vid: TEST_VID,
                        closeIcon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        closePageCallBack: ()=> Navigator.maybePop(pageContext),
                        shareBtn: IconButton(
                          icon: const Icon(
                            Icons.share_sharp,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  );
                },
              ),
              Padding(padding: EdgeInsets.only(top: 50)),
              RaisedButton(
                child: Text('竖屏Demo'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => PolyVPortraitDemo(
                          vid: TEST_VID,
                          title: '测试标题',
                        )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}