import 'dart:convert';

import 'package:er_flutter_project/singUP/resetPassword/forgetPasswordEmail.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/singUP/resetPassword/forgetPasswordOtp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../commanScreen/allAPIList.dart';
import '../../themes/empThemes.dart';
import '../login_page.dart';
class ForgotPasswordResetPage extends StatefulWidget {
  var emailControllerNew;

  ForgotPasswordResetPage(this.emailControllerNew);

  @override
  State<ForgotPasswordResetPage> createState() => _ForgotPasswordResetPageState(
      emailControllerNew);
}

class _ForgotPasswordResetPageState extends State<ForgotPasswordResetPage> {
  bool _obscureNewPassword = true;
  bool _obscureRePassword = true;
  var emailControllersNew;
  _ForgotPasswordResetPageState(
      this.emailControllersNew);

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  String? _errorText;


  void _changePassword() {
    if (_newPasswordController.text != _rePasswordController.text) {
      setState(() {
        _errorText = 'Passwords do not match';
      });
    } else {
      setState(() {
        _errorText = null;
      });
      // Proceed with password reset logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!')),
      );
    }
  }

  Future<void> changePassword(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.resetPasswordApi;
    final url = Uri.parse('$conn$apiUrl?'
        'email=${emailControllersNew.text}&'
        'pw=${_newPasswordController.text}');

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
        /*Fluttertoast.showToast(
            msg: "OTP verified successfully !!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Mythemes.successColor,
            textColor: Colors.white,
            fontSize: 16.0
        );*/
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Success"),
            content: Text(data['reason'] ?? "Password changed successfully !!"),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    //Navigator.of(context, rootNavigator: true).pop();
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
  void dispose() {
    _newPasswordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailControllersNew = emailController;
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/new_password.png', height: 250),
              const SizedBox(height: 24),
              const Text('Please enter a new password', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 24),

              // New Password Field
              TextField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Re-enter Password Field
              TextField(
                controller: _rePasswordController,
                obscureText: _obscureRePassword,
                decoration: InputDecoration(
                  labelText: 'Re-enter Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureRePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureRePassword = !_obscureRePassword;
                      });
                    },
                  ),
                ),
              ),

              if (_errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                changePassword(context);
                },
                child: const Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}