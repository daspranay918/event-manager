import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ProfileService {
  Future<void> createProfile({
    required String userId,
    required String email,
    required String fullName,
    String? phone,
  }) async {
    await supabase.from('profiles').upsert({
      'id': userId,
      'email': email,
      'full_name': fullName,
      'phone': phone,
    });
  }

  Future<bool> profileExists(String userId) async {
    final data = await supabase
        .from('profiles')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    return data != null;
  }
}