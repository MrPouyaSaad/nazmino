import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

String errorMessage = (Get.locale?.languageCode == 'fa')
    ? 'خطایی در برقراری ارتباط رخ داده است.'
    : 'An error occurred.';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

void validateResponse(Response response) {
  if (response.statusCode != 200 &&
      response.statusCode != 201 &&
      response.statusCode != 204) {
    final data = response.data;

    if (data is Map) {
      errorMessage = (Get.locale?.languageCode == 'fa')
          ? (data['message'] ?? 'خطایی در برقراری ارتباط رخ داده است.')
          : (data['message_en'] ?? 'An error occurred.');
    } else {
      errorMessage = (Get.locale?.languageCode == 'fa')
          ? 'خطایی در برقراری ارتباط رخ داده است.'
          : 'An error occurred.';
    }

    throw ApiException(errorMessage);
  }
}
