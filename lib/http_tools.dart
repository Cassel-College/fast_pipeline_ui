import 'package:dio/dio.dart';

class HttpTools {
  static final HttpTools _instance = HttpTools._internal();
  late Dio _dio;

  factory HttpTools() {
    return _instance;
  }

  HttpTools._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://127.0.0.1:8000', // 根据你的API基础URL进行调整
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {'accept': 'application/json'},
    ));
  }

  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      print('GET Response: $response');
      print('GET Response data: ${response.data}');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('GET Error: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      print('POST Response: $response');
      print('POST Response data: ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('POST Error: $e');
      rethrow;
    }
  }
}
