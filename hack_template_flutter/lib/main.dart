import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'config/di/di.dart';
import 'ui/core/ui/hack_template_app.dart';

void main() => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        configureDependencies();

        Bloc.observer = TalkerBlocObserver(talker: getIt.get<Talker>());

        runApp(HackTemplateApp());
      },
      (error, stack) => getIt.get<Talker>().handle(error, stack),
    );
