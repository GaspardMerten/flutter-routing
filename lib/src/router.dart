import 'package:flutter/material.dart';
import 'observer.dart';
import 'paths.dart' show BuildableNorsePath, NorsePath;

final Route<A> Function<A>(Widget view) _kDefaultRouteWidgetBuilder =
    <A>(Widget view) {
  return MaterialPageRoute<A>(builder: (BuildContext context) => view);
};

class NorseRouter {
  final String basePath;

  final Function(String log)? logger;

  final List<NorsePath> children;

  late NorseObserver observer = NorseObserver(_updateLatestPath);

  BuildableNorsePath? latestPath;

  NorseRouter({this.children = const [], this.logger, this.basePath = ''}) {
    for (final NorsePath path in children) {
      this._populateComputedMap(basePath, path);
    }
  }

  void _updateLatestPath(String newStringPath) {
    latestPath = _computedMap[newStringPath];
  }

  void _populateComputedMap(String previousPath, NorsePath _rootingPath) {
    if (_rootingPath is BuildableNorsePath) {
      _computedMap['$previousPath/${_rootingPath.name}'] = _rootingPath;
    }

    for (final NorsePath childPath in _rootingPath.children) {
      _populateComputedMap('$previousPath/${_rootingPath.name}', childPath);
    }
  }

  Route Function([dynamic value])? _getRoutingPath(String? route) {
    assert(route != null);

    NorsePath? newPath = _computedMap[route];

    if (newPath == null && latestPath != null) {
      NorsePath currentPath = latestPath!;

      for (final String partialPath
          in route!.split('/').where((e) => e.isNotEmpty)) {
        if (partialPath == '..' && currentPath.parent != null) {
          currentPath = currentPath.parent!;
        } else {
          if (!currentPath.childrenDict.containsKey(partialPath)) {
            throw Exception('No relative path found for $route');
          }

          currentPath = currentPath.childrenDict[partialPath]!;
        }
      }

      if (currentPath == latestPath) {
        throw Exception('No path/relative path found for $route');
      } else {
        newPath = currentPath;
      }
    }

    if (newPath is BuildableNorsePath) {
      latestPath = newPath;

      return newPath.buildRoute;
    } else {
      throw Exception(
          'A matching path was found but its instance does not extend the BuildableNorsePath class');
    }
  }

  Route onGenerateRoute(RouteSettings routeSettings) {
    final Route Function([dynamic value]) _routeBuilder =
        _getRoutingPath(routeSettings.name)!;

    logger?.call(routeSettings.name!);

    return _routeBuilder(routeSettings.arguments);
  }

  final Map<String, BuildableNorsePath> _computedMap = {};

  static Route<A> Function<A>(Widget view) routeBuilder =
      _kDefaultRouteWidgetBuilder;
}
