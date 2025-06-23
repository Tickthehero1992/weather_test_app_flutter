import 'package:flutter/material.dart';
import 'auth_worker/pages/auth_init_page.dart';
import 'ble_worker/ble_worker_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        cardTheme: CardTheme(
                  color: Colors.greenAccent[40],
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
                  margin: const EdgeInsets.all(16.0),

        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            textStyle: TextStyle(
              color: Colors.greenAccent,
              fontSize: 14,
              fontStyle: FontStyle.italic
            )
          )
        ),

        useMaterial3: true,
      ),
     // home: BleWorkerPage(),
      home: LoginEnterPage()
    );
  }
}

