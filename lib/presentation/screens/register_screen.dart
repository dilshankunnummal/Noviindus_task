import 'package:ayurveda_patients_app/core/app_colors.dart';
import 'package:ayurveda_patients_app/presentation/providers/register%20provider.dart';
import 'package:ayurveda_patients_app/presentation/widgets/custom_button.dart';
import 'package:ayurveda_patients_app/presentation/widgets/custom_date_picker.dart';
import 'package:ayurveda_patients_app/presentation/widgets/custom_drop_down.dart';
import 'package:ayurveda_patients_app/presentation/widgets/custom_hour_minute_picker.dart';
import 'package:ayurveda_patients_app/presentation/widgets/custom_text.dart';
import 'package:ayurveda_patients_app/presentation/widgets/custom_text_field.dart';
import 'package:ayurveda_patients_app/presentation/widgets/treatment_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/login_provider.dart';
import 'package:open_file/open_file.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final registerProvider = Provider.of<RegisterProvider>(
        context,
        listen: false,
      );

      await loginProvider.getTokenFromStorage();
      await registerProvider.fetchBranches();
      await registerProvider.fetchTreatments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: 'Register',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                hintText: 'Enter Your Name',
                label: 'Name',
                onChanged: (val) => registerProvider.name = val,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Enter Your WhatsApp Number',
                label: 'WhatsApp Number',
                keyboardType: TextInputType.phone,
                onChanged: (val) => registerProvider.phone = val,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Enter Your Address',
                label: 'Address',
                onChanged: (val) => registerProvider.address = val,
              ),
              const SizedBox(height: 10),
              CustomDropdown<String>(
                hintText: 'Select Your Location',
                label: 'Location',
                value: registerProvider.selectedLocation,
                items:
                    registerProvider.locationOptions
                        .map(
                          (loc) =>
                              DropdownMenuItem(value: loc, child: Text(loc)),
                        )
                        .toList(),
                onChanged: registerProvider.setSelectedLocation,
              ),
              const SizedBox(height: 10),
              CustomDropdown<String>(
                hintText: 'Choose Your Branch',
                label: 'Branch',
                value: registerProvider.selectedBranch,
                items:
                    registerProvider.branchOptions
                        .map(
                          (branch) => DropdownMenuItem(
                            value: branch,
                            child: Text(branch),
                          ),
                        )
                        .toList(),
                onChanged: registerProvider.setSelectedBranch,
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ListView(
                        children: registerProvider.treatmentOptions.map((treatment) {
                          if (treatment is Map<String, dynamic>) {
                            final id = treatment["id"] as int;
                            final name = treatment["name"] as String;
                            return CheckboxListTile(
                              value: registerProvider.selectedTreatmentIds.contains(id),
                              title: Text(name),
                              onChanged: (_) {
                                registerProvider.toggleTreatmentSelection(id);
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }).toList(),
                      );
                    },
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: CustomText(text: 'Treatments'),
                    ),
                    Container(
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
                                registerProvider.selectedTreatmentIds.isEmpty
                                    ? "Choose Treatments"
                                    : registerProvider.selectedTreatmentIds
                                    .map((id) => registerProvider.treatmentOptions
                                    .firstWhere((t) => t["id"] == id)["name"])
                                    .join(", "),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.arrow_drop_down, color: AppColors.textGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              TreatmentsWidget(), // If you want to keep it, else remove
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Total Amount',
                keyboardType: TextInputType.number,
                onChanged:
                    (val) =>
                        registerProvider.totalAmount =
                            double.tryParse(val) ?? 0.0,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Discount Amount',
                keyboardType: TextInputType.number,
                onChanged:
                    (val) =>
                        registerProvider.discountAmount =
                            double.tryParse(val) ?? 0.0,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: "Payment Method",
                    fontSize: 14,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Wrap(
                spacing: 60,
                runSpacing: 8,
                children: [
                  _buildPaymentOption('Cash', registerProvider),
                  _buildPaymentOption('UPI', registerProvider),
                  _buildPaymentOption('Card', registerProvider),
                ],
              ),
              CustomTextField(
                label: 'Advance Amount',
                keyboardType: TextInputType.number,
                onChanged:
                    (val) =>
                        registerProvider.advanceAmount =
                            double.tryParse(val) ?? 0.0,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Balance Amount',
                keyboardType: TextInputType.number,
                onChanged:
                    (val) =>
                        registerProvider.balanceAmount =
                            double.tryParse(val) ?? 0.0,
              ),
              const SizedBox(height: 10),
              CustomDatePicker(
                label: "Treatment Date",
                selectedDate: registerProvider.selectedDate,
                onDateSelected: registerProvider.setSelectedDate,
              ),
              const SizedBox(height: 10),
              CustomHourMinutePicker(
                label: "Treatment Time",
                selectedHour: registerProvider.selectedHour,
                selectedMinute: registerProvider.selectedMinute,
                onTimeSelected: (hour, minute) {
                  registerProvider.setSelectedHour(hour);
                  registerProvider.setSelectedMinute(minute);
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Save',
                onPressed: () async {
                  final file = await registerProvider.generatePdf(context);
                  await OpenFile.open(file.path);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PDF created')),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String value, RegisterProvider provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: provider.paymentMethod,
          activeColor: AppColors.primaryGreen,
          onChanged: (val) => provider.setPaymentMethod(val!),
        ),
        CustomText(text: value),
      ],
    );
  }
}
