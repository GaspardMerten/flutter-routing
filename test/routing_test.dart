import 'package:flutter/material.dart';
import 'package:routing/routing.dart';

Widget viewBuilder(String name) => Scaffold(body: Center(child: Text(name)));

void main() {

  final NorseRouter tree = NorseRouter(
      children: [
        NorseViewPath(
            name: 'public',
            view: viewBuilder('public'),
            children: [
              NorseViewPath(
                name: 'login',
                view: viewBuilder('login'),
              ),
              NorseViewPath(
                  name: 'register',
                  view: viewBuilder('register'),
                  children: [
                    NorsePath(
                        name: 'flow',
                        children: [
                          NorseViewPath(
                            name: 'godfather',
                            view: viewBuilder('godfather'),
                          ),
                          NorseViewPath(
                            name: 'username',
                            view: viewBuilder('username'),
                          ),
                        ]
                    )
                  ]
              ),
              NorseViewPath(
                  name: 'passwordForgotten',
                  view: viewBuilder('passwordForgotten'),
                  children: [
                    NorseViewPath(
                        name: 'codeValidation',
                        view: viewBuilder('codeValidation'),
                        children: [
                          NorseViewPath(
                            name: 'changePassword',
                            view: viewBuilder('changePassword'),
                          ),
                        ]
                    ),
                  ]
              ),
            ]
        )
      ]
  );
}

