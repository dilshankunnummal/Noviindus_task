import 'package:ayurveda_patients_app/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../providers/login_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Consumer<LoginProvider>(
        builder: (context, loginProvider, _) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/part.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Login or register to book your appointments",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 30),

                  CustomTextField(
                    label: "Username",
                    hintText: "Enter your username",
                    controller: usernameController,
                  ),

                  const SizedBox(height: 20),

                  CustomTextField(
                    label: "Password",
                    hintText: "Enter your password",
                    controller: passwordController,
                    obscureText: true,
                  ),

                  const SizedBox(height: 30),

                  if (loginProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        loginProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  if (loginProvider.isLoading)
                    const CircularProgressIndicator()
                  else
                    CustomButton(
                      text: "Login",
                      onPressed: () {
                        final username = usernameController.text.trim();
                        final password = passwordController.text.trim();

                        if (username.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter username and password'),
                            ),
                          );
                          return;
                        }

                        loginProvider.login(username, password).then((_) {
                          if (loginProvider.token != null) {
                            debugPrint("Login Successful. Token: ${loginProvider.token}");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(token: loginProvider.token!),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login Successful!')),
                            );


                          } else {
                            debugPrint("Login Failed. Error: ${loginProvider.errorMessage}");
                          }
                        });
                      },
                    ),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(
                              text:
                              'By creating or logging into an account you are agreeing with our '),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy.',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
