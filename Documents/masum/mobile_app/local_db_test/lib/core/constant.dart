class AppConstants {
  // Android emulator: 10.0.2.2 = host machine localhost
  // Real device: change to your machine's local IP, e.g., "http://192.168.1.x:3000"
  static const String baseUrl = "http://192.168.50.118:3000";

  static const String visitPending = "pending";
  static const String visitVisited = "visited";
  static const String visitNotAvailable = "not_available";

  static const String syncSynced = "synced";
  static const String syncPendingCreate = "pending_create";
  static const String syncPendingUpdate = "pending_update";
  static const String syncFailed = "failed";

  static const int maxRetries = 3;
}
