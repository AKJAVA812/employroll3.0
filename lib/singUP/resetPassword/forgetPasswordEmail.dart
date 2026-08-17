import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../commanScreen/allAPIList.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';

import '../../themes/empThemes.dart';
import 'forgetPasswordOtp.dart';

class ForgotPasswordEmailPage extends StatefulWidget {
  const ForgotPasswordEmailPage({super.key});

  @override
  State<ForgotPasswordEmailPage> createState() =>
      _ForgotPasswordEmailPageState();
}

TextEditingController emailController = TextEditingController();

class _ForgotPasswordEmailPageState extends State<ForgotPasswordEmailPage> {
  Future<void> sendOtp(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.otpSendApi;
    final url = Uri.parse('$conn$apiUrl?email=${emailController.text}');


    // Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await MobileHttpClient.instance.post(url);

      // Dismiss loader
      Navigator.of(context, rootNavigator: true).pop();

      final data = json.decode(response.body);

      if (response.statusCode == 200 &&
          data['result']?.toString().toLowerCase() == 'success') {
        // Show success dialog
        Fluttertoast.showToast(
          msg: "OTP sent successfully !!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Mythemes.successColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ForgotPasswordOtpPage(emailController.text),
          ),
        );

        /*showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Success"),
            content: Text(data['reason'] ?? "OTP sent successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  } else {
                    print("âš ï¸ Warning: No route to close.");
                  }
                },
                child: const Text("OK"),
              )
            ],
          ),
        );*/
      } else {
        // Show error dialog from response
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Error"),
                content: Text(data['reason'] ?? "Something went wrong"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
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
        builder:
            (context) => AlertDialog(
              title: const Text("Error"),
              content: Text("Failed to send OTP. Error: $e"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
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
