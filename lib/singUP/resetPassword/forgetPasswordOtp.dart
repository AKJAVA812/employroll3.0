import 'dart:convert';
import 'package:er_flutter_project/singUP/resetPassword/forgetPasswordEmail.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/routes.dart';
import '../../themes/empThemes.dart';
import 'forgetPasswordNewCreation.dart';

class ForgotPasswordOtpPage extends StatefulWidget {
  var emailController;

  ForgotPasswordOtpPage(this.emailController);

  @override
  State<ForgotPasswordOtpPage> createState() =>
      _ForgotPasswordOtpPageState(emailController);
}

class _ForgotPasswordOtpPageState extends State<ForgotPasswordOtpPage> {
  var emailControllers;
  var otp;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailControllers = emailController;
  }

  _ForgotPasswordOtpPageState(this.emailControllers);
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  Future<void> verifyOtp(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.verifyOtpApi;
    final url = Uri.parse(
      '$conn$apiUrl?'
      'email=${emailControllers.text}&'
      'otp=${otp}',
    );

    print("Calling API: $url");

    // Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await MobileHttpClient.instance.post(url);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Dismiss loader
      Navigator.of(context, rootNavigator: true).pop();

      final data = json.decode(response.body);

      if (response.statusCode == 200 &&
          data['result']?.toString().toLowerCase() == 'success') {
        // Show success dialog
        Fluttertoast.showToast(
          msg: "OTP verified successfully !!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Mythemes.successColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ForgotPasswordResetPage(emailControllers),
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
              Image.asset('assets/images/otp_enter.png', height: 300),
              const SizedBox(height: 24),
              const Text(
                'Please enter your verification code.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'We have sent a verification code to your registered email ID.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 40,
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(
                            context,
                          ).requestFocus(focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(
                            context,
                          ).requestFocus(focusNodes[index - 1]);
                        }
                      },
                      decoration: const InputDecoration(counterText: ''),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  otp = controllers.map((c) => c.text).join();
                  if (otp.length == 6) {
                    verifyOtp(context);
                    //Navigator.pushNamed(context, MyRoutings.resetPasswordRoute);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter complete 6-digit OTP'),
                      ),
                    );
                  }
                },
                child: const Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
