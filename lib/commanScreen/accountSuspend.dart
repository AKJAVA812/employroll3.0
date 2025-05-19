import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/ProjectListPage.dart';
import 'package:er_flutter_project/commanScreen/punchInUploadPage.dart';
import 'package:er_flutter_project/commanScreen/recognization_page.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/commanScreen/skyDecorWorkDone.dart';
import 'package:er_flutter_project/commanScreen/workDonePage.dart';
import 'package:er_flutter_project/commanScreen/ujalaCreditWorkdone.dart';
import 'package:er_flutter_project/modules/helpDesk/helpdeskItem/helpdeskItem.dart';
import 'package:er_flutter_project/profiles/profilePage.dart';
import 'package:er_flutter_project/singUP/model/loginModel.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ntp/ntp.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:safe_device/safe_device.dart';
//import 'package:trust_location/trust_location.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/singUP/login_page.dart';
import 'package:er_flutter_project/widgets/drawer_file.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/adminPage/adminDashboard/adminDashboard.dart';
import '../adminPage/modelClass/dashboardModel.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';

import 'allAPIList.dart';
import 'commanNotificationPage.dart';
import 'digiWeighWorkDone.dart';

class AccountSuspendPage extends StatefulWidget {
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
    sessionId = await shared!.getSessionId();
    //print('Response snapshot: ${sessionId}');
  }

  @override
  void initState() {
    getSharedPrfanceList();
    // TODO: implement initState
    super.initState();
  }

  showLogoutPopup(BuildContext buildContext, result,alert) {
    String text = "Stop Service";
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text( alert, style: TextStyle(
              fontSize: 20
          ),)),
        ],
      ),
      content: Text(result , style: TextStyle(
          fontSize: 14
      )),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
            onPressed: () async {
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
              child: Text("Yes", style: TextStyle(color: Mythemes.warningColor),),
            )
        ),

      ],
      elevation: 24.0,
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future getLogout(BuildContext buildContext) async{
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
    print("Request - $request");
    http.Response response = await http.Response.fromStream(await request.send());
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
      if(result.compareToIgnoringCase("success")==0){
        print("Logout Successfully !!");
        Fluttertoast.showToast(
            msg: "Logout Successfully !!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        //CommonNotificationPage.showDialgSucess(this.context,reason.upperCamelCase+" ","Success");
      }else if(result.compareToIgnoringCase("error")==0){
        print("Logout Error !!");
        Fluttertoast.showToast(
            msg: "Logout Error !!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        //CommonNotificationPage.showDialgSucess(this.context,reason.upperCamelCase, " Error ");
      }

    }
    //print("Heloo Bharat  $qrData");
    /*CommonNotificationPage.showWorkDoneSuccess(
            context,
            "$qrData"
                .upperCamelCase +
                " ",
            "Successfully Punch $clockingType");*/

    /*else {
        var isGrant = await Permission.camera.request();
        if(isGrant.isGranted){
          String? qrData = await scanner.scan();
          print(qrData);
        }
      }*/


  }
  logoutApp(context) async {
    String text = "Stop Service";
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
              })
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
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
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