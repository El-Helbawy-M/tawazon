import 'dart:developer';
import 'package:tawazon/network/app_end_points.dart';
import 'package:dio/dio.dart';

class NetworkHandler {
  Dio dio = Dio();
  static NetworkHandler instance = NetworkHandler._internal();

  NetworkHandler._internal() {
    dio.options.baseUrl = AppEndPoints.baseUrl;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log("==: Method => ${options.method}");
          log("==: Headers => ${options.headers}");
          log('==: Request => ${options.uri}');
          log('==: Request Body => ${options.data}');
          log("==: Request Query => ${options.queryParameters}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('==: {${response.realUri.path}} Response => ${response.data}');
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          log('==: Error => ${e.message}');
          log('==: Error Response => ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
    dio.options.headers = {
      "Accept": "application/json",
    };
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      log('${dio.options.baseUrl}$url');

      return await dio.get(
        url,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    try {
      return await dio.post(
        url,
        queryParameters: queryParameters,
        data: body,
      );
    } catch (e) {
      rethrow;
    }
  }
}
