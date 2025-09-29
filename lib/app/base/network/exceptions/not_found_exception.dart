import 'dart:io';

import 'api_exception.dart';

class NotFoundException extends ApiException {
  NotFoundException(String message, String status, String description)
      : super(
          httpCode: HttpStatus.notFound,
          status: status,
          message: message,
          description: description,
        );
}
