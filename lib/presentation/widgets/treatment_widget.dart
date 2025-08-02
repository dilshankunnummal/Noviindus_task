import 'package:ayurveda_patients_app/core/app_colors.dart';
import 'package:ayurveda_patients_app/presentation/providers/register%20provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_text.dart';

class TreatmentsWidget extends StatelessWidget {
  Widget buildCounter(
      int count, {
        required VoidCallback onIncrement,
        required VoidCallback onDecrement,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      constraints: BoxConstraints(minWidth: 60, maxWidth: 90),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.remove, size: 16, color: Colors.grey[600]),
            ),
          ),
          Container(
            width: 24,
            alignment: Alignment.center,
            child: CustomText(
              text: count.toString(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.add, size: 16, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Treatments',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: CustomText(
                          text: 'Couple Combo package i..',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF6B6B),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: CustomText(
                                text: 'Male',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4CAF50),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 6),
                            buildCounter(
                              provider.maleCount,
                              onDecrement: provider.decrementMale,
                              onIncrement: provider.incrementMale,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: CustomText(
                                text: 'Female',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4CAF50),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 6),
                            buildCounter(
                              provider.femaleCount,
                              onDecrement: provider.decrementFemale,
                              onIncrement: provider.incrementFemale,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.edit, color: AppColors.primaryGreen, size: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF81C784),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  CustomText(
                    text: 'Add Treatments',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
