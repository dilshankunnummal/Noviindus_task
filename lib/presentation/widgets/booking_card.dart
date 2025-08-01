import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../widgets/custom_text.dart';

class BookingCard extends StatelessWidget {
  final String customerName;
  final String packageName;
  final String date;
  final String bookedBy;
  final VoidCallback? onViewDetails;
  final int? index;

  const BookingCard({
    Key? key,
    required this.customerName,
    required this.packageName,
    required this.date,
    required this.bookedBy,
    this.onViewDetails,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (index != null)
                      CustomText(
                        text: '${index! + 1}. ',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    Expanded(
                      child: CustomText(
                        text: customerName,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomText(
                  text: packageName,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.teal[700],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(
                      width: 140, // Fixed width for date
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.orange[600],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: CustomText(
                              text: date.isNotEmpty ? date : "-",
                              fontSize: 13,
                              color: Colors.grey[600],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 140, // Fixed width for bookedBy
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.orange[600],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: CustomText(
                              text: bookedBy.isNotEmpty ? bookedBy : "-",
                              fontSize: 13,
                              color: Colors.grey[600],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
          InkWell(
            onTap: onViewDetails,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'View Booking details',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.primaryGreen,
                    size: 20,
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
