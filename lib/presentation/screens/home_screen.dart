import 'package:ayurveda_patients_app/core/app_colors.dart';
import 'package:ayurveda_patients_app/presentation/screens/register_screen.dart';
import 'package:ayurveda_patients_app/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import '../widgets/booking_card.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientProvider = context.read<PatientProvider>();
      patientProvider.token = widget.token;
      patientProvider.fetchPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.25),
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none,
                            color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.01,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(width * 0.02),
                            border:
                            Border.all(color: Colors.grey.shade400, width: 1),
                          ),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "Search...",
                              hintStyle: GoogleFonts.poppins(
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: const Icon(Icons.search,
                                  color: Colors.grey),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.grey),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {});
                                },
                              )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: height * 0.017,
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.03),
                      Container(
                        height: height * 0.06,
                        width: width * 0.25,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(width * 0.02),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Search',
                            color: Colors.white,
                            fontSize: width * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.012),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: width * 0.03),
                          child: CustomText(
                            text: 'Sort by:',
                            fontWeight: FontWeight.w500,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.04),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03,
                          vertical: height * 0.012,
                        ),
                        decoration: BoxDecoration(
                          border:
                          Border.all(color: Colors.grey.shade400, width: 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Select Date",
                              style: GoogleFonts.poppins(
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: width * 0.01),
                            const Icon(Icons.keyboard_arrow_down,
                                color: AppColors.primaryGreen),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<PatientProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          final filteredPatients = provider.patients.where((patient) {
            final searchText = searchController.text.toLowerCase();
            return patient.name.toLowerCase().contains(searchText);
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              await provider.fetchPatients();
            },
            child: filteredPatients.isEmpty
                ? ListView(
              children: [
                SizedBox(height: height * 0.4),
                const Center(child: Text('No patients found.')),
              ],
            )
                : ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = filteredPatients[index];
                return BookingCard(
                  customerName: patient.name,
                  packageName: patient.branchName ?? "No package",
                  date: patient.dateTime ?? "No date",
                  bookedBy: patient.treatmentName ?? "N/A",
                  onViewDetails: () {},
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(width * 0.04),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: height * 0.06,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.02),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ),
              );
            },
            child: CustomText(
              text: 'Register Patient',
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: width * 0.04,
            ),
          ),
        ),
      ),
    );
  }
}
