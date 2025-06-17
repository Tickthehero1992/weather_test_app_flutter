import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:test_project/weather/weather_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_project/ble_worker/ble_worker_bloc.dart';


class CharacteristicWritePage extends StatelessWidget {
  final Guid guid ;
  final BleWorkerBloc bleBloc;

  const CharacteristicWritePage({super.key, required this.guid, required this.bleBloc});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
            child:TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Введите значение",
                  helperText: "Введите значение параметра характеристики"
              ),
              onSubmitted: (text){
                bleBloc.add(BleWriteCharacteristicEvent(guid, text));
               // Navigator.of(context).pop();
              },
            )
        )

    );
  }
}
