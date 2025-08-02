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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        icon: const Icon(Icons.notifications_none, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "Search...",
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.close, color: Colors.grey),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {});
                                },
                              )
                                  : null,
                              border: InputBorder.none,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                            ),
                            onChanged: (val) {
                              setState(() {}); // update UI on search text change
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 50,
                        width: 92,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Search',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: CustomText(
                            text: 'Sort by:',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Select Date",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 4),
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
                ? ListView( // Required for pull-to-refresh to work when list is empty
              children: const [
                SizedBox(height: 300),
                Center(child: Text('No patients found.')),
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
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterScreen(),
                ),
              );
            },
            child: CustomText(
              text: 'Register Patient',
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
