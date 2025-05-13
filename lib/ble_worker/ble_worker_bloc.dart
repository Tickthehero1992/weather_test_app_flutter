import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


part 'ble_worker_event.dart';
part 'ble_worker_state.dart';

class BleWorkerBloc extends Bloc<BleWorkerEvent, BleWorkerState> {
  BleWorkerBloc() : super(BleWorkerInitial()) {
    on<BleWorkerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
