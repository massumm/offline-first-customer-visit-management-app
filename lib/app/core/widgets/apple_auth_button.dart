import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthButton extends StatelessWidget {
  const AppleAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInWithAppleButton(
      onPressed: () async {
        try {
          final  AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
            scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
          );

          final String token =   credential.identityToken ?? '';
          'Apple access token: $token'.log();


        } on SignInWithAppleAuthorizationException catch (e) {
          // Surface the precise AuthorizationErrorCode to logs/analytics
          'Apple Sign-In failed: code=${e.code}, message=${e.message}'.log(name: 'Apple Auth');
        } catch (e, st) {
          'Unexpected Apple Sign-In error: $e\n$st'.log(name: 'Apple Auth');
        }

      },
    );
  }
}
