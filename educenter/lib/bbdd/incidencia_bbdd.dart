import 'dart:io';

import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IncidenciaBBDD {
  uploadImage(
    File file,
  ) async {
    final String fullPath = await usersBBDD.supabase.storage
        .from('avatars')
        .upload(
          'public/avatar1.png',
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
  }
}
