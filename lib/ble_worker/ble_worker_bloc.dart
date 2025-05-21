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

  BleWorkerBloc() : super(BleWorkerInitial()) {
    on<BleInitEvent>(onBleFetchEvent);
    on<BleScanEvent>(onBleScanEvent);


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
  print("HERE");
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

  FutureOr<void> onBleFetchEvent(BleWorkerEvent event,
      Emitter <BleWorkerState> emit) async{


    on<BleConnectEvent>((event, emit)
    async
    {
      if(readyToBle && await FlutterBluePlus.scanResults.isEmpty.then((val) =>  val))
        {
          emit(BleWorkerConnect());

        }

    });

    on<BleReadCharacteristicEvent>((event, emit)
    {
      emit(BleWorkerGetCharacteristics());
    });


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
