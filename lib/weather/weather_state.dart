part of 'weather_bloc.dart';


@immutable
sealed class WeatherState {}


final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherSuccess extends WeatherState
{
   Weather weather = Weather(now: 0, nowDt: "01-02-25", info: Map(), fact: Map());
   WeatherSuccess({
     required this.weather,
   });
}

final class WeatherFailed extends WeatherState{
 late final String ErrorMessage;
  WeatherFailed({
    required this.ErrorMessage,
  });
}

