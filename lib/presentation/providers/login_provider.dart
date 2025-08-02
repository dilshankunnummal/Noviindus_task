import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? token;

  final String baseUrl = "https://flutter-amr.noviindus.in";

  Future<void> saveToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', value);
    debugPrint("Token saved to storage");
    token = value;
    notifyListeners();
  }

  Future<void> getTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');
    debugPrint("Loaded token: $token");
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      var uri = Uri.parse("$baseUrl/api/Login");
      var request = http.MultipartRequest("POST", uri);
      request.fields['username'] = username;
      request.fields['password'] = password;

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["status"] == true) {
          await saveToken(data["token"]);
        } else {
          errorMessage = data["message"] ?? "Login failed";
        }
      } else {
        errorMessage = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "Something went wrong: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}
