import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';


class BLEWorker extends GetxController{

  Stream <List<ScanResult>> stream = Stream.empty();
  Future scanDevices() async{
    if(await Permission.bluetoothConnect.request().isGranted)
      {
        print("Connect Granted!");
      }
    if(await Permission.bluetoothScan.request().isGranted)
      {
        print("Scan Granted!");
      }
    // var subscription = FlutterBluePlus.onScanResults.listen((results){
    //   if(results.isNotEmpty){
    //     ScanResult r = results.last;
    //
    //     // stream.results.last;
    //     print('${r.device.remoteId}');
    //   }
    // },
    // onError: (e)=> print(e)
    // );
  }


/*  BluetoothAdapterState state = BluetoothAdapterState.off;

  void initBle() async{
    print("Start listen");
    if(await FlutterBluePlus.isSupported){
     await FlutterBluePlus.adapterState.listen((state){
        print(state);
        if(state == BluetoothAdapterState.on)
          {
            print("Turn ON!");
            FlutterBluePlus.turnOn();
          }
      },
        onError: (e) => print(e),
      );
    }
    else
      {
        print("No bluetooth");
      }


  }

  Future<void> scan() async{
  }*/
}
