class RegistrationResponseModel {
  RegistrationResponseModel({
    required this.message,
  });

  final String? message;

  RegistrationResponseModel copyWith({
    String? message,
  }) {
    return RegistrationResponseModel(
      message: message ?? this.message,
    );
  }

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json){
    return RegistrationResponseModel(
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
  };

}
