import 'package:flutter/material.dart';

class NorseObserver extends NavigatorObserver {
  NorseObserver(this.onPop);

  final Function() onPop;

  @override
  void didPop(Route route, Route? previousRoute) {
    if (!(route is DialogRoute || route is OverlayRoute)) {
      onPop();
    }
  }
}