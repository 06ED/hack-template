// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:hack_template_client/hack_template_client.dart' as _i385;
import 'package:hack_template_flutter/config/di/modules/app_module.dart'
    as _i931;
import 'package:injectable/injectable.dart' as _i526;
import 'package:talker_flutter/talker_flutter.dart' as _i207;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.factory<_i207.Talker>(() => appModule.talker);
    gh.factory<_i385.Client>(() => appModule.client);
    gh.factory<_i583.GoRouter>(() => appModule.router);
    return this;
  }
}

class _$AppModule extends _i931.AppModule {}
