import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:question_bank/utils/color.dart';

/// 自定义列表的加载状态
class MyLoadingMoreIndicator {
  const MyLoadingMoreIndicator({
    this.listSourceRepository,
    this.isSliver = false,
    this.loadingMoreBusyingWidget,
    this.fullScreenBusyingWidget,
    this.errorWidget,
    this.fullScreenErrorWidget,
    this.noMoreLoadWidget,
    this.emptyWidget,
  });

  final LoadingMoreBase listSourceRepository;
  final bool isSliver;
  final Widget loadingMoreBusyingWidget;
  final Widget fullScreenBusyingWidget;
  final Widget errorWidget;
  final Widget fullScreenErrorWidget;
  final Widget noMoreLoadWidget;
  final Widget emptyWidget;

  Widget build(BuildContext context, IndicatorStatus status) {
    Widget widget;
    switch (status) {
      case IndicatorStatus.none:
        widget = Container(height: 0.0);
        break;
      case IndicatorStatus.loadingMoreBusying:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 5.0),
                height: 15.0,
                width: 15.0,
                child: getIndicator(context)),
            Text("拼命加载中")
          ],
        );
        widget = setBackground(false, widget, 35.0);
        widget = loadingMoreBusyingWidget ?? widget;
        break;
      case IndicatorStatus.fullScreenBusying:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 4.0),
              height: 30.0,
              width: 30.0,
              child: getIndicator(context),
            ),
            Text("刷新中")
          ],
        );
        widget = setBackground(true, widget, double.infinity);
        widget = fullScreenBusyingWidget ?? widget;
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.error:
        widget = Text(
          "加载失败(点我重试)",
        );
        widget = setBackground(false, widget, 35.0);
        widget = errorWidget ?? widget;
        widget = GestureDetector(
          onTap: () {
            listSourceRepository?.errorRefresh();
          },
          child: widget,
        );
        break;
      case IndicatorStatus.fullScreenError:
        widget = Text(
          "加载失败(点我重试)",
        );
        widget = setBackground(true, widget, double.infinity);
        widget = fullScreenErrorWidget ?? widget;
        widget = GestureDetector(
          onTap: () {
            listSourceRepository?.errorRefresh();
          },
          child: widget,
        );
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.noMoreLoad:
        widget = Text(
          "没有更多了",
          style: TextStyle(color: ColorUtils.color_text_level1),
        );
        widget = setBackground(false, widget, 80.0);
        widget = noMoreLoadWidget ?? widget;
        break;
      case IndicatorStatus.empty:
        widget = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.privacy_tip_outlined,
                size: 64,
                color: ColorUtils.color_text_level1,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Text(
                "暂无数据",
                style: TextStyle(
                    fontSize: 10, color: ColorUtils.color_text_level1),
              )
            ],
          ),
        );
        widget = emptyWidget ?? widget;
        widget = GestureDetector(
          onTap: () => listSourceRepository?.errorRefresh(),
          child: widget,
        );
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
    }
    return widget;
  }

  Widget setBackground(bool full, Widget widget, double height,
      {Color backgroundColor}) {
    widget = Container(
      width: double.infinity,
      height: height,
      child: widget,
//        color: backgroundColor ?? Colors.grey[200],
      alignment: Alignment.center,
    );
    return widget;
  }

  Widget getIndicator(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
            animating: true,
            radius: 16.0,
          )
        : CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
          );
  }
}
