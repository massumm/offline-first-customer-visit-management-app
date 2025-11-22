
class TrainerProfileModel {
  final int id;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? avatar;
  final String? phoneNumber;
  final String? fullAddress;
  final String? country;
  final String? city;
  final String? gender;
  final String personaName;
  final String personaDescription;
  final String coachingStyleName;
  final String coachingStyleDescription;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;

  TrainerProfileModel({
    required this.id,
    this.bio,
    this.dateOfBirth,
    this.avatar,
    this.phoneNumber,
    this.fullAddress,
    this.country,
    this.city,
    this.gender,
    required this.personaName,
    required this.personaDescription,
    required this.coachingStyleName,
    required this.coachingStyleDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory TrainerProfileModel.fromJson(Map<String, dynamic> json) {
    return TrainerProfileModel(
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
      personaName: json['persona_name'] ?? '',
      personaDescription: json['persona_description'] ?? '',
      coachingStyleName: json['coaching_style_name'] ?? '',
      coachingStyleDescription: json['coaching_style_description'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      userId: json['user'],
    );
  }
}
