class Weather
{
  final int now;
  final String nowDt;
  final Map <String, dynamic> fact;
  // final Map <String, dynamic> forecast;
  final Map <String, dynamic> info;
  Weather({required this.now, required this.nowDt,
    required this.info, required this.fact});
  factory Weather.fromJson(Map<String, dynamic>json)
  {
    return switch(json)
    {
      {'now': int now, 'now_dt':String nowDt,
      'fact' : Map <String, dynamic> fact,
      //'forecasts': Map <String, dynamic> forecast,
      'info' : Map<String,dynamic> info
      } => Weather(
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