import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:test_project/data/dio_client.dart';
import 'package:meta/meta.dart';
import 'weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final String subName = "/v2/forecast";

  final lat = 56.266687;
  final lon = 37.564142;

  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherFetchEvent>((onWeatherFetchEvent));
  }

  FutureOr<void> onWeatherFetchEvent(
      WeatherFetchEvent event, Emitter <WeatherState> emit
      ) async {
    emit(WeatherLoading());
    try
        {
          Map <String, String> ask = {
            "lat":lat.toString(),
            "lon":lon.toString(),
            //"exclude":"hourly",
          };
          var client = DioClient();
          await client.dio.get(subName, queryParameters: ask).then((value)
          {
            Weather weather =Weather.fromJson(value.data);
            emit(WeatherSuccess(weather: weather));
          }).catchError((error) {
            emit(WeatherFailed(ErrorMessage: error.toString()));
          });
        }
        catch(e){
        emit(WeatherFailed(ErrorMessage: e.toString()));
        }
  }
}
