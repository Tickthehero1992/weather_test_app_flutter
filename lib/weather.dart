import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetWeather extends ChangeNotifier {

  final apikey = "6f393f74-c09a-4679-bd97-54482b2476b8";
  final url_name = "api.weather.yandex.ru";
  final url_name_p = "/v2/forecast";

  String info = "";
  final lat = 56.266687;
  final lon = 37.564142;

  void getWeather() async
  {
    var header = {
      "X-Yandex-Weather-Key" : apikey
    };
    Map <String, String> ask = {
      "lat":lat.toString(),
      "lon":lon.toString(),
      //"exclude":"hourly",
    };

    var client = http.Client();
    try
    {
      var url = Uri.https(url_name, url_name_p, ask);
      final response = await client.get(
          url, headers: header
      );

      if(response.statusCode == 200)
      {
        WeatherAnswer ans = WeatherAnswer.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        info = ans.getTemp();
      }
      else
      {

      }

    }
    finally {
      client.close();
    }
  }
}

class WeatherAnswer
{
  final int now;
  final String nowDt;
  final Map <String, dynamic> fact;
 // final Map <String, dynamic> forecast;
  final Map <String, dynamic> info;
  const WeatherAnswer({required this.now, required this.nowDt,
    required this.info, required this.fact});
  factory WeatherAnswer.fromJson(Map<String, dynamic>json)
  {
    return switch(json)
        {
         {'now': int now, 'now_dt':String nowDt,
         'fact' : Map <String, dynamic> fact,
         //'forecasts': Map <String, dynamic> forecast,
         'info' : Map<String,dynamic> info
         } => WeatherAnswer(
             now:now,
             nowDt: nowDt,
             fact:fact,
           // forecast: forecast,
            info:info
          ),
          _ => throw const FormatException("Not good"),
          };
  }
  String getTemp()
  {
    print(fact["temp"].toString());
    return fact["temp"].toString();
  }
}


