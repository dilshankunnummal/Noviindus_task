import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? token;

  final String baseUrl = "https://flutter-amr.noviindus.in";

  Future<void> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    debugPrint("Starting login process...");
    notifyListeners();

    try {
      var uri = Uri.parse("$baseUrl/api/Login");
      debugPrint("API URL: $uri");

      var request = http.MultipartRequest("POST", uri);
      request.fields['username'] = username;
      request.fields['password'] = password;
      debugPrint("FormData Sent -> username: $username, password: [HIDDEN]");

      var streamedResponse = await request.send();
      debugPrint("Response Status: ${streamedResponse.statusCode}");

      var response = await http.Response.fromStream(streamedResponse);
      debugPrint("Full API Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint("Decoded JSON: $data");

        if (data["status"] == true) {
          token = data["token"];
          debugPrint("Token received successfully: $token");
        } else {
          errorMessage = data["message"] ?? "Login failed";
          debugPrint("Login failed: $errorMessage");
        }
      } else {
        errorMessage = "Server error: ${response.statusCode}";
        debugPrint(errorMessage!);
      }
    } catch (e) {
      errorMessage = "Something went wrong: $e";
      debugPrint(errorMessage!);
    }

    isLoading = false;
    debugPrint("Login process finished.");
    notifyListeners();
  }
}
