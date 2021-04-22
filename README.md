# Routing

An object-oriented package allowing you to build up a navigation tree from well-defined classes and to use
relative navigation.

You can also use it to have named routes with <b>typed</b> arguments.

## Example

```dart

final NorseRouter router = NorseRouter(
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

...
MaterialApp(
  onGenerateRoute: router.onGenerateRoute
)
...

Navigator.of(context).pushNamed('/public/login');

Navigator.of(context).pushNamed('/public');
// shorthand version
navTo(context, '/public');

// Relative routing based navigation
navTo(context, 'login');
navTo(context, '../register');
```