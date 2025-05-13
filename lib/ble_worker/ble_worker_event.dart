part of 'ble_worker_bloc.dart';

@immutable
sealed class BleWorkerEvent {}

final class BleWorkerFetchEvent extends BleWorkerEvent{}
