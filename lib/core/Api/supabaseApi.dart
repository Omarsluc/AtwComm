import 'dart:developer';

import 'package:atw_comm/core/utils/consts.dart';
import 'package:atw_comm/features/articles/model/podcast_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<bool> ensureUserExists(String userName) async {
  try {
    // Check if user exists
    final existingUser = await supabase
        .from('users')
        .select()
        .eq('name', userName)
        .maybeSingle();

    if (existingUser != null) {
      return true; // User already exists
    }

    // Create new user if doesn't exist
    await supabase.from('users').insert({
      'name': userName,
      'created_at': DateTime.now().toIso8601String(),
    });

    return true;
  } catch (e) {
    log('Error ensuring user exists: $e');
    return false;
  }
}

Future<List<Podcast>> fetchPodcastsByType(String type) async {
  final response = await supabase
      .from('podcasts')
      .select()
      .eq('type', type)
      .order('created_at', ascending: false);
  if (response is List) {
    return response.map((e) => Podcast.fromJson(e)).toList();
  } else {
    return [];
  }
}

Future<List<Podcast>> fetchAllPodcasts() async {
  try {
    final response = await supabase
        .from('podcasts')
        .select()
        .order('created_at', ascending: false);

    if (response is List) {
      return response.map((e) => Podcast.fromJson(e)).toList();
    } else {
      return [];
    }
  } catch (e) {
    log('Error fetching all podcasts: $e');
    return [];
  }
}

Future<Map<String, dynamic>?> createPodcast({
  required String title,
  required String article,
  required String type,
  required String authorName,
  String? audioUrl,
}) async {
  try {
    // First ensure the user exists
    final userExists = await ensureUserExists(authorName);
    if (!userExists) {
      throw Exception('Failed to create or verify user');
    }

    // Then create the podcast
    final response = await supabase
        .from('podcasts')
        .insert({
          'title': title,
          'article': article,
          'type': type,
          'author_name': authorName,
          'audio_url': audioUrl,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return response;
  } catch (e) {
    log('Error creating podcast: $e');
    return null;
  }
}

Future<String?> getCurrentUserName() async {
  try {
    log(userNameIdentified ?? 'no');
    return userNameIdentified;
  } catch (e) {
    print('Error getting user name: $e');
    return null;
  }
}
