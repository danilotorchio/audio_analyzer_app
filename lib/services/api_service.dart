import 'dart:developer';

import 'package:dio/dio.dart';

class ApiService {
  late final Dio _client;

  ApiService({
    required String baseUrl,
  }) : _client = Dio(BaseOptions(baseUrl: baseUrl));

  Future<dynamic> sendText(String text) async {
    try {
      final res = await _client.post(
        '/',
        data: <String, String>{'text': text},
      );

      if (res.data != null) {
        return res.data;
      }

      throw AppException('Nenhum dado retornado');
    } on DioException catch (e) {
      final msg = e.message.toString();
      log(msg);

      throw AppException(msg);
    }
  }
}

class AppException implements Exception {
  final String message;
  AppException(this.message);
}
