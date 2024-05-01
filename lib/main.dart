import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'views/remove_bg_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final boatToastBuilder = BotToastInit();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Remove Background',
      debugShowCheckedModeBanner: false,
      home: const RemoveBackgroundScreen(),
      builder: (context, child) {
        child = boatToastBuilder(context, child);
        return Theme(
          data: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primarySwatch: Colors.deepPurple,
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.teal,
            cardColor: Colors.deepPurple.shade400,
          ),
          child: child,
        );
      },
    );
  }
}
