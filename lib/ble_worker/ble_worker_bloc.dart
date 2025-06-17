
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import "dart:io";
import "dart:convert";
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

part 'ble_worker_event.dart';
part 'ble_worker_state.dart';

class BluetoothCharacteristicWithParam extends BluetoothCharacteristic
{
  late final String parameter;
  BluetoothCharacteristicWithParam({required super.remoteId, required super.serviceUuid, required super.characteristicUuid, required this.parameter});
}

class BleWorkerBloc extends Bloc<BleWorkerEvent, BleWorkerState> {

  late  BluetoothDevice devicePair;
  var characteristicController = StreamController<List<BluetoothCharacteristicWithParam>>();
  late StreamSubscription charSub;
  late List<BluetoothCharacteristicWithParam> charParams;

  BleWorkerBloc() : super(BleWorkerInitial()) {

    on<BleInitEvent>(onBleFetchEvent);
    on<BleScanEvent>(onBleScanEvent);
    on<BleConnectEvent>(onBleConnectEvent);
    on<BleReadCharacteristicEvent>(onBleReadCharacteristicEvent);
    on<BleWaitWriteCharacteristicEvent>(onBleWaitWriteCharacteristicEvent);
    on<BleWriteCharacteristicEvent>(onBleWriteCharacteristicEvent);
    on<BleReadCharacteristicSuccessEvent>(onBleReadCharacteristicSuccessEvent);

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
  List<BluetoothCharacteristicWithParam> llst = [];

  charSub = characteristicController.stream.listen((data) =>() {
    charParams = data;
  });


  for (BluetoothService service in services)
    {
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
          BluetoothCharacteristicWithParam charact = BluetoothCharacteristicWithParam(remoteId:  c.remoteId, serviceUuid: c.serviceUuid,
              characteristicUuid: c.characteristicUuid, parameter: st);
          llst.add(charact);
        }
      }
    }
  characteristicController.add(llst);
  emit(BleWorkerGetCharacteristicsSuccess());
}

  FutureOr<void> onBleWaitWriteCharacteristicEvent(BleWaitWriteCharacteristicEvent event,
      Emitter <BleWorkerState> emit) async
  {
    emit(BleWorkerWaitWriteCharacteristic(characteristicUuid: event.characteristicUuid));
  }

FutureOr<void>ServiceRead(List<BluetoothService> services, BleWriteCharacteristicEvent event)
async {

}

FutureOr<void> onBleWriteCharacteristicEvent(BleWriteCharacteristicEvent event,
      Emitter <BleWorkerState> emit) async {
    List<BluetoothService> services = await devicePair.discoverServices();
    //Future.wait([ServiceRead(services, event)] as Iterable<Future>);
    BluetoothCharacteristic characteristic;
    for(BluetoothService service in services)
      {
        try
        {
          characteristic = service.characteristics.firstWhere((element) => element.characteristicUuid == event.characteristicUuid);
          List<int> llInfo = utf8.encode(event.parameter);
          await characteristic.setNotifyValue(true);
          await characteristic.write(llInfo);
        }
        catch(e)
        {
        }
      }
    emit(BleWorkerWriteCharacteristicsSuccess());

  }

  FutureOr<void> onBleReadCharacteristicSuccessEvent(BleWorkerEvent event,
      Emitter <BleWorkerState> emit){
      emit(BleWorkerGetCharacteristicsSuccess());
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
