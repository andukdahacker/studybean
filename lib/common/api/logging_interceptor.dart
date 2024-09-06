import 'dart:async';

import 'package:http_interceptor/http_interceptor.dart';

import '../logging/logger.dart';

class LoggingInterceptor extends InterceptorContract {

  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) {
    httpLogger.info('Request: ${request.method} ${request.url}');
    httpLogger.info('Headers: ${request.headers}');

    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) {
    httpLogger
        .info('Response: ${response.statusCode} for ${response.request?.url}');
    return response;
  }
}
