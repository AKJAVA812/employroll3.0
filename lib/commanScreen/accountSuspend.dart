import 'dart:async';
import 'dart:convert';
import 'package:er_flutter_project/singUP/model/loginModel.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:safe_device/safe_device.dart';
//import 'package:trust_location/trust_location.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/singUP/login_page.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/services/notification_service.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'package:er_flutter_project/themes/empThemes.dart';

import 'allAPIList.dart';

class AccountSuspendPage extends StatefulWidget {
  const AccountSuspendPage({super.key});

  @override
  _AccountSuspendPageState createState() => _AccountSuspendPageState();
}

SessionManager shared = SessionManager();

Map<String, dynamic> mapResponse = {};

late LoginModel _loginModel;
String timeString = "";
String? sessionId;

class _AccountSuspendPageState extends State<AccountSuspendPage> {
  var type = "0";

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    //print('Response snapshot: ${sessionId}');
  }

  @override
  void initState() {
    getSharedPrfanceList();
    // TODO: implement initState
    super.initState();
  }

  showLogoutPopup(BuildContext buildContext, result, alert) {
    String text = "Stop Service";
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text(alert, style: TextStyle(fontSize: 20))),
        ],
      ),
      content: Text(result, style: TextStyle(fontSize: 14)),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () async {
            await getLogout(context);
            shared.setSessionId("");
            shared.setAdminRole(0);
            shared.setEmpRoll(0);
            shared.setRoRoll(0);
            shared.setMobAction(0);
            final service = FlutterBackgroundService();
            var isRunning = await service.isRunning();
            if (isRunning) {
              service.invoke("stopService");
            }
            if (!isRunning) {
              text = 'Stop Service';
            } else {
              text = 'Start Service';
            }
            setState(() {});
            Navigator.of(buildContext, rootNavigator: true).pop();
            Navigator.pushAndRemoveUntil(
              buildContext,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false,
            );

            //Navigator.of(buildContext, rootNavigator: true).pop();
          },
          child: Container(
            child: Text("Yes", style: TextStyle(color: Mythemes.warningColor)),
          ),
        ),
      ],
      elevation: 24.0,
    );
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  Future getLogout(BuildContext buildContext) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.logoutAPi;
    final currentSessionId = await shared.getMobileSessionId();
    final accessToken = await shared.getAccessToken();
    final tokenType = await shared.getTokenType() ?? 'Bearer';
    final urlapi = Uri.parse("$conn$apiUrl");

    final response = await MobileHttpClient.instance.post(
      urlapi,
      headers: {
        if (accessToken != null && accessToken.isNotEmpty)
          'Authorization': '$tokenType $accessToken',
        if (currentSessionId != null && currentSessionId.isNotEmpty)
          'X-Mobile-Session-Id': currentSessionId,
      },
    );

    if (response.body.isNotEmpty) {
      mapResponse = json.decode(response.body);
    } else {
      mapResponse = <String, dynamic>{};
    }

    final result =
        (mapResponse['status'] ?? mapResponse['result'] ?? '').toString();
    final message =
        (mapResponse['message'] ?? mapResponse['reason'] ?? '').toString();

    if (response.statusCode == 200 &&
        result.compareToIgnoringCase('success') == 0) {
      await NotificationService.instance.deactivateCurrentToken();
      await shared.clearMobileAuth();
      Fluttertoast.showToast(
        msg: message.isNotEmpty ? message : "Logout Successfully !!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: message.isNotEmpty ? message : "Logout Error !!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  logoutApp(context) async {
    String text = "Stop Service";
    await getLogout(this.context);
    shared.setSessionId("");
    shared.setAdminRole(0);
    shared.setEmpRoll(0);
    shared.setRoRoll(0);
    shared.setMobAction(0);
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }
    if (!isRunning) {
      text = 'Stop Service';
    } else {
      text = 'Start Service';
    }
    setState(() {});
    //Navigator.of(buildContext, rootNavigator: true).pop();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
    /* showLogoutPopup(
        context, "Do You Want To Logout?".toString() + " " , "Alert");*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Mythemes.whitish,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new_outlined),
            onPressed: () {
              logoutApp(context);
            },
          ),
        ],
      ),
      backgroundColor: Mythemes.whitish, // Light grey background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              Image.network(
                'https://s3.ap-south-1.amazonaws.com/employroll.com/images/1731758641783.png', // Add your image path here
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 24),

              // Error Title
              const Text(
                "Oops !",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Error Description
              const Text(
                "Your subscription has been expired.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Employroll support for this licence has expired. Renew the subscription to keep using Employroll Service.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Retry Button
              /*SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(

                    //primary: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Retry logic here
                    print("Retry button pressed");
                  },
                  child: const Text(
                    "Retry",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
