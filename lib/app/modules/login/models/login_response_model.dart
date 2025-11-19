class LoginResponseModel {
  LoginResponseModel({
    this.details,
    this.refresh, this.access, this.traineeProfile, this.twoFaEnabled});

  final String? refresh;
  final String? access;
  final bool? twoFaEnabled;
  final String? details;
  final TraineeProfile? traineeProfile;

  LoginResponseModel copyWith({
    String? refresh,
    String? access,
    bool? twoFaEnabled,
    TraineeProfile? traineeProfile,
  }) {
    return LoginResponseModel(
      refresh: refresh ?? this.refresh,
      access: access ?? this.access,
      twoFaEnabled: twoFaEnabled ?? this.twoFaEnabled,
      traineeProfile: traineeProfile ?? this.traineeProfile,
    );
  }

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      details: json["detail"],
      refresh: json["refresh"] ?? json['refresh_token'],
      access: json["access"] ?? json['token'],
      twoFaEnabled: json["2fa_required"] ?? false,
      traineeProfile: json["trainee_profile"] != null
          ? TraineeProfile.fromJson(json["trainee_profile"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "refresh": refresh,
    "access": access,
    "2fa_required": twoFaEnabled,
    "trainee_profile": traineeProfile?.toJson(),
  };
}

class TraineeProfile {
  final int id;
  final int user;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? avatar;
  final String? phoneNumber;
  final String? fullAddress;
  final String? country;
  final String? city;
  final String? gender;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> goals;        // change to List<YourType> if you know it
  final List<dynamic> inspirations; // change to List<YourType> if you know it
  final int? trainerId;
  
  // Paywall/Subscription fields
  final bool? isPremium;
  final int? remainingFreeMessages;
  final DateTime? subscriptionExpiryDate;
  final String? subscriptionStatus;

  const TraineeProfile({
    required this.id,
    required this.user,
    this.bio,
    this.dateOfBirth,
    this.avatar,
    this.phoneNumber,
    this.fullAddress,
    this.country,
    this.city,
    this.gender,
    required this.createdAt,
    required this.updatedAt,
    this.goals = const [],
    this.inspirations = const [],
    this.trainerId,
    this.isPremium,
    this.remainingFreeMessages,
    this.subscriptionExpiryDate,
    this.subscriptionStatus,
  });

  /// Build from JSON (snake_case keys supported)
  factory TraineeProfile.fromJson(Map<String, dynamic> json) {
    DateTime? parseNullableDate(String? s) =>
        (s == null || s.isEmpty) ? null : DateTime.parse(s);

    List<dynamic> list(dynamic v) =>
        v is List ? v : const <dynamic>[];

    return TraineeProfile(
      id: json['id'] as int,
      user: json['user'] as int,
      bio: _emptyToNull(json['bio']),
      dateOfBirth: parseNullableDate(json['date_of_birth'] as String?),
      avatar: _emptyToNull(json['avatar']),
      phoneNumber: _emptyToNull(json['phone_number']),
      fullAddress: _emptyToNull(json['full_address']),
      country: _emptyToNull(json['country']),
      city: _emptyToNull(json['city']),
      gender: _emptyToNull(json['gender']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      goals: list(json['goals']),
      inspirations: list(json['inspirations']),
      trainerId: json['trainer_id'] as int?,
      isPremium: json['is_premium'] as bool?,
      remainingFreeMessages: json['remaining_free_messages'] as int?,
      subscriptionExpiryDate: parseNullableDate(json['subscription_expiry_date'] as String?),
      subscriptionStatus: _emptyToNull(json['subscription_status']),
    );
  }

  /// Convert to JSON (snake_case keys out)
  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user,
    'bio': bio ?? '',
    'date_of_birth': dateOfBirth?.toIso8601String(),
    'avatar': avatar,
    'phone_number': phoneNumber ?? '',
    'full_address': fullAddress ?? '',
    'country': country ?? '',
    'city': city ?? '',
    'gender': gender ?? '',
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'goals': goals,
    'inspirations': inspirations,
    'trainer_id': trainerId,
    'is_premium': isPremium,
    'remaining_free_messages': remainingFreeMessages,
    'subscription_expiry_date': subscriptionExpiryDate?.toIso8601String(),
    'subscription_status': subscriptionStatus,
  };

  TraineeProfile copyWith({
    int? id,
    int? user,
    String? bio,
    DateTime? dateOfBirth,
    String? avatar,
    String? phoneNumber,
    String? fullAddress,
    String? country,
    String? city,
    String? gender,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<dynamic>? goals,
    List<dynamic>? inspirations,
    int? trainerId,
    bool? isPremium,
    int? remainingFreeMessages,
    DateTime? subscriptionExpiryDate,
    String? subscriptionStatus,
  }) {
    return TraineeProfile(
      id: id ?? this.id,
      user: user ?? this.user,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      avatar: avatar ?? this.avatar,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullAddress: fullAddress ?? this.fullAddress,
      country: country ?? this.country,
      city: city ?? this.city,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      goals: goals ?? this.goals,
      inspirations: inspirations ?? this.inspirations,
      trainerId: trainerId ?? this.trainerId,
      isPremium: isPremium ?? this.isPremium,
      remainingFreeMessages: remainingFreeMessages ?? this.remainingFreeMessages,
      subscriptionExpiryDate: subscriptionExpiryDate ?? this.subscriptionExpiryDate,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
    );
  }

  // Treat empty strings from API as nulls for nicer Dart-side handling
  static String? _emptyToNull(dynamic v) {
    if (v == null) return null;
    if (v is String && v.trim().isEmpty) return null;
    return v as String?;
  }
}

