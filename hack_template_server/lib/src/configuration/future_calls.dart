import 'package:serverpod/serverpod.dart';

import '../birthday_reminder.dart';
import '../generated/protocol.dart';

enum FutureCallNames { birthdayReminder }

extension SetupFutureCalls on Serverpod {
  Future<void> setupFutureCalls() async {
    registerFutureCall(
      BirthdayReminder(),
      FutureCallNames.birthdayReminder.name,
    );

    await futureCallWithDelay(
      FutureCallNames.birthdayReminder.name,
      Greeting(
        message: 'Hello!',
        author: 'Serverpod Server',
        timestamp: DateTime.now(),
      ),
      Duration(seconds: 5),
    );
  }
}
