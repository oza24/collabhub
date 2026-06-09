import 'dart:io';

import 'package:collabhub/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class DirectMessageService {
  static Future<Response> createConversation({
    required String receiverId,
  }) async {
    return await DioClient.dio.post(
      '/conversation/create',
      data: {
        'receiverId': receiverId,
      },
    );
  }

  static Future<Response> getMessages({
    required String conversationId,
  }) async {
    return await DioClient.dio.get('/dm/$conversationId',);
  }

  static Future<Response> sendMessage({
    required String conversationId,
    required String text,
    String messageType = "text",
    String fileUrl = "",
    String fileName = "",
  }) async {
    return await DioClient.dio.post('/dm/send',
      data: {
        'conversationId': conversationId,
        'text': text,
        'messageType': messageType,
        'fileUrl': fileUrl,
        'fileName': fileName,
      },
    );
  }

  static Future<Response> getUserStatus({required String userId,}) async {
    return await DioClient.dio.get(
      "/status/$userId",
    );
  }

  static Future<Map<String,dynamic>> uploadFile(File file) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path,),
    });
    final response = await DioClient.dio.post("/upload/chat-file",
      data: formData,
    );
    return response.data;
  }

  static Future<void> markMessagesRead({required String conversationId,}) async {
     await DioClient.dio.put("/dm/read",
      data: {
        "conversationId": conversationId,
      },
    );
  }


}