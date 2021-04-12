import 'package:flutter/material.dart';
import 'package:question_bank/config/build_config.dart';
import 'package:question_bank/utils/theme.dart';
import 'package:question_bank/widget/loading/general_loading.dart';

class LoadingDataContainer extends StatelessWidget {
  final bool showHeader;
  final String title;

  const LoadingDataContainer({
    Key key,
    this.showHeader = false,
    this.title = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showHeader
          ? AppBar(
              toolbarHeight: BuildConfig.appBarHeight,
              leading: ThemeUtils.getDefaultLeading(),
            )
          : null,
      body: GeneralLoading(title: title),
    );
  }
}
