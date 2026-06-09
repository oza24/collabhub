import 'package:collabhub/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class AuthService {
  static Future<Response> signup({
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {


    return await DioClient.dio.post(
      'auth/signup',
      data: {
        'username': username,
        'email': email,
        'password': password,
        'Role': role,
      },
    );
  }

  static Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await DioClient.dio.post(
      'auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  static Future<void> forgotPassword({
    required String email,
  }) async{
     await DioClient.dio.post('auth/forgot-password',
    data: {
      "email": email,
    }
    );
  }

  static Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async{
    await DioClient.dio.post('auth/verify-otp',
      data: {
        "email" : email,
        "otp": otp,
      }
    );
  }

  static Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {

    await DioClient.dio.post(
      "/auth/reset-password",
      data: {
        "email": email,
        "otp": otp,
        "password": password,
      },
    );
  }
}

