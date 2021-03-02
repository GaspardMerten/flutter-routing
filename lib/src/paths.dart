import 'package:flutter/material.dart' show Route, immutable, Widget;

import 'router.dart';

class NorsePath<T extends Object, A extends Object> {
  NorsePath({this.name, this.children});

  final String name;

  final List<NorsePath> children;
}

abstract class BuildableNorsePath<T extends Object, A extends Object>
    extends NorsePath<T, A> {
  String get name;

  List<NorsePath> get children;

  Route<A> buildRoute([T value]);
}

@immutable
class NorseViewPath<T, A> extends BuildableNorsePath<T, A> {
  final List<NorsePath> children;

  final Widget Function() view;

  final String name;

  NorseViewPath({this.children, this.view, this.name}) : assert(view != null);

  @override
  Route<A> buildRoute([T value]) {
    return NorseRouter.routeBuilder<A>(view());
  }
}

@immutable
class NorseViewBuilderPath<T extends Object, A extends Object>
    extends BuildableNorsePath<T, A> {
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
