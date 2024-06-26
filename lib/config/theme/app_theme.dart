import 'package:flutter/material.dart';

import 'color_manager.dart';

class AppTheme {
  final bool isDarkMode;

  const AppTheme({this.isDarkMode = true});

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: ColorManager.malachite,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,

        /// drawer
        drawerTheme: const DrawerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          endShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
        ),
        navigationDrawerTheme: NavigationDrawerThemeData(
          tileHeight: 80,
          indicatorSize: const Size.fromHeight(double.infinity),
          indicatorColor: ColorManager.colorSeed,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          elevation: 0,
          iconTheme: const WidgetStatePropertyAll(
            IconThemeData(
              size: 60,
            ),
          ),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          
          indicatorShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
          ),
        ),

        /// Text
        textTheme: const TextTheme(
          labelLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            color: ColorManager.blueOuterSpace,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          titleSmall: TextStyle(
            color: ColorManager.blueOuterSpace,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            color: ColorManager.blueOuterSpace,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            color: ColorManager.blueOuterSpace,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
}
