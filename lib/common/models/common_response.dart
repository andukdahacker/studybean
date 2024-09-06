import 'dart:convert';

class CommonResponse {
  Map<String, dynamic>? data;
  int? code;
  String? message;

  CommonResponse({this.data, this.code, this.message});

  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(
      data: json['data'] != null ? jsonDecode(json['data']) : null,
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (data != null) {
      json['data'] = jsonEncode(data);
    } else {
      json['data'] = null;
    }
    json['code'] = code;
    json['message'] = message;

    return json;
  }
}
