import 'package:flutter/material.dart';
import 'package:lazyload/ui/navigation/main_navigation.dart';

import '../../Theme/app_colors.dart';
import 'my_app_model.dart';

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  final MyAppModel model;
  const MyApp({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mainDarkBlue,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateRoute,
      initialRoute: mainNavigation.initialRoute(model.isAuth),
    );
  }
}
