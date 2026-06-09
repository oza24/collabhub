import 'dart:io';

import 'package:collabhub/core/constants/app_colors.dart';
import 'package:collabhub/core/storage/token_storage.dart';
import 'package:collabhub/features/profile/services/profile_service.dart';
import 'package:collabhub/features/profile/widgets/edit_bio_bottom_sheet.dart';
import 'package:collabhub/features/profile/widgets/profile_header.dart';
import 'package:collabhub/features/profile/widgets/profile_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/network/dio_client.dart';
import 'models/profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService profileService = ProfileService();

  ProfileModel? profile;
  bool isLoading = true;
  int channelCount = 0;

  Future<void> updateBio(String newBio) async {
    try {
      final updatedProfile = await profileService.updateProfile(
        username: profile!.username,
        bio: newBio,
        avatar: "", // Avatar update not implemented yet
      );

      setState(() {
        profile = updatedProfile;
      });
    } catch (e) {
      print("Update Bio Error: $e");
    }
  }

  Future<void> pickAvatar() async {

    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return;
    }

    print("PATH = ${image.path}");

    await uploadAvatar(
      File(image.path),
    );
  }

  Future<void> uploadAvatar(File image) async {
    try {
      final imageUrl = await profileService.uploadAvatar(image);
      final updatedProfile = await profileService.updateProfile(
        username: profile!.username,
        bio: profile!.bio,
        avatar: imageUrl,
      );
      setState(() {
        profile = updatedProfile;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    loadChannelCount();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final result = await profileService.getProfile();

      print(result.username);
      print(result.email);

      setState(() {
        profile = result;
        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadChannelCount() async {

    try {

      final response =
      await DioClient.dio.get(
        "/dashboard",
      );

      setState(() {
        channelCount =
            response.data["channelCount"] ?? 0;
      });

    } catch (e) {

      print(e);

    }
  }

  Future<void> logout() async {
    await TokenStorage.clear();

    final token =
    await TokenStorage.getToken();

    if(!mounted) return ;

    context.go("/login");
  }

  @override
  Widget build(BuildContext context,) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // AVATAR
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profile!.avatar.trim().isNotEmpty
                        ? NetworkImage(profile!.avatar)
                        : null,
                    child: profile!.avatar.trim().isEmpty
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),

                    child: IconButton(
                      onPressed: pickAvatar,

                      icon: const Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // USERNAME
              Text(
                profile!.username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              // EMAIL
              Text(
                profile!.email,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),

              const SizedBox(height: 16),

              // BIO
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      profile!.bio.trim().isEmpty
                          ? "No bio added"
                          : profile!.bio,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) {
                          return EditBioBottomSheet(
                            currentBio: profile!.bio,
                            onSave: updateBio,
                          );
                        },
                      );

                      // Open Edit Profile
                    },

                    icon: const Icon(Icons.edit, size: 20),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // STATS
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      Column(
                        children: [
                          Text(
                            profile!.workspaces.length.toString(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text("Workspaces"),
                        ],
                      ),

                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),

                       Column(
                        children: [
                          Text(
                            channelCount.toString(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text("Channels"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // LOGOUT
              Card(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),

                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),

                  onTap: logout
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
