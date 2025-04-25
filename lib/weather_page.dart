import 'package:flutter/material.dart';
import 'package:test_project/weather/weather_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/weather/weather.dart';

class WeatherPage extends StatelessWidget
{
  const WeatherPage({super.key});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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

// class _WeatherPageState extends State<WeatherPage>
// {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return const Scaffold(
//       body: Center(
//         child: Text('Weather app')
//       )
//     );
//     throw UnimplementedError();
//   }
// }

