import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:test_project/ble_worker/pages/ble_get_characteristic_page.dart';
import 'package:test_project/ble_worker/pages/ble_scan_success_page.dart';
import 'package:test_project/weather/weather_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ble_worker_bloc.dart';
import 'package:test_project/ble_worker/pages/ble_write_characteristic_page.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';


class BleWorkerPage extends StatefulWidget
{
  const BleWorkerPage({super.key});
  @override
  _BleWorkerPageState createState()=> _BleWorkerPageState();
}

class _BleWorkerPageState extends State<BleWorkerPage>
{

  final BleWorkerBloc bleBloc = BleWorkerBloc();
  Object pervState = BleWorkerInitial;
  int numTapBreak = 0;
  late Timer timer;

  void clearTap()
  {
    numTapBreak = 0;
  }

  @override
  Widget build(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 5), (_) => clearTap());
    BackButtonInterceptor.add(myInterceptor);
    return Scaffold(
        body: Center(
            child: BlocConsumer(
                bloc: bleBloc,
                listener: (context, state) {
                      if(state is BleWorkerWaitWriteCharacteristic)
                      {
                        Navigator.of(context).push(MaterialPageRoute(builder: (c)=> CharacteristicWritePage(guid:state.characteristicUuid, bleBloc: bleBloc,)));
                      }
                      if(state is BleWorkerWriteCharacteristicsSuccess)
                      {
                        Navigator.pop(context);
                        bleBloc.add(BleReadCharacteristicEvent());
                      }
                      if(state is BleWorkerGetCharacteristicsSuccess)
                      {
                        Navigator.of(context).push(MaterialPageRoute(builder: (c)=> CharacteristicReadPage(bleBloc: bleBloc,)));
                      }
                      if((state is BleWorkerScan) || (state is BleWorkerScanSuccess))
                      {
                        Navigator.of(context).push(MaterialPageRoute(builder: (c)=> ScannedReadPage(bleBloc: bleBloc,)));
                      }
                      if(state is BleWorkerConnectSuccess)
                      {
                        Navigator.of(context).pop();
                      }
                      pervState  = state!;
                },
                builder: (context, state){
                  switch (state.runtimeType)
                  {
                    case BleWorkerInitial:
                       bleBloc.add(BleInitEvent());
                        return Center(
                          child: Text("Init state")
                        );
                    case BleWorkerInitialSuccess:
                      return  Center(
                        child: ElevatedButton(onPressed: () {
                          print("Button Pressed");
                          bleBloc.add(BleScanEvent());
                        }, child: Text("SCAN")),
                      );

                    case BleWorkerInitialError:
                      String error = (state as BleWorkerInitialError).errorInfo;
                      return Center(
                        child:Text("Error $error")
                      );
                    case BleWorkerScanError:
                      String err = (state as BleWorkerScanError).error;
                      return Center(
                        child: Text("Error $err")
                      );
                    case BleWorkerConnectSuccess:
                      bleBloc.add(BleReadCharacteristicEvent());
                      return  Center(
                        child: CircularProgressIndicator(strokeWidth: 0.7),
                      );
                    default :
                      return Container();
                  }
                }
            )
        )
    );
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // Your logic here

    if (stopDefaultButtonEvent) {
      // Handle the back button event

    }
    numTapBreak++;
    if(pervState is BleWorkerGetCharacteristicsSuccess)
    {
      bleBloc.add(BleReadCharacteristicEvent());
    }
    if((pervState is BleWorkerInitialSuccess) || (numTapBreak >= 2))
      {
        exit(0);
      }
    return true; // Prevent default behavior
  }
}


