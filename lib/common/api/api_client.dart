import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:studybean/common/exceptions/http_exception.dart';
import 'package:studybean/common/logging/logger.dart';

import '../exceptions/unauthorized_exception.dart';
import '../models/common_response.dart';

class APIClient {
  final Client _client;

  // final String _apiUrl = 'https://api.studybean.io';
  final String _apiUrl = 'https://studybeanserver-production.up.railway.app/api/v1';
  // final String _apiUrl = 'http://10.0.2.2:3000/api/v1';

  APIClient(this._client);

  Uri constructUri(String? path, {Map<String, dynamic>? query}) {
    final constructedQuery = Uri(queryParameters: query).query;
    return Uri.parse(
        '$_apiUrl$path${constructedQuery.isNotEmpty ? '?$constructedQuery' : ''}');
  }

  Future<CommonResponse> call(HttpMethod method,
      {String? path,
      Map<String, dynamic>? body,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
    try {
      late final Response response;

      final encodedBody = body != null ? jsonEncode(body) : null;

      switch (method) {
        case HttpMethod.HEAD:
          response = await _client
              .head(
                constructUri(path, query: query),
                headers: headers,
              )
              .timeout(const Duration(seconds: 30));
          break;
        case HttpMethod.GET:
          response = await _client
              .get(constructUri(path, query: query), headers: headers)
              .timeout(const Duration(seconds: 30));
          break;
        case HttpMethod.POST:
          response = await _client
              .post(constructUri(path, query: query),
                  body: encodedBody, headers: headers)
              .timeout(const Duration(seconds: 30));
          break;
        case HttpMethod.PUT:
          response = await _client
              .put(constructUri(path, query: query),
                  body: encodedBody, headers: headers)
              .timeout(const Duration(seconds: 30));
          break;
        case HttpMethod.PATCH:
          response = await _client
              .patch(constructUri(path, query: query),
                  body: encodedBody, headers: headers)
              .timeout(const Duration(seconds: 30));
          break;
        case HttpMethod.DELETE:
          response = await _client
              .delete(constructUri(path, query: query),
                  headers: headers, body: encodedBody)
              .timeout(const Duration(seconds: 30));
          break;
      }

      httpLogger.info('Request body: $encodedBody');

      httpLogger.info('Response: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return CommonResponse(
          data: decoded['data'],
          code: response.statusCode,
          message: decoded['message'],
        );
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException(decoded['message'] ?? '');
      }

      throw APIException(decoded['message'], response.statusCode);
    } catch (e) {
      rethrow;
    }
  }
}
