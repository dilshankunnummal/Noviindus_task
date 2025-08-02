import 'package:ayurveda_patients_app/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String hintText;
  final FormFieldValidator<T>? validator;

  const CustomDropdown({
    super.key,
    this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CustomText(text: label!),
          ),
        Container(
          width: 350,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.textFieldBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderGrey, width: 1),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textGrey,
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textBlack,
            ),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryGreen,),
            iconSize: 34,
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}
