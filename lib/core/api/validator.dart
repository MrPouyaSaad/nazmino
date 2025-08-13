import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

validateResponse(Response response) {
  if (response.statusCode != 200 &&
      response.statusCode != 201 &&
      response.statusCode != 204) {
    errorMessage = response.data['message'];
    throw Text(response.data['message']);
  }
}

String errorMessage =
    'خطایی در برقراری ارتباط رخ داده است. لطفاً مجدداً تلاش فرمایید.';
