// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
//
// class PdfGenerator {
//   static Future<File> generateMedicalInvoice({
//     required String? name,
//     required String? executive,
//     required String paymentMethod,
//     required String? phone,
//     required String? address,
//     required String? totalAmount,
//     required String? discountAmount,
//     required String? advanceAmount,
//     required String? balanceAmount,
//     required String formattedDateTime,
//     required String? selectedBranch,
//     required List<String> maleTreatmentIds,
//     required List<String> femaleTreatmentIds,
//     required List<String> selectedTreatmentIds,
//     List<Map<String, dynamic>>? treatmentDetails, // Optional detailed treatment data
//   }) async {
//     print("Starting PDF generation...");
//
//     final pdf = pw.Document();
//
//     // Define colors
//     final greenColor = PdfColor.fromHex('#4CAF50');
//     final lightGreenColor = PdfColor.fromHex('#E8F5E8');
//     final greyColor = PdfColor.fromHex('#666666');
//     final darkGreyColor = PdfColor.fromHex('#333333');
//
//     print("Adding page content...");
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(20),
//         build: (context) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 // Logo and Company Info
//                 pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     // Logo placeholder (you can add actual logo here)
//                     pw.Container(
//                       width: 50,
//                       height: 50,
//                       decoration: pw.BoxDecoration(
//                         color: greenColor,
//                         borderRadius: pw.BorderRadius.circular(25),
//                       ),
//                       child: pw.Center(
//                         child: pw.Text(
//                           'K',
//                           style: pw.TextStyle(
//                             color: PdfColors.white,
//                             fontSize: 24,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     pw.SizedBox(height: 10),
//                     pw.Text(
//                       'KUMARAKOM',
//                       style: pw.TextStyle(
//                         fontSize: 16,
//                         fontWeight: pw.FontWeight.bold,
//                         color: darkGreyColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 // Contact Information
//                 pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.end,
//                   children: [
//                     pw.Text(
//                       'Contact Information',
//                       style: pw.TextStyle(
//                         fontSize: 12,
//                         fontWeight: pw.FontWeight.bold,
//                         color: darkGreyColor,
//                       ),
//                     ),
//                     pw.SizedBox(height: 5),
//                     pw.Text(
//                       'email: kumarakom@gmail.com',
//                       style: pw.TextStyle(fontSize: 10, color: greyColor),
//                     ),
//                     pw.Text(
//                       'Phone: +91 9876543210 / +91 8765432109',
//                       style: pw.TextStyle(fontSize: 10, color: greyColor),
//                     ),
//                     pw.Text(
//                       'GST No: 32AABCU9603R1ZN',
//                       style: pw.TextStyle(fontSize: 10, color: greyColor),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//             pw.SizedBox(height: 30),
//
//             // Patient Details Section
//             pw.Container(
//               width: double.infinity,
//               decoration: pw.BoxDecoration(
//                 color: lightGreenColor,
//                 borderRadius: pw.BorderRadius.circular(8),
//               ),
//               padding: const pw.EdgeInsets.all(15),
//               child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text(
//                     'Patient Details',
//                     style: pw.TextStyle(
//                       fontSize: 16,
//                       fontWeight: pw.FontWeight.bold,
//                       color: greenColor,
//                     ),
//                   ),
//                   pw.SizedBox(height: 15),
//                   pw.Row(
//                     children: [
//                       pw.Expanded(
//                         child: pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             _buildDetailRow('Name', name ?? 'N/A'),
//                             pw.SizedBox(height: 12),
//                             _buildDetailRow('Address', address ?? 'N/A'),
//                             pw.SizedBox(height: 12),
//                             _buildDetailRow('WhatsApp Number', phone ?? 'N/A'),
//                           ],
//                         ),
//                       ),
//                       pw.SizedBox(width: 40),
//                       pw.Expanded(
//                         child: pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             _buildDetailRow('Booked On', formattedDateTime),
//                             pw.SizedBox(height: 12),
//                             _buildDetailRow('Treatment Date', formattedDateTime),
//                             pw.SizedBox(height: 12),
//                             _buildDetailRow('Treatment Time', '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             pw.SizedBox(height: 30),
//
//             // Treatment Section Header
//             pw.Text(
//               'Treatment',
//               style: pw.TextStyle(
//                 fontSize: 16,
//                 fontWeight: pw.FontWeight.bold,
//                 color: greenColor,
//               ),
//             ),
//             pw.SizedBox(height: 15),
//
//             // Treatment Table
//             _buildTreatmentTable(treatmentDetails, selectedTreatmentIds, maleTreatmentIds, femaleTreatmentIds),
//
//             pw.SizedBox(height: 25),
//
//             // Totals Section
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.end,
//               children: [
//                 pw.Container(
//                   width: 250,
//                   child: pw.Column(
//                     children: [
//                       _buildTotalRow('Total Amount', '₹${totalAmount ?? '7620'}'),
//                       pw.SizedBox(height: 8),
//                       _buildTotalRow('Discount', '₹${discountAmount ?? '500'}'),
//                       pw.SizedBox(height: 8),
//                       _buildTotalRow('Advance', '₹${advanceAmount ?? '1500'}'),
//                       pw.SizedBox(height: 15),
//                       pw.Container(
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(top: pw.BorderSide(color: PdfColors.grey, width: 1)),
//                         ),
//                         padding: const pw.EdgeInsets.only(top: 10),
//                         child: pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text(
//                               'Balance',
//                               style: pw.TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: pw.FontWeight.bold,
//                                 color: darkGreyColor,
//                               ),
//                             ),
//                             pw.Text(
//                               '₹${balanceAmount ?? '5620'}',
//                               style: pw.TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: pw.FontWeight.bold,
//                                 color: greenColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             pw.Spacer(),
//
//             // Thank you message
//             pw.Center(
//               child: pw.Text(
//                 'Thank you for choosing us',
//                 style: pw.TextStyle(
//                   fontSize: 18,
//                   color: greenColor,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//             ),
//
//             pw.SizedBox(height: 40),
//
//             // Signature Section
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.end,
//               children: [
//                 pw.Column(
//                   children: [
//                     pw.Container(
//                       width: 120,
//                       height: 50,
//                       child: pw.CustomPaint(
//                         painter: (canvas, size) {
//                           // You can add actual signature image here
//                           // canvas.drawLine(
//                           //    PdfPoint(0, 40),
//                           //   const PdfPoint(120, 40),
//                           //   const PdfPen(PdfColors.grey, 1),
//                           // );
//                         },
//                       ),
//                     ),
//                     pw.Text(
//                       'Signature',
//                       style: pw.TextStyle(
//                         fontSize: 10,
//                         color: greyColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//
//     print("Preparing to save PDF...");
//     final output = await getApplicationDocumentsDirectory();
//     print("Documents directory path: ${output.path}");
//
//     final fileName = "medical_invoice_${DateTime.now().millisecondsSinceEpoch}.pdf";
//     final filePath = "${output.path}/$fileName";
//     final file = File(filePath);
//
//     print("Writing PDF bytes to file: $filePath");
//     final pdfBytes = await pdf.save();
//     await file.writeAsBytes(pdfBytes);
//
//     print("PDF saved successfully: $filePath (size: ${pdfBytes.length} bytes)");
//
//     return file;
//   }
//
//   // Helper method to build detail rows in patient section
//   static pw.Widget _buildDetailRow(String label, String value) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           label,
//           style: pw.TextStyle(
//             fontSize: 10,
//             color: PdfColor.fromHex('#666666'),
//           ),
//         ),
//         pw.SizedBox(height: 3),
//         pw.Text(
//           value,
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//             color: PdfColor.fromHex('#333333'),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Helper method to build total rows
//   static pw.Widget _buildTotalRow(String label, String amount) {
//     return pw.Row(
//       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//       children: [
//         pw.Text(
//           label,
//           style: pw.TextStyle(
//             fontSize: 12,
//             color: PdfColor.fromHex('#333333'),
//           ),
//         ),
//         pw.Text(
//           amount,
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//             color: PdfColor.fromHex('#333333'),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Helper method to build treatment table
//   static pw.Widget _buildTreatmentTable(
//       List<Map<String, dynamic>>? treatmentDetails,
//       List<String> selectedTreatmentIds,
//       List<String> maleTreatmentIds,
//       List<String> femaleTreatmentIds,
//       ) {
//     // Default sample data if no treatment details provided
//     final treatments = treatmentDetails ?? [
//       {'name': 'Panchakarma', 'price': '₹930', 'male': '4', 'female': '4', 'total': '₹2,540'},
//       {'name': 'Navarakizhi Treatment', 'price': '₹230', 'male': '4', 'female': '4', 'total': '₹2,540'},
//       {'name': 'Panchakarma', 'price': '₹930', 'male': '4', 'female': '4', 'total': '₹2,540'},
//     ];
//
//     return pw.Table(
//       border: pw.TableBorder.all(color: PdfColors.grey300),
//       columnWidths: {
//         0: const pw.FlexColumnWidth(3),
//         1: const pw.FlexColumnWidth(1),
//         2: const pw.FlexColumnWidth(1),
//         3: const pw.FlexColumnWidth(1),
//         4: const pw.FlexColumnWidth(1),
//       },
//       children: [
//         // Header Row
//         pw.TableRow(
//           decoration: const pw.BoxDecoration(color: PdfColors.grey100),
//           children: [
//             _buildTableCell('Treatment', isHeader: true),
//             _buildTableCell('Price', isHeader: true),
//             _buildTableCell('Male', isHeader: true),
//             _buildTableCell('Female', isHeader: true),
//             _buildTableCell('Total', isHeader: true),
//           ],
//         ),
//         // Data Rows
//         ...treatments.map((treatment) => pw.TableRow(
//           children: [
//             _buildTableCell(treatment['name'] ?? 'N/A'),
//             _buildTableCell(treatment['price'] ?? '₹0'),
//             _buildTableCell(treatment['male'] ?? '0'),
//             _buildTableCell(treatment['female'] ?? '0'),
//             _buildTableCell(treatment['total'] ?? '₹0'),
//           ],
//         )).toList(),
//       ],
//     );
//   }
//
//   // Helper method to build table cells
//   static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
//     return pw.Container(
//       padding: const pw.EdgeInsets.all(8),
//       child: pw.Text(
//         text,
//         style: pw.TextStyle(
//           fontSize: isHeader ? 12 : 11,
//           fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
//           color: PdfColor.fromHex(isHeader ? '#333333' : '#555555'),
//         ),
//       ),
//     );
//   }
// }
//
// // Extension class for easy usage
// extension PdfGeneratorExtension on BuildContext {
//   Future<File> generateMedicalInvoicePdf({
//     required String? name,
//     required String? executive,
//     required String paymentMethod,
//     required String? phone,
//     required String? address,
//     required String? totalAmount,
//     required String? discountAmount,
//     required String? advanceAmount,
//     required String? balanceAmount,
//     required String formattedDateTime,
//     required String? selectedBranch,
//     required List<String> maleTreatmentIds,
//     required List<String> femaleTreatmentIds,
//     required List<String> selectedTreatmentIds,
//     List<Map<String, dynamic>>? treatmentDetails,
//   }) {
//     return PdfGenerator.generateMedicalInvoice(
//       name: name,
//       executive: executive,
//       paymentMethod: paymentMethod,
//       phone: phone,
//       address: address,
//       totalAmount: totalAmount,
//       discountAmount: discountAmount,
//       advanceAmount: advanceAmount,
//       balanceAmount: balanceAmount,
//       formattedDateTime: formattedDateTime,
//       selectedBranch: selectedBranch,
//       maleTreatmentIds: maleTreatmentIds,
//       femaleTreatmentIds: femaleTreatmentIds,
//       selectedTreatmentIds: selectedTreatmentIds,
//       treatmentDetails: treatmentDetails,
//     );
//   }
// }