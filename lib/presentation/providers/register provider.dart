import 'dart:convert';
import 'dart:io';

import 'package:ayurveda_patients_app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;

class RegisterProvider extends ChangeNotifier {
  int maleCount = 0;
  int femaleCount = 0;
  String paymentMethod = 'Cash';
  DateTime? selectedDate;
  int? selectedHour;
  int? selectedMinute;

  String? selectedLocation;
  String? selectedBranch;
  String? name;
  String? executive;
  String? phone;
  String? address;
  double? totalAmount;
  double? discountAmount;
  double? advanceAmount;
  double? balanceAmount;

  List<int> maleTreatmentIds = [];
  List<int> femaleTreatmentIds = [];
  List<int> selectedTreatmentIds = [];

  List<String> locationOptions = ['Location A', 'Location B', 'Location C'];
  List<String> branchOptions = [];

  List<Map<String, dynamic>> maleTreatments = [];
  List<Map<String, dynamic>> femaleTreatments = [];
  List<Map<String, dynamic>> treatmentOptions = [];

  void setSelectedLocation(String? location) {
    selectedLocation = location;
    notifyListeners();
  }

  void setSelectedBranch(String? branch) {
    selectedBranch = branch;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setSelectedHour(int hour) {
    selectedHour = hour;
    notifyListeners();
  }

  void setSelectedMinute(int minute) {
    selectedMinute = minute;
    notifyListeners();
  }

  void incrementMale() {
    maleCount++;
    notifyListeners();
  }

  void decrementMale() {
    if (maleCount > 0) {
      maleCount--;
      notifyListeners();
    }
  }

  void incrementFemale() {
    femaleCount++;
    notifyListeners();
  }

  void decrementFemale() {
    if (femaleCount > 0) {
      femaleCount--;
      notifyListeners();
    }
  }

  void toggleMaleTreatment(int id) {
    if (maleTreatmentIds.contains(id)) {
      maleTreatmentIds.remove(id);
    } else {
      maleTreatmentIds.add(id);
    }
    notifyListeners();
  }

  void toggleFemaleTreatment(int id) {
    if (femaleTreatmentIds.contains(id)) {
      femaleTreatmentIds.remove(id);
    } else {
      femaleTreatmentIds.add(id);
    }
    notifyListeners();
  }

  void toggleTreatmentSelection(int id) {
    if (selectedTreatmentIds.contains(id)) {
      selectedTreatmentIds.remove(id);
    } else {
      selectedTreatmentIds.add(id);
    }
    notifyListeners();
  }

  String get formattedDateTime {
    if (selectedDate == null ||
        selectedHour == null ||
        selectedMinute == null) {
      return "";
    }
    final date = selectedDate!;
    final time = TimeOfDay(hour: selectedHour!, minute: selectedMinute!);
    final formattedDate =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$formattedDate-$hour:$minute $period";
  }

  Future<void> fetchBranches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) return;

      final response = await http.get(
        Uri.parse('$baseUrl/BranchList'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['branches'] != null) {
          final List<dynamic> branchesData = jsonResponse['branches'];
          branchOptions = branchesData.map<String>((e) => e['name'] as String).toList();
        } else {
          branchOptions = [];
        }
        notifyListeners();
      } else {
        branchOptions = [];
        notifyListeners();
      }
    } catch (e) {
      // handle error or log
    }
  }

  Future<void> fetchTreatments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) return;

      final response = await http.get(
        Uri.parse('$baseUrl/TreatmentList'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['treatments'] != null) {
          final List<dynamic> treatmentsData = jsonResponse['treatments'];

          maleTreatments = treatmentsData
              .where((e) => e['gender'] == 'male')
              .map<Map<String, dynamic>>((e) => {"id": e['id'], "name": e['name']})
              .toList();

          femaleTreatments = treatmentsData
              .where((e) => e['gender'] == 'female')
              .map<Map<String, dynamic>>((e) => {"id": e['id'], "name": e['name']})
              .toList();

          treatmentOptions = treatmentsData
              .map<Map<String, dynamic>>((e) => {"id": e["id"], "name": e["name"]})
              .toList();
        }
        notifyListeners();
      }
    } catch (e) {
      // handle error or log
    }
  }

  Future<bool> registerPatient() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        print("No auth token found");
        return false;
      }

      const hardcodedMaleTreatments = "2,3,4";
      const hardcodedFemaleTreatments = "2,3,4";

      final body = {
        "name": name ?? "",
        "excecutive": executive ?? "no data",
        "payment": paymentMethod,
        "phone": phone ?? "",
        "address": address ?? "",
        "total_amount": (totalAmount ?? 0.0).toString(),
        "discount_amount": (discountAmount ?? 0.0).toString(),
        "advance_amount": (advanceAmount ?? 0.0).toString(),
        "balance_amount": (balanceAmount ?? 0.0).toString(),
        "date_nd_time": formattedDateTime,
        "id": "",
        "branch": selectedBranch ?? "",
        // Here send comma-separated string, because form data can't send lists
        "male": maleTreatmentIds.isNotEmpty ? maleTreatmentIds.join(",") : "",
        // Join femaleTreatmentIds list similarly
        "female": femaleTreatmentIds.isNotEmpty ? femaleTreatmentIds.join(",") : "",
        "treatments": selectedTreatmentIds.join(","),
      };

      print("Register Patient Request Body: ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse('$baseUrl/PatientUpdate'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        await generatePdf();
        return true;
      } else {
        print("Failed to register patient, status code: ${response.statusCode}");
        return false;
      }
    } catch (e, stacktrace) {
      print("Exception in registerPatient: $e");
      print("Stacktrace: $stacktrace");
      return false;
    }
  }


  Future<void> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Patient Registration',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Name: ${name ?? ''}'),
            pw.Text('Executive: ${executive ?? ''}'),
            pw.Text('Payment Method: $paymentMethod'),
            pw.Text('Phone: ${phone ?? ''}'),
            pw.Text('Address: ${address ?? ''}'),
            pw.Text('Total Amount: $totalAmount'),
            pw.Text('Discount Amount: $discountAmount'),
            pw.Text('Advance Amount: $advanceAmount'),
            pw.Text('Balance Amount: $balanceAmount'),
            pw.Text('Date & Time: $formattedDateTime'),
            pw.Text('Branch: ${selectedBranch ?? ''}'),
            pw.Text('Male Treatments: ${maleTreatmentIds.join(",")}'),
            pw.Text('Female Treatments: ${femaleTreatmentIds.join(",")}'),
            pw.Text('Treatments: ${selectedTreatmentIds.join(",")}'),
          ],
        ),
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File(
      "${output.path}/patient_registration_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
    await file.writeAsBytes(await pdf.save());
  }
}
