import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:test_project/weather/weather_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_project/ble_worker/ble_worker_bloc.dart';


class CharacteristicReadPage extends StatelessWidget
{
  final BleWorkerBloc bleBloc;

  const CharacteristicReadPage({super.key, required this.bleBloc});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          bleBloc.add(BleScanEvent());
                        },
                        child: Text("Return to scan")
                    )
                ),
                ListView.builder(
                    shrinkWrap: true,
                  itemCount: bleBloc.charParams.length,
                  itemBuilder: (context, index){
                    final data = bleBloc.charParams[index];
                    return Card(
                        elevation: 2,
                        child: ListTile(
                        title: Text(data.characteristicUuid.toString()),
                    subtitle: Text(data.parameter.toString()),
                    trailing: Text(data.remoteId.toString()),
                    onTap: () => {bleBloc.add(BleWaitWriteCharacteristicEvent(data.characteristicUuid))},
                      )
                    );
                  }

                )

              ],
            )
        )
    );

  }
}