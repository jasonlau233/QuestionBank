import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import '../widget/loading/general_loading.dart';

/// toast样式主题
enum ToastTheme {
  /// 明亮,黑底白字
  light,

  /// 暗黑,白底黑字
  dark
}

class ToastUtils {
  /// 文本toast
  static void showText({
    @required String text,
    ToastTheme theme = ToastTheme.light,
    Duration duration = const Duration(seconds: 3),
    AlignmentGeometry align = const Alignment(0, 0.8),
    EdgeInsetsGeometry contentPadding = const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 9),
  }) {
    Color contentColor;
    TextStyle textStyle = TextStyle(fontSize: 13, color: Colors.white);

    switch (theme) {
      case ToastTheme.dark:
        contentColor = Colors.white;
        textStyle = TextStyle(fontSize: 13, color: Colors.black);
        break;
      case ToastTheme.light:
      default:
        contentColor = Color(0xFF1D1D1D);
        textStyle = TextStyle(fontSize: 13, color: Colors.white);
        break;
    }

    BotToast.showText(
      text: text,
      contentColor: contentColor,
      duration: duration,
      textStyle: textStyle,
      align: align,
      contentPadding: contentPadding,
    ); //popup a text toast;
  }

  /// toast通知样式
  static void showSimpleNotification({
    @required String title,
    String subTitle,
    GestureTapCallback onTap,
    Color backgroundColor,
    double borderRadius,
    Alignment align = const Alignment(0, -0.99),
    List<DismissDirection> dismissDirections = const [DismissDirection.horizontal, DismissDirection.up],
    Icon closeIcon,
    Duration duration = const Duration(seconds: 3),
  }) {
    BotToast.showSimpleNotification(
      title: title,
      subTitle: subTitle,
      onTap: onTap,
      align: align,
      closeIcon: closeIcon,
      duration: duration,
      backgroundColor: backgroundColor,
    ); // popup a notification toast;
  }

  /// loading
  static void showCustomLoading({
    @required ToastBuilder toastBuilder,
    WrapAnimation wrapToastAnimation,
    Alignment align = Alignment.center,
    BackButtonBehavior backButtonBehavior,
    bool clickClose = false,
    bool allowClick = false,
    bool ignoreContentClick = false,
    bool crossPage = false,
    bool enableKeyboardSafeArea = true,
    VoidCallback onClose,
    Duration duration,
    Duration animationDuration,
    Duration animationReverseDuration,
    Color backgroundColor = Colors.black26,
  }) {
    BotToast.showCustomLoading(
      enableKeyboardSafeArea: enableKeyboardSafeArea,
      toastBuilder: toastBuilder,
      backButtonBehavior: backButtonBehavior,
      animationDuration: animationDuration ?? const Duration(milliseconds: 300),
      animationReverseDuration: animationReverseDuration,
      wrapToastAnimation: wrapToastAnimation,
      onClose: onClose,
      clickClose: clickClose,
      allowClick: allowClick,
      crossPage: crossPage,
      ignoreContentClick: ignoreContentClick,
      duration: duration,
      backgroundColor: backgroundColor,
    );
  }

  static void showGeneralLoading({String title = "正在请求中"}) {
    showCustomLoading(
      enableKeyboardSafeArea: false,
      toastBuilder: (CancelFunc cancelFunc) {
        return GeneralLoading(
          title: title,
        );
      },
      backButtonBehavior: BackButtonBehavior.close,
      clickClose: true,
    );
  }

  /// 清楚所有loading
  static void cleanAllLoading() {
    BotToast.closeAllLoading();
  }
}
