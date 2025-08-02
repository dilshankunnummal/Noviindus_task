import 'package:ayurveda_patients_app/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../providers/register provider.dart';

class CustomDatePicker extends StatelessWidget {
  final String? label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected; // <-- Added

  const CustomDatePicker({
    super.key,
    this.label,
    this.selectedDate,
    this.onDateSelected, // <-- Added
  });

  Future<void> _pickDate(BuildContext context) async {
    final provider = Provider.of<RegisterProvider>(context, listen: false);
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? provider.selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (onDateSelected != null) {
        onDateSelected!(picked);
      } else {
        provider.setSelectedDate(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterProvider>(context);
    final dateToDisplay = selectedDate ?? provider.selectedDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CustomText(text: label!),
          ),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            width: 350,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.textFieldBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGrey, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      dateToDisplay != null
                          ? "${dateToDisplay.day}/${dateToDisplay.month}/${dateToDisplay.year}"
                          : "Select Date",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: dateToDisplay != null
                            ? AppColors.textBlack
                            : AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
