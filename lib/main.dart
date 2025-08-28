import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'navigation/app_navigation.dart';
import 'storage/db_storage/db_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbStorage.instance.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            //全局设置状态栏
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
            ),
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            iconTheme: IconThemeData(color: Colors.black),
          )),
      home: const AppNavigation(),
    );
  }
}
