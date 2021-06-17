import 'package:flutter/cupertino.dart';

class NorseObserver extends NavigatorObserver {
  NorseObserver(this.onPop);

  final Function() onPop;

  @override
  void didPop(Route route, Route? previousRoute) {
    onPop();
  }
}