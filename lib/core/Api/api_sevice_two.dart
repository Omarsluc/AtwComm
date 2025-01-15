import 'package:dio/dio.dart';

class ApiServiceTwo {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://ml-test.atwdemo.com', // Base URL
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> sendMessage({
    required String message,
    required String sessionId,
  }) async {
    try {
      final response = await _dio.post(
        '/chat',
        data: {
          "message": message,
          "session_id": sessionId,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to send message. Status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        // Server error
        throw Exception(
            'Failed with status code: ${e.response?.statusCode}, Response: ${e.response?.data}');
      } else {
        // Network error
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
