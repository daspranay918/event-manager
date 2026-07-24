import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final _supabase = Supabase.instance.client;

  Future<String> uploadEventBanner({
    required File imageFile,
    required String userId,
  }) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final path = '$userId/$fileName';

    await _supabase.storage
        .from('event-banners')
        .upload(path, imageFile, fileOptions: const FileOptions(upsert: true));

    final imageUrl = _supabase.storage.from('event-banners').getPublicUrl(path);

    return imageUrl;
  }
}
