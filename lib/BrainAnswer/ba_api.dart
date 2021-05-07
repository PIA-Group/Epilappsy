import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity/connectivity.dart';
import 'package:epilappsy/Authentication/user.dart';
import 'package:epilappsy/BrainAnswer/api_key.dart';
import 'package:epilappsy/BrainAnswer/form_data.dart';
import 'package:epilappsy/BrainAnswer/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const TIMEOUT_IN_SECONDS = 10;
const TIMEOUT_UPLOAD_IN_SECONDS = 20;

class BAApi {

  static final String apiKey = APIKey.apiKey;

  static Future<bool> isLoggedIn() async {
    return (await getLocalLoginToken()) != null;
  }

  static Future<String> getLocalLoginToken() async {
    String token = await SharedPref.read("loginToken");
    print('LOGIN TOKEN: $token');
    return token;
  }

  static Future<String> getEmail() async {
    return await SharedPref.read("email");
  }

  static Future<String> getName() async {
    return await SharedPref.read("userName");
  }

  static void rememberUsername(String username) {
    SharedPref.save("loginUsername", username);
  }

  static Future<String> getUsername() async {
    return await SharedPref.read("loginUsername");
  }

  static void forgetUsername() {
    SharedPref.remove("loginUsername");
  }

  static Future<String> login(String user, String password) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'api-key': apiKey,
    };

    Map<String, String> params = {
      'email': user,
      'password': password,
    };
    String query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    try {
      http.Response res = await http
          .get(Uri.parse('https://app.brainanswer.pt/api/client/user/login?$query'),
              headers: headers)
          .timeout(Duration(seconds: TIMEOUT_IN_SECONDS));
      if (res.statusCode != 200) {
        debugPrint('http.get error: statusCode= ${res.statusCode}');
        throw Exception;
      } else {
        if (res.body == null || res.body.isEmpty) {
          throw Exception;
        } else {
          Map<String, dynamic> info = decode(res.bodyBytes);
          String loginToken = info["login_token"];
          if (loginToken == null) throw Exception;
          SharedPref.save("loginToken", loginToken);
          User user = User(info["name"], info["email"], info["role"]);
          SharedPref.saveUser(user);
          return loginToken;
        }
      }
    } on SocketException catch (e) {
      debugPrint(e.toString());
      throw 1; // no internet
    } on TimeoutException catch (e) {
      debugPrint(e.toString());
      throw 2; // timeout
    } catch (e) {
      debugPrint(e.toString());
      throw -1; // error
    }
  }

  static Future<String> loginToken(String loginToken) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'api-key': apiKey,
    };

    Map<String, String> params = {
      'token': loginToken,
    };
    String query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    try {
      print("loginQR");
      http.Response res = await http
          .get(
            Uri.parse('https://app.brainanswer.pt/api/client/user/loginTokenGeneral?$query'),
            headers: headers,
          )
          .timeout(Duration(seconds: TIMEOUT_IN_SECONDS));
      print("got here");
      if (res.statusCode != 200) {
        debugPrint('http.get error: statusCode= ${res.statusCode}');
        throw Exception;
      } else {
        Map<String, dynamic> info = decode(res.bodyBytes);
        print(info);
        String loginToken = info["login_token"];
        if (loginToken == null) throw Exception;
        SharedPref.save("loginToken", loginToken);
        User user = User(
            info["name"],
            info["email"] != "" ? info["email"] : info["username"],
            info["role"]);
        SharedPref.saveUser(user);
        return loginToken;
      }
    } on SocketException catch (e) {
      debugPrint(e.toString());
      throw e; // no internet
    } catch (e) {
      return null;
    }
  }

  static Future<void> logout() async {
    await SharedPref.remove("loginToken");
  }

  static Future<List<Map<String, dynamic>>> getStations(String loginToken) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'api-key': apiKey,
    };

    Map<String, String> params = {
      'token': loginToken,
    };
    String query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    try {
      http.Response res = await http
          .get(
            Uri.parse('https://app.brainanswer.pt/api/client/user/loginToken?$query'),
            headers: headers,
          )
          .timeout(
            Duration(seconds: TIMEOUT_IN_SECONDS),
          );
      if (res.statusCode != 200) {
        debugPrint('http.get error: statusCode= ${res.statusCode}');
        return null;
      } else {
        return List<Map<String, dynamic>>.from(
            decode(res.bodyBytes)["stations"]);
      }
    } on SocketException catch (e) {
      debugPrint(e.toString());
      throw 1; // no internet
    } on TimeoutException catch (e) {
      debugPrint(e.toString());
      throw 2; // timeout
    } catch (e) {
      debugPrint(e.toString());
      throw -1; // error
    }
  }

  static Future<dynamic> getStudies(String idStation, String loginToken) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'login-token': loginToken,
      'api-key': apiKey,
    };

    Map<String, String> params = {
      'id_station': idStation,
    };
    String query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    try {
      final http.Response res = await http
          .get(Uri.parse('https://app.brainanswer.pt/api/client/study/list?$query'),
              headers: headers)
          .timeout(Duration(seconds: TIMEOUT_IN_SECONDS));
      if (res.statusCode != 200) {
        debugPrint('http.get error: statusCode= ${res.statusCode}');
        return null;
      } else {
        return List<Map<String, dynamic>>.from(
            decode(res.bodyBytes)["studies"]);
      }
    } on SocketException catch (e) {
      debugPrint(e.toString());
      throw 1; // no internet
    } on TimeoutException catch (e) {
      debugPrint(e.toString());
      throw 2; // timeout
    } catch (e) {
      debugPrint(e.toString());
      throw -1; // error
    }
  }

  static Future<String> getSessionToken(String idStation, String loginToken) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'login-token': loginToken,
      'api-key': apiKey,
    };

    Map<String, String> params = {
      'id_station': idStation,
    };
    String query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    try {
      http.Response res = await http
          .get(Uri.parse('https://app.brainanswer.pt/api/client/study/list?$query'),
              headers: headers)
          .timeout(Duration(seconds: TIMEOUT_IN_SECONDS));
      if (res.statusCode != 200) {
        debugPrint('http.get error: statusCode= ${res.statusCode}');
        throw Exception;
      } else {
        return decode(res.bodyBytes)["studies"][2]["token"];
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<Map<String, dynamic>> createSession(
      String sessionToken, String loginToken) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'login-token': loginToken,
      'api-key': apiKey,
    };

    try {
      http.Response res = await http
          .get(
              Uri.parse('https://app.brainanswer.pt/api/client/session/get/$sessionToken'),
              headers: headers)
          .timeout(Duration(seconds: TIMEOUT_IN_SECONDS));
      if (res.statusCode != 200) {
        debugPrint('http.get error: statusCode= ${res.statusCode}');
        throw Exception;
      } else {
        return decode(res.bodyBytes);
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<bool> completeSession(String sessionToken, String loginToken) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'login-token': loginToken,
      'api-key': apiKey,
    };

    try {
      http.Response res = await http
          .post(
              Uri.parse('https://app.brainanswer.pt/api/client/session/setComplete/$sessionToken'),
              headers: headers)
          .timeout(Duration(seconds: TIMEOUT_IN_SECONDS));
      if (res.statusCode == 200) {
        return true;
      } else {
        debugPrint('http.post error: statusCode= ${res.statusCode}');
        throw Exception;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<bool> uploadFile(String filepath, String url) async {
    try {
      http.MultipartRequest request =
          new http.MultipartRequest("POST", Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath('file', filepath,
            filename: filepath.split("/").last),
      );
      http.StreamedResponse response = await request
          .send()
          .timeout(Duration(seconds: TIMEOUT_UPLOAD_IN_SECONDS));
      debugPrint(response.statusCode.toString());
      return response.statusCode == 200;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // DOESN'T WORK - BRAIN ANSWER PROBLEM
  static Future<bool> uploadFiles(List<String> filepaths, String url) async {
    try {
      http.MultipartRequest request =
          new http.MultipartRequest("POST", Uri.parse(url));

      for (int i = 0; i < filepaths.length; i++) {
        File file = File(filepaths[i]);
        request.files.add(
          http.MultipartFile(
              'file', http.ByteStream(file.openRead()), await file.length(),
              filename: filepaths[i].split("/").last),
        );
      }

      http.StreamedResponse response = await request
          .send()
          .timeout(Duration(seconds: TIMEOUT_UPLOAD_IN_SECONDS));
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<FormData> getForm(
      {@required String loginToken, @required String idForm}) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'api-key': apiKey,
      'login-token': loginToken,
    };

    try {
      http.Response res = await http
          .get(Uri.parse('https://app.brainanswer.pt/api/form/get/$idForm'),
              headers: headers)
          .timeout(Duration(seconds: TIMEOUT_IN_SECONDS));
      if (res.statusCode == 200) {
        return FormData.fromMap(decode(res.bodyBytes));
      } else {
        debugPrint('http.post error: statusCode= ${res.statusCode}');
        throw Exception;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
 // ver pipeline em session.dart submitForm para enviar  
  static Future<bool> formSetStarted( //initializes 
      {@required String sessionToken,
      @required String loginToken,
      @required String idForm,
      @required String formToken,
      @required DateTime start,
      String repeatCicle}) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'login-token': loginToken,
      'api-key': apiKey,
    };

    Map<String, String> params = {
      'id_form': idForm,
      'token': formToken,
      'datetime_start': start.millisecondsSinceEpoch.toString(),
      'session_token': sessionToken,
    };

    params.addAll({
      "repeat_cicle": repeatCicle ?? "",
    });
    String query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    try {
      http.Response res = await http
          .post(Uri.parse('https://app.brainanswer.pt/api/form/setStarted?$query'),
              headers: headers)
          .timeout(Duration(seconds: TIMEOUT_IN_SECONDS));
      if (res.statusCode == 200) {
        if (res.body.isEmpty) return false;
        return true;
      } else {
        debugPrint('http.post error: statusCode= ${res.statusCode}');
        throw Exception;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<bool> formSaveResult(
      {@required String sessionToken,
      @required String loginToken,
      @required List<dynamic> fields,
      @required String idForm,
      @required String formToken,
      @required DateTime start,
      @required DateTime end,
      String repeatCicle,
      List<dynamic> templateFields}) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'login-token': loginToken,
      'api-key': apiKey,
    };

    Map<String, String> params = {
      'id_form': idForm,
      'token': formToken,
      'session_token': sessionToken,
      'datetime_start': start.millisecondsSinceEpoch.toString(),
      'datetime_end': end.millisecondsSinceEpoch.toString(),
      'fields_json': jsonEncode(
        List<String>.from(
          fields.map(
            (value) => value.toString(),
          ),
        ),
      ),
    };
    params.addAll({
      "repeat_cicle": repeatCicle ?? "",
      "form_templates_fields_json": jsonEncode(templateFields) ?? "",
    });

    String query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    try {
      http.Response res = await http
          .post(Uri.parse('https://app.brainanswer.pt/api/form/saveResult?$query'),
              headers: headers)
          .timeout(Duration(seconds: TIMEOUT_IN_SECONDS));
      if (res.statusCode == 200) {
        if (res.body.isEmpty) return false;
        return true;
      } else {
        debugPrint('http.post error: statusCode= ${res.statusCode}');
        throw Exception;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<bool> checkConnectivity() async {
    return ((await (Connectivity().checkConnectivity())) !=
        ConnectivityResult.none);
  }

  static Map<String, dynamic> decode(Uint8List bytes) {
    return Map<String, dynamic>.from(json.decode(utf8.decode(bytes)));
  }
}