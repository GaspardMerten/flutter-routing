import 'package:flutter/material.dart'
    show BuildContext, MaterialPageRoute, Route, RouteSettings, Widget;

import 'paths.dart';

final Route<A> Function<A>(Widget view) _kDefaultRouteWidgetBuilder =
    <A>(Widget view) {
  return MaterialPageRoute<A>(builder: (BuildContext context) => view);
};

class NorseRouter {
  final String basePath;

  final Function(String log) logger;

  final List<NorsePath> children;

  NorseRouter({this.children = const [], this.logger, this.basePath = ''}) {
    for (final NorsePath path in children) {
      this._populateComputedMap(basePath, path);
    }
  }

  void _populateComputedMap(String previousPath, NorsePath _rootingPath) {
    if (_rootingPath is BuildableNorsePath) {
      _computedMap['$previousPath/${_rootingPath.name}'] =
          _rootingPath.buildRoute;
    }

    for (final NorsePath childPath in _rootingPath.children ?? []) {
      _populateComputedMap('$previousPath/${_rootingPath.name}', childPath);
    }
  }

  Route Function([dynamic value]) _getRoutingPath(String route) {
    assert(_computedMap.containsKey(route),
        '$route is not present in the computed dictionary');

    return _computedMap[route];
  }

  Route onGenerateRoute(RouteSettings routeSettings) {
    final Route Function([dynamic value]) _routeBuilder =
        _getRoutingPath(routeSettings.name);

    logger?.call(routeSettings.name);

    return _routeBuilder(routeSettings.arguments);
  }

  final Map<String, Route Function([dynamic value])> _computedMap = {};

  static Route<A> Function<A>(Widget view) routeBuilder =
      _kDefaultRouteWidgetBuilder;
}
