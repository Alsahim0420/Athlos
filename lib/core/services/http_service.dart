// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class HttpService extends GetxService {
  // Base configuration
  static const String baseUrl =
      'https://api.athlos.app'; // Change this to your API base URL
  static const Duration timeout = Duration(seconds: 30);

  // Default headers
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Helper method to log requests
  void _logRequest(String method, String path) {
    debugPrint('🌐 HTTP Request: $method $path');
  }

  // Helper method to log responses
  void _logResponse(int statusCode, String path) {
    debugPrint('✅ HTTP Response: $statusCode $path');
  }

  // Helper method to log errors
  void _logError(int? statusCode, String path, String message) {
    debugPrint('❌ HTTP Error: $statusCode $path');
    debugPrint('Error message: $message');
  }

  // Helper method to handle HTTP errors
  void _handleHttpError(int statusCode) {
    switch (statusCode) {
      case 401:
        debugPrint('Unauthorized - Token expired or invalid');
        break;
      case 403:
        debugPrint('Forbidden - Access denied');
        break;
      case 404:
        debugPrint('Not found');
        break;
      case 500:
        debugPrint('Internal server error');
        break;
      default:
        debugPrint('HTTP Error: $statusCode');
    }
  }

  // GET request
  Future<http.Response> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
      _logRequest('GET', path);

      final response = await http
          .get(uri, headers: {..._defaultHeaders, ...?headers})
          .timeout(timeout);

      _logResponse(response.statusCode, path);
      if (response.statusCode >= 400) {
        _handleHttpError(response.statusCode);
      }

      return response;
    } catch (e) {
      _logError(null, path, e.toString());
      rethrow;
    }
  }

  // POST request
  Future<http.Response> post(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
      _logRequest('POST', path);

      final response = await http
          .post(uri, body: body, headers: {..._defaultHeaders, ...?headers})
          .timeout(timeout);

      _logResponse(response.statusCode, path);
      if (response.statusCode >= 400) {
        _handleHttpError(response.statusCode);
      }

      return response;
    } catch (e) {
      _logError(null, path, e.toString());
      rethrow;
    }
  }

  // PUT request
  Future<http.Response> put(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
      _logRequest('PUT', path);

      final response = await http
          .put(uri, body: body, headers: {..._defaultHeaders, ...?headers})
          .timeout(timeout);

      _logResponse(response.statusCode, path);
      if (response.statusCode >= 400) {
        _handleHttpError(response.statusCode);
      }

      return response;
    } catch (e) {
      _logError(null, path, e.toString());
      rethrow;
    }
  }

  // DELETE request
  Future<http.Response> delete(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
      _logRequest('DELETE', path);

      final response = await http
          .delete(uri, body: body, headers: {..._defaultHeaders, ...?headers})
          .timeout(timeout);

      _logResponse(response.statusCode, path);
      if (response.statusCode >= 400) {
        _handleHttpError(response.statusCode);
      }

      return response;
    } catch (e) {
      _logError(null, path, e.toString());
      rethrow;
    }
  }

  // PATCH request
  Future<http.Response> patch(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
      _logRequest('PATCH', path);

      final response = await http
          .patch(uri, body: body, headers: {..._defaultHeaders, ...?headers})
          .timeout(timeout);

      _logResponse(response.statusCode, path);
      if (response.statusCode >= 400) {
        _handleHttpError(response.statusCode);
      }

      return response;
    } catch (e) {
      _logError(null, path, e.toString());
      rethrow;
    }
  }

  // Update base URL (useful for different environments)
  void updateBaseUrl(String newBaseUrl) {
    // Note: HTTP package doesn't have a base URL concept like Dio
    // You'll need to update the baseUrl constant or handle it differently
    debugPrint('Base URL updated to: $newBaseUrl');
  }

  // Add custom headers
  void addHeaders(Map<String, String> headers) {
    // Note: HTTP package doesn't store headers globally like Dio
    // Headers are passed per request
    debugPrint('Custom headers added: $headers');
  }

  // Remove custom headers
  void removeHeaders(List<String> headerKeys) {
    // Note: HTTP package doesn't store headers globally like Dio
    debugPrint('Headers removed: $headerKeys');
  }

  @override
  void onClose() {
    // HTTP package doesn't need explicit cleanup
    super.onClose();
  }
}
