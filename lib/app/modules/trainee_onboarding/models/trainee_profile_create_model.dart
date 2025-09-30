class TraineeProfileCreateModel {
  TraineeProfileCreateModel({
    required this.bio,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.fullAddress,
    required this.country,
    required this.city,
    required this.gender,
  });

  final String? bio;
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final String? fullAddress;
  final String? country;
  final String? city;
  final String? gender;

  TraineeProfileCreateModel copyWith({
    String? bio,
    DateTime? dateOfBirth,
    String? phoneNumber,
    String? fullAddress,
    String? country,
    String? city,
    String? gender,
  }) {
    return TraineeProfileCreateModel(
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullAddress: fullAddress ?? this.fullAddress,
      country: country ?? this.country,
      city: city ?? this.city,
      gender: gender ?? this.gender,
    );
  }

  factory TraineeProfileCreateModel.fromJson(Map<String, dynamic> json){
    return TraineeProfileCreateModel(
      bio: json["bio"],
      dateOfBirth: DateTime.tryParse(json["date_of_birth"] ?? ""),
      phoneNumber: json["phone_number"],
      fullAddress: json["full_address"],
      country: json["country"],
      city: json["city"],
      gender: json["gender"],
    );
  }

  Map<String, dynamic> toJson() => {
    "bio": bio,
    "date_of_birth":
    "${dateOfBirth?.year.toString().padLeft(4)}-${dateOfBirth?.month.toString().padLeft(2)}-${dateOfBirth?.day.toString().padLeft(2)}",
    "phone_number": phoneNumber,
    "full_address": fullAddress,
    "country": country,
    "city": city,
    "gender": gender?.toLowerCase(),
  };

}
