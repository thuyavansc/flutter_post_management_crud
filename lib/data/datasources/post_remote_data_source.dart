import 'package:dio/dio.dart';
import 'dart:convert';

class PostRemoteDataSource {
  final Dio _dio;

  PostRemoteDataSource()
      : _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
    ),
  ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        _logRequest(options);
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logResponse(response);
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        _logError(error);
        return handler.next(error);
      },
    ));
  }

  Future<List<dynamic>> fetchPosts({
    required int start,
    required int limit,
  }) async {
    try {
      final response = await _dio.get('/posts',
          queryParameters: {'_start': start, '_limit': limit});
      return response.data;
    } catch (error) {
      throw Exception('Failed to fetch posts: $error');
    }
  }

  Future<Map<String, dynamic>> createPost({
    required String title,
    required String body,
  }) async {
    try {
      final response = await _dio.post('/posts',
          data: {'title': title, 'body': body, 'userId': 1});
      return response.data;
    } catch (error) {
      throw Exception('Failed to create post: $error');
    }
  }

  Future<Map<String, dynamic>> updatePost({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      final response = await _dio.put('/posts/$id',
          data: {'title': title, 'body': body, 'userId': 1});
      return response.data;
    } catch (error) {
      throw Exception('Failed to update post: $error');
    }
  }

  Future<void> deletePost({required int id}) async {
    try {
      await _dio.delete('/posts/$id');
    } catch (error) {
      throw Exception('Failed to delete post: $error');
    }
  }

  /// Logs request details
  void _logRequest(RequestOptions options) {
    print('--- API Request ---');
    print('URL: ${options.baseUrl}${options.path}');
    print('Method: ${options.method}');
    if (options.queryParameters.isNotEmpty) {
      print('Query Parameters: ${jsonEncode(options.queryParameters)}');
    }
    if (options.data != null) {
      print('Request Data: ${jsonEncode(options.data)}');
    }
    print('Headers: ${jsonEncode(options.headers)}');
    print('-------------------');
  }

  /// Logs response details
  void _logResponse(Response response) {
    print('--- API Response ---');
    print('URL: ${response.realUri}');
    print('Status Code: ${response.statusCode}');
    print('Response Data: ${jsonEncode(response.data)}');
    print('--------------------');
  }

  /// Logs error details
  void _logError(DioException error) {
    print('--- API Error ---');
    print('URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}');
    print('Method: ${error.requestOptions.method}');
    print('Status Code: ${error.response?.statusCode}');
    print('Error Message: ${error.message}');
    print('Response Data: ${jsonEncode(error.response?.data)}');
    print('----------------');
  }
}
