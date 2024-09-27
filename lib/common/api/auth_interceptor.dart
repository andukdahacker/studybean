import 'dart:async';

import 'package:http_interceptor/http_interceptor.dart';

import '../services/shared_preference_service.dart';

class AuthInterceptor extends InterceptorContract {
  final SharedPreferenceService pref;

  AuthInterceptor(this.pref);
  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) {
    final token = pref.getToken();
    request.headers['Authorization'] = 'Bearer $token';
    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) {
    return response;
  }
}