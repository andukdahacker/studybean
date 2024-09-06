import 'package:studybean/features/auth/models/user.dart';

class SignUpResponse {
  final User user;
  SignUpResponse({required this.user});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user.toJson();
    return data;
  }
}