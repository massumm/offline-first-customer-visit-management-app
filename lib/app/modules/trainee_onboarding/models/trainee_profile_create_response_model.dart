class TraineeProfileCreateResponseModel {
  TraineeProfileCreateResponseModel({
    required this.id,
    required this.user,
    required this.bio,
    required this.dateOfBirth,
    required this.avatar,
    required this.phoneNumber,
    required this.fullAddress,
    required this.country,
    required this.city,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
    required this.goals,
    required this.inspirations,
  });

  final int? id;
  final num? user;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? avatar;
  final String? phoneNumber;
  final String? fullAddress;
  final String? country;
  final String? city;
  final String? gender;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Goal> goals;
  final List<Goal> inspirations;

  TraineeProfileCreateResponseModel copyWith({
    int? id,
    num? user,
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
    List<Goal>? goals,
    List<Goal>? inspirations,
  }) {
    return TraineeProfileCreateResponseModel(
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
    );
  }

  factory TraineeProfileCreateResponseModel.fromJson(Map<String, dynamic> json){
    return TraineeProfileCreateResponseModel(
      id: json["id"],
      user: json["user"],
      bio: json["bio"],
      dateOfBirth: DateTime.tryParse(json["date_of_birth"] ?? ""),
      avatar: json["avatar"],
      phoneNumber: json["phone_number"],
      fullAddress: json["full_address"],
      country: json["country"],
      city: json["city"],
      gender: json["gender"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      goals: json["goals"] == null ? [] : List<Goal>.from(json["goals"]!.map((x) => Goal.fromJson(x))),
      inspirations: json["inspirations"] == null ? [] : List<Goal>.from(json["inspirations"]!.map((x) => Goal.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "bio": bio,
    "date_of_birth": '',
    // "${dateOfBirth?.year.toString().padLeft(4)}-${dateOfBirth.month.toString().padLeft(2'0')}-${dateOfBirth.day.toString().padLeft(2'0')}",
    "avatar": avatar,
    "phone_number": phoneNumber,
    "full_address": fullAddress,
    "country": country,
    "city": city,
    "gender": gender,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "goals": goals.map((x) => x.toJson()).toList(),
    "inspirations": inspirations.map((x) => x.toJson()).toList(),
  };

}

class Goal {
  Goal({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? text;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Goal copyWith({
    int? id,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Goal(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Goal.fromJson(Map<String, dynamic> json){
    return Goal(
      id: json["id"],
      text: json["text"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}