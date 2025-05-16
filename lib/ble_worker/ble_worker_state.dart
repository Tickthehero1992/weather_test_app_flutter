part of 'ble_worker_bloc.dart';

@immutable
sealed class BleWorkerState {}

final class BleWorkerInitial extends BleWorkerState {

}

final class BleWorkerScan extends BleWorkerState{}

final class BleWorkerScanSuccess extends BleWorkerState{}

final class BleWorkerConnect extends BleWorkerState{}

final class BleWorkerConnectSuccess extends BleWorkerState{}

final class BleWorkerGetCharacteristics extends BleWorkerState{}

final class BleWorkerGetCharacteristicsSuccess extends BleWorkerState{}


