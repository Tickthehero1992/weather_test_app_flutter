import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor
{
  late final Dio dio;
  final apikey = "6f393f74-c09a-4679-bd97-54482b2476b8";
  AuthInterceptor(
  {
    required this.dio
  }
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({
      "X-Yandex-Weather-Key" : apikey
    });
    handler.next(options);
  }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async
  {
    print(err.response?.statusCode);
    if(err.response?.statusCode == 401)
      {
        return handler.resolve( await dio.fetch(err.requestOptions));
      }
    return handler.reject(DioException(requestOptions: err.requestOptions, error: err.response));
  }
}