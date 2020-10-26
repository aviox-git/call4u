import 'package:shared_preferences/shared_preferences.dart';

StoredPrefs storedPrefs;

class StoredPrefs {
  final SharedPreferences prefs;

  StoredPrefs(this.prefs);

  String get accessToken => prefs.getString("accessToken") ?? "";
  set accessToken(String token) => prefs.setString("accessToken", token);
}