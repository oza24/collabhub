import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class ChatService {
  static Future<Response> getMyChats() async {
    return await DioClient.dio.get('/chat/mychats');
  }
}