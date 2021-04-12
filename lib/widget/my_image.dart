import 'package:flutter/material.dart';

/// Network Image
class MyNetworkImage extends StatelessWidget {
  const MyNetworkImage(
    this.name, {
    Key key,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.fit,
    this.color,
    this.loadingBuilder,
    this.errorBuilder,
  }) : super(key: key);

  final String name;
  final double width;
  final double height;
  final Alignment alignment;
  final BoxFit fit;
  final Color color;
  final ImageLoadingBuilder loadingBuilder;
  final ImageErrorWidgetBuilder errorBuilder;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      name ?? '',
      width: width,
      height: height,
      alignment: alignment,
      fit: fit,
      color: color,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Asset Image
class MyAssetImage extends StatelessWidget {
  const MyAssetImage(
    this.name, {
    Key key,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.fit,
    this.color,
  }) : super(key: key);

  final String name;
  final double width;
  final double height;
  final Alignment alignment;
  final BoxFit fit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      name ?? '',
      width: width,
      height: height,
      alignment: alignment,
      fit: fit,
      color: color,
    );
  }
}

/// 清理网络图片缓存
void evictNetworkImages(List<String> urlList) async {
  urlList?.forEach((path) {
    if (path != null) {
      final provider = NetworkImage(path);
      //不打印日志
      provider.evict();
    }
  });
}
