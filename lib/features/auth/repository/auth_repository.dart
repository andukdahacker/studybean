import 'package:http_interceptor/http/http_methods.dart';
import 'package:studybean/common/api/api_client.dart';
import 'package:studybean/features/auth/models/sign_up_input.dart';

import '../models/sign_in_response.dart';
import '../models/sign_up_response.dart';

class AuthRepository {
  final APIClient _client;

  AuthRepository(this._client);

  Future<SignUpResponse> signUp(SignUpInput input) async {
    final response = await _client.call(
      HttpMethod.POST,
      path: '/users/register',
      body: input.toJson(),
    );

    if (response.data == null) throw Exception('Failed to sign up');

    return SignUpResponse.fromJson(response.data!);
  }

  Future<SignInResponse> signIn(String token) async {
    final response = await _client.call(
      HttpMethod.POST,
      path: '/users/login',
      body: {'idToken': token},
    );

    if (response.data == null) throw Exception('Failed to sign in');

    return SignInResponse.fromJson(response.data!);
  }
}
