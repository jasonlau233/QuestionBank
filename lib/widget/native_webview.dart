import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NativeWebView extends StatefulWidget {
  /// 请求的网址
  final String url;

  /// 拦截页面url
  final NavigationDelegate navigationDelegate;

  const NativeWebView({
    Key key,
    this.url,
    this.navigationDelegate,
  })  : assert(url != null),
        super(key: key);

  @override
  _NativeWebViewState createState() => _NativeWebViewState();
}

class _NativeWebViewState extends State<NativeWebView> {
  /// 是否显示对应的加载中
  bool hiddenLoading = false;

  /// 是否开始初始化
  bool isCanLoadingWebView = false;

  @override
  void initState() {
    super.initState();

    /// Enable hybrid composition.
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    /// 主要是为了减少动画导致了卡顿，延迟动画完了再去加载原生视图
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 450), () {
            setState(() => isCanLoadingWebView = true);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 页面正在开始加载
  void _onPageStarted(String url) {}

  /// 页面加载完毕
  void _onPageFinished(String url) {}

  @override
  Widget build(BuildContext context) {
    return isCanLoadingWebView
        ? WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: _onPageStarted,
            onPageFinished: _onPageFinished,
            navigationDelegate: widget.navigationDelegate,
          )
        : const Center(
            child: const SizedBox(
              width: 40.0,
              height: 40.0,
              child: const CircularProgressIndicator(),
            ),
          );
  }
}
