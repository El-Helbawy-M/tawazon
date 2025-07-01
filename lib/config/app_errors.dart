import 'dart:developer';

import 'package:dio/dio.dart';

abstract class Failure implements Exception{
  final String message;
  Failure(this.message);
  @override
  String toString() {
    return message;
  }

  static Failure handleDioException(DioException exception){
    log(exception.type.name);
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionFailure("Failed due to internet connection");
      case DioExceptionType.sendTimeout:
        return TimeoutFailure("Send Timeout");
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure("Receive Timeout");
      case DioExceptionType.cancel:
        return ServerFailure('Request to API server was cancelled');
      case DioExceptionType.connectionError:
        return ConnectionFailure("Failed due to internet connection");
      case DioExceptionType.unknown:
        return UnknownFailure("Unexpected error occurred");
      case DioExceptionType.badResponse:
        String message = (exception.response?.data['message']??"Something Went Wrong").toString();
        return BadRequestFailure(message);
      default:
        return UnknownFailure("Unexpected error occurred");
    }
  }
}

class ConnectionFailure extends Failure {
  ConnectionFailure(super.message);
}
class BadRequestFailure extends Failure {
  BadRequestFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(super.message);
}
class NotFoundFailure extends Failure {
  NotFoundFailure(super.message);
}
class TimeoutFailure extends Failure {
  TimeoutFailure(super.message);
}
class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}
class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}
class AuthFailure extends Failure {
  String? code;
  AuthFailure({required String message,this.code}) : super(message);
}

