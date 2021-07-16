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

  /* static saveReminders(List<TimeOfDay> reminders) {
    if (reminders.isNotEmpty) {
      SharedPref.save(
        "reminders",
        reminders
            .map(
              (timeOfDay) =>
                  timeOfDay.hour.toString().padLeft(2, "0") +
                  timeOfDay.minute.toString().padLeft(2, "0"),
            )
            .join(";"),
      );
    } else {
      SharedPref.remove("reminders");
    }
  } */

  /* static getReminders() async {
    String reminders = await SharedPref.read("reminders");
    if (reminders != null) {
      return List<TimeOfDay>.from(
        reminders.split(";").map(
              (time) => TimeOfDay(
                  hour: int.tryParse(time.substring(0, 2)) ?? 0,
                  minute: int.tryParse(time.substring(2)) ?? 0),
            ),
      );
    }
    return <TimeOfDay>[];
  }
 */
  static saveDevices(List<Map<String, String>> devices) {
    if (devices.isNotEmpty) {
      SharedPref.save("devices", json.encode(devices));
    } else {
      SharedPref.remove("devices");
    }
  }

  static Future<List<Map<String, String>>> getDevices() async {
    String devices = await SharedPref.read("devices");
    if (devices != null) {
      return List<Map<String, String>>.from(json
          .decode(devices)
          .map((device) => Map<String, String>.from(device)));
    }
    return <Map<String, String>>[];
  }

  static Future<String> getECovigDevice() async {
    List<Map<String, String>> devices = await getDevices();
    Map<String, String> device = devices.firstWhere(
        (Map<String, String> device) =>
            device["name"].toLowerCase().contains("e-covig"),
        orElse: () => null);
    if (device != null) {
      return device["address"];
    } else {
      return null;
    }
  }

  static Future<String> getBitalino() async {
    List<Map<String, String>> devices = await getDevices();
    Map<String, String> device = devices.firstWhere(
        (Map<String, String> device) =>
            device["name"].toLowerCase().contains("bitalino"),
        orElse: () => null);
    if (device != null) {
      return device["address"];
    } else {
      return null;
    }
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