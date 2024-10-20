import 'package:flutter/material.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';

import '../exceptions/http_exception.dart';

extension ContextErrorHandling<T> on BuildContext {
  void handleError(Object error) {
   switch(error.runtimeType) {
     case const (Exception):
       showErrorDialog(title: 'Error', message: error.toString());
       break;
     case const (APIException):
       final apiException = error as APIException;
       showErrorDialog(title: 'Error', message: apiException.message);
       break;
     default:
       break;
   }
  }
}
