import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_rev/layout/home_screen.dart';
import 'package:todo_rev/shared/bloc_observer.dart';
import 'package:todo_rev/shared/components/constants.dart';
import 'package:todo_rev/shared/style/colors.dart';
import 'package:todo_rev/shared/style/themes.dart';

void main() {

  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: HomeLayoutScreen(),
    );
  }

}



