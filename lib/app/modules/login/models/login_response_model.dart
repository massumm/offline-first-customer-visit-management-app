class LoginResponseModel {
  LoginResponseModel({
     this.refresh,
     this.access,
  });

  final String? refresh;
  final String? access;

  LoginResponseModel copyWith({
    String? refresh,
    String? access,
  }) {
    return LoginResponseModel(
      refresh: refresh ?? this.refresh,
      access: access ?? this.access,
    );
  }

  factory LoginResponseModel.fromJson(Map<String, dynamic> json){
    return LoginResponseModel(
      refresh: json["refresh"] ?? json['refresh_token'],
      access: json["access"] ?? json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    "refresh": refresh,
    "access": access,
  };

}
