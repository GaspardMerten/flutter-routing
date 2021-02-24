library routing;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef routeBuilder = Route Function([dynamic value]);

final Route<A> Function<A>(Widget view) _kDefaultRouteWidgetBuilder = <A>(Widget view) {
  return MaterialPageRoute<A>(builder: (BuildContext context) => view);
};

class NorseRouter {
  final String basePath;

  final Function(String log) logger;

  final List<NorsePath> children;

  NorseRouter({this.children = const [],this.logger,  this.basePath = ''}) {
    for (final NorsePath path in children) {
      this._populateComputedMap(basePath, path);
    }
  }

  void _populateComputedMap(String previousPath, NorsePath _rootingPath) {
    if (_rootingPath is BuildableNorsePath) {
      _computedMap['$previousPath/${_rootingPath.name}'] = _rootingPath.buildRoute;
    }

    for (final NorsePath childPath in _rootingPath.children ?? []) {
      _populateComputedMap('$previousPath/${_rootingPath.name}', childPath);
    }

  }

  Route Function([dynamic value]) _getRoutingPath(String route) {
    assert(_computedMap.containsKey(route), '$route is not present in the computed dictionary');

    return _computedMap[route];
  }

  Route onGenerateRoute (RouteSettings routeSettings) {
    final Route Function([dynamic value]) _routeBuilder = _getRoutingPath(routeSettings.name);

    logger?.call(routeSettings.name);

    return _routeBuilder(routeSettings.arguments);
  }

  final Map<String, Route Function([dynamic value])> _computedMap = {};

  static Route<A> Function<A>(Widget view) routeBuilder = _kDefaultRouteWidgetBuilder;
}

class NorsePath<T extends Object, A extends Object> {
  NorsePath({this.name, this.children});

  final String name;

  final List<NorsePath> children;
}

abstract class BuildableNorsePath<T extends Object, A extends Object> extends NorsePath<T, A> {
  String get name;

  List<NorsePath> get children;

  Route<A> buildRoute([T value]);
}

@immutable
class NorseViewPath<T, A> extends BuildableNorsePath<T, A> {
  final List<NorsePath> children;

  final Widget view;

  final String name;

  NorseViewPath({this.children, this.view, this.name})
      : assert(view != null);

  @override
  Route<A> buildRoute([T value]) {
    return NorseRouter.routeBuilder<A>(view);
  }
}

@immutable
class NorseViewBuilderPath<T extends Object, A extends Object> extends BuildableNorsePath<T, A> {
  final List<NorsePath> children;

  final Function(T value) widgetBuilder;

  final String name;

  @override
  Route<A> buildRoute([T value]) {
    return NorseRouter.routeBuilder<A>(widgetBuilder(value));
  }

  NorseViewBuilderPath({this.children, this.widgetBuilder, this.name})
      : assert(widgetBuilder != null);
}
