import 'package:flutter/material.dart';
import '../../commanScreen/routes.dart';

class ForgotPasswordOtpPage extends StatelessWidget {
  ForgotPasswordOtpPage({super.key});

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());

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
                          FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(focusNodes[index - 1]);
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
                  String otp = controllers.map((c) => c.text).join();
                  if (otp.length == 6) {
                    Navigator.pushNamed(context, MyRoutings.resetPasswordRoute);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter complete 6-digit OTP')),
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