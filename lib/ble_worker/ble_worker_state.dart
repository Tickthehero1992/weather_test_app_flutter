part of 'ble_worker_bloc.dart';

@immutable
sealed class BleWorkerState {}

final class BleWorkerInitial extends BleWorkerState {}

final class BleWorkerInitialSuccess extends BleWorkerState{}

final class BleWorkerInitialError extends BleWorkerState
{
  late final String errorInfo;
  BleWorkerInitialError({required this.errorInfo});
}




final class BleWorkerScan extends BleWorkerState{}

final class BleWorkerScanSuccess extends BleWorkerState{}

final class BleWorkerScanError extends BleWorkerState{
  late String error;
  BleWorkerScanError({required this.error});
}

final class BleWorkerConnect extends BleWorkerState{}

final class BleWorkerConnectSuccess extends BleWorkerState{}

final class BleWorkerGetCharacteristics extends BleWorkerState{}

final class BleWorkerGetCharacteristicsSuccess extends BleWorkerState{}


