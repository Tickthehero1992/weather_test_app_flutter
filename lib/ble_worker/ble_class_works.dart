import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEWorker {

  BluetoothAdapterState state = BluetoothAdapterState.off;

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

  }
}