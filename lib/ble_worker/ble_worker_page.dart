import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:test_project/ble_worker/pages/ble_get_characteristic_page.dart';
import 'package:test_project/weather/weather_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ble_worker_bloc.dart';
import 'package:test_project/ble_worker/pages/ble_write_characteristic_page.dart';



class BleWorkerPage extends StatefulWidget
{
  const BleWorkerPage({super.key});
  @override
  _BleWorkerPageState createState()=> _BleWorkerPageState();
}

class _BleWorkerPageState extends State<BleWorkerPage>
{
  final BleWorkerBloc bleBloc = BleWorkerBloc();

  @override
  Widget build(BuildContext context) {
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
                      Navigator.of(context).pop();
                      bleBloc.add(BleReadCharacteristicEvent());
                    }
                  if(state is BleWorkerGetCharacteristicsSuccess)
                    {
                      Navigator.of(context).push(MaterialPageRoute(builder: (c)=> CharacteristicReadPage(bleBloc: bleBloc,)));
                    }
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



                    default :
                      return Container();
                  }
                }
            )
        )
    );
  }
}


