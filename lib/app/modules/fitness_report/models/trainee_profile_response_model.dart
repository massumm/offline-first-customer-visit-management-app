class TraineeProfileModel {
  final int id;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? avatar;
  final String? phoneNumber;
  final String? fullAddress;
  final String? country;
  final String? city;
  final String? gender;
  final bool isPremium;
  final int remainingFreeMessages;
  final DateTime? subscriptionExpiryDate;
  final String subscriptionStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;

  TraineeProfileModel({
    required this.id,
    this.bio,
    this.dateOfBirth,
    this.avatar,
    this.phoneNumber,
    this.fullAddress,
    this.country,
    this.city,
    this.gender,
    required this.isPremium,
    required this.remainingFreeMessages,
    this.subscriptionExpiryDate,
    required this.subscriptionStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory TraineeProfileModel.fromJson(Map<String, dynamic> json) {
    return TraineeProfileModel(
      id: json['id'],
      bio: json['bio'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      avatar: json['avatar'],
      phoneNumber: json['phone_number'],
      fullAddress: json['full_address'],
      country: json['country'],
      city: json['city'],
      gender: json['gender'],
      isPremium: json['is_premium'] ?? false,
      remainingFreeMessages: json['remaining_free_messages'] ?? 0,
      subscriptionExpiryDate: json['subscription_expiry_date'] != null
          ? DateTime.parse(json['subscription_expiry_date'])
          : null,
      subscriptionStatus: json['subscription_status'] ?? 'inactive',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      userId: json['user'],
    );
  }
}
