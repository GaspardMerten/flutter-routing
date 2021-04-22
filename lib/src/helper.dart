import 'package:flutter/material.dart' show BuildContext, Navigator;

Future<T?> navTo<T extends Object>(
  BuildContext context,
  String name, {
  dynamic arg,
}) {
  return Navigator.of(context).pushNamed<T>(name, arguments: arg);
}
