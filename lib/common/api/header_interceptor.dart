import 'dart:async';

import 'package:http_interceptor/http_interceptor.dart';

class CommonHeaderInterceptor extends InterceptorContract {
  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) {
    request.headers['Content-Type'] = 'application/json';
    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) {
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    return false;
  }

}