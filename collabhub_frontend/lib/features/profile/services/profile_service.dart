import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../models/profile_model.dart';

class ProfileService {
  Future<ProfileModel> getProfile() async {
    try {
      final response = await DioClient.dio.get("/profile");
      print(response.data);
      return ProfileModel.fromJson(response.data["user"],);
    } catch (e) {
      print("Profile Error: $e");
      rethrow;
    }
  }

  Future<ProfileModel> updateProfile({
    required String username,
    required String bio,
    required String avatar,
  }) async {
    try {
      final response = await DioClient.dio.put("/profile", data: {
        "username": username,
        "bio": bio,
        "avatar": avatar,
      });
      print(response.data);
      return ProfileModel.fromJson(response.data["updatedUser"],);
    }
    catch (e) {
      print("Profile Update Error: $e");
      rethrow;
    }
  }

  Future<String> uploadAvatar(File imageFile,) async {
    FormData formData = FormData.fromMap({"avatar": await MultipartFile.fromFile(imageFile.path,),});

    final response = await DioClient.dio.post("/upload/avatar", data: formData,);

    return response
        .data["imageUrl"];
  }
}