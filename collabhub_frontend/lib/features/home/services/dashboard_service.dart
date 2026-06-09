import 'package:collabhub/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class DashboardService {
  static Future<Response> getDashboard() async{
    return await DioClient.dio.get("/dashboard");
  }
}