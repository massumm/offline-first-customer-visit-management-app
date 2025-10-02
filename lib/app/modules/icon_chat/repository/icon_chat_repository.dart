abstract class IconChatRepository {
  Future<int?> getOrCreateRoom({
    required int traineeProfileId,
    required int trainerProfileId,
    required String token,
  });
  Future<List<Map<String, dynamic>>> fetchMessages(int roomId, String token);
  Future<void> sendMessage(int roomId, String token, String message);
}
