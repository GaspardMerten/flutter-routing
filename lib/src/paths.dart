import 'package:flutter/material.dart' show Route, Widget;

import 'router.dart';

/// A class representing a node in the navigation tree.
class NorsePath<T extends Object?, A extends Object?> {
  NorsePath({this.parent, required this.name, this.children = const []})
      : childrenDict = Map.fromIterable(children, key: (e) => e.name) {
    children.forEach(_populateChild);
  }

  /// A link to the parent [NorsePath] path. A parent-child link is when
  /// a path (the child) is contained inside the children field of another path (the parent).
  ///
  /// The field is populated in the parent's constructor and is used to accelerate
  /// the relative-rooting based navigation.
  late NorsePath? parent;

  /// A [Map] field populated in this object's constructor to allow faster
  /// relative-rooting based navigation by creating a more efficient way
  /// to retrieve a child based on his name.
  ///
  /// Otherwise calling [children.where] would be mandatory to check/get a child
  /// of this object.
  final Map<String, NorsePath> childrenDict;

  /// The name that will be used to access this path using the [NorseRouter.routeBuilder]
  /// method.
  final String name;

  /// An optional list of path.
  /// If this object's name field is 'home' and one of the child's name is 'profile'.
  /// Accessing the child will be achieved using the following url '/home/profile'.
  /// Or if the user is already on the home page, '/profile' using the relative-rooting
  /// based navigation.
  final List<NorsePath> children;

  void _populateChild(NorsePath child) => child.parent = this;

  String buildPath() {
    final String _path = '/$name';
    if (parent != null) {
      return parent!.buildPath() + _path;
    }
    return _path;
  }
}

abstract class BuildableNorsePath<T extends Object?, A extends Object?>
    extends NorsePath<T, A> {
  BuildableNorsePath(String name, [List<NorsePath> children = const []])
      : super(
          name: name,
          children: children,
        );

  Route<A> buildRoute([T? value]);

  @override
  String toString() {
    return buildPath();
  }
}

class NorseViewPath<T, A> extends BuildableNorsePath<T, A> {
  NorseViewPath({
    required String name,
    required this.view,
    List<NorsePath> children = const [],
  }) : super(name, children);

  final Widget Function() view;

  @override
  Route<A> buildRoute([T? value]) {
    return NorseRouter.routeBuilder<A>(view(), this);
  }
}

class NorseViewBuilderPath<T extends Object, A extends Object>
    extends BuildableNorsePath<T, A> {
  NorseViewBuilderPath({
    required String name,
    required this.widgetBuilder,
    List<NorsePath> children = const [],
  }) : super(name, children);

  final Function(T value) widgetBuilder;

  @override
  Route<A> buildRoute([T? value]) {
    assert(value != null);

    return NorseRouter.routeBuilder<A>(widgetBuilder(value!), this);
  }
}
