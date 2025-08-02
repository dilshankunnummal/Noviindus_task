import 'package:ayurveda_patients_app/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../providers/register provider.dart';

class CustomHourMinutePicker extends StatelessWidget {
  final String? label;
  final int? selectedHour;
  final int? selectedMinute;
  final void Function(int hour, int minute)? onTimeSelected;

  const CustomHourMinutePicker({
    super.key,
    this.label,
    this.selectedHour,
    this.selectedMinute,
    this.onTimeSelected,
  });

  Future<void> _pickTime(BuildContext context) async {
    final provider = Provider.of<RegisterProvider>(context, listen: false);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: selectedHour ?? provider.selectedHour ?? TimeOfDay.now().hour,
        minute: selectedMinute ?? provider.selectedMinute ?? 0,
      ),
    );
    if (picked != null) {
      if (onTimeSelected != null) {
        onTimeSelected!(picked.hour, picked.minute);
      } else {
        provider.setSelectedHour(picked.hour);
        provider.setSelectedMinute(picked.minute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterProvider>(context);
    final displayHour = selectedHour ?? provider.selectedHour;
    final displayMinute = selectedMinute ?? provider.selectedMinute;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CustomText(
                text: label!,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickTime(context),
                  child: Container(
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
                              displayHour != null
                                  ? displayHour.toString().padLeft(2, '0')
                                  : "Hour",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: displayHour != null
                                    ? AppColors.textBlack
                                    : AppColors.textGrey,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: AppColors.primaryGreen,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickTime(context),
                  child: Container(
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
                              displayMinute != null
                                  ? displayMinute.toString().padLeft(2, '0')
                                  : "Minute",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: displayMinute != null
                                    ? AppColors.textBlack
                                    : AppColors.textGrey,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: AppColors.primaryGreen,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
