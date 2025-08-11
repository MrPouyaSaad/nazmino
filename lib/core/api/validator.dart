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

String errorMessage = 'لطفا دستررسی به اینترنت خود را بررسی کنید!';
