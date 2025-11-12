import 'package:supabase_flutter/supabase_flutter.dart';

String? extractDisplayName(User user) {
  final metadata = user.userMetadata;
  if (metadata != null) {
    final possibleKeys = ['name', 'full_name', 'username', 'display_name'];
    for (final key in possibleKeys) {
      final value = metadata[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
  }

  final email = user.email;
  if (email != null && email.contains('@')) {
    return email.split('@').first;
  }

  return user.id;
}

