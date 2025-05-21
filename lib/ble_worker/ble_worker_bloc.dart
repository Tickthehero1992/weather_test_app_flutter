import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import "dart:io";
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

part 'ble_worker_event.dart';
part 'ble_worker_state.dart';

class BleWorkerBloc extends Bloc<BleWorkerEvent, BleWorkerState> {

  late  BluetoothDevice devicePair;
  var characteristicController = StreamController<List<String>>();
  late StreamSubscription charSub;

  BleWorkerBloc() : super(BleWorkerInitial()) {

    on<BleInitEvent>(onBleFetchEvent);
    on<BleScanEvent>(onBleScanEvent);
    on<BleConnectEvent>(onBleConnectEvent);
    on<BleReadCharacteristicEvent>(onBleReadCharacteristicEvent);

  }
  bool readyToBle = false;

  Future<bool> checkPermissions() async
  {
    bool connectGranted = await Permission.bluetoothConnect.request().isGranted;
    bool scanGranted = await Permission.bluetoothScan.request().isGranted;
    bool advertiseGranted = await Permission.bluetoothAdvertise.request().isGranted;
    return (connectGranted && scanGranted && advertiseGranted);
  }

FutureOr<void> onBleScanEvent(BleWorkerEvent event,
      Emitter <BleWorkerState> emit) async{
  emit(BleWorkerScan());
  if(readyToBle)
  {
    var subscription = FlutterBluePlus.onScanResults.listen((results){
    },
      onError: (error) => emit(BleWorkerScanError(error: error)),
      onDone:() => emit(BleWorkerScanSuccess()),
    );
    FlutterBluePlus.cancelWhenScanComplete(subscription);
    await FlutterBluePlus.startScan(
      androidLegacy: true,
      timeout: Duration(seconds: 15),
    );
    await FlutterBluePlus.isScanning.where((val) => val == false).first;

  }
}

FutureOr<void> onBleConnectEvent(BleConnectEvent event,
    Emitter <BleWorkerState> emit)  async{
    BluetoothDevice device = event.device;
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
      devicePair = device;
      emit(BleWorkerConnectSuccess());
    }

  },
      onError: (error) => emit(BleWorkerConnectError(error: error)),

  );
  device.cancelWhenDisconnected(subscribe, delayed: true, next:true);
  await device.connect( timeout:Duration(seconds: 15));
}

FutureOr<void> onBleReadCharacteristicEvent(BleWorkerEvent event,
      Emitter <BleWorkerState> emit) async{
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
      emit(BleWorkerGetCharacteristicsSuccess());
    }
  });
}

  FutureOr<void> onBleFetchEvent(BleWorkerEvent event,
      Emitter <BleWorkerState> emit) async{
    await checkPermissions().then((value) async{
      if (value) {

        var subscribe = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state){
          if(state == BluetoothAdapterState.off)
          {
            FlutterBluePlus.turnOn();
          }
          else
          {
            emit(BleWorkerInitialSuccess());
            readyToBle = true;
          }
        });
        await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;

      }
      else {
        emit(BleWorkerInitialError(errorInfo: "No privilages"));
      }
    });
  }
}
