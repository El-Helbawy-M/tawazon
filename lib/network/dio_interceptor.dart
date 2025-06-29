import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioLoggingInterceptor {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Number of stack trace lines to display
      errorMethodCount: 5, // Number of stack trace lines for errors
      lineLength: 80, // Width of the log line
      colors: true, // Enable colored logs
      printEmojis: true, // Add emojis to log levels
      printTime: true, // Include timestamp in logs
    ),
  );

  static InterceptorsWrapper getInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i("==: Method => ${options.method}");
        _logger.d("==: Headers => ${options.headers}");
        _logger.i("==: Request => ${options.uri}");
        _logger.d("==: Request Body => ${options.data}");
        _logger.d("==: Request Query => ${options.queryParameters}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i("==: {${response.realUri.path}} Response => ${response.data}");
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        _logger.e("==: Error => ${e.message}",error: e,stackTrace: e.stackTrace);
        _logger.e("==: Error Response => ${e.response?.data}",error: e,stackTrace: e.stackTrace);
        return handler.next(e);
      },
    );
  }
}