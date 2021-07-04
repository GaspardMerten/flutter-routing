import 'package:flutter/material.dart';
import 'package:flutter_routing/flutter_routing.dart';
import 'package:flutter_test/flutter_test.dart';

Widget viewBuilder(String name) => Scaffold(body: Center(child: Text(name)));

void main() {
  final NorseRouter tree = NorseRouter(children: [
    NorseViewPath(name: 'public', view: () => viewBuilder('public'), children: [
      NorseViewPath(
        name: 'login',
        view: () => viewBuilder('login'),
      ),
      NorseViewPath(
          name: 'register',
          view: () => viewBuilder('register'),
          children: [
            NorsePath(name: 'flow', children: [
              NorseViewPath(
                name: 'godfather',
                view: () => viewBuilder('godfather'),
              ),
              NorseViewPath(
                name: 'username',
                view: () => viewBuilder('username'),
              ),
            ])
          ]),
      NorseViewPath(
          name: 'passwordForgotten',
          view: () => viewBuilder('passwordForgotten'),
          children: [
            NorseViewPath(
                name: 'codeValidation',
                view: () => viewBuilder('codeValidation'),
                children: [
                  NorseViewPath(
                    name: 'changePassword',
                    view: () => viewBuilder('changePassword'),
                  ),
                ]),
          ]),
    ])
  ]);

  test('Simple tree navigation', () {
    expect(tree.onGenerateRoute(RouteSettings(name: '/public')),  isNotNull);
    expect(tree.onGenerateRoute(RouteSettings(name: '/public/login')),  isNotNull);
    expect(tree.onGenerateRoute(RouteSettings(name: '/public/register')),  isNotNull);
  });

  test('Relative tree navigation', () {

    expect(tree.onGenerateRoute(RouteSettings(name: '/public')),  isNotNull);
    expect(tree.onGenerateRoute(RouteSettings(name: 'login')),  isNotNull);
    expect(tree.onGenerateRoute(RouteSettings(name: '../register')),  isNotNull);
    expect(tree.onGenerateRoute(RouteSettings(name: '../login')),  isNotNull);
    expect(tree.onGenerateRoute(RouteSettings(name: '../register/flow/godfather')),  isNotNull);

    tree.observer.onPop();

    expect(tree.onGenerateRoute(RouteSettings(name: '../register')),  isNotNull);
  });
}
