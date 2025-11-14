
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class GoogleSignInApi {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<String?> login() async {
    String clientId =
        "150486406603-0s45gr0d592iihcqp9h0t4g5bqigrvk8.apps.googleusercontent.com";

    // Handle client id with platform
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      clientId = "150486406603-tfj2369fbgbpv2aq1phao15j93089vsf.apps.googleusercontent.com";
    }

    try {
      _googleSignIn.initialize(
        clientId: clientId,
        serverClientId:
            '150486406603-5jlpj7l09mp8o1v1pfvlko3btkr5j8qq.apps.googleusercontent.com',
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
