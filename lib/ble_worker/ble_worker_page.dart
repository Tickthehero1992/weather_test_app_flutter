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
    BleWorkerBloc bleBloc = BleWorkerBloc();
    return Scaffold(
        body: Center(
            child: BlocBuilder(
                bloc: bleBloc,
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
                    case BleWorkerScan:
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
                                          onTap: () => bleBloc.add(BleConnectEvent(data.device)),
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
                    case BleWorkerConnectSuccess:
                      return  Center(
                        child: ElevatedButton(onPressed: () {
                          print("Button Pressed");
                          bleBloc.add(BleReadCharacteristicEvent());
                        }, child: Text("Read Characteristics")),
                      );
                    case BleWorkerGetCharacteristicsSuccess:
                      return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreamBuilder<List<BluetoothCharacteristicWithParam>>(
                                  stream: bleBloc.characteristicController.stream,
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
                                                  title: Text(data.characteristicUuid.toString()),
                                                  subtitle: Text(data.parameter.toString()),
                                                  trailing: Text(data.remoteId.toString()),
                                                  onTap: () => {bleBloc.add(BleWaitWriteCharacteristicEvent(data.characteristicUuid))},
                                                ),
                                              );
                                            },
                                            ),
                                      );
                                    }
                                    else{

                                      return  Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                  }

                              )
                            ],
                          )
                      );
                    case BleWorkerWaitWriteCharacteristic:
                      Guid guid = (state as BleWorkerWaitWriteCharacteristic).characteristicUuid;
                      return Center(
                        child:TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Введите значение",
                            helperText: "Введите значение параметра характеристики"
                          ),
                          onSubmitted: (text){
                            bleBloc.add(BleWriteCharacteristicEvent(guid, text));
                          },
                        )
                      );
                    case BleWorkerWriteCharacteristicsSuccess:
                      bleBloc.add(BleReadCharacteristicSuccessEvent());
                      return  Center(
                        child: CircularProgressIndicator(),

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


