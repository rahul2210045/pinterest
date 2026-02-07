import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pinterest/core/services/exception.dart';
import 'package:pinterest/reusable_element.dart/common_function.dart';


class NetworkApiService {
  final Dio dio;

  NetworkApiService(this.dio);

  Future<dynamic> getApi(String url) async {
    try {
      final response = await dio.get(url);
      return _handleResponse(response);
    } catch (e) {
      throw ExceptionHandlers().getExceptionString(e);
    }
  }

  Future<dynamic> postApi(String url, dynamic data) async {
    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        if (responseData is Map) {
          throw Exception(responseData['message'] ??
              responseData['error'] ??
              'Request failed with status ${e.response?.statusCode}');
        }
        throw Exception('Request failed: ${e.response?.statusCode}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  Future<dynamic> patchApi(String url, dynamic data) async {
    try {
      final response = await dio.patch(url, data: data);
      return _handleResponse(response);
    } catch (e) {
      throw ExceptionHandlers().getExceptionString(e);
    }
  }

  Future<Map<String, dynamic>> deleteApi(
      String url, Map<String, dynamic> body) async {
    try {
      final response = await dio.delete(url, data: body);
      return _handleResponse(response);
    } catch (e) {
      throw ExceptionHandlers().getExceptionString(e);
    }
  }

  Future<dynamic> putApi(String url, dynamic data) async {
    try {
      final response = await dio.put(
        url,
        data: data,
        options: Options(
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        if (responseData is Map) {
          throw Exception(responseData['message'] ??
              responseData['error'] ??
              'Request failed with status ${e.response?.statusCode}');
        }
        throw Exception('Request failed: ${e.response?.statusCode}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  

  // -------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------



  dynamic _handleResponse(Response response) {
    prnt("response dio is ${response.statusCode}, ${response.data["message"]}");
    if(response.data["message"]=="Unauthorized: No Token found"||response.data["message"]=="Unauthorized: Invalid token"){
        prnt("JWT EXPIRED LOGGING OUT");
      // appRouter.go(AppRoutes.logout);
    }
    else{
 switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        if (response.data['name'] == 'UserAlreadyExistsError') {
          // throw UserAlreadyExistsException(response.data['message']);
        }
        if (response.data['payload']?['result']?['userId'] != null) {
          return response.data;
        }
        throw BadRequestException(response.data.toString());
      case 401:
        throw UnAuthorizedException(response.data.toString());
      case 404:
      {
        // appRouter.go(AppRoutes.logout);
        //  throw NotFoundException(response.data.toString());
      }
       
      case 500:
        throw InternalServerError(response.data.toString());
      default:
        throw FetchDataException(
            "Error with status code ${response.statusCode}");
    }
    }
   
  }
}