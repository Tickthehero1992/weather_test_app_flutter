import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'weather_page.dart';
import 'ble_worker/ble_class_works.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}
/*
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
*/




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class SecondRoute extends StatelessWidget {
  SecondRoute({super.key, required BLEWorker this.controller});

  late BLEWorker controller;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate back to first route when tapped.
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              ),
                   StreamBuilder<List<String>>(
                      stream: controller.characteristicController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final data = snapshot.data![index];
                                  return Card(
                                    elevation: 2,
                                    child: ListTile(
                                      title: Text(data),
                                      subtitle: Text(data),
                                      trailing: Text(data),

                                    ),
                                  );
                                }),
                          );
                        }else{
                          return Center(child: Text("No Device Found"),);
                        }
                      }),
            ]
        )
      );

  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("BLE SCANNER"),),
        body: GetBuilder<BLEWorker>(
          init: BLEWorker(),
          builder: (BLEWorker controller)
          {

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  StreamBuilder<BluetoothDevice>(
                    stream: controller.deviceController.stream,
                    builder: (context, snapshot)
                    {
                      if(snapshot.connectionState == ConnectionState.waiting)
                        {
                          return Text("Waiting");
                        }
                      if(snapshot.hasError)
                        {
                          return Text("Error!");
                        }
                      if(snapshot.hasData)
                        {
                          //return Text(snapshot.data!.advName.toString());
                          return Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  SecondRoute(controller: controller)),
                                  );// Navigate back to first route when tapped.
                                },
                                child:  Text(snapshot.data!.advName.toString()),
                              ),
                            );

                        }
                      else
                        {
                          return Center(child: Text("No Device Found"),);
                        }
                    },
                  ),

                  StreamBuilder<List<ScanResult>>(
                      
                      stream: FlutterBluePlus.scanResults,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final data = snapshot.data![index];
                                  return Card(
                                    elevation: 2,
                                    child: ListTile(
                                      title: Text(data.device.name),
                                      subtitle: Text(data.device.id.id),
                                      trailing: Text(data.rssi.toString()),
                                      onTap: ()=> controller.connectToDevice(data.device),
                                    ),
                                  );
                                }),
                          );
                        }else{
                          return Center(child: Text("No Device Found"),);
                        }
                      }),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: ()  async {
                    controller.scanDevices();
                    // await controller.disconnectDevice();
                  }, child: Text("SCAN")),

                ],
              ),
            );
          },
        )

    );
  }
}


