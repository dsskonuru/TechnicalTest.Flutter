import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/router/router.gr.dart';
// import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // _setupLogging();
  runApp(const ProviderScope(child: MyApp()));
}

final container = ProviderContainer();

final sharedPreferencesProvider = Provider<Future<SharedPreferences>>(
  (ref) async => SharedPreferences.getInstance(),
);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  void dispose() {
    container.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
    );
  }
}

// void _setupLogging() {
//   Logger.root.level = Level.ALL;
//   Logger.root.onRecord.listen((rec) {
//     debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
//   });
// }
