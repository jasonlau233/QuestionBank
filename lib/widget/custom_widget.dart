import 'package:flutter/cupertino.dart';

///展示ios风格的提示dialog
Future<bool> showIosTipsDialog(BuildContext context, String title, String content, {VoidCallback confirm, VoidCallback cancel}) {
  return showCupertinoDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Container(
          margin: const EdgeInsets.only(top: 12),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        insetAnimationDuration: const Duration(milliseconds: 350),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('取消'),
            onPressed: cancel ??
                () {
                  Navigator.pop(context);
                },
          ),
          CupertinoDialogAction(
            child: Text('确认'),
            onPressed: confirm ??
                () {
                  Navigator.pop(context);
                },
          ),
        ],
      );
    },
  );
}
