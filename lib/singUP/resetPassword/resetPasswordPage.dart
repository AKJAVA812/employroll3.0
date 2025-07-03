import 'dart:convert';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../../sharedPrefancePage/ShardPre.dart';
import '../../themes/empThemes.dart';
import '../login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

SessionManager shared = SessionManager();
String? sessionId;
String? getEmailId;
Map<String, dynamic> mapResponse = {};
class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool isOtpRequested = false;
  bool isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool showPasswordHints = false;
  bool _obscureConfirm = true;

  final TextEditingController otpController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  FocusNode newPasswordFocusNode = FocusNode();
  final TextEditingController confirmPasswordController = TextEditingController();

  var type = "0";
  var resendKey = "0";

  Future getLogout(BuildContext buildContext) async {
    //var cameraStatus = await Permission.camera.status;
    //if(cameraStatus.isGranted) {
    //String? qrData = await scanner.scan();
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.logoutAPi;
    /*var stream = http.ByteStream(value!.openRead());
    stream.cast();*/
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "type=$type");
    var request = new http.MultipartRequest("Post", urlapi);
    http.Response response =
    await http.Response.fromStream(await request.send());
    mapResponse = json.decode(response.body);
    String reason = mapResponse['reason'];
    //String status = mapResponse['status'];
    String result = mapResponse['result'];
    print('reason $reason');
    print('reason${reason}');

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      //Navigator.pop(this.context);
      mapResponse = json.decode(response.body);
      String reason = mapResponse['reason'];
      //String status = mapResponse['status'];
      print('reason both $reason');
      //print('reason${reason}');
      if (result.compareToIgnoringCase("success") == 0) {
        print("Logout Successfully !!");
        Fluttertoast.showToast(
            msg: "Password Changed !!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        //CommonNotificationPage.showDialgSucess(this.context,reason.upperCamelCase+" ","Success");
      } else if (result.compareToIgnoringCase("error") == 0) {
        print("Logout Error !!");
        Fluttertoast.showToast(
            msg: "Logout Error !!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        //CommonNotificationPage.showDialgSucess(this.context,reason.upperCamelCase, " Error ");
      }
    }
  }

  Future<void> sendOtp(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.resetPasswordOtpSendApi;
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('$conn$apiUrl?'
        'email=${getEmailId}&'
        'resend=$resendKey');

    print("Calling API: $url");

    // Show loader
/*    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );*/

    try {
      final response = await http.post(url);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Dismiss loader
      Navigator.of(context, rootNavigator: true).pop();

      final data = json.decode(response.body);

      if (response.statusCode == 200 &&
          data['result']?.toString().toLowerCase() == 'success') {
        setState(() {
          isLoading = false;
          isOtpRequested = true;

          newPasswordFocusNode.addListener(() {
            setState(() {
              showPasswordHints = newPasswordFocusNode.hasFocus;
            });
          });
        });

        // Show success dialog
        Fluttertoast.showToast(
            msg: "OTP sent successfully !!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Mythemes.successColor,
            textColor: Colors.white,
            fontSize: 16.0
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
                    print("⚠️ Warning: No route to close.");
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

  Future<void> changePassword(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.changePasswordApi;
    final url = Uri.parse('$conn$apiUrl?'
        'email=$getEmailId&'
        'curr=${currentPasswordController.text}&'
        'newpass=${newPasswordController.text}&'
        'otp=${otpController.text}');

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
        // After success:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Success'),
                ],
              ),
              content: Text('Your password has been changed successfully.'),
              actions: [
                TextButton(
                  onPressed: () async{
                    shared.setSessionId("");
                    shared.setAdminRole(0);
                    shared.setEmpRoll(0);
                    shared.setRoRoll(0);
                    shared.setMobAction(0);
                    getLogout(this.context);
                    final service = FlutterBackgroundService();
                    var isRunning = await service.isRunning();
                    print(isRunning);
                    if (isRunning) {
                      service.invoke("stopService");
                      print("Background Stop");
                    } else {
                      service.startService();
                      print("New service Started");
                    }
                    setState(() {});
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false,
                    );
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            );
          },
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

  void requestOtp() async {
    setState(() {
      isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
      isOtpRequested = true;

      newPasswordFocusNode.addListener(() {
        setState(() {
          showPasswordHints = newPasswordFocusNode.hasFocus;
        });
      });
    });
  }

  void changePasswords() {
    // Add validation and backend logic here
    print("OTP: ${otpController.text}");
    print("Current Password: ${currentPasswordController.text}");
    print("New Password: ${newPasswordController.text}");
    print("Confirm Password: ${confirmPasswordController.text}");


    // After success:
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Success'),
            ],
          ),
          content: Text('Your password has been changed successfully.'),
          actions: [
            TextButton(
              onPressed: () async{
                shared.setSessionId("");
                shared.setAdminRole(0);
                shared.setEmpRoll(0);
                shared.setRoRoll(0);
                shared.setMobAction(0);
                getLogout(this.context);
                final service = FlutterBackgroundService();
                var isRunning = await service.isRunning();
                print(isRunning);
                if (isRunning) {
                  service.invoke("stopService");
                  print("Background Stop");
                } else {
                  service.startService();
                  print("New service Started");
                }
                setState(() {});
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreferenceList();
  }

  Future getSharedPreferenceList() async{
    sessionId = await shared!.getSessionId();
    getEmailId = await shared!.getEmailId();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            !isOtpRequested ?
            Image.asset('assets/images/otp_enter.png', height: 300) :
            Image.asset('assets/images/new_password.png', height: 200),
            const SizedBox(height: 2),
            if (!isOtpRequested) ...[
              const Text(
                'We will send a OTP to your registered email ID.',
                textAlign: TextAlign.center,
              ),
               Text(
                '$getEmailId',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ).py8(),
              ElevatedButton.icon(
                onPressed: () {
                  sendOtp(context);
                },
                icon: Icon(Icons.sms),
                label: Text('Get OTP'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],

            if (isOtpRequested) ...[
              const Text(
                'We have sent an OTP to your registered email ID.',
                textAlign: TextAlign.center,
              ),
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  prefixIcon: Icon(Icons.security),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: requestOtp,
                  child: Text('Resend OTP'),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: currentPasswordController,
                obscureText: _obscureCurrent,
                decoration: InputDecoration(
                  labelText: "Current Password",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureCurrent ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureCurrent = !_obscureCurrent;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: newPasswordController,
                focusNode: newPasswordFocusNode,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureNew = !_obscureNew;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {});
                },
              ),
              SizedBox(height: 8),
// Password Hints
              if (showPasswordHints) ...[
                passwordHintRow(
                  "Minimum 8 characters",
                  newPasswordController.text.length >= 8,
                ),
                passwordHintRow(
                  "Do not use #, \$, & in password",
                  !newPasswordController.text.contains(RegExp(r'[#\$&]')),
                ),
              ],
              SizedBox(height: 16),

              TextFormField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: "Re-enter New Password",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {});
                },
              ),

              if (confirmPasswordController.text.isNotEmpty &&
                  confirmPasswordController.text != newPasswordController.text)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    "Passwords do not match",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () {
                  changePassword(context);
                },
                icon: Icon(Icons.check_circle_outline),
                label: Text('Change Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget passwordHintRow(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            color: isValid ? Colors.green : Colors.red,
            size: 18,
          ),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isValid ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

