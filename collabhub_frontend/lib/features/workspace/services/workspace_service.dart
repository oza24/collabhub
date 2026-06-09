import 'dart:async';

import 'package:collabhub/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class WorkspaceService {
  static Future<Response> createWorkspace({
    required String name,
    required String description,
  }) async {
    return await DioClient.dio.post(
      '/workspace/create',
      data: {
        'name': name,
        'description': description,
      },
    );
  }

  static Future<Response> getWorkspaces()
  async {
    return await DioClient.dio.get('/workspace/getworkspaces');
  }

  static Future<Response> addMember({
    required String workspaceId,
    required String email,
  }) async {

    return await DioClient.dio.post('/workspace/addmember',
      data: {

        'workspaceId': workspaceId,
        'email': email,
      },
    );
  }
}