// Pure domain entity representing one item waiting to be synced
class SyncItemEntity {
  final int? id;
  final String entityType;
  final int entityId;
  final String operationType;
  final String payload;
  final int retryCount;
  final String createdAt;
  final String lastAttemptAt;
  final String syncStatus;

  const SyncItemEntity({
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
}
