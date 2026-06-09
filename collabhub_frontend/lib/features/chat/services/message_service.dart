import 'package:collabhub/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class MessageService {
  static Future<Response> getChannelMessages({
    required String channelId,
  }) async {
    return await DioClient.dio.get('/message/$channelId');
  }

  static Future<Response> sendMessage({
    required String channelId,
    required String text,
  }) async {
    return await DioClient.dio.post(
      '/message/send',
      data: {
        'channel': channelId,
        'text': text,
      },
    );
  }
}