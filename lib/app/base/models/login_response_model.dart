class LoginResponseModel {
 final   String accessToken;


  LoginResponseModel({this.accessToken = ''});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    accessToken: json["access_token"],
  );

}