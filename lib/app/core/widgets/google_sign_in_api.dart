
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class GoogleSignInApi {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<String?> login() async {
    String clientId =
        "1059805585872-pgrk4boajnk45122jim5qvo1qgiol0bg.apps.googleusercontent.com";

    // Handle client id with platform
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      clientId = "1059805585872-6n7la7rto1tv69ns6nigv6sa2g8jfk6p.apps.googleusercontent.com";
    }

    try {
      _googleSignIn.initialize(
        clientId: clientId,
        serverClientId:
            '1059805585872-pgrk4boajnk45122jim5qvo1qgiol0bg.apps.googleusercontent.com',
      );

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      GoogleSignInClientAuthorization usr = await googleUser.authorizationClient
          .authorizeScopes([
            'https://www.googleapis.com/auth/userinfo.profile',
          ]);

      return usr.accessToken;
    } catch (error) {
      Logger().e("Google Sign-In error: $error");
      Future.error(error);
    }
    return null;
  }
}
