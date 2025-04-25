import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => GetWeather(),
      child: MaterialApp(
        title: "Weather App",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        ),
          home: PageWeather(),
      )
    );
  }
}

class PageWeather extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
      var inf = context.watch<GetWeather>();
      return Scaffold(
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
            [
              Text('Weather info'),
              Text(inf.info),
              ElevatedButton(
                  onPressed: () {
                    inf.getWeather();
                    },
                  child: Text("Get Weather!"),
              ),

            ]
        )
      );
    // TODO: implement build
    throw UnimplementedError();
  }

}


