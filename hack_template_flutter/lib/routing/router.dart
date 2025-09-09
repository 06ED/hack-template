import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

@TypedGoRoute<HomeScreenRoute>(path: '/')
class HomeScreenRoute extends GoRouteData with $HomeScreenRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Placeholder();
  }
}
