import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/converter_screen.dart';
import 'screens/result_screen.dart';
import 'screens/not_found_screen.dart';

import 'theme/theme_controller.dart';
import 'theme/theme_scope.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  usePathUrlStrategy();
  
  GoRouter.optionURLReflectsImperativeAPIs = true; 
  
  final themeController = ThemeController();
  await themeController.load();
  
  runApp(MyApp(themeController: themeController));
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
    GoRoute(path: '/calculator', builder: (c, s) => const CalculatorScreen()),
    GoRoute(path: '/converter', builder: (c, s) => const ConverterScreen()),
    GoRoute(
      path: '/result',
      builder: (context, state) {
        return ResultScreen(params: state.uri.queryParameters);
      },
    ),
  ],
  errorBuilder: (context, state) => NotFoundScreen(uri: state.uri),
);

class MyApp extends StatelessWidget {
  final ThemeController themeController;
  const MyApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: themeController,
      child: ListenableBuilder(
        listenable: themeController,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'calc_app',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: themeController.mode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}