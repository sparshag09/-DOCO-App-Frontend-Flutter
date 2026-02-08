import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:doco_store/model/api_response.dart';

class ApiService {
  static final String _baseUrl = "http://10.0.2.2:8000/api/";

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8000/api/",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<List<dynamic>> fetchBrands() async {
    final response = await _dio.get("brands/");
    return response.data;
  }
  static const int _timeout = 30;

  Future<ApiResponse<dynamic>> request({
    required String url,
    required String method,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(url);

      http.Response response;

      final defaultHeaders = {
        HttpHeaders.contentTypeHeader: 'application/json',
        ...?headers,
      };

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http
              .get(uri, headers: defaultHeaders)
              .timeout(const Duration(seconds: _timeout));
          break;

        case 'POST':
          response = await http
              .post(
            uri,
            headers: defaultHeaders,
            body: jsonEncode(body),
          )
              .timeout(const Duration(seconds: _timeout));
          break;

        case 'PUT':
          response = await http
              .put(
            uri,
            headers: defaultHeaders,
            body: jsonEncode(body),
          )
              .timeout(const Duration(seconds: _timeout));
          break;

        default:
          throw UnsupportedError('HTTP method not supported');
      }

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return ApiResponse(
          success: true,
          data: decoded,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          success: false,
          message: decoded['message'] ?? 'Something went wrong',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'No internet connection',
      );
    } on FormatException {
      return ApiResponse(
        success: false,
        message: 'Invalid response from server',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }



}
