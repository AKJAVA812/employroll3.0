import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mss_profiles/profileListModal.dart';

class MobileProfileCache {
  MobileProfileCache._();

  static final ValueNotifier<int> revision = ValueNotifier<int>(0);

  static void notifyChanged() {
    revision.value++;
  }

  static Future<ProfileListModal> loadProfileList() async {
    final prefs = await SharedPreferences.getInstance();
    final bootstrapJson = prefs.getString('mobileBootstrapJson') ?? '';
    final loginJson = prefs.getString('mobileLoginResponseJson') ?? '';
    final profiles = _profilesFromJson(bootstrapJson);
    if (profiles.isNotEmpty) {
      return ProfileListModal(data: profiles);
    }
    return ProfileListModal(data: _profilesFromJson(loginJson));
  }

  static List<ProfileData> _profilesFromJson(String raw) {
    if (raw.trim().isEmpty) return <ProfileData>[];
    try {
      final decoded = json.decode(raw);
      if (decoded is! Map<String, dynamic>) return <ProfileData>[];
      final source = decoded['profiles'];
      if (source is! List) return <ProfileData>[];
      return source
          .whereType<Map<String, dynamic>>()
          .map(ProfileData.fromJson)
          .toList();
    } catch (error) {
      return <ProfileData>[];
    }
  }
}
