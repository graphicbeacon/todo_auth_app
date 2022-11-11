import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class InvalidTokenInterceptor extends Interceptor {
  InvalidTokenInterceptor({required this.onInvalidToken});

  final VoidCallback onInvalidToken;

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == HttpStatus.forbidden) {
      final info = err.response!.data;

      if (info['code'] == 'INVALID_JWT') {
        onInvalidToken();
        handler.reject(err);
        return;
      }
    }

    handler.next(err);
  }
}
