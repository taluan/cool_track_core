class AppException implements Exception {
  final String message;
  final int code;
  final String? title;
  final dynamic data;

  AppException(this.message, {this.title, this.code = 500, this.data});

  @override
  String toString() {
    return message;
  }
}