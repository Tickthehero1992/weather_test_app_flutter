import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_page.dart';
import 'ble_worker/ble_class_works.dart';

void main() {
  BLEWorker ble = BLEWorker();
  ble.initBle();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return
      MaterialApp(
        title: "Weather App",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        ),
         // home: const WeatherPage(),

    );
  }
}



