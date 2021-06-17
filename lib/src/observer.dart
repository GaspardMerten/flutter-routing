import 'package:flutter/cupertino.dart';

class NorseObserver extends NavigatorObserver {
  NorseObserver(this.setCurrentRoute);

  final Function(String newRouteName) setCurrentRoute;

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      setCurrentRoute(route.settings.name!);
    }
  }
}