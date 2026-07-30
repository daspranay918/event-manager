import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final _supabase = Supabase.instance.client;

  Future<String> uploadEventBanner({
    required File imageFile,
    required String userId,
  }) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    print("1. Starting upload");

    final path = '$userId/$fileName';

    await _supabase.storage
        .from('event-banners')
        .upload(path, imageFile, fileOptions: const FileOptions(upsert: true));

        print("2. Upload completed");
        print(_supabase.auth.currentUser);

    final imageUrl = _supabase.storage.from('event-banners').getPublicUrl(path);

    print("2. Upload completed");

    return imageUrl;
  }
}
