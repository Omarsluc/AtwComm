import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List<Map<String, dynamic>>> fetchPodcastsByType(String type) async {
  final response = await supabase
      .from('podcasts')
      .select()
      .eq('type', type)
      .order('created_at', ascending: false);
  if (response is List) {
    return List<Map<String, dynamic>>.from(response);
  } else {
    return [];
  }
}
