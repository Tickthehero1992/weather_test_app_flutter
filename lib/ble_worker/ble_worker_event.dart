part of 'ble_worker_bloc.dart';

@immutable
sealed class BleWorkerEvent {}

final class BleWorkerFetchEvent extends BleWorkerEvent{}

class BleInitEvent extends BleWorkerEvent{}

class BleScanEvent extends BleWorkerEvent{}

class BleConnectEvent extends BleWorkerEvent{}

class BleReadCharacteristicEvent extends BleWorkerEvent{}


