import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:test_project/weather/weather_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ble_worker_bloc.dart';



class BleWorkerPage extends StatelessWidget
{
  const BleWorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: BlocBuilder(
                bloc: BleWorkerBloc()..add((BleWorkerFetchEvent())),
                builder: (context, state){
                  switch (state.runtimeType)
                  {
                    case BleWorkerInitial:
                    case BleWorkerInitialSuccess:
                      return  Center(
                          child: ElevatedButton(onPressed: ()  async {
                            context.read<BleWorkerBloc>().add(BleScanEvent());

                          }, child: Text("SCAN")),
                      );
                    case BleWorkerInitialError:
                      String error = (state as BleWorkerInitialError).errorInfo;
                      return Center(
                        child:Text("Error $error")
                      );
                    case BleWorkerScanSuccess:
                      return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                StreamBuilder<List<ScanResult>>(
                          stream: FlutterBluePlus.scanResults,
                          builder: (context, snapshot) {
                            if(snapshot.hasError)
                            {
                              return Text("Error!");
                            }
                            if (snapshot.hasData) {
                              return Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final data = snapshot.data![index];
                                      return Card(
                                        elevation: 2,
                                        child: ListTile(
                                          title: Text(data.device.advName.toString()),
                                          subtitle: Text(data.device.remoteId.str),
                                          trailing: Text(data.rssi.toString()),
                                        ),
                                      );
                                    }),
                              );
                            }else{
                              return  Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }
                      )
                            ],
                          )
                      );

                    case BleWorkerScanError:
                      String err = (state as BleWorkerScanError).error;
                      return Center(
                        child: Text("Error $err")
                      );

                    default :
                      return Container();
                  }
                }
            )
        )
    );
  }
}


