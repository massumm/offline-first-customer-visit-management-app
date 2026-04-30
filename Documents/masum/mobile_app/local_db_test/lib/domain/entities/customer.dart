// Pure domain entity — no dependency on DB or API layer
class CustomerEntity {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String lastVisitDate;
  final String visitStatus;
  final String notes;
  final String syncStatus;
  final String updatedAt;
  final String lastSyncedAt;

  const CustomerEntity({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.lastVisitDate,
    required this.visitStatus,
    required this.notes,
    required this.syncStatus,
    required this.updatedAt,
    required this.lastSyncedAt,
  });
}
