abstract class BaseException implements Exception {
  final String message;
  final String description;

  BaseException({this.message = "", this.description = ""});
}
