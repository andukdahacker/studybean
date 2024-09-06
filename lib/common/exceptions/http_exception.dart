class APIException implements Exception {
  final String message;
  final int statusCode;

  APIException(this.message,this.statusCode);
}