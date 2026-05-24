import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:next_meet/core/constants/app_constants.dart';
import 'package:next_meet/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AuthService {
  /// GOOGLE SIGN IN INSTANCE
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// REGISTER
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,

      data: {'full_name': fullName, 'phone': phone},
    );
  }

  /// GOOGLE LOGIN / SIGNUP
  Future<void> continueWithGoogle(BuildContext context) async {
    try {
      /// INITIALIZE GOOGLE
      await _googleSignIn.initialize(
        serverClientId:
            AppConstants.googleWebClientId,
        clientId:
            AppConstants.androidClindId,
      );

      /// AUTHENTICATE USER
      final GoogleSignInAccount account = await _googleSignIn.authenticate();

      /// GET ID TOKEN
      final String? idToken = account.authentication.idToken;

      if (idToken == null) {
        throw Exception("Google ID Token not found");
      }

      /// GET ACCESS TOKEN
      final GoogleSignInClientAuthorization? authorization = await account
          .authorizationClient
          .authorizationForScopes(['email', 'profile']);

      /// SUPABASE AUTH
      final AuthResponse result = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,

        idToken: idToken,

        accessToken: authorization?.accessToken,
      );

      /// CHECK USER
      if (result.user != null && result.session != null) {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,

            MaterialPageRoute(builder: (context) => const HomeScreen()),

            (route) => false,
          );
        }
      } else {
        throw Exception("Google Sign In Failed");
      }
    } on AuthException catch (e) {
      debugPrint("Supabase Auth Error: ${e.message}");

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } on GoogleSignInException catch (e) {
      debugPrint("Google Sign In Error: ${e.description}");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.description ?? "Google Sign In Failed")),
        );
      }
    } catch (e) {
      debugPrint("Unknown Error: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  /// EMAIL LOGIN
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// LOGOUT
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    await supabase.auth.signOut();
  }

  /// CURRENT USER
  User? get currentUser => supabase.auth.currentUser;

  /// IS LOGGED IN
  bool get isLoggedIn => currentUser != null;
}
