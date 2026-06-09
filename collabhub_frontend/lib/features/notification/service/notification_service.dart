import 'package:collabhub/core/network/dio_client.dart';

class NotificationService {
  Future<List<dynamic>> getNotifications() async{
    final response = await DioClient.dio.get("/notification",);
    return response.data["notifications"] ?? [];
  }

  Future<int> getUnreadCount() async {
    final response = await DioClient.dio.get("/notification/unread",);
    return response.data["count"] ?? 0;
  }

  Future<void> markAsRead() async {
    await DioClient.dio.put("/notification/mark-as-read",);
  }

  Future<void> markSingleNotificationRead(String notificationId) async {
    await DioClient.dio.put(
      "/notification/$notificationId/read",
    );

  }


}