class LoginResponseModel {
  LoginResponseModel({this.refresh, this.access, this.traineeProfile});

  final String? refresh;
  final String? access;
  final TraineeProfile? traineeProfile;

  LoginResponseModel copyWith({
    String? refresh,
    String? access,
    TraineeProfile? traineeProfile,
  }) {
    return LoginResponseModel(
      refresh: refresh ?? this.refresh,
      access: access ?? this.access,
      traineeProfile: traineeProfile ?? this.traineeProfile,
    );
  }

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      refresh: json["refresh"] ?? json['refresh_token'],
      access: json["access"] ?? json['token'],
      traineeProfile: json["trainee_profile"] != null
          ? TraineeProfile.fromJson(json["trainee_profile"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "refresh": refresh,
    "access": access,
    "trainee_profile": traineeProfile?.toJson(),
  };
}

class TraineeProfile {
  final int id;

  TraineeProfile({required this.id});

  factory TraineeProfile.fromJson(Map<String, dynamic> json) {
    return TraineeProfile(id: json["id"]);
  }

  Map<String, dynamic> toJson() => {"id": id};
}
