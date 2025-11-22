class TraineeProfileModel {
  final int id;
  final TraineeUser? user;
  final String? bio;
  final String? name;
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
    this.user,
    this.name,
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
      user: json['user'] != null ? TraineeUser.fromJson(json['user']) : null,
      name: json['name'],
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

// "user": {
//             "id": 19,
//             "username": "Syed Hasan",
//             "email": "syedhasan.cse@gmail.com",
//             "first_name": "syed",
//             "last_name": "vvgg, Date: 22 Nov, 2025"
//         },
class TraineeUser {
  final int id;
  final String userName, email, firstName, lastName;

  TraineeUser({
    required this.id,
    required this.userName,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory TraineeUser.fromJson(Map<String, dynamic> json) {
    return TraineeUser(

      id: json['id'] ?? 0,
      userName: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}
