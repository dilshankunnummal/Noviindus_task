// import 'package:ayurveda_patients_app/core/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'custom_text.dart';
//
// class TreatmentSelectionDialog extends StatefulWidget {
//   final dynamic registerProvider; // Your provider instance
//   final Function() onSave;
//
//   const TreatmentSelectionDialog({
//     Key? key,
//     required this.registerProvider,
//     required this.onSave,
//   }) : super(key: key);
//
//   @override
//   State<TreatmentSelectionDialog> createState() => _TreatmentSelectionDialogState();
// }
//
// class _TreatmentSelectionDialogState extends State<TreatmentSelectionDialog> {
//   int maleCount = 0;
//   int femaleCount = 0;
//
//   void _showTreatmentBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.6,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             children: [
//               // Handle bar
//               Container(
//                 margin: const EdgeInsets.only(top: 12),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               // Header
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Select Treatments',
//                       style: GoogleFonts.poppins(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.black,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.close),
//                     ),
//                   ],
//                 ),
//               ),
//               // Treatment list with checkboxes
//               Expanded(
//                 child: StatefulBuilder(
//                   builder: (context, setModalState) {
//                     return ListView(
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       children: widget.registerProvider.treatmentOptions.map<Widget>((treatment) {
//                         if (treatment is Map<String, dynamic>) {
//                           final id = treatment["id"] as int;
//                           final name = treatment["name"] as String;
//                           return CheckboxListTile(
//                             value: widget.registerProvider.selectedTreatmentIds.contains(id),
//                             title: Text(
//                               name,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                                 color: AppColors.black,
//                               ),
//                             ),
//                             activeColor: AppColors.primaryGreen,
//                             onChanged: (_) {
//                               widget.registerProvider.toggleTreatmentSelection(id);
//                               setModalState(() {}); // Update modal state
//                               setState(() {}); // Update dialog state
//                             },
//                           );
//                         } else {
//                           return const SizedBox.shrink();
//                         }
//                       }).toList(),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildCounterRow(String label, int count, VoidCallback onDecrement, VoidCallback onIncrement) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           // Label
//           Container(
//             width: 80,
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             decoration: BoxDecoration(
//               color: AppColors.textFieldBg,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: AppColors.borderGrey, width: 1),
//             ),
//             child: Text(
//               label,
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//                 color: AppColors.textGrey,
//               ),
//             ),
//           ),
//           const Spacer(),
//           // Counter controls
//           Row(
//             children: [
//               // Decrement button
//               InkWell(
//                 onTap: count > 0 ? onDecrement : null,
//                 child: Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryGreen,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.remove,
//                     color: AppColors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//               // Count display
//               Container(
//                 width: 50,
//                 height: 36,
//                 margin: const EdgeInsets.symmetric(horizontal: 8),
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.circular(4),
//                   border: Border.all(color: AppColors.borderGrey, width: 1),
//                 ),
//                 child: Center(
//                   child: Text(
//                     count.toString(),
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               // Increment button
//               InkWell(
//                 onTap: onIncrement,
//                 child: Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryGreen,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.add,
//                     color: AppColors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Container(
//         width: 350,
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title
//             Text(
//               'Choose Treatment',
//               style: GoogleFonts.poppins(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.black,
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Treatment Selection
//             InkWell(
//               onTap: _showTreatmentBottomSheet,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.only(bottom: 8.0),
//                     child: CustomText(text: 'Choose preferred treatment'),
//                   ),
//                   Container(
//                     width: double.infinity,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: AppColors.textFieldBg,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: AppColors.borderGrey, width: 1),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             child: Text(
//                               widget.registerProvider.selectedTreatmentIds.isEmpty
//                                   ? "Choose Treatments"
//                                   : widget.registerProvider.selectedTreatmentIds
//                                   .map((id) => widget.registerProvider.treatmentOptions
//                                   .firstWhere((t) => t["id"] == id)["name"])
//                                   .join(", "),
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                                 color: AppColors.textGrey,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.only(right: 8.0),
//                           child: Icon(Icons.arrow_drop_down, color: AppColors.textGrey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // Add Patients Section
//             const CustomText(text: 'Add Patients'),
//             const SizedBox(height: 16),
//
//             // Male Counter
//             _buildCounterRow(
//               'Male',
//               maleCount,
//                   () => setState(() => maleCount--),
//                   () => setState(() => maleCount++),
//             ),
//
//             // Female Counter
//             _buildCounterRow(
//               'Female',
//               femaleCount,
//                   () => setState(() => femaleCount--),
//                   () => setState(() => femaleCount++),
//             ),
//
//             const SizedBox(height: 24),
//
//             // Save Button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   widget.onSave();
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryGreen,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: Text(
//                   'Save',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
