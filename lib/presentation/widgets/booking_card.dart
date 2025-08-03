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
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: width * 0.02,
      ),
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
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (index != null)
                      CustomText(
                        text: '${index! + 1}. ',
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    Expanded(
                      child: CustomText(
                        text: customerName,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.02),
                CustomText(
                  text: packageName,
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Colors.teal[700],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: width * 0.03),
                Wrap(
                  spacing: width * 0.05,
                  runSpacing: width * 0.02,
                  children: [
                    SizedBox(
                      width: width * 0.38,
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: width * 0.04,
                            color: Colors.orange[600],
                          ),
                          SizedBox(width: width * 0.015),
                          Expanded(
                            child: CustomText(
                              text: date.isNotEmpty ? date : "-",
                              fontSize: width * 0.032,
                              color: Colors.grey[600],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.38,
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: width * 0.04,
                            color: Colors.orange[600],
                          ),
                          SizedBox(width: width * 0.015),
                          Expanded(
                            child: CustomText(
                              text: bookedBy.isNotEmpty ? bookedBy : "-",
                              fontSize: width * 0.032,
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
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: width * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'View Booking details',
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.primaryGreen,
                    size: width * 0.05,
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
