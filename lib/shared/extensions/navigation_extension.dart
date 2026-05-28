// - BottomSheet, Dialog, FullscreenDialog

import 'package:flutter/cupertino.dart';

extension ContextNavExtension on BuildContext {
  Future<T?> pushWidget<T>(
    Widget page, {
    bool fullscreenDialog = false,
    bool maintainState = true,
  }) {
    return Navigator.of(this, rootNavigator: true).push<T>(
      CupertinoPageRoute(
        builder: (_) => page,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
        settings: RouteSettings(name: page.runtimeType.toString()),
      ),
    );
  }

  void pop<T>([T? result]) => Navigator.of(this).pop<T>(result);

  bool canPop() => Navigator.of(this).canPop();
}
