import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io'; // For SocketException

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
      throw Exception('Failed to fetch posts: ${_mapDioError(error)}');
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
      throw Exception('Failed to create post: ${_mapDioError(error)}');
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
      throw Exception('Failed to update post: ${_mapDioError(error)}');
    }
  }

  Future<void> deletePost({required int id}) async {
    try {
      await _dio.delete('/posts/$id');
    } catch (error) {
      throw Exception('Failed to delete post: ${_mapDioError(error)}');
    }
  }

  /// Centralized error mapper that converts Dio errors to user-friendly messages.
  String _mapDioError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timeout. Please try again later.";
        case DioExceptionType.sendTimeout:
          return "Request send timeout. Please try again later.";
        case DioExceptionType.receiveTimeout:
          return "Response timeout. Please try again later.";
        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 401) {
            return "Unauthorized. Please log in.";
          } else if (error.response?.statusCode != null &&
              error.response!.statusCode! >= 500) {
            return "Server error. Please try again later.";
          } else {
            return "Received invalid status code: ${error.response?.statusCode}";
          }
        case DioExceptionType.cancel:
          return "Request was cancelled.";
        case DioExceptionType.connectionError:
          return "No internet connection. Please check your network.";
        default:
          return "Unexpected error occurred. Please try again.";
      }
    } else if (error is SocketException) {
      return "No internet connection. Please check your network.";
    } else {
      return "Unexpected error occurred. Please try again.";
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
