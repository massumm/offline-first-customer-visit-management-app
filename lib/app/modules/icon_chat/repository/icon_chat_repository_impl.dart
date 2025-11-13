import 'package:dio/dio.dart';
import '../../../base/base_remote_source.dart';
import '../../../base/network/dio_provider.dart';
import 'icon_chat_repository.dart';

class IconChatRepositoryImpl extends BaseRemoteSource
    implements IconChatRepository {
  @override
  Future<int?> getOrCreateRoom({
    required int traineeProfileId,
    required int trainerProfileId,
    required String token,
  }) async {
    final String endpoint =
        "${DioProvider.baseUrl}/api/ai_chat/rooms/by-trainer/$trainerProfileId/";
    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: {
        'trainee_profile': traineeProfileId,
        'trainer_profile': trainerProfileId,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    try {
      final response = await callApiWithErrorParser(dioCall);
      return response.data['id'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMessages(
    int roomId,
    String token,
  ) async {
    final String endpoint =
        "${DioProvider.baseUrl}/api/ai_chat/rooms/$roomId/messages/";
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    try {
      final response = await callApiWithErrorParser(dioCall);
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendMessage(int roomId, String token, String message) async {
    final String endpoint =
        "${DioProvider.baseUrl}/api/ai_chat/rooms/$roomId/messages/";
    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: {'content': message},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    try {
      await callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }
}
