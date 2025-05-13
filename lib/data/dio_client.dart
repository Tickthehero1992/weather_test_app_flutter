import 'package:dio/dio.dart';
import 'package:test_project/interceptions/auth_interceptor.dart';

class DioClient
{
  static const String _weatherUrl = "https://api.weather.yandex.ru";

  DioClient(){
    addInterceptor(LogInterceptor());
  }

  final Dio dio = Dio(BaseOptions(baseUrl: _weatherUrl));

  void addInterceptor(Interceptor interceptor)
  {
    dio.interceptors.add(AuthInterceptor(dio: dio));
    dio.interceptors.add(interceptor);
  }

}
