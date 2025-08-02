import 'dart:convert';
import 'dart:io';

import 'package:ayurveda_patients_app/core/constants.dart';
import 'package:ayurveda_patients_app/presentation/screens/pdf_viewer_screeen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
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

  Future<bool> registerPatient(BuildContext context) async {
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
        await generatePdf(context);
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

  PdfColor hexToPdfColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    final int colorInt = int.parse(hex, radix: 16);
    return PdfColor.fromInt(colorInt);
  }

  Future<File> generatePdf(BuildContext context) async {
    final pdf = pw.Document();
    final greenColor = hexToPdfColor('#4CAF50');
    final greyColor = hexToPdfColor('#999999');
    final lightGreyColor = hexToPdfColor('#F5F5F5');

    final registerProvider = Provider.of<RegisterProvider>(context, listen: false);

    final bookedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final bookedTime = DateFormat('hh:mm a').format(DateTime.now());
    final treatmentDate = registerProvider.selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(registerProvider.selectedDate!)
        : 'N/A';
    final treatmentTime =
        '${registerProvider.selectedHour.toString().padLeft(2, '0')}:${registerProvider.selectedMinute.toString().padLeft(2, '0')} am';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Text(
                      'KUMARAKOM',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Cheepunkal P.O. Kumarakom, kottayam, Kerala - 686563',
                      style: pw.TextStyle(fontSize: 10, color: greyColor),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'e-mail: unknown@gmail.com',
                      style: pw.TextStyle(fontSize: 10, color: greyColor),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Mob: +91 9876543210 | +91 9876543210',
                      style: pw.TextStyle(fontSize: 10, color: greyColor),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'GST No: 32AABCU9603R1ZW',
                      style: pw.TextStyle(fontSize: 10, color: greyColor),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 40),
            pw.Container(
              width: double.infinity,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Patient Details',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: greenColor,
                    ),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Name', registerProvider.name ?? 'N/A', greyColor),
                            pw.SizedBox(height: 12),
                            _buildDetailRow('Address', registerProvider.address ?? 'N/A', greyColor),
                            pw.SizedBox(height: 12),
                            _buildDetailRow('WhatsApp Number', registerProvider.phone ?? 'N/A', greyColor),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 40),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Booked On', '$bookedDate | $bookedTime', greyColor),
                            pw.SizedBox(height: 12),
                            _buildDetailRow('Treatment Date', treatmentDate, greyColor),
                            pw.SizedBox(height: 12),
                            _buildDetailRow('Treatment Time', treatmentTime, greyColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Text(
              'Treatment',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: greenColor,
              ),
            ),
            pw.SizedBox(height: 15),
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
              ),
              child: pw.Column(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: pw.BoxDecoration(
                      color: lightGreyColor,
                      border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Expanded(flex: 3, child: _buildHeaderText('Treatment')),
                        pw.Expanded(flex: 1, child: _buildHeaderText('Price')),
                        pw.Expanded(flex: 1, child: _buildHeaderText('Male')),
                        pw.Expanded(flex: 1, child: _buildHeaderText('Female')),
                        pw.Expanded(flex: 1, child: _buildHeaderText('Total')),
                      ],
                    ),
                  ),
                  ...registerProvider.selectedTreatmentIds.asMap().entries.map((entry) {
                    final index = entry.key;
                    final id = entry.value;
                    final treatment = registerProvider.treatmentOptions
                        .firstWhere((t) => t["id"] == id);
                    final price = (treatment["price"] ?? 0) as num;
                    final maleCount = registerProvider.maleCount;
                    final femaleCount = registerProvider.femaleCount;
                    final totalPrice = price * (maleCount + femaleCount);

                    return pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: pw.BoxDecoration(
                        color: index % 2 == 0 ? PdfColors.white : PdfColors.grey50,
                        border: index < registerProvider.selectedTreatmentIds.length - 1
                            ? pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5))
                            : null,
                      ),
                      child: pw.Row(
                        children: [
                          pw.Expanded(flex: 3, child: _buildCellText(treatment["name"])),
                          pw.Expanded(flex: 1, child: _buildCellText('Rs $price')),
                          pw.Expanded(flex: 1, child: _buildCellText('$maleCount')),
                          pw.Expanded(flex: 1, child: _buildCellText('$femaleCount')),
                          pw.Expanded(flex: 1, child: _buildCellText('Rs $totalPrice')),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 250,
                child: pw.Column(
                  children: [
                    _buildAmountRow('Total Amount', 'Rs ${registerProvider.totalAmount}', greyColor),
                    pw.SizedBox(height: 8),
                    _buildAmountRow('Discount', 'Rs ${registerProvider.discountAmount}', greyColor),
                    pw.SizedBox(height: 8),
                    _buildAmountRow('Advance', 'Rs ${registerProvider.advanceAmount}', greyColor),
                    pw.SizedBox(height: 12),
                    pw.Divider(color: PdfColors.grey400),
                    pw.SizedBox(height: 8),
                    _buildAmountRow('Balance', 'Rs ${registerProvider.balanceAmount}', null,
                        bold: true, fontSize: 16),
                  ],
                ),
              ),
            ),
            pw.Spacer(),
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'Thank you for choosing us',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: greenColor,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Your well-being is our commitment, and we\'re honored',
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: greyColor,
                    ),
                  ),
                  pw.Text(
                    'you\'ve entrusted us with your health journey',
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: greyColor,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    width: 120,
                    height: 40,
                    child: pw.CustomPaint(
                      painter: (PdfGraphics canvas, PdfPoint size) {
                        canvas.setStrokeColor(PdfColors.black);
                        canvas.setLineWidth(1.5);
                        canvas.strokePath();
                      },
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Text(
                '"Booking amount is non-refundable, and it\'s important to arrive on the allotted time for your treatment"',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: greyColor,
                  fontStyle: pw.FontStyle.italic,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final fileName = "medical_invoice_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final filePath = "${output.path}/$fileName";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return file;
  }

// Helper methods
  pw.Widget _buildDetailRow(String label, String value, PdfColor greyColor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            color: greyColor,
            fontWeight: pw.FontWeight.normal,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildHeaderText(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.black,
      ),
    );
  }

  pw.Widget _buildCellText(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 12,
        color: PdfColors.black,
      ),
    );
  }

  pw.Widget _buildAmountRow(String label, String value, PdfColor? color,
      {bool bold = false, double fontSize = 12}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color ?? PdfColors.black,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color ?? PdfColors.black,
          ),
        ),
      ],
    );
  }






}
