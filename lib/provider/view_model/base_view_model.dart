import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:question_bank/em/view_state_type.dart';

class BaseViewModel with ChangeNotifier, DiagnosticableTreeMixin {
  /// 页面状态
  ViewState _viewState = ViewState.Idle;
  ViewState get viewState => _viewState;
  set viewState(ViewState state) {
    if (_viewState != state) {
      _viewState = state;
      notifyListeners();
    }
  }
}
