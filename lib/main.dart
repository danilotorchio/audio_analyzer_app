import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        log(details.exceptionAsString(), stackTrace: details.stack);
      };

      runApp(const App());
    },
    (error, stack) => log(error.toString()),
  );
}
