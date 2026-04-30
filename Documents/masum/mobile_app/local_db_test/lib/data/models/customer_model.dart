class CustomerModel {
  int? id;

  String name;
  String phone;
  String email;
  String address;

  String lastVisitDate;
  String visitStatus;
  String notes;

  String syncStatus;
  String updatedAt;
  String lastSyncedAt;

  CustomerModel({
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

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      // json-server v1 returns id as String ("1"), SQLite returns it as int — handle both
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),

      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],

      lastVisitDate: json['lastVisitDate'] ?? "",

      visitStatus: json['visitStatus'] ?? "pending",

      notes: json['notes'] ?? "",

      syncStatus: json['syncStatus'] ?? "synced",

      updatedAt: json['updatedAt'] ?? "",

      lastSyncedAt: json['lastSyncedAt'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "name": name,
      "phone": phone,
      "email": email,
      "address": address,

      "lastVisitDate": lastVisitDate,

      "visitStatus": visitStatus,

      "notes": notes,

      "syncStatus": syncStatus,

      "updatedAt": updatedAt,

      "lastSyncedAt": lastSyncedAt,
    };
  }
}
