import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:next_meet/Services/profile_service.dart';
import 'package:next_meet/core/constants/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AuthService {
  /// GOOGLE SIGN IN INSTANCE
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final ProfileService _profileService = ProfileService();

  /// REGISTER
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'phone': phone},
    );

    final user = response.user;

    if (user != null) {
      final exists = await _profileService.profileExists(user.id);

      if (!exists) {
        await _profileService.createProfile(
          userId: user.id,
          email: email,
          fullName: fullName,
          phone: phone,
        );
      }
    }

    return response;
  }

  /// GOOGLE LOGIN / SIGNUP
  Future<void> continueWithGoogle(BuildContext context) async {
    try {
      /// INITIALIZE GOOGLE
      await _googleSignIn.initialize(
        serverClientId: AppConstants.googleWebClientId,
        clientId: Platform.isAndroid
            ? AppConstants.androidClindId
            : AppConstants.iosClindId,
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

      // debugPrint("EMAIL: ${result.user?.email}");
      // debugPrint("METADATA: ${result.user?.userMetadata}");

      /// CHECK USER
      if (result.user != null && result.session != null) {
        final user = result.user!;

        final exists = await _profileService.profileExists(user.id);

        if (!exists) {
          await _profileService.createProfile(
            userId: user.id,
            email: user.email ?? '',
            fullName: user.userMetadata?['full_name'] ?? 'User',
          );
        }

        if (context.mounted) {
          context.go('/navigation');
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
