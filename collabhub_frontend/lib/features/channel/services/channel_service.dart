import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class ChannelService {
  // GET CHANNELS OF A WORKSPACE
  static Future<Response> getWorkspaceChannels({
    required String workspaceId,
  }) async {
    return await DioClient.dio.get('/channel/$workspaceId');
  }

  // CREATE CHANNEL
  static Future<Response> createChannel({
    required String workspaceId,

    required String name,
  }) async {
    return await DioClient.dio.post(
      '/channel/create',

      data: {'workspace': workspaceId, 'name': name},
    );
  }
}
