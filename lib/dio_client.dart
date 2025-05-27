import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://aggregator.dev.gnb.tools/api/',
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'PHPSESSID=gueeea76cpjtfeamprev87pqmu',
          },
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('➡️ Request: ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          String errorMsg;
          switch (e.type) {
            case DioExceptionType.connectionError:
              errorMsg = "No internet connection.";
              break;
            case DioExceptionType.receiveTimeout:
              errorMsg = "Connection timeout.";
              break;
            case DioExceptionType.sendTimeout:
              errorMsg = "Request timeout.";
              break;
            case DioExceptionType.badResponse:
              errorMsg = "Server error: ${e.response?.statusCode ?? 'Unknown'}";
              break;
            case DioExceptionType.cancel:
              errorMsg = "Request was cancelled.";
              break;
            default:
              errorMsg = "Unexpected error: ${e.message}";
          }

          debugPrint('Error: $errorMsg');
          handler.next(
            DioException(
              requestOptions: e.requestOptions,
              type: e.type,
              error: Exception(errorMsg),
            ),
          );
        },
      ),
    );
  }
}
