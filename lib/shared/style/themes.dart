
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    bodyText1: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.black
    ),
  ),
  fontFamily: 'Muli',
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: defaultColor[400],

    ),
    elevation: 0.0,
    titleSpacing: 20.0,
    titleTextStyle: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.w900,
    ),
    centerTitle: true,
    iconTheme: IconThemeData(
      size: 30.0,
      color: Colors.white,
    ),


  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 20.0,
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,

  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: defaultColor
  ),
);