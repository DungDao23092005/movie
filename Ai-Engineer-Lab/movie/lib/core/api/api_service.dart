import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class ApiService {
  ApiService._internal();

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  late final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      responseType: ResponseType.json,
    ),
  )..interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
  }) async {
    try {
      return await dio.post(
        path,
        data: data,
      );
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection Timeout";

      case DioExceptionType.receiveTimeout:
        return "Receive Timeout";

      case DioExceptionType.sendTimeout:
        return "Send Timeout";

      case DioExceptionType.badResponse:
        return "Server Error : ${e.response?.statusCode}";

      case DioExceptionType.connectionError:
        return "No Internet Connection";

      case DioExceptionType.cancel:
        return "Request Cancelled";

      default:
        return e.message ?? "Unknown Error";
    }
  }
}