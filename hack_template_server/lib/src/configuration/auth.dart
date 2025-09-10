import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart' as auth;

extension SetupAuth on Serverpod {
  Future<void> setupAuth() async {
    auth.AuthConfig.set(auth.AuthConfig(
      sendValidationEmail: (session, email, validationCode) async {
        return true;
      },
      sendPasswordResetEmail: (session, userInfo, validationCode) async {
        return true;
      },
    ));
  }
}
