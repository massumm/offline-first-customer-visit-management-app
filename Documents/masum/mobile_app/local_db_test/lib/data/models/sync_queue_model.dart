class SyncQueueModel {
  int? id;

  String entityType;
  int entityId;

  String operationType;

  String payload;

  int retryCount;

  String createdAt;

  String lastAttemptAt;

  String syncStatus;

  SyncQueueModel({
    this.id,

    required this.entityType,
    required this.entityId,

    required this.operationType,
    required this.payload,

    required this.retryCount,

    required this.createdAt,
    required this.lastAttemptAt,

    required this.syncStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "entityType": entityType,
      "entityId": entityId,

      "operationType": operationType,

      "payload": payload,

      "retryCount": retryCount,

      "createdAt": createdAt,

      "lastAttemptAt": lastAttemptAt,

      "syncStatus": syncStatus,
    };
  }
}
