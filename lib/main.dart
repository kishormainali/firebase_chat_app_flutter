import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mvvm_architecture/di/injection.dart';
import 'package:mvvm_architecture/views/routes/app_router.gr.dart';
import 'package:stacked_services/stacked_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setUpInjection(Environment.prod);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                Size.fromHeight(
                  50,
                ),
              ),
              textStyle: MaterialStateProperty.all(TextStyle(
                fontSize: 18.0,
              ))),
        ),
      ),
      onGenerateRoute: AppRouter().onGenerateRoute,
      initialRoute: Routes.splashView,
      navigatorKey: getIt<NavigationService>().navigatorKey,
    );
  }
}
