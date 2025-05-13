import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';


class BLEWorker extends GetxController{

  //Stream <List<ScanResult>> stream = Stream.empty();
  Stream<List<ScanResult>>  scanResult = Stream.empty();
  Future scanDevices() async{
    bool connectGranted = await Permission.bluetoothConnect.request().isGranted;
    bool scanGranted = await Permission.bluetoothScan.request().isGranted;
    bool st = await Permission.bluetoothAdvertise.request().isGranted;
    bool stateBle = false;
    if(connectGranted && scanGranted && st){
      var subscription = FlutterBluePlus.onScanResults.listen((results){
        if(results.isNotEmpty){
          ScanResult r = results.last;
          print("results:");
          print('${r.advertisementData.advName}');
        }
        else
          {
            print("results empty");
          }
      },
          onError: (e)=> print('error $e'),

      );
      FlutterBluePlus.cancelWhenScanComplete(subscription);
      await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;
      await FlutterBluePlus.startScan(
        androidLegacy: true,
        timeout: Duration(seconds: 15),
      );
      await FlutterBluePlus.isScanning.where((val) => val == false).first;
    }
  }
}
