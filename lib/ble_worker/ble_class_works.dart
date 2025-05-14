import 'dart:async';
import "dart:io";
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';


class BLEWorker extends GetxController{

  //Stream <List<ScanResult>> stream = Stream.empty();
  Stream<List<ScanResult>>  scanResult = Stream.empty();
  bool connectedDevice = false;
  final  String fileInfo = "/infoBle";
  String deviceId = "";
  BluetoothDevice? devicePair;
  BLEWorker() {
    if (File(fileInfo).existsSync()) {
      deviceId = File(fileInfo).readAsStringSync();
      devicePair = BluetoothDevice.fromId(deviceId);
    }
  }

  Future<String> firstConnection() async{
    if(devicePair != null)
      {
        await scanDevices();
        if(await FlutterBluePlus.scanResults.contains(devicePair) == true)
        {
          await devicePair!.connect(autoConnect: true);
          await devicePair!.connectionState.where((val) => val == BluetoothConnectionState.connected).first;
          print("Here device!");
          return devicePair!.advName.toString();
        }
      }
    print("Here no device");
    return "No saved Device";
}

  Future scanDevices() async{
    bool connectGranted = await Permission.bluetoothConnect.request().isGranted;
    bool scanGranted = await Permission.bluetoothScan.request().isGranted;
    bool st = await Permission.bluetoothAdvertise.request().isGranted;
    if(connectGranted && scanGranted && st){
      var subscription = FlutterBluePlus.onScanResults.listen((results){
        if(results.isNotEmpty){
          ScanResult r = results.last;
          print('found: ${r.advertisementData.advName} ${r.device.remoteId}');
        }
        else
          {
            print("results empty");
          }
      },
          onError: (e)=> print('error $e'),

      );
      FlutterBluePlus.cancelWhenScanComplete(subscription);
      var sub = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state){
       if(state == BluetoothAdapterState.off)
         {
           FlutterBluePlus.turnOn();
         }
      });
      await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;

      await FlutterBluePlus.startScan(
        androidLegacy: true,
        timeout: Duration(seconds: 15),
      );
      await FlutterBluePlus.isScanning.where((val) => val == false).first;
    }
  }

  Future connectToDevice(BluetoothDevice device) async{

   var subscribe =  device.connectionState.listen((isConnected){
     if(isConnected == BluetoothConnectionState.disconnected)
       {
         print("${device.disconnectReason?.code} ${device.disconnectReason?.description}");
         device.connect(timeout:Duration(seconds: 15));
       }
     else
       {
         connectedDevice = true;
       }
    });
   device.cancelWhenDisconnected(subscribe, delayed: true, next:true);
   await device.connect(autoConnect: true, timeout:Duration(seconds: 15));
   await File(fileInfo).writeAsString(device.remoteId.str);


   subscribe.cancel();
  }
}
