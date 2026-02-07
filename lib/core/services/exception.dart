import 'dart:async';
import 'dart:io';

class AppException implements Exception {
  final message;
  final prefix;
  AppException({this.message, this.prefix});

  @override
  String toString() {
    return '$prefix $message';
  }
}

class BadRequestException extends AppException {
  BadRequestException([
    String? message,
  ]) : super(message: message, prefix: 'Bad request');
}

class FetchDataException extends AppException {
  FetchDataException([
    String? message,
  ]) : super(
          message: message,
          prefix: 'Unable to process the request',
        );
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([
    String? message,
  ]) : super(
          message: message,
          prefix: 'Api not responding',
        );
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([
    String? message,
  ]) : super(
          message: message,
          prefix: 'Unauthorized request',
        );
}

class NotFoundException extends AppException {
  NotFoundException([
    String? message,
  ]) : super(
          message: message,
          prefix: 'Page not found',
        );
}

class InternalServerError extends AppException {
  InternalServerError([
    String? message,
  ]) : super(
          message: message,
          prefix: 'Internal Server error',
        );
}

class ExceptionHandlers {
  getExceptionString(error) {
    if (error is SocketException) {
      return "this is the error for no internet connection ${error.message.toString()}";
    } else if (error is HttpException) {
      return 'HTTP error occured.';
    } else if (error is FormatException) {
      return 'Invalid data format.';
    } else if (error is TimeoutException) {
      return 'Request timedout.';
    } else if (error is BadRequestException) {
      return error.message.toString();
    } else if (error is UnAuthorizedException) {
      return error.message.toString();
    } else if (error is NotFoundException) {
      return error.message.toString();
    } else if (error is FetchDataException) {
      return error.message.toString();
    } else if (error is InternalServerError) {
      return error.message.toString();
    } else {
      return 'Unknown error occurred.';
    }
  }
}
