import 'package:casia/Authentication/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  static read(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return json.decode(prefs.getString(key));
    } else {
      return null;
    }
  }

  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, json.encode(value));
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<User> getUser() async {
    String userJson = await read("user");
    if (userJson != null && userJson.isNotEmpty) {
      return User.fromJson(userJson);
    } else {
      return null;
    }
  }

  static Future<void> saveUser(User user) async {
    await save("user", user.toJson());
  }

  static Future<void> logout() async {
    //await remove("devices");
    await remove("user");
    await remove("reminders");
    await remove("loginToken");
    await remove("isFirstAcquisition");
  }
}