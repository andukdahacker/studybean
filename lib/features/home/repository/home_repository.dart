import 'package:http_interceptor/http/http_methods.dart';
import 'package:studybean/common/api/api_client.dart';

import '../../auth/models/user.dart';

class HomeRepository {
  final APIClient _client;
  
  HomeRepository(this._client);
  
  Future<int> getTotalCredits() async {
    final response = await _client.call(HttpMethod.GET, path: '/users/me');
    if(response.data == null) {
      throw Exception('Cannot get total credits');
    }

    final user = User.fromJson(response.data!);

    return user.totalCredits;
  }
}