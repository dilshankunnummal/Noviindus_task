import 'dart:convert';
import 'package:ayurveda_patients_app/data/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PatientProvider extends ChangeNotifier {
  List<Patient> patients = [];
  bool isLoading = false;
  String? errorMessage;

  String baseUrl = "https://flutter-amr.noviindus.in/api";
  String? token;

  Future<void> fetchPatients() async {
    if (token == null) {
      errorMessage = "No token found";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/PatientList"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          patients = (data['patient'] as List)
              .map((p) => Patient.fromJson(p))
              .toList();
          errorMessage = null;
        } else {
          errorMessage = data['message'] ?? "Failed to fetch patients";
        }
      } else {
        errorMessage = "Error ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
