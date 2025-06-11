part of 'ble_worker_bloc.dart';

@immutable
sealed class BleWorkerEvent {}

final class BleWorkerFetchEvent extends BleWorkerEvent{}

class BleInitEvent extends BleWorkerEvent{}

class BleScanEvent extends BleWorkerEvent{}

class BleConnectEvent extends BleWorkerEvent{
  late BluetoothDevice device;
  BleConnectEvent(this.device);
}

class BleReadCharacteristicEvent extends BleWorkerEvent{}

class BleWaitWriteCharacteristicEvent extends BleWorkerEvent
{
  late Guid characteristicUuid;
  BleWaitWriteCharacteristicEvent(this.characteristicUuid);
}

class BleWriteCharacteristicEvent extends BleWorkerEvent{
  late Guid characteristicUuid;
  late String parameter;
  BleWriteCharacteristicEvent(this.characteristicUuid, this.parameter);
}


