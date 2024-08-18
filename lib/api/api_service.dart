import 'package:dio/dio.dart';
import 'package:infinite_image/api/dio_client.dart';

class APIService {
  static Dio get _dio => DioClient.dio;

  static Future<dynamic> get(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(
        endpoint,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioExceptionType catch (e) {
      _handleError(e);
      return null;
    }
  }

  static Future<String?> post(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioExceptionType catch (e) {
      _handleError(e);
      return null;
    }
  }

  static Future<String?> put(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: body,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioExceptionType catch (e) {
      _handleError(e);
      return null;
    }
  }

  static void _handleError(DioExceptionType error) {
    switch (error) {
      case DioExceptionType.connectionTimeout:
        print("Connection Timeout Exception");
        break;
      case DioExceptionType.sendTimeout:
        print("Send Timeout Exception");
        break;
      case DioExceptionType.receiveTimeout:
        print("Receive Timeout Exception");
        break;
      case DioExceptionType.badResponse:
        print("Received invalid status code");
        break;
      case DioExceptionType.cancel:
        print("Request to API server was cancelled");
        break;
      case DioExceptionType.unknown:
        print("Unexpected error occurred:");
        break;
      case DioExceptionType.badCertificate:
        print("Bad Certificate");
        break;
      case DioExceptionType.connectionError:
        print("Connection Error");
        break;
    }
  }
}
