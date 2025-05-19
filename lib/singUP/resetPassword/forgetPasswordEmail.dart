import 'dart:convert';

import 'package:flutter/material.dart';
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/routes.dart';
import 'package:http/http.dart' as http;

import '../login_page.dart';

class ForgotPasswordEmailPage extends StatefulWidget {
  const ForgotPasswordEmailPage({super.key});

  @override
  State<ForgotPasswordEmailPage> createState() => _ForgotPasswordEmailPageState();
}
TextEditingController emailController = new TextEditingController();

class _ForgotPasswordEmailPageState extends State<ForgotPasswordEmailPage> {

  Future<void> sendOtp(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.otpSendApi;
    final url = Uri.parse('$conn$apiUrl?email=${emailController.text}');

    print("Calling API: $url");

    // Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http.post(url);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Dismiss loader
      Navigator.of(context, rootNavigator: true).pop();

      final data = json.decode(response.body);

      if (response.statusCode == 200 &&
          data['result']?.toString().toLowerCase() == 'success') {
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Success"),
            content: Text(data['reason'] ?? "OTP sent successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) { // ✅ Using `context` inside the builder
                    Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  } else {
                    print("⚠️ Warning: No route to close.");
                  }
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      } else {
        // Show error dialog from response
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(data['reason'] ?? "Something went wrong"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    } catch (e) {
      // Dismiss loader if exception occurs
      Navigator.of(context, rootNavigator: true).pop();

      // Show exception error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to send OTP. Error: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Forgot Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Image.asset('assets/images/reset_password_otp.png', height: 150),
              const SizedBox(height: 54),
              const Text(
                'Please enter your registered email ID.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'We will send a verification code to your registered email ID.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'example@gmail.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  sendOtp(context);
                  //Navigator.pushNamed(context, MyRoutings.forgetPasswordOtpRoute);

                },
                child: const Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}