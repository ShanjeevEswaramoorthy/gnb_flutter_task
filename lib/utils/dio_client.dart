import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'http://147.182.207.192:8003/',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('Request: ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (e, handler) {
          debugPrint('Dio error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}
