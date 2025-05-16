import 'dart:async';
import "dart:io";
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';


class BLEWorker extends GetxController{

  //Stream <List<ScanResult>> stream = Stream.empty();

  bool connectedDevice = false;
  final  String fileInfo = "/infoBle";
  String deviceId = "";

  var deviceController = StreamController<BluetoothDevice>();
  var characteristicController = StreamController<List<String>>();

  BluetoothDevice devicePair = BluetoothDevice.fromId("12345");
  late StreamSubscription sub;
  late StreamSubscription charSub;

  @override
  void initState() {


    sub = deviceController.stream.listen((item){}
    );
    charSub = characteristicController.stream.listen((item){});

  }

  @override
  void dispose() {
    // TODO: implement $configureLifeCycle
    sub.cancel();
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
      var subscribe = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state){
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
         print("device connected!");
         print(device.advName.toString());
         connectedDevice = true;
         deviceController.add(device);
         devicePair = device;

       }
    });
   device.cancelWhenDisconnected(subscribe, delayed: true, next:true);
   await device.connect( timeout:Duration(seconds: 15));
   await characteristicRead();
   //subscribe.cancel();
  }

  Future characteristicRead() async
  {
    if(devicePair.isConnected)
      {
        List<BluetoothService> services = await devicePair.discoverServices();
        services.forEach((service) async {
          List<String> llst = [];
          for(BluetoothCharacteristic c in service.characteristics)
            {
              if(c.properties.read){
                List<int> value = await c.read();
               // print("Characteristic: ${value}");
                String st = "";
                for(int num in value)
                  {
                    st += String.fromCharCode(num);
                  }

                print("Characteristic: ${st}");
                llst.add(st);
              }

              characteristicController.add(llst);
            }
        });
      }
  }

}
