import 'package:collabhub/core/network/api_constants.dart';
import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },

    ),
  );



  static Future<void> initialize() async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
}