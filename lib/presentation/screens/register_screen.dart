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
import 'package:open_file/open_file.dart';

import '../providers/login_provider.dart';

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
      final registerProvider =
      Provider.of<RegisterProvider>(context, listen: false);

      await loginProvider.getTokenFromStorage();
      await registerProvider.fetchBranches();
      await registerProvider.fetchTreatments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.13),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                    vertical: height * 0.005,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: const Align(
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
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            children: [
              CustomTextField(
                hintText: 'Enter Your Name',
                label: 'Name',
                onChanged: (val) => registerProvider.name = val,
              ),
              SizedBox(height: height * 0.015),
              CustomTextField(
                hintText: 'Enter Your WhatsApp Number',
                label: 'WhatsApp Number',
                keyboardType: TextInputType.phone,
                onChanged: (val) => registerProvider.phone = val,
              ),
              SizedBox(height: height * 0.015),
              CustomTextField(
                hintText: 'Enter Your Address',
                label: 'Address',
                onChanged: (val) => registerProvider.address = val,
              ),
              SizedBox(height: height * 0.015),
              CustomDropdown<String>(
                hintText: 'Select Your Location',
                label: 'Location',
                value: registerProvider.selectedLocation,
                items: registerProvider.locationOptions
                    .map((loc) =>
                    DropdownMenuItem(value: loc, child: Text(loc)))
                    .toList(),
                onChanged: registerProvider.setSelectedLocation,
              ),
              SizedBox(height: height * 0.015),
              CustomDropdown<String>(
                hintText: 'Choose Your Branch',
                label: 'Branch',
                value: registerProvider.selectedBranch,
                items: registerProvider.branchOptions
                    .map((branch) => DropdownMenuItem(
                  value: branch,
                  child: Text(branch),
                ))
                    .toList(),
                onChanged: registerProvider.setSelectedBranch,
              ),
              SizedBox(height: height * 0.015),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ListView(
                        children:
                        registerProvider.treatmentOptions.map((treatment) {
                          if (treatment is Map<String, dynamic>) {
                            final id = treatment["id"] as int;
                            final name = treatment["name"] as String;
                            return CheckboxListTile(
                              value: registerProvider.selectedTreatmentIds
                                  .contains(id),
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
                      width: width * 0.9,
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        color: AppColors.textFieldBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.borderGrey, width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: width * 0.03),
                              child: Text(
                                registerProvider.selectedTreatmentIds.isEmpty
                                    ? "Choose Treatments"
                                    : registerProvider.selectedTreatmentIds
                                    .map((id) => registerProvider
                                    .treatmentOptions
                                    .firstWhere(
                                        (t) => t["id"] == id)["name"])
                                    .join(", "),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.arrow_drop_down,
                                color: AppColors.textGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.015),
              TreatmentsWidget(),
              SizedBox(height: height * 0.015),
              CustomTextField(
                label: 'Total Amount',
                keyboardType: TextInputType.number,
                onChanged: (val) =>
                registerProvider.totalAmount = double.tryParse(val) ?? 0.0,
              ),
              SizedBox(height: height * 0.015),
              CustomTextField(
                label: 'Discount Amount',
                keyboardType: TextInputType.number,
                onChanged: (val) => registerProvider.discountAmount =
                    double.tryParse(val) ?? 0.0,
              ),
              SizedBox(height: height * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: "Payment Method",
                    fontSize: 14,
                  ),
                ),
              ),
              Wrap(
                spacing: width * 0.15,
                runSpacing: height * 0.01,
                children: [
                  _buildPaymentOption('Cash', registerProvider),
                  _buildPaymentOption('UPI', registerProvider),
                  _buildPaymentOption('Card', registerProvider),
                ],
              ),
              SizedBox(height: height * 0.015),
              CustomTextField(
                label: 'Advance Amount',
                keyboardType: TextInputType.number,
                onChanged: (val) => registerProvider.advanceAmount =
                    double.tryParse(val) ?? 0.0,
              ),
              SizedBox(height: height * 0.015),
              CustomTextField(
                label: 'Balance Amount',
                keyboardType: TextInputType.number,
                onChanged: (val) => registerProvider.balanceAmount =
                    double.tryParse(val) ?? 0.0,
              ),
              SizedBox(height: height * 0.015),
              CustomDatePicker(
                label: "Treatment Date",
                selectedDate: registerProvider.selectedDate,
                onDateSelected: registerProvider.setSelectedDate,
              ),
              SizedBox(height: height * 0.015),
              CustomHourMinutePicker(
                label: "Treatment Time",
                selectedHour: registerProvider.selectedHour,
                selectedMinute: registerProvider.selectedMinute,
                onTimeSelected: (hour, minute) {
                  registerProvider.setSelectedHour(hour);
                  registerProvider.setSelectedMinute(minute);
                },
              ),
              SizedBox(height: height * 0.03),
              CustomButton(
                text: 'Save',
                onPressed: () async {
                  bool success =
                  await registerProvider.registerPatient(context);
                  final file = await registerProvider.generatePdf(context);
                  await OpenFile.open(file.path);
                  if (success) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Patient registered successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Failed to register patient')),
                    );
                  }
                },
              ),
              SizedBox(height: height * 0.03),
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
