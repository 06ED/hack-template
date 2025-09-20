import 'package:go_router/go_router.dart';
import 'package:hack_template_client/hack_template_client.dart';
import 'package:injectable/injectable.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../routing/routing.dart';
import '../../enviroment.dart';
import '../di.dart';

@module
abstract class AppModule {
  Talker get talker => TalkerFlutter.init();

  Client get client =>
      Client(apiUrl)..connectivityMonitor = FlutterConnectivityMonitor();

  GoRouter get router => GoRouter(
        routes: $appRoutes,
        observers: [TalkerRouteObserver(getIt.get<Talker>())],
      );
}
