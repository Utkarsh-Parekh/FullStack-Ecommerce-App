import 'package:dio/dio.dart';

class ApiException implements Exception{
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => message;

}

class BadRequestException extends ApiException{
  BadRequestException(String message) :  super(message: message,statusCode: 400);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message: message, statusCode: 404);
}

class ServerException extends ApiException {
  ServerException(String message) : super(message: message, statusCode: 500);
}

class UnknownException extends ApiException {
  UnknownException(String message) : super(message: message, statusCode: -1);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message: message, statusCode: 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message: message, statusCode: 403);
}


