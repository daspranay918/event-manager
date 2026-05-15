import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AuthService {

  // REGISTER
  Future<AuthResponse> signUp({

    required String email,
    required String password,
    required String fullName,
    required String phone,

  }) async {

    return await supabase.auth.signUp(

      email: email,
      password: password,

      data: {
        'full_name': fullName,
        'phone': phone,
      },
    );
  }

  // LOGIN
  Future<AuthResponse> signIn({

    required String email,
    required String password,

  }) async {

    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // LOGOUT
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}