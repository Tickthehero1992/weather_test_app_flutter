import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:test_project/ble_worker/ble_worker_bloc.dart';


class ScannedReadPage extends StatelessWidget
{
  final BleWorkerBloc bleBloc;

  const ScannedReadPage ({super.key, required this.bleBloc});
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Center(
        child:Column(
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
            ]
        )
      )
    );
  }
}