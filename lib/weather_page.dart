import 'package:flutter/material.dart';
import 'package:test_project/weather/weather_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class WeatherPage extends StatelessWidget
{
  const WeatherPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder(
          bloc: WeatherBloc()..add(WeatherFetchEvent()),
          builder: (context, state){
            switch (state.runtimeType)
                {
              case WeatherInitial:
              case WeatherLoading:
                return const Center(
                  child: CircularProgressIndicator()
                );
              case WeatherSuccess:
                var temp = (state as WeatherSuccess).weather.getTemp();
                return Text("Temp is $temp");
              default :
                return Container();
            }
          }
        )
      )
    );
  }
}


