import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

import 'package:er_flutter_project/commanScreen/accountSuspend.dart';
import 'package:er_flutter_project/singUP/resetPassword/forgetPasswordEmail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/singUP/model/loginFaild.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../adminPage/adminPanelScreen.dart';
import '../commanScreen/allAPIList.dart';
import '../commanScreen/commanNotificationPage.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../commanScreen/routes.dart';
import '../firebasePushNotification/firebase_api.dart';
import '../main.dart';
import '../sharedPrefancePage/ShardPre.dart';
import '../sharedPrefancePage/shared_preference_helper.dart';
import '../themes/empThemes.dart';
import 'model/adminLoginModal.dart';
import 'model/loginModel.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}
int? empRole;
int? roRole;
int? adminRole;
int? adminRoleChcker;
int? adminlength;
int? empLength;
int? roLength;
String? levelOne;
String? levelTwo;
String? claimLevelOne;
String? claimLevelTwo;
String? claimLevelThree;
String? preOnboardShow;
String? exitShow;
String? myTeamShow;
String? exitResignationListShow;
String? exitResignationApproveL1Show;
String? exitResignationApproveL2Show;
String? exitResignationDisApproveL1Show;
String? exitResignationDisApproveL2Show;
String? loanApprovalL1Show;
String? loanApprovalL2Show;
String? loanApprovalL3Show;
String? pendingLeaveRequisitions;
bool accountExpired = false;

String appName = "";
String packageName = "";
String version = "";
String buildNumber = "";

String? fcmToken;
class _LoginPageState extends State<LoginPage> {
  String name = "";
  bool changeButton = false;
  bool _showPassword = true;
  LoginModel? loginModelglobal;
  AdminLoginModal? adminLoginModalGlobal;
  late BuildContext buildContext;
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  late Box passwordChange;
  SessionManager shared = SessionManager();
  Map<String, dynamic> mapResponse = {};
  var loginValidation = "";
  String? sessionId = "";

  final _formkey = GlobalKey<FormState>();

  moveToHome() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });
      await (Future.delayed(Duration(seconds: 3)));
      // await Navigator.pushNamed(context, MyRoutes.homeRoute);
      /*setState(() {
        changeButton = false;
      });*/
    }
  }

  Future<void> getAppVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version; // e.g. 1.0.0
    buildNumber = packageInfo.buildNumber; // e.g. 1

    print("App Name: $appName");
    print("Package Name: $packageName");
    print("Version: $version");
    print("Build Number: $buildNumber");
    shared.setAppVersion(version);
  }

  final loading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CircularProgressIndicator(),
      Text(" Login ... Please wait")
    ],
  );

  var attAction;
  var mobileActions;
  var mobileTrackTime;
  var geofenceActive;

  var profileName;
  var userPanel;
  var profileId;
  var defaultProfile;
  var startPayCycle;
  var endPayCycle;
  Future<LoginModel> monthAttendance(String emailId, String password) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.login;
    changeButton = true;
    LoginModel loginModel;
    LoginFaild loginFaild;
    /*var urlapi = Uri.parse("$conn$apiUrl?"
        "userName=$emailId&password=$password");*/
    var urlapi = Uri.parse(
        "$conn$apiUrl?userName=${Uri.encodeComponent(emailId)}&password=${Uri.encodeComponent(password)}"
    );
    /*var urlapi = Uri.parse(
        "http://www.employroll.com/restful/service/login?userName=$emailId&password=$password");*/
    /*  final response= await http.get(urlapi,headers: {
      "email": emailId,
      "password": password
    });*/
    /* empRole= await shared.getEmpRoll();
    roRole= await shared.getRoRole();
    adminRole= await shared.getAdminRole();
    print('EmpRoleChecks $empRole');
    print('roRole $roRole');
    print('adminRole $adminRole');*/
    final response = await http.get(urlapi);
    print('Response status: ${response.request}');
    print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    if(response.statusCode == 500) {
      Fluttertoast.showToast(
          msg: "Please check your internet connection.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        changeButton = false;
      });
    }
    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];

    print('response data $getData');
    var result = getData['reason'];
    if (result != null) {
      //print('response reason $result');
      showDialgErro(buildContext, result);
    }
    var getEmpData = mapResponse['data']['empRole'];
    var getRoData = mapResponse['data']['roRole'];
    var getAdminData = mapResponse['data']['adminrole'];


    setState(() {
      empLength = getEmpData.length;
      roLength = getRoData.length;
      adminlength = getAdminData.length;
    });

    try {
      if (response.statusCode == 200) {
        setState(() {
          print("My APP Version - $version");
          accountExpired = mapResponse['data']['expired'] ?? false;
          print("Account Expired - $accountExpired");

          if (accountExpired == true) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AccountSuspendPage()));
          } else {
            // call shared prefs loader AFTER login
            getSharedPrfanceList();
            SharedPrefHelper.clearApiCacheOnLogin();

            if (empLength == 1 || roLength == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
            } else if (adminlength == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminPanelScreen()));
            }
          }
        });
      } else {
        Fluttertoast.showToast(
            msg: "Please check your internet connection.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        //print('response {$loginValidation.toString()}');
        //print('response {$loginValidation[result]');
        //print('response {$loginValidation[reason]');
      }

    } catch (e) {
      //print('response error $e.tostring()');
    }

    //print('response Emp data $getEmpData');
    //print('response Ro data $getRoData');
    //print('response Emp data $empLength');
    //print('response Emp data $roLength');
    //print('Response body: ${mapResponse}');
    //print(stringResponse);
    /*loginFaild = LoginFaild.fromJson(mapResponse);
    print('response Login ${loginFaild.data!.reason}');*/
    loginModel = LoginModel.fromJson(mapResponse);



    // shared?.setSessionId(loginModel!.data!.sessionId);
    // getSharedPrfanceList();
    return loginModel;
  }

  Future<AdminLoginModal> adminPanel(String emailId, String password) async {
    AdminLoginModal adminLoginModal;
    var urlapi = Uri.parse(
        "http://www.employroll.com/restful/service/login?userName=$emailId&password=$password");

    final response = await http.get(urlapi);
    print('URL: ${response.request}');
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    var getAdminData = mapResponse['data']['adminrole'];

    setState(() {
      adminlength = getAdminData.length;

    });

    //print('response Admin data $getAdminData');
    //print('response Admin data $adminlength');
    //print('response data $getData');
    var result = getData['reason'];
    if (result != null) {
      print('response reason $result');
      showDialgErro(buildContext, result);
    }
    //print('Response body: ${mapResponse}');
    //print(stringResponse);
    /*loginFaild = LoginFaild.fromJson(mapResponse);
    print('response Login ${loginFaild.data!.reason}');*/
    adminLoginModal = AdminLoginModal.fromJson(mapResponse);
    try {
      if (response.statusCode == 200) {
        setState(() {
          //print('response Login ${loginModel.data!.sessionId}');
          //print('response {$loginValidation.toString()}');
          /*accountExpired = mapResponse['data']['expired'];
          print("Account Expired - $accountExpired");
          if(accountExpired == false) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AccountSuspendPage()));
          } else {

          }*/
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminPanelScreen()));
        });
      } else {
        //print('response {$loginValidation.toString()}');
        //print('response {$loginValidation[result]');
        //print('response {$loginValidation[reason]');
      }
    } catch (e) {
      //print('response error $e.tostring()');
    }

    // shared?.setSessionId(loginModel!.data!.sessionId);
    // getSharedPrfanceList();
    return adminLoginModal;
  }

  Future getSharedPrfanceList() async {
    /*  PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    print('App Version $version');
    if(version == "2.2.8") {
      CommonNotificationPage.showWorkDoneSuccess(
          context, "Your mobile timing is not updated, please change time settings", "Info ");
    }*/
    sessionId = await shared.getSessionId();
    userPanel = await shared.getUserPanel();
    //fcmToken = await NotificationService.getToken();
    print("User Panel - $userPanel");
    setState(() {
    });
    levelOne =await shared.getLevelOne();
    levelTwo =await shared.getLevelTwo();
    empLength=await shared.getEmpRoll();
    roLength=await shared.getRoRole();
    adminlength=await shared.getAdminRole();

    claimLevelOne = await shared.getClaimLevelOne();
    claimLevelTwo = await shared.getClaimLevelTwo();
    claimLevelThree = await shared.getClaimLevelThree();


    if (sessionId != null && sessionId != "") {
      setState(() {
        //print('response Login ${loginModel.data!.sessionId}');
        //print('response {$loginValidation.toString()}');

        print('response user $sessionId');
        print('response user $empLength');
        print('response user $roLength');
        print('response user admin $adminlength');
        print('response user1 $levelOne');
        print('response user2 $levelTwo');
      /*  accountExpired = mapResponse['data']['expired'] ?? false;
        //accountExpired = mapResponse['data']['expired'];
        print("Account Expired - $accountExpired");
        if(accountExpired == true) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AccountSuspendPage()));
        } else {

        }*/
        if (mapResponse != null && mapResponse['data'] != null) {
          accountExpired = mapResponse['data']['expired'] ?? false;
          print("Account Expired - $accountExpired");
          if (accountExpired == true) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AccountSuspendPage()));
          }
        } else {
          if(empLength == 1 || roLength == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
          }
          else if(adminlength == 1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AdminPanelScreen()));
          }
        }



        /*else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
        }*/

      });
    }
    //print('Response snapshot login: ${sessionId}');

    getAppVersionInfo();

  }

  void showUpdateDialog(BuildContext context) {
    final isAndroid = Platform.isAndroid;
    final storeUrl = isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.employroll.employroll' // ✅ Replace with your Play Store URL
        : 'https://apps.apple.com/in/app/employroll-2-0/id1664350846'; // ✅ Replace with your App Store ID

    final message = isAndroid
        ? 'A new version of the app is available on the Play Store. Please update your app to continue.'
        : 'A new version of the app is available on the App Store. Please update your app to continue.';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Update Available'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () async {
              if (await canLaunchUrl(Uri.parse(storeUrl))) {
                launchUrl(Uri.parse(storeUrl), mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open store.')));
              }
            },
            child: Text('Update Now'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    levelOne = "false";
    levelTwo = "false";
    pendingLeaveRequisitions = "false";
    getSharedPrfanceList();
    setState(() {

    });

    createIdpass();
    //checkLoginOrNot();
  }

  void getCredentials() async {
    if (passwordChange.get("email") != null) {
      _username.text = passwordChange.get("email");
    }
    if (passwordChange.get("pass") != null) {
      _password.text = passwordChange.get("pass");
    }
  }
  String text = "Start Service";
  void createIdpass() async {
    //Table name mention here
    passwordChange = await Hive.openBox("SavePass");
    getCredentials();
  }

  Future<void> sendGeoFenceId(String sessionId, String geofenceTokenId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.firebaseApiSend;
    try {
      // Build the URL
      var urlapi = Uri.parse(
          "$conn$apiUrl?sessionId=$sessionId&"
              "firebaseId=$fcmToken"
      );

      print("Geofence URL: $urlapi");

      // Send POST request
      final response = await http.post(urlapi);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print("Success: $jsonResponse");
      } else {
        print("Failed with status: ${response.statusCode}");
        print("Response body: ${response.body}");

        // Retry logic (similar to your Android code)
        //await sendGeoFenceId(sessionId, geofenceTokenId);
      }
    } catch (e) {
      print("Error sending GeoFence ID: $e");

      // Retry on error
      //await sendGeoFenceId(sessionId, geofenceTokenId);
    }
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    //print(name);
    return MaterialApp(
      color: Colors.white,
      home: Scaffold(
        body: Form(
          key: _formkey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 120,
                      ),
                      Image.asset(
                        "assets/images/employroll_logo_flutter_login_page.png",
                        height: 150,
                        width: 190,
                      ),
                      SizedBox(
                        height: 0.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 32.0),
                        child: AutofillGroup(
                          child: Column(children: [
                            TextFormField(
                              enableSuggestions: true,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: [AutofillHints.username],
                              controller: _username,
                              decoration: InputDecoration(
                                prefixIcon: Icon(CupertinoIcons.profile_circled, size: 20, color: Mythemes.black,),
                                  hintText: "Enter User Name ",
                                  labelText: "UserName"),
                              onChanged: (value) {
                                name = value;
                                setState(() {});
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "UserName can not be Null";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              autofillHints: [AutofillHints.password],
                              keyboardType: TextInputType.text,
                              controller: _password,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.security, size: 20, color: Mythemes.black,),
                                  suffixIcon: IconButton(
                                    icon: Icon(_showPassword
                                        ? CupertinoIcons.eye_fill
                                        : CupertinoIcons.eye_slash_fill, size: 20,),
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                  ),
                                  hintText: "Enter Password Name ",
                                  labelText: "Password"),
                              obscureText: _showPassword,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password can not be Null";
                                } else if (value.length < 6) {
                                  return "Password length shoud be 6 charcter";
                                }
                                return null;
                              },
                            ),
                            InkWell(
                              onTap: () {
                                //Navigator.pushNamed(context, MyRoutings.forgetPasswordEmailRoute);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPasswordEmailPage()));
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text("Forget Password? ",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 13,
                                    )),
                              ).py4(),
                            ),
                            SizedBox(
                              height: 80,
                            ),
                            SizedBox(
                              height: 50,
                              width: changeButton ? 50 : 180,
                              child: Material(
                                elevation: 5,
                                color: Mythemes.lightBluishColor,
                                borderRadius:
                                BorderRadius.circular(changeButton ? 150 : 20),
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      changeButton = true;
                                    });
                                    bool internetCheck =
                                    await InternetConnectionChecker()
                                        .hasConnection;
                                    if (internetCheck == false) {
                                      setState(() {
                                        AlertDialog(
                                          content:
                                          "Please check your internet connection."
                                              .text
                                              .make(),
                                        );
                                        Fluttertoast.showToast(
                                            msg:
                                            "Please check your Internet connection.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM_RIGHT,
                                            timeInSecForIosWeb: 4,
                                            backgroundColor: Mythemes.black,
                                            textColor: Colors.white,
                                            fontSize: 17.0);
                                      });
                                    } else {

                                      //FlutterBackgroundService().invoke('setAsForeground');
                                      //FlutterBackgroundService().startService();
                                      setState(() {
                                      });
                                      changeButton =true;
                                      moveToHome();
                                      if (_username != null &&
                                          _password != null) {
                                        saveLoginCredentials();

                                        setState(() {
                                          changeButton = true;
                                          Future<LoginModel> logaa =
                                          monthAttendance(
                                              _username.text.toString(),
                                              _password.text.toString());
                                          logaa.then((value) {
                                            //print('loginbuttonclick$value');
                                            loginModelglobal = value;
                                            value.data!.sessionId;
                                            print('session id ${value.data!.sessionId}');
                                            shared.setAdminRole(value.data!.adminrole!.length);
                                            shared.setMobAction(value.data!.mobAction!.length);
                                            shared.setEmpRoll(value.data!.empRole!.length);
                                            shared.setRoRoll(value.data!.roRole!.length);
                                            shared.setShowPayroll(loginModelglobal!.data!.userLoginned!.showPayroll);
                                            //sendGeoFenceId(value.data!.sessionId!, fcmToken!);
                                            if(adminRole==1){
                                              setAdminSharedPrefValue(loginModelglobal);
                                            }else{
                                              setSharedPrefanceValue(loginModelglobal);
                                            }
                                          });
                                        });
                                      }
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(seconds: 2),
                                    width: changeButton ? 50 : 150,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: changeButton
                                        ?  Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CircularProgressIndicator(color: Mythemes.whitish,),
                                    )
                                        : Text(
                                      "Sign In",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  void showDialgErro(BuildContext buildContext, result) {
    var alertDialog = AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning),
          Text("   Alert Dialog "),
        ],
      ),
      content: Text(result),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            print('response11 ${result}');
            setState(() {
              changeButton = false;
            });
          },
          child: Text("Ok"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void setSharedPrefanceValue(LoginModel? loginModelglobal) {
    setState(() {
      shared.setSessionId(loginModelglobal!.data!.sessionId!);
      print("MY NEW SESSION - ${shared.getSessionId}");
      shared.setDept(loginModelglobal!.data!.department);
      shared.setName(loginModelglobal!.data!.userLoginned!.name);
      shared.setProfileImage(loginModelglobal!.data!.userImage);
      shared.setOrgId(loginModelglobal!.data!.orgId);
      shared.setEmailid(loginModelglobal!.data!.userLoginned!.userId);
      shared.setDob(loginModelglobal!.data!.dob);
      shared.setMobileNo(loginModelglobal!.data!.contact);
      shared.setDesignation(loginModelglobal!.data!.designation);
      shared.setBranch(loginModelglobal!.data!.branch);
      shared.setAadhar(loginModelglobal!.data!.aadharNo);
      shared.setPfNo(loginModelglobal!.data!.pfNo);
      shared.setEsicNo(loginModelglobal!.data!.esicNo);
      shared.setBankName(loginModelglobal!.data!.bankName);
      shared.setBankAcc(loginModelglobal!.data!.bankAccNo);
      shared.setIfscCode(loginModelglobal!.data!.ifscCode);
      shared.setEmpId(loginModelglobal!.data!.empId);
      shared.setUserType(loginModelglobal!.data!.userLoginned!.userType);

      shared.setUserPanel(loginModelglobal!.data!.userPanel);
      userPanel = loginModelglobal!.data!.userPanel;
      shared.setEnrollId(loginModelglobal!.data!.enrollId);

      if(loginModelglobal!.data!.startDate == null) {
        startPayCycle = "0";
        shared.setPayCycleStart(startPayCycle);
        print("If Null Show 0 - $startPayCycle");
      } else {
        startPayCycle = loginModelglobal!.data!.startDate;
        shared.setPayCycleStart(startPayCycle);
        print("Else Show value - $startPayCycle");
      }
      if(loginModelglobal!.data!.endDate == null) {
        endPayCycle = "0";
        shared.setPayCycleEnd(endPayCycle);
        print("If Null Show 0 - $endPayCycle");
      } else {
        endPayCycle = loginModelglobal!.data!.endDate;
        shared.setPayCycleEnd(endPayCycle);
        print("Else Show value - $startPayCycle");
      }


    });

    print("Check User Panel - $userPanel");
    setState(() {

    });


    shared.setEmpRoll(loginModelglobal!.data!.empRole!.length);
    shared.setMobAction(loginModelglobal!.data!.mobAction!.length);
    shared.setDoj(loginModelglobal!.data!.doj);
    shared.setShowPayroll(loginModelglobal!.data!.userLoginned!.showPayroll);
    shared.setEmpCode(loginModelglobal!.data!.empCode);

    var mobAction = loginModelglobal!.data!.mobAction!.length;
    /*shared.setUserRoles(loginModelglobal!.data!.userRoles![0]);
    print(loginModelglobal!.data!.userRoles![0]);*/



    print('mobActionCheck $mobAction');
    var empRole;
    empRole = loginModelglobal!.data!.empRole!.length;
    print('empRoleChecker $empRole');
    shared.setRoRoll(loginModelglobal!.data!.roRole!.length);
    var roRole;
    roRole = loginModelglobal!.data!.roRole!.length;
    print('roRole $roRole');
    shared.setAdminRole(loginModelglobal!.data!.adminrole!.length);

    adminRoleChcker = loginModelglobal!.data!.adminrole!.length;
    print('adminRolesCheckss $adminRoleChcker');
    for(int i=0; i<loginModelglobal!.data!.mobAction!.length;i++){
      geofenceActive = shared.setGeofenceActive(loginModelglobal!.data!.mobAction![i].geofenceActive);
      attAction = shared.setAttAction(loginModelglobal!.data!.mobAction![i].attAction);
      mobileActions = shared.setMobAttAction(loginModelglobal!.data!.mobAction![i].mobAction);
      mobileTrackTime = shared.setMobTrackTime(loginModelglobal!.data!.mobAction![i].time);
      print('attActionSet $attAction');
      print('MobActionSet $mobileActions');
      print('MobTrackTime $mobileTrackTime');
      print('Geofence Active $geofenceActive');
    }

    /*for(int i=0; i<loginModelglobal!.data!.profileList!.length;i++){
      profileName = loginModelglobal!.data!.profileList![i].profileName;
      profileId = loginModelglobal!.data!.profileList![i].profileId;
      defaultProfile = loginModelglobal!.data!.profileList![i].defaultProfile;

      if (defaultProfile == true || loginModelglobal!.data!.profileList![i].isDefaultProfile == true) {
        String profileNameNew = '${loginModelglobal!.data!.profileList![i].profileName}';
        dynamic profileIdNew = loginModelglobal!.data!.profileList![i].profileId;
          shared.setDefaultProfileName(profileNameNew);
          shared.setDefaultProfileId(profileIdNew);
      }

      print('Profile Name $profileName');
      print('Profile Id $profileId');
      print('Default Profile $defaultProfile');
    }*/
    if (userPanel == "COMPANY_EMPLOYEE") {
      // Clear profile ID and name in SharedPreferences
       shared.setDefaultProfileName('');
       shared.setDefaultProfileId(0); // or '' if you're treating it as a String
    } else {
      // Loop through profiles and save default one
      for (int i = 0; i < loginModelglobal!.data!.profileList!.length; i++) {
        profileName = loginModelglobal!.data!.profileList![i].profileName;
        profileId = loginModelglobal!.data!.profileList![i].profileId;
        defaultProfile = loginModelglobal!.data!.profileList![i].defaultProfile;

        if (defaultProfile == true || loginModelglobal!.data!.profileList![i].isDefaultProfile == true) {
          String profileNameNew = loginModelglobal!.data!.profileList![i].profileName ?? '';
          dynamic profileIdNew = loginModelglobal!.data!.profileList![i].profileId;
          shared.setDefaultProfileName(profileNameNew);
          shared.setDefaultProfileId(profileIdNew);

          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD")) {
            print("resopnse LEVEL_ONE_LEAVE_APPROVE_ADD");
            //levelOne = "true";
            shared.setLevelOne("true");
          } else {
            print("resopnse LEVEL_ONE_LEAVE_APPROVE_ADD");
            //levelOne = "false";
            shared.setLevelOne("false");
          }

          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("FINAL_LEVEL_LEAVE_APPROVE_MYTEAM_ADD")) {
            print("resopnse LEVEL_TWO_LEAVE_APPROVE_ADD");
            //levelTwo = "true";
            shared.setLevelTwo("true");
          } else {
            print("resopnse LEVEL_TWO_LEAVE_APPROVE_ADD");
            //levelTwo = "false";
            shared.setLevelTwo("false");
          }
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD")) {
            print("resopnse LEAVE_REQ_APPROVAL_ADD");
            //pendingLeaveRequisitions = "true";
            shared.setPendingLeaveReq("true");
          }
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW")) {
            print("resopnse CLAIM_APPROVAL_LEVEL_ONE_VIEW");
            //claimLevelOne = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
            shared.setClaimLevelOne("CLAIM_APPROVAL_LEVEL_ONE_VIEW");
          } else {
            print("claimLevelOne else");
            //claimLevelOne = "";
            shared.setClaimLevelOne("");
          }
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW")) {
            print("resopnse CLAIM_APPROVAL_LEVEL_TWO_VIEW");
            //claimLevelTwo = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
            shared.setClaimLevelTwo("CLAIM_APPROVAL_LEVEL_TWO_VIEW");
          } else {
            print("claimLevelTwo else");
            //claimLevelTwo = "";
            shared.setClaimLevelTwo("");
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW")) {
            print("Response: CLAIM_APPROVAL_LEVEL_THREE_VIEW");
            //claimLevelThree = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
            shared.setClaimLevelThree("CLAIM_APPROVAL_LEVEL_THREE_VIEW");
          } else {
            print("claimLevelThree else");
            //claimLevelThree = "";
            shared.setClaimLevelThree("");
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("PRE_INDUCTION_ONBOARDING_ADD")) {
            print("Response: PRE_INDUCTION_ONBOARDING_ADD");
            //preOnboardShow = "true";
            shared.setPreOnboardShow("true");
          } else {
            print("preOnboardShow else");
            //preOnboardShow = "false";
            shared.setPreOnboardShow("false");
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_EMP_LIST_ADD")) {
            print("Response: EXIT_EMP_LIST_ADD");
            //exitShow = "true";
            shared.setExitShow("true");
          } else {
            print("exitShow else");
            //exitShow = "false";
            shared.setExitShow("false");
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("HRIS_EMP_LIST_VIEW")) {
            print("Response: HRIS_EMP_LIST_VIEW");
            //myTeamShow = "true";
            shared.setMyTeamShow("true");
            shared.setMyTeamPageShow("1");
          } else {
            print("My Team else");
            //myTeamShow = "false";
            shared.setMyTeamShow("false");
            shared.setMyTeamPageShow("0");
          }

          //Exit Permission setter
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESIGN_REQUEST_LIST_VIEW")) {
            print("Response: EXIT_RESIGN_REQUEST_LIST_VIEW");
            //exitResignationListShow = "true";
            //exitResignationListView = "1";
            shared.setExitResignationListShow("true");
            shared.setExitResignationListView("1");
          } else {
            print("EXIT_RESIGN_REQUEST_LIST_VIEW else");
            //exitResignationListShow = "false";
            //exitResignationListView = "0";
            shared.setExitResignationListShow("false");
            shared.setExitResignationListView("0");
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD")) {
            print("Response: EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD");
            //exitResignationApproveL1Show = "true";
            shared.setExitResignationApproveL1Show("true");
          } else {
            print("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD else");
            //exitResignationApproveL1Show = "false";
            shared.setExitResignationApproveL1Show("false");
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD")) {
            print("Response: EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD");
            //exitResignationApproveL2Show = "true";
            shared.setExitResignationApproveL2Show("true");
          } else {
            print("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD else");
            //exitResignationApproveL2Show = "false";
            shared.setExitResignationApproveL2Show("false");
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE")) {
            print("Response: EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE");
            //exitResignationDisApproveL1Show = "true";
            shared.setExitResignationDisApproveL1Show("true");
          } else {
            print("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE else");
            //exitResignationDisApproveL1Show = "false";
            shared.setExitResignationDisApproveL1Show("false");
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE")) {
            print("Response: EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE");
            //exitResignationDisApproveL2Show = "true";
            shared.setExitResignationDisApproveL2Show("true");
          } else {
            print("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE else");
            //exitResignationDisApproveL2Show = "false";
            shared.setExitResignationDisApproveL2Show("false");
          }

          //MSS MO
          // 🟢 Check if the selected profile has the Pending Attendance Request permission
          /*String pendingAttReqMOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD") == true) {
            shared.setPendingAttendanceReqMSSMOPermission("1");
          } else {
            shared.setPendingAttendanceReqMSSMOPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request permission
          /*String leaveReqMOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_MO_ADD") == true || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_MYTEAM_ADD") == true) {
            shared.setPendingLeaveReqMSSMOPermission("1");
          } else {
            shared.setPendingLeaveReqMSSMOPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L1 permission
          /*String leaveReqL1MOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MO_ADD") == true || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD") == true) {
            shared.setPendingLeaveReqL1MSSMOPermission("1");
          } else {
            shared.setPendingLeaveReqL1MSSMOPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L2 permission
          /*String leaveReqL2MOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MO_ADD") == true || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") == true) {
            shared.setPendingLeaveReqL2MSSMOPermission("1");
          } else {
            shared.setPendingLeaveReqL2MSSMOPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L2 permission
          /*String othersLeaveReqMOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_MO_ADD") == true) {
            shared.setOthersLeaveReqMSSMOPermission("1");
          } else {
            shared.setOthersLeaveReqMSSMOPermission("0");
          }
          // 🟢 Check if the selected profile has the Claim L1 permission
          /*String pendingClaimL1MOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") == true) {
            shared.setClaimLevelOneMO("1");
          } else {
            shared.setClaimLevelOneMO("0");
          }
          // 🟢 Check if the selected profile has the Claim L2 permission
          /*String pendingClaimL2MOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") == true) {
            shared.setClaimLevelTwoMO("1");
          } else {
            shared.setClaimLevelTwoMO("0");
          }
          // 🟢 Check if the selected profile has the Claim L3 permission
          /*String pendingClaimL3MOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") == true) {
            shared.setClaimLevelThreeMO("1");
          } else {
            shared.setClaimLevelThreeMO("0");
          }
          // 🟢 Check if the selected profile has the OD Pending List permission
          /* String pendingODListMOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") == true) {
            shared.setODPendingListMO("1");
          } else {
            shared.setODPendingListMO("0");
          }
          // 🟢 Check if the selected profile has the OD Activate permission
          /*String odActivateMOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") == true) {
            shared.setODActivateMO("1");
          } else {
            shared.setODActivateMO("0");
          }
          // 🟢 Check if the selected profile has the OD Pending List permission
          /*String pendingAttendanceRequestMOL1 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") == true) {
            shared.setPendingAttendanceReqL1MO("1");
          } else {
            shared.setPendingAttendanceReqL1MO("0");
          }
          // 🟢 Check if the selected profile has the OD Activate permission
          /* String pendingAttendanceRequestMOL2 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") == true) {
            shared.setPendingAttendanceReqL2MO("1");
          } else {
            shared.setPendingAttendanceReqL2MO("0");
          }

          //MSS
          // 🟢 Check if the selected profile has the Pending Attendance Request permission
          /*String pendingAttReqMSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") == true) {
            shared.setPendingAttendanceReqMSSPermission("1");
          } else {
            shared.setPendingAttendanceReqMSSPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request permission
          /*String leaveReqMSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_APP_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD") == true || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_APP_MYTEAM_ADD") == true) {
            shared.setPendingLeaveReqMSSPermission("1");
          } else {
            shared.setPendingLeaveReqMSSPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L1 permission
          /*String leaveReqL1MSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") == true || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD") == true) {
            shared.setPendingLeaveReqL1MSSPermission("1");
          } else {
            shared.setPendingLeaveReqL1MSSPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L2 permission
          /*String leaveReqL2MSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") == true || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") == true) {
            shared.setPendingLeaveReqL2MSSPermission("1");
          } else {
            shared.setPendingLeaveReqL2MSSPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L2 permission
          /* String othersLeaveReqMSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_ADD") == true) {
            shared.setOthersLeaveReqMSSPermission("1");
          } else {
            shared.setOthersLeaveReqMSSPermission("0");
          }
          // 🟢 Check if the selected profile has the Claim L1 permission
          /* String pendingClaimL1Permission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") == true) {
            shared.setClaimLevelOne("1");
          } else {
            shared.setClaimLevelOne("0");
          }
          // 🟢 Check if the selected profile has the Claim L2 permission
          /*String pendingClaimL2Permission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") == true) {
            shared.setClaimLevelTwo("1");
          } else {
            shared.setClaimLevelTwo("0");
          }
          // 🟢 Check if the selected profile has the Claim L3 permission
          /*String pendingClaimL3Permission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") == true) {
            shared.setClaimLevelThree("1");
          } else {
            shared.setClaimLevelThree("0");
          }
          // 🟢 Check if the selected profile has the OD Pending List permission
          /*String pendingODListPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") == true) {
            shared.setODPendingList("1");
          } else {
            shared.setODPendingList("0");
          }
          // 🟢 Check if the selected profile has the OD Activate permission
          /*String odActivatePermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") == true) {
            shared.setODActivate("1");
          } else {
            shared.setODActivate("0");
          }
          // 🟢 Check if the selected profile has the OD Pending List permission
          /*String pendingAttendanceRequestMSSL1 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") == true) {
            shared.setPendingAttendanceReqL1MSS("1");
          } else {
            shared.setPendingAttendanceReqL1MSS("0");
          }
          // 🟢 Check if the selected profile has the OD Activate permission
          /*String pendingAttendanceRequestMSSL2 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") == true) {
            shared.setPendingAttendanceReqL2MSS("1");
          } else {
            shared.setPendingAttendanceReqL2MSS("0");
          }

          //USER
          // 🟢 Check if the selected profile has the Pending Attendance Request permission
          /*String pendingAttReqUISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") == true) {
            shared.setPendingAttendanceReqUISPermission("1");
          } else {
            shared.setPendingAttendanceReqUISPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request permission
          /*String leaveReqUISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD") == true) {
            shared.setPendingLeaveReqUISPermission("1");
          } else {
            shared.setPendingLeaveReqUISPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L1 permission
          /*String leaveReqL1UISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") == true) {
            shared.setPendingLeaveReqL1UISPermission("1");
          } else {
            shared.setPendingLeaveReqL1UISPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L2 permission
          /*String leaveReqL2UISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") == true) {
            shared.setPendingLeaveReqL2UISPermission("1");
          } else {
            shared.setPendingLeaveReqL2UISPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L2 permission
          /*String othersLeaveReqUISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_ADD") == true) {
            shared.setOthersLeaveReqUISPermission("1");
          } else {
            shared.setOthersLeaveReqUISPermission("0");
          }
          // 🟢 Check if the selected profile has the Claim L1 permission
          /*String pendingClaimL1UISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") == true) {
            shared.setClaimLevelOneUIS("1");
          } else {
            shared.setClaimLevelOneUIS("0");
          }
          // 🟢 Check if the selected profile has the Claim L2 permission
          /*String pendingClaimL2UISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") == true) {
            shared.setClaimLevelTwoUIS("1");
          } else {
            shared.setClaimLevelTwoUIS("0");
          }
          // 🟢 Check if the selected profile has the Claim L3 permission
          /*String pendingClaimL3UISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") == true) {
            shared.setClaimLevelThreeUIS("1");
          } else {
            shared.setClaimLevelThreeUIS("0");
          }
          // 🟢 Check if the selected profile has the OD Pending List permission
          /*String pendingODListUISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") == true) {
            shared.setODPendingListUIS("1");
          } else {
            shared.setODPendingListUIS("0");
          }
          // 🟢 Check if the selected profile has the OD Activate permission
          /*String odActivateUISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") == true) {
            shared.setODActivateUIS("1");
          } else {
            shared.setODActivateUIS("0");
          }
          // 🟢 Check if the selected profile has the OD Pending List permission
          /*String pendingAttendanceRequestUISL1 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") == true) {
            shared.setPendingAttendanceReqL1UIS("1");
          } else {
            shared.setPendingAttendanceReqL1UIS("0");
          }
          // 🟢 Check if the selected profile has the OD Activate permission
          /*String pendingAttendanceRequestUISL2 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") == true) {
            shared.setPendingAttendanceReqL2UIS("1");
          } else {
            shared.setPendingAttendanceReqL2UIS("0");
          }



          // 🟢 Save the MSS MO permission to SharedPreferences
          /*shared.setPendingAttendanceReqMSSMOPermission(pendingAttReqMOPermValue);
          shared.setPendingLeaveReqMSSMOPermission(leaveReqMOPermValue);
          shared.setPendingLeaveReqL1MSSMOPermission(leaveReqL1MOPermValue);
          shared.setPendingLeaveReqL2MSSMOPermission(leaveReqL2MOPermValue);
          shared.setOthersLeaveReqMSSMOPermission(othersLeaveReqMOPermValue);
          shared.setClaimLevelOneMO(pendingClaimL1MOPermission);
          shared.setClaimLevelTwoMO(pendingClaimL2MOPermission);
          shared.setClaimLevelThreeMO(pendingClaimL3MOPermission);
          shared.setODActivateMO(odActivateMOPermission);
          shared.setODPendingListMO(pendingODListMOPermission);
          shared.setPendingAttendanceReqL1MO(pendingAttendanceRequestMOL1);
          shared.setPendingAttendanceReqL2MO(pendingAttendanceRequestMOL2);
          print("✅ Attendance Permission for profileId $profileIdNew: $pendingAttReqMOPermValue");
          print("✅ Leave Permission for profileId $profileIdNew: $leaveReqMOPermValue");
          print("✅ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1MOPermValue");
          print("✅ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2MOPermValue");
          print("✅ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqMOPermValue");
          print("✅ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1MOPermission");
          print("✅ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2MOPermission");
          print("✅ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3MOPermission");
          print("✅ OD Activate Permission for profileId $profileIdNew: $odActivateMOPermission");
          print("✅ Pending OD Permission for profileId $profileIdNew: $pendingODListMOPermission");
          print("✅ Pending Attendance L1 MO Permission for profileId $profileIdNew: $pendingAttendanceRequestMOL1");
          print("✅ Pending Attendance L2 MO Permission for profileId $profileIdNew: $pendingAttendanceRequestMOL2");

          // 🟢 Save the MSS permission to SharedPreferences
          shared.setPendingAttendanceReqMSSPermission(pendingAttReqMSSPermValue);
          shared.setPendingLeaveReqMSSPermission(leaveReqMSSPermValue);
          shared.setPendingLeaveReqL1MSSPermission(leaveReqL1MSSPermValue);
          shared.setPendingLeaveReqL2MSSPermission(leaveReqL2MSSPermValue);
          shared.setOthersLeaveReqMSSPermission(othersLeaveReqMSSPermValue);
          shared.setClaimLevelOne(pendingClaimL1Permission);
          shared.setClaimLevelTwo(pendingClaimL2Permission);
          shared.setClaimLevelThree(pendingClaimL3Permission);
          shared.setODActivate(odActivatePermission);
          shared.setODPendingList(pendingODListPermission);
          shared.setPendingAttendanceReqL1MSS(pendingAttendanceRequestMSSL1);
          shared.setPendingAttendanceReqL2MSS(pendingAttendanceRequestMSSL2);
          print("✅ Attendance Permission for profileId $profileIdNew: $pendingAttReqMSSPermValue");
          print("✅ Leave Permission for profileId $profileIdNew: $leaveReqMSSPermValue");
          print("✅ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1MSSPermValue");
          print("✅ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2MSSPermValue");
          print("✅ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqMSSPermValue");
          print("✅ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1Permission");
          print("✅ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2Permission");
          print("✅ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3Permission");
          print("✅ OD Activate Permission for profileId $profileIdNew: $odActivatePermission");
          print("✅ Pending OD List Permission for profileId $profileIdNew: $pendingODListPermission");
          print("✅ Pending Attendance L1 MSS Permission for profileId $profileIdNew: $pendingAttendanceRequestMSSL1");
          print("✅ Pending Attendance L2 MSS Permission for profileId $profileIdNew: $pendingAttendanceRequestMSSL2");

          // 🟢 Save the UIS permission to SharedPreferences
          shared.setPendingAttendanceReqUISPermission(pendingAttReqUISPermValue);
          shared.setPendingLeaveReqUISPermission(leaveReqUISPermValue);
          shared.setPendingLeaveReqL1UISPermission(leaveReqL1UISPermValue);
          shared.setPendingLeaveReqL2UISPermission(leaveReqL2UISPermValue);
          shared.setOthersLeaveReqUISPermission(othersLeaveReqUISPermValue);
          shared.setClaimLevelOneUIS(pendingClaimL1UISPermission);
          shared.setClaimLevelTwoUIS(pendingClaimL2UISPermission);
          shared.setClaimLevelThreeUIS(pendingClaimL3UISPermission);
          shared.setODActivateUIS(odActivateUISPermission);
          shared.setODPendingListUIS(pendingODListUISPermission);
          shared.setPendingAttendanceReqL1UIS(pendingAttendanceRequestUISL1);
          shared.setPendingAttendanceReqL2UIS(pendingAttendanceRequestUISL2);
          print("✅ Attendance Permission for profileId $profileIdNew: $pendingAttReqUISPermValue");
          print("✅ Leave Permission for profileId $profileIdNew: $leaveReqUISPermValue");
          print("✅ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1UISPermValue");
          print("✅ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2UISPermValue");
          print("✅ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqUISPermValue");
          print("✅ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1UISPermission");
          print("✅ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2UISPermission");
          print("✅ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3UISPermission");
          print("✅ OD Activate Permission for profileId $profileIdNew: $odActivateUISPermission");
          print("✅ Pending OD List Permission for profileId $profileIdNew: $pendingODListUISPermission");
          print("✅ Pending Attendance L1 UIS Permission for profileId $profileIdNew: $pendingAttendanceRequestUISL1");
          print("✅ Pending Attendance L2 UIS Permission for profileId $profileIdNew: $pendingAttendanceRequestUISL2");*/
        }

        print('Profile Name $profileName');
        print('Profile Id $profileId');
        print('Default Profile $defaultProfile');
      }
    } setState(() {

    });
    empLength;
    roLength;
    adminlength;
    /*levelOne = "false";
    levelTwo = "false";
    pendingLeaveRequisitions = "false";
    shared.setLevelOne(levelOne);
    shared.setLevelTwo(levelTwo);
    shared.setPendingLeaveReq(pendingLeaveRequisitions);*/
    print("User Role Length - ${loginModelglobal!.data!.profileList!.length}");

    setState(() {

    });


    getSharedPrfanceList();
  }

  void setAdminSharedPrefValue(LoginModel? loginModelglobal) {
    setState(() {
      shared.setSessionId(loginModelglobal!.data!.sessionId!);
      print("MY NEW SESSION - ${shared.getSessionId}");
      shared.setDept(loginModelglobal!.data!.department);
      shared.setName(loginModelglobal!.data!.userLoginned!.name);
      shared.setProfileImage(loginModelglobal!.data!.userImage);
      shared.setOrgId(loginModelglobal!.data!.orgId);
      shared.setEmailid(loginModelglobal!.data!.userLoginned!.userId);
      shared.setDob(loginModelglobal!.data!.dob);
      shared.setMobileNo(loginModelglobal!.data!.contact);
      shared.setDesignation(loginModelglobal!.data!.designation);
      shared.setBranch(loginModelglobal!.data!.branch);
      shared.setAadhar(loginModelglobal!.data!.aadharNo);
      shared.setPfNo(loginModelglobal!.data!.pfNo);
      shared.setEsicNo(loginModelglobal!.data!.esicNo);
      shared.setBankName(loginModelglobal!.data!.bankName);
      shared.setBankAcc(loginModelglobal!.data!.bankAccNo);
      shared.setIfscCode(loginModelglobal!.data!.ifscCode);
      shared.setEmpId(loginModelglobal!.data!.empId);
      shared.setUserType(loginModelglobal!.data!.userLoginned!.userType);

      shared.setUserPanel(loginModelglobal!.data!.userPanel);
      userPanel = loginModelglobal!.data!.userPanel;
      shared.setEnrollId(loginModelglobal!.data!.enrollId);

      if(loginModelglobal!.data!.startDate == null) {
        startPayCycle = "0";
        shared.setPayCycleStart(startPayCycle);
        print("If Null Show 0 - $startPayCycle");
      } else {
        startPayCycle = loginModelglobal!.data!.startDate;
        shared.setPayCycleStart(startPayCycle);
        print("Else Show value - $startPayCycle");
      }
      if(loginModelglobal!.data!.endDate == null) {
        endPayCycle = "0";
        shared.setPayCycleEnd(endPayCycle);
        print("If Null Show 0 - $endPayCycle");
      } else {
        endPayCycle = loginModelglobal!.data!.endDate;
        shared.setPayCycleEnd(endPayCycle);
        print("Else Show value - $startPayCycle");
      }
    });

    print("Check User Panel - $userPanel");


    shared.setEmpRoll(loginModelglobal!.data!.empRole!.length);
    shared.setMobAction(loginModelglobal!.data!.mobAction!.length);
    shared.setDoj(loginModelglobal!.data!.doj);
    shared.setShowPayroll(loginModelglobal!.data!.userLoginned!.showPayroll);
    shared.setEmpCode(loginModelglobal!.data!.empCode);
    shared.setEmpCode(loginModelglobal!.data!.empCode);

    var mobAction = loginModelglobal!.data!.mobAction!.length;
    /*shared.setUserRoles(loginModelglobal!.data!.userRoles![0]);
    print(loginModelglobal!.data!.userRoles![0]);*/



    print('mobActionCheck $mobAction');
    var empRole;
    empRole = loginModelglobal!.data!.empRole!.length;
    print('empRoleChecker $empRole');
    shared.setRoRoll(loginModelglobal!.data!.roRole!.length);
    var roRole;
    roRole = loginModelglobal!.data!.roRole!.length;
    print('roRole $roRole');
    shared.setAdminRole(loginModelglobal!.data!.adminrole!.length);

    adminRoleChcker = loginModelglobal!.data!.adminrole!.length;
    print('adminRolesCheckss $adminRoleChcker');
    for (int i = 0; i < loginModelglobal!.data!.profileList!.length; i++) {
      profileName = loginModelglobal!.data!.profileList![i].profileName;
      profileId = loginModelglobal!.data!.profileList![i].profileId;
      defaultProfile = loginModelglobal!.data!.profileList![i].defaultProfile;

      if (defaultProfile == true || loginModelglobal!.data!.profileList![i].isDefaultProfile == true) {
        String profileNameNew = loginModelglobal!.data!.profileList![i].profileName ?? '';
        dynamic profileIdNew = loginModelglobal!.data!.profileList![i].profileId;
        shared.setDefaultProfileName(profileNameNew);
        shared.setDefaultProfileId(profileIdNew);

        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD")) {
          print("resopnse LEVEL_ONE_LEAVE_APPROVE_ADD");
          //levelOne = "true";
          shared.setLevelOne("true");
        } else {
          print("resopnse LEVEL_ONE_LEAVE_APPROVE_ADD");
          //levelOne = "false";
          shared.setLevelOne("false");
        }

        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("FINAL_LEVEL_LEAVE_APPROVE_MYTEAM_ADD")) {
          print("resopnse LEVEL_TWO_LEAVE_APPROVE_ADD");
          //levelTwo = "true";
          shared.setLevelTwo("true");
        } else {
          print("resopnse LEVEL_TWO_LEAVE_APPROVE_ADD");
          //levelTwo = "false";
          shared.setLevelTwo("false");
        }
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD")) {
          print("resopnse LEAVE_REQ_APPROVAL_ADD");
          //pendingLeaveRequisitions = "true";
          shared.setPendingLeaveReq("true");
        }
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW")) {
          print("resopnse CLAIM_APPROVAL_LEVEL_ONE_VIEW");
          //claimLevelOne = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
          shared.setClaimLevelOne("CLAIM_APPROVAL_LEVEL_ONE_VIEW");
        } else {
          print("claimLevelOne else");
          //claimLevelOne = "";
          shared.setClaimLevelOne("");
        }
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW")) {
          print("resopnse CLAIM_APPROVAL_LEVEL_TWO_VIEW");
          //claimLevelTwo = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
          shared.setClaimLevelTwo("CLAIM_APPROVAL_LEVEL_TWO_VIEW");
        } else {
          print("claimLevelTwo else");
          //claimLevelTwo = "";
          shared.setClaimLevelTwo("");
        }
        if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW")) {
          print("Response: CLAIM_APPROVAL_LEVEL_THREE_VIEW");
          //claimLevelThree = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
          shared.setClaimLevelThree("CLAIM_APPROVAL_LEVEL_THREE_VIEW");
        } else {
          print("claimLevelThree else");
          //claimLevelThree = "";
          shared.setClaimLevelThree("");
        }
        if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("PRE_INDUCTION_ONBOARDING_ADD")) {
          print("Response: PRE_INDUCTION_ONBOARDING_ADD");
          //preOnboardShow = "true";
          shared.setPreOnboardShow("true");
        } else {
          print("preOnboardShow else");
          //preOnboardShow = "false";
          shared.setPreOnboardShow("false");
        }
        if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_EMP_LIST_ADD")) {
          print("Response: EXIT_EMP_LIST_ADD");
          //exitShow = "true";
          shared.setExitShow("true");
        } else {
          print("exitShow else");
          //exitShow = "false";
          shared.setExitShow("false");
        }
        if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("HRIS_EMP_LIST_VIEW")) {
          print("Response: HRIS_EMP_LIST_VIEW");
          //myTeamShow = "true";
          shared.setMyTeamShow("true");
          shared.setMyTeamPageShow("1");
        } else {
          print("My Team else");
          //myTeamShow = "false";
          shared.setMyTeamShow("false");
          shared.setMyTeamPageShow("0");
        }

        //Exit Permission setter
        if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESIGN_REQUEST_LIST_VIEW")) {
          print("Response: EXIT_RESIGN_REQUEST_LIST_VIEW");
          //exitResignationListShow = "true";
          //exitResignationListView = "1";
          shared.setExitResignationListShow("true");
          shared.setExitResignationListView("1");
        } else {
          print("EXIT_RESIGN_REQUEST_LIST_VIEW else");
          //exitResignationListShow = "false";
          //exitResignationListView = "0";
          shared.setExitResignationListShow("false");
          shared.setExitResignationListView("0");
        }
        if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD")) {
          print("Response: EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD");
          //exitResignationApproveL1Show = "true";
          shared.setExitResignationApproveL1Show("true");
        } else {
          print("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD else");
          //exitResignationApproveL1Show = "false";
          shared.setExitResignationApproveL1Show("false");
        }
        if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD")) {
          print("Response: EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD");
          //exitResignationApproveL2Show = "true";
          shared.setExitResignationApproveL2Show("true");
        } else {
          print("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD else");
          //exitResignationApproveL2Show = "false";
          shared.setExitResignationApproveL2Show("false");
        }
        if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE")) {
          print("Response: EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE");
          //exitResignationDisApproveL1Show = "true";
          shared.setExitResignationDisApproveL1Show("true");
        } else {
          print("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE else");
          //exitResignationDisApproveL1Show = "false";
          shared.setExitResignationDisApproveL1Show("false");
        }
        if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE")) {
          print("Response: EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE");
          //exitResignationDisApproveL2Show = "true";
          shared.setExitResignationDisApproveL2Show("true");
        } else {
          print("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE else");
          //exitResignationDisApproveL2Show = "false";
          shared.setExitResignationDisApproveL2Show("false");
        }

        //MSS MO
        // 🟢 Check if the selected profile has the Pending Attendance Request permission
        /*String pendingAttReqMOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD") == true) {
          shared.setPendingAttendanceReqMSSMOPermission("1");
        } else {
          shared.setPendingAttendanceReqMSSMOPermission("0");
        }
        // 🟢 Check if the selected profile has the Leave Request permission
        /*String leaveReqMOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_MO_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_MO_ADD") == true || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_MYTEAM_ADD") == true) {
          shared.setPendingLeaveReqMSSMOPermission("1");
        } else {
          shared.setPendingLeaveReqMSSMOPermission("0");
        }
        // 🟢 Check if the selected profile has the Leave Request L1 permission
        /*String leaveReqL1MOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MO_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MO_ADD") == true || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD") == true) {
          shared.setPendingLeaveReqL1MSSMOPermission("1");
        } else {
          shared.setPendingLeaveReqL1MSSMOPermission("0");
        }
        // 🟢 Check if the selected profile has the Leave Request L2 permission
        /*String leaveReqL2MOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MO_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MO_ADD") == true || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") == true) {
          shared.setPendingLeaveReqL2MSSMOPermission("1");
        } else {
          shared.setPendingLeaveReqL2MSSMOPermission("0");
        }
        // 🟢 Check if the selected profile has the Leave Request L2 permission
        /*String othersLeaveReqMOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_MO_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_MO_ADD") == true) {
          shared.setOthersLeaveReqMSSMOPermission("1");
        } else {
          shared.setOthersLeaveReqMSSMOPermission("0");
        }
        // 🟢 Check if the selected profile has the Claim L1 permission
        /*String pendingClaimL1MOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") == true) {
          shared.setClaimLevelOneMO("1");
        } else {
          shared.setClaimLevelOneMO("0");
        }
        // 🟢 Check if the selected profile has the Claim L2 permission
        /*String pendingClaimL2MOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") == true) {
          shared.setClaimLevelTwoMO("1");
        } else {
          shared.setClaimLevelTwoMO("0");
        }
        // 🟢 Check if the selected profile has the Claim L3 permission
        /*String pendingClaimL3MOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") == true) {
          shared.setClaimLevelThreeMO("1");
        } else {
          shared.setClaimLevelThreeMO("0");
        }
        // 🟢 Check if the selected profile has the OD Pending List permission
        /* String pendingODListMOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") == true) {
          shared.setODPendingListMO("1");
        } else {
          shared.setODPendingListMO("0");
        }
        // 🟢 Check if the selected profile has the OD Activate permission
        /*String odActivateMOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") == true) {
          shared.setODActivateMO("1");
        } else {
          shared.setODActivateMO("0");
        }
        // 🟢 Check if the selected profile has the OD Pending List permission
        /*String pendingAttendanceRequestMOL1 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") == true) {
          shared.setPendingAttendanceReqL1MO("1");
        } else {
          shared.setPendingAttendanceReqL1MO("0");
        }
        // 🟢 Check if the selected profile has the OD Activate permission
        /* String pendingAttendanceRequestMOL2 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") == true) {
          shared.setPendingAttendanceReqL2MO("1");
        } else {
          shared.setPendingAttendanceReqL2MO("0");
        }

        //MSS
        // 🟢 Check if the selected profile has the Pending Attendance Request permission
        /*String pendingAttReqMSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") == true) {
          shared.setPendingAttendanceReqMSSPermission("1");
        } else {
          shared.setPendingAttendanceReqMSSPermission("0");
        }
        // 🟢 Check if the selected profile has the Leave Request permission
        /*String leaveReqMSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_APP_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD") == true || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_APP_MYTEAM_ADD") == true) {
          shared.setPendingLeaveReqMSSPermission("1");
        } else {
          shared.setPendingLeaveReqMSSPermission("0");
        }
        // 🟢 Check if the selected profile has the Leave Request L1 permission
        /*String leaveReqL1MSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") == true || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD") == true) {
          shared.setPendingLeaveReqL1MSSPermission("1");
        } else {
          shared.setPendingLeaveReqL1MSSPermission("0");
        }
        // 🟢 Check if the selected profile has the Leave Request L2 permission
        /*String leaveReqL2MSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") == true || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") == true) {
          shared.setPendingLeaveReqL2MSSPermission("1");
        } else {
          shared.setPendingLeaveReqL2MSSPermission("0");
        }
        // 🟢 Check if the selected profile has the Leave Request L2 permission
        /* String othersLeaveReqMSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_ADD") == true) {
          shared.setOthersLeaveReqMSSPermission("1");
        } else {
          shared.setOthersLeaveReqMSSPermission("0");
        }
        // 🟢 Check if the selected profile has the Claim L1 permission
        /* String pendingClaimL1Permission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") == true) {
          shared.setClaimLevelOne("1");
        } else {
          shared.setClaimLevelOne("0");
        }
        // 🟢 Check if the selected profile has the Claim L2 permission
        /*String pendingClaimL2Permission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") == true) {
          shared.setClaimLevelTwo("1");
        } else {
          shared.setClaimLevelTwo("0");
        }
        // 🟢 Check if the selected profile has the Claim L3 permission
        /*String pendingClaimL3Permission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") == true) {
          shared.setClaimLevelThree("1");
        } else {
          shared.setClaimLevelThree("0");
        }
        // 🟢 Check if the selected profile has the OD Pending List permission
        /*String pendingODListPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") == true) {
          shared.setODPendingList("1");
        } else {
          shared.setODPendingList("0");
        }
        // 🟢 Check if the selected profile has the OD Activate permission
        /*String odActivatePermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") == true) {
          shared.setODActivate("1");
        } else {
          shared.setODActivate("0");
        }
        // 🟢 Check if the selected profile has the OD Pending List permission
        /*String pendingAttendanceRequestMSSL1 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") == true) {
          shared.setPendingAttendanceReqL1MSS("1");
        } else {
          shared.setPendingAttendanceReqL1MSS("0");
        }
        // 🟢 Check if the selected profile has the OD Activate permission
        /*String pendingAttendanceRequestMSSL2 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") == true) {
          shared.setPendingAttendanceReqL2MSS("1");
        } else {
          shared.setPendingAttendanceReqL2MSS("0");
        }

        //USER
        // 🟢 Check if the selected profile has the Pending Attendance Request permission
        /*String pendingAttReqUISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") == true) {
          shared.setPendingAttendanceReqUISPermission("1");
        } else {
          shared.setPendingAttendanceReqUISPermission("0");
        }
        // 🟢 Check if the selected profile has the Leave Request permission
        /*String leaveReqUISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD") == true) {
          shared.setPendingLeaveReqUISPermission("1");
        } else {
          shared.setPendingLeaveReqUISPermission("0");
        }
        // 🟢 Check if the selected profile has the Leave Request L1 permission
        /*String leaveReqL1UISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") == true) {
          shared.setPendingLeaveReqL1UISPermission("1");
        } else {
          shared.setPendingLeaveReqL1UISPermission("0");
        }
        // 🟢 Check if the selected profile has the Leave Request L2 permission
        /*String leaveReqL2UISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") == true) {
          shared.setPendingLeaveReqL2UISPermission("1");
        } else {
          shared.setPendingLeaveReqL2UISPermission("0");
        }
        // 🟢 Check if the selected profile has the Leave Request L2 permission
        /*String othersLeaveReqUISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_ADD") == true) {
          shared.setOthersLeaveReqUISPermission("1");
        } else {
          shared.setOthersLeaveReqUISPermission("0");
        }
        // 🟢 Check if the selected profile has the Claim L1 permission
        /*String pendingClaimL1UISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") == true) {
          shared.setClaimLevelOneUIS("1");
        } else {
          shared.setClaimLevelOneUIS("0");
        }
        // 🟢 Check if the selected profile has the Claim L2 permission
        /*String pendingClaimL2UISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") == true) {
          shared.setClaimLevelTwoUIS("1");
        } else {
          shared.setClaimLevelTwoUIS("0");
        }
        // 🟢 Check if the selected profile has the Claim L3 permission
        /*String pendingClaimL3UISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") == true) {
          shared.setClaimLevelThreeUIS("1");
        } else {
          shared.setClaimLevelThreeUIS("0");
        }
        // 🟢 Check if the selected profile has the OD Pending List permission
        /*String pendingODListUISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") == true) {
          shared.setODPendingListUIS("1");
        } else {
          shared.setODPendingListUIS("0");
        }
        // 🟢 Check if the selected profile has the OD Activate permission
        /*String odActivateUISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") == true) {
          shared.setODActivateUIS("1");
        } else {
          shared.setODActivateUIS("0");
        }
        // 🟢 Check if the selected profile has the OD Pending List permission
        /*String pendingAttendanceRequestUISL1 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") == true) {
          shared.setPendingAttendanceReqL1UIS("1");
        } else {
          shared.setPendingAttendanceReqL1UIS("0");
        }
        // 🟢 Check if the selected profile has the OD Activate permission
        /*String pendingAttendanceRequestUISL2 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
        if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") == true) {
          shared.setPendingAttendanceReqL2UIS("1");
        } else {
          shared.setPendingAttendanceReqL2UIS("0");
        }



        // 🟢 Save the MSS MO permission to SharedPreferences
        /*shared.setPendingAttendanceReqMSSMOPermission(pendingAttReqMOPermValue);
          shared.setPendingLeaveReqMSSMOPermission(leaveReqMOPermValue);
          shared.setPendingLeaveReqL1MSSMOPermission(leaveReqL1MOPermValue);
          shared.setPendingLeaveReqL2MSSMOPermission(leaveReqL2MOPermValue);
          shared.setOthersLeaveReqMSSMOPermission(othersLeaveReqMOPermValue);
          shared.setClaimLevelOneMO(pendingClaimL1MOPermission);
          shared.setClaimLevelTwoMO(pendingClaimL2MOPermission);
          shared.setClaimLevelThreeMO(pendingClaimL3MOPermission);
          shared.setODActivateMO(odActivateMOPermission);
          shared.setODPendingListMO(pendingODListMOPermission);
          shared.setPendingAttendanceReqL1MO(pendingAttendanceRequestMOL1);
          shared.setPendingAttendanceReqL2MO(pendingAttendanceRequestMOL2);
          print("✅ Attendance Permission for profileId $profileIdNew: $pendingAttReqMOPermValue");
          print("✅ Leave Permission for profileId $profileIdNew: $leaveReqMOPermValue");
          print("✅ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1MOPermValue");
          print("✅ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2MOPermValue");
          print("✅ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqMOPermValue");
          print("✅ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1MOPermission");
          print("✅ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2MOPermission");
          print("✅ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3MOPermission");
          print("✅ OD Activate Permission for profileId $profileIdNew: $odActivateMOPermission");
          print("✅ Pending OD Permission for profileId $profileIdNew: $pendingODListMOPermission");
          print("✅ Pending Attendance L1 MO Permission for profileId $profileIdNew: $pendingAttendanceRequestMOL1");
          print("✅ Pending Attendance L2 MO Permission for profileId $profileIdNew: $pendingAttendanceRequestMOL2");

          // 🟢 Save the MSS permission to SharedPreferences
          shared.setPendingAttendanceReqMSSPermission(pendingAttReqMSSPermValue);
          shared.setPendingLeaveReqMSSPermission(leaveReqMSSPermValue);
          shared.setPendingLeaveReqL1MSSPermission(leaveReqL1MSSPermValue);
          shared.setPendingLeaveReqL2MSSPermission(leaveReqL2MSSPermValue);
          shared.setOthersLeaveReqMSSPermission(othersLeaveReqMSSPermValue);
          shared.setClaimLevelOne(pendingClaimL1Permission);
          shared.setClaimLevelTwo(pendingClaimL2Permission);
          shared.setClaimLevelThree(pendingClaimL3Permission);
          shared.setODActivate(odActivatePermission);
          shared.setODPendingList(pendingODListPermission);
          shared.setPendingAttendanceReqL1MSS(pendingAttendanceRequestMSSL1);
          shared.setPendingAttendanceReqL2MSS(pendingAttendanceRequestMSSL2);
          print("✅ Attendance Permission for profileId $profileIdNew: $pendingAttReqMSSPermValue");
          print("✅ Leave Permission for profileId $profileIdNew: $leaveReqMSSPermValue");
          print("✅ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1MSSPermValue");
          print("✅ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2MSSPermValue");
          print("✅ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqMSSPermValue");
          print("✅ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1Permission");
          print("✅ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2Permission");
          print("✅ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3Permission");
          print("✅ OD Activate Permission for profileId $profileIdNew: $odActivatePermission");
          print("✅ Pending OD List Permission for profileId $profileIdNew: $pendingODListPermission");
          print("✅ Pending Attendance L1 MSS Permission for profileId $profileIdNew: $pendingAttendanceRequestMSSL1");
          print("✅ Pending Attendance L2 MSS Permission for profileId $profileIdNew: $pendingAttendanceRequestMSSL2");

          // 🟢 Save the UIS permission to SharedPreferences
          shared.setPendingAttendanceReqUISPermission(pendingAttReqUISPermValue);
          shared.setPendingLeaveReqUISPermission(leaveReqUISPermValue);
          shared.setPendingLeaveReqL1UISPermission(leaveReqL1UISPermValue);
          shared.setPendingLeaveReqL2UISPermission(leaveReqL2UISPermValue);
          shared.setOthersLeaveReqUISPermission(othersLeaveReqUISPermValue);
          shared.setClaimLevelOneUIS(pendingClaimL1UISPermission);
          shared.setClaimLevelTwoUIS(pendingClaimL2UISPermission);
          shared.setClaimLevelThreeUIS(pendingClaimL3UISPermission);
          shared.setODActivateUIS(odActivateUISPermission);
          shared.setODPendingListUIS(pendingODListUISPermission);
          shared.setPendingAttendanceReqL1UIS(pendingAttendanceRequestUISL1);
          shared.setPendingAttendanceReqL2UIS(pendingAttendanceRequestUISL2);
          print("✅ Attendance Permission for profileId $profileIdNew: $pendingAttReqUISPermValue");
          print("✅ Leave Permission for profileId $profileIdNew: $leaveReqUISPermValue");
          print("✅ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1UISPermValue");
          print("✅ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2UISPermValue");
          print("✅ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqUISPermValue");
          print("✅ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1UISPermission");
          print("✅ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2UISPermission");
          print("✅ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3UISPermission");
          print("✅ OD Activate Permission for profileId $profileIdNew: $odActivateUISPermission");
          print("✅ Pending OD List Permission for profileId $profileIdNew: $pendingODListUISPermission");
          print("✅ Pending Attendance L1 UIS Permission for profileId $profileIdNew: $pendingAttendanceRequestUISL1");
          print("✅ Pending Attendance L2 UIS Permission for profileId $profileIdNew: $pendingAttendanceRequestUISL2");*/
      }

      print('Profile Name $profileName');
      print('Profile Id $profileId');
      print('Default Profile $defaultProfile');
    }

    /*for(int i=0; i<loginModelglobal!.data!.profileList!.length;i++){
      profileName = loginModelglobal!.data!.profileList![i].profileName;
      profileId = loginModelglobal!.data!.profileList![i].profileId;
      defaultProfile = loginModelglobal!.data!.profileList![i].defaultProfile;

      if (defaultProfile == true || loginModelglobal!.data!.profileList![i].isDefaultProfile == true) {
        String profileNameNew = '${loginModelglobal!.data!.profileList![i].profileName}';
        dynamic profileIdNew = loginModelglobal!.data!.profileList![i].profileId;
          shared.setDefaultProfileName(profileNameNew);
          shared.setDefaultProfileId(profileIdNew);
      }

      print('Profile Name $profileName');
      print('Profile Id $profileId');
      print('Default Profile $defaultProfile');
    }*/
    if (userPanel == "COMPANY_EMPLOYEE") {
      // Clear profile ID and name in SharedPreferences
      shared.setDefaultProfileName('');
      shared.setDefaultProfileId(0); // or '' if you're treating it as a String
    } else {
      // Loop through profiles and save default one
      for (int i = 0; i < loginModelglobal!.data!.profileList!.length; i++) {
        profileName = loginModelglobal!.data!.profileList![i].profileName;
        profileId = loginModelglobal!.data!.profileList![i].profileId;
        defaultProfile = loginModelglobal!.data!.profileList![i].defaultProfile;

        if (defaultProfile == true || loginModelglobal!.data!.profileList![i].isDefaultProfile == true) {
          String profileNameNew = loginModelglobal!.data!.profileList![i].profileName ?? '';
          dynamic profileIdNew = loginModelglobal!.data!.profileList![i].profileId;
          shared.setDefaultProfileName(profileNameNew);
          shared.setDefaultProfileId(profileIdNew);

          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD")) {
            print("resopnse LEVEL_ONE_LEAVE_APPROVE_ADD");
            levelOne = "true";
            shared.setLevelOne(levelOne);
          } else {
            print("resopnse LEVEL_ONE_LEAVE_APPROVE_ADD");
            levelOne = "false";
            shared.setLevelOne(levelOne);
          }

          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("FINAL_LEVEL_LEAVE_APPROVE_MYTEAM_ADD")) {
            print("resopnse LEVEL_TWO_LEAVE_APPROVE_ADD");
            levelTwo = "true";
            shared.setLevelTwo(levelTwo);
          } else {
            print("resopnse LEVEL_TWO_LEAVE_APPROVE_ADD");
            levelTwo = "false";
            shared.setLevelTwo(levelTwo);
          }
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD")) {
            print("resopnse LEAVE_REQ_APPROVAL_ADD");
            pendingLeaveRequisitions = "true";
            shared.setPendingLeaveReq(pendingLeaveRequisitions);
          }
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW")) {
            print("resopnse CLAIM_APPROVAL_LEVEL_ONE_VIEW");
            claimLevelOne = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
            shared.setClaimLevelOne(claimLevelOne);
          } else {
            print("claimLevelOne else");
            claimLevelOne = "";
            shared.setClaimLevelOne(claimLevelOne);
          }
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW")) {
            print("resopnse CLAIM_APPROVAL_LEVEL_TWO_VIEW");
            claimLevelTwo = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
            shared.setClaimLevelTwo(claimLevelTwo);
          } else {
            print("claimLevelTwo else");
            claimLevelTwo = "";
            shared.setClaimLevelTwo(claimLevelTwo);
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW")) {
            print("Response: CLAIM_APPROVAL_LEVEL_THREE_VIEW");
            claimLevelThree = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
            shared.setClaimLevelThree(claimLevelThree);
          } else {
            print("claimLevelThree else");
            claimLevelThree = "";
            shared.setClaimLevelThree(claimLevelThree);
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("PRE_INDUCTION_ONBOARDING_ADD")) {
            print("Response: PRE_INDUCTION_ONBOARDING_ADD");
            preOnboardShow = "true";
            shared.setPreOnboardShow(preOnboardShow);
          } else {
            print("preOnboardShow else");
            preOnboardShow = "false";
            shared.setPreOnboardShow(preOnboardShow);
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_EMP_LIST_ADD")) {
            print("Response: EXIT_EMP_LIST_ADD");
            exitShow = "true";
            shared.setExitShow(exitShow);
          } else {
            print("exitShow else");
            exitShow = "false";
            shared.setExitShow(exitShow);
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("HRIS_EMP_LIST_VIEW")) {
            print("Response: HRIS_EMP_LIST_VIEW");
            //myTeamShow = "true";
            shared.setMyTeamShow("true");
            shared.setMyTeamPageShow("1");
          } else {
            print("My Team else");
            //myTeamShow = "false";
            shared.setMyTeamShow("false");
            shared.setMyTeamPageShow("0");
          }

          //Exit Permission setter
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESIGN_REQUEST_LIST_VIEW")) {
            print("Response: EXIT_RESIGN_REQUEST_LIST_VIEW");
            //exitResignationListShow = "true";
            //exitResignationListView = "1";
            shared.setExitResignationListShow("true");
            shared.setExitResignationListView("1");
          } else {
            print("EXIT_RESIGN_REQUEST_LIST_VIEW else");
            //exitResignationListShow = "false";
            //exitResignationListView = "0";
            shared.setExitResignationListShow("false");
            shared.setExitResignationListView("0");
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD")) {
            print("Response: EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD");
            exitResignationApproveL1Show = "true";
            shared.setExitResignationApproveL1Show(exitResignationApproveL1Show);
          } else {
            print("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD else");
            exitResignationApproveL1Show = "false";
            shared.setExitResignationApproveL1Show(exitResignationApproveL1Show);
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD")) {
            print("Response: EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD");
            exitResignationApproveL2Show = "true";
            shared.setExitResignationApproveL2Show(exitResignationApproveL2Show);
          } else {
            print("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD else");
            exitResignationApproveL2Show = "false";
            shared.setExitResignationApproveL2Show(exitResignationApproveL2Show);
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE")) {
            print("Response: EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE");
            exitResignationDisApproveL1Show = "true";
            shared.setExitResignationDisApproveL1Show(exitResignationDisApproveL1Show);
          } else {
            print("EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE else");
            exitResignationDisApproveL1Show = "false";
            shared.setExitResignationDisApproveL1Show(exitResignationDisApproveL1Show);
          }
          if (loginModelglobal!.data!.profileList![i].profilePermission!.contains("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE")) {
            print("Response: EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE");
            exitResignationDisApproveL2Show = "true";
            shared.setExitResignationDisApproveL2Show(exitResignationDisApproveL2Show);
          } else {
            print("EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE else");
            exitResignationDisApproveL2Show = "false";
            shared.setExitResignationDisApproveL2Show(exitResignationDisApproveL2Show);
          }

          //MSS MO
          // 🟢 Check if the selected profile has the Pending Attendance Request permission
          /*String pendingAttReqMOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD") == true) {
            shared.setPendingAttendanceReqMSSMOPermission("1");
          } else {
            shared.setPendingAttendanceReqMSSMOPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request permission
          /*String leaveReqMOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_MO_ADD") == true) {
            shared.setPendingLeaveReqMSSMOPermission("1");
          } else {
            shared.setPendingLeaveReqMSSMOPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L1 permission
          /*String leaveReqL1MOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MO_ADD") == true) {
            shared.setPendingLeaveReqL1MSSMOPermission("1");
          } else {
            shared.setPendingLeaveReqL1MSSMOPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L2 permission
          /*String leaveReqL2MOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MO_ADD") == true) {
            shared.setPendingLeaveReqL2MSSMOPermission("1");
          } else {
            shared.setPendingLeaveReqL2MSSMOPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L2 permission
          /*String othersLeaveReqMOPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_MO_ADD") == true) {
            shared.setOthersLeaveReqMSSMOPermission("1");
          } else {
            shared.setOthersLeaveReqMSSMOPermission("0");
          }
          // 🟢 Check if the selected profile has the Claim L1 permission
          /*String pendingClaimL1MOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") == true) {
            shared.setClaimLevelOneMO("1");
          } else {
            shared.setClaimLevelOneMO("0");
          }
          // 🟢 Check if the selected profile has the Claim L2 permission
          /*String pendingClaimL2MOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") == true) {
            shared.setClaimLevelTwoMO("1");
          } else {
            shared.setClaimLevelTwoMO("0");
          }
          // 🟢 Check if the selected profile has the Claim L3 permission
          /*String pendingClaimL3MOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") == true) {
            shared.setClaimLevelThreeMO("1");
          } else {
            shared.setClaimLevelThreeMO("0");
          }
          // 🟢 Check if the selected profile has the OD Pending List permission
          /* String pendingODListMOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") == true) {
            shared.setODPendingListMO("1");
          } else {
            shared.setODPendingListMO("0");
          }
          // 🟢 Check if the selected profile has the OD Activate permission
          /*String odActivateMOPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") == true) {
            shared.setODActivateMO("1");
          } else {
            shared.setODActivateMO("0");
          }
          // 🟢 Check if the selected profile has the OD Pending List permission
          /*String pendingAttendanceRequestMOL1 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") == true) {
            shared.setPendingAttendanceReqL1MO("1");
          } else {
            shared.setPendingAttendanceReqL1MO("0");
          }
          // 🟢 Check if the selected profile has the OD Activate permission
          /* String pendingAttendanceRequestMOL2 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") == true) {
            shared.setPendingAttendanceReqL2MO("1");
          } else {
            shared.setPendingAttendanceReqL2MO("0");
          }

          //MSS
          // 🟢 Check if the selected profile has the Pending Attendance Request permission
          /*String pendingAttReqMSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") == true) {
            shared.setPendingAttendanceReqMSSPermission("1");
          } else {
            shared.setPendingAttendanceReqMSSPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request permission
          /*String leaveReqMSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_APP_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD") == true) {
            shared.setPendingLeaveReqMSSPermission("1");
          } else {
            shared.setPendingLeaveReqMSSPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L1 permission
          /*String leaveReqL1MSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") == true) {
            shared.setPendingLeaveReqL1MSSPermission("1");
          } else {
            shared.setPendingLeaveReqL1MSSPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L2 permission
          /*String leaveReqL2MSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") || loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") == true) {
            shared.setPendingLeaveReqL2MSSPermission("1");
          } else {
            shared.setPendingLeaveReqL2MSSPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L2 permission
          /* String othersLeaveReqMSSPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_ADD") == true) {
            shared.setOthersLeaveReqMSSPermission("1");
          } else {
            shared.setOthersLeaveReqMSSPermission("0");
          }
          // 🟢 Check if the selected profile has the Claim L1 permission
          /* String pendingClaimL1Permission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") == true) {
            shared.setClaimLevelOne("1");
          } else {
            shared.setClaimLevelOne("0");
          }
          // 🟢 Check if the selected profile has the Claim L2 permission
          /*String pendingClaimL2Permission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") == true) {
            shared.setClaimLevelTwo("1");
          } else {
            shared.setClaimLevelTwo("0");
          }
          // 🟢 Check if the selected profile has the Claim L3 permission
          /*String pendingClaimL3Permission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") == true) {
            shared.setClaimLevelThree("1");
          } else {
            shared.setClaimLevelThree("0");
          }
          // 🟢 Check if the selected profile has the OD Pending List permission
          /*String pendingODListPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") == true) {
            shared.setODPendingList("1");
          } else {
            shared.setODPendingList("0");
          }
          // 🟢 Check if the selected profile has the OD Activate permission
          /*String odActivatePermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") == true) {
            shared.setODActivate("1");
          } else {
            shared.setODActivate("0");
          }
          // 🟢 Check if the selected profile has the OD Pending List permission
          /*String pendingAttendanceRequestMSSL1 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") == true) {
            shared.setPendingAttendanceReqL1MSS("1");
          } else {
            shared.setPendingAttendanceReqL1MSS("0");
          }
          // 🟢 Check if the selected profile has the OD Activate permission
          /*String pendingAttendanceRequestMSSL2 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") == true) {
            shared.setPendingAttendanceReqL2MSS("1");
          } else {
            shared.setPendingAttendanceReqL2MSS("0");
          }

          //USER
          // 🟢 Check if the selected profile has the Pending Attendance Request permission
          /*String pendingAttReqUISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") == true) {
            shared.setPendingAttendanceReqUISPermission("1");
          } else {
            shared.setPendingAttendanceReqUISPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request permission
          /*String leaveReqUISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEAVE_REQ_APPROVAL_ADD") == true) {
            shared.setPendingLeaveReqUISPermission("1");
          } else {
            shared.setPendingLeaveReqUISPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L1 permission
          /*String leaveReqL1UISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") == true) {
            shared.setPendingLeaveReqL1UISPermission("1");
          } else {
            shared.setPendingLeaveReqL1UISPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L2 permission
          /*String leaveReqL2UISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") == true) {
            shared.setPendingLeaveReqL2UISPermission("1");
          } else {
            shared.setPendingLeaveReqL2UISPermission("0");
          }
          // 🟢 Check if the selected profile has the Leave Request L2 permission
          /*String othersLeaveReqUISPermValue = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("OTHERS_LEAVE_REQUEST_ADD") == true) {
            shared.setOthersLeaveReqUISPermission("1");
          } else {
            shared.setOthersLeaveReqUISPermission("0");
          }
          // 🟢 Check if the selected profile has the Claim L1 permission
          /*String pendingClaimL1UISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") == true) {
            shared.setClaimLevelOneUIS("1");
          } else {
            shared.setClaimLevelOneUIS("0");
          }
          // 🟢 Check if the selected profile has the Claim L2 permission
          /*String pendingClaimL2UISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") == true) {
            shared.setClaimLevelTwoUIS("1");
          } else {
            shared.setClaimLevelTwoUIS("0");
          }
          // 🟢 Check if the selected profile has the Claim L3 permission
          /*String pendingClaimL3UISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") == true) {
            shared.setClaimLevelThreeUIS("1");
          } else {
            shared.setClaimLevelThreeUIS("0");
          }
          // 🟢 Check if the selected profile has the OD Pending List permission
          /*String pendingODListUISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_PENDING_REQ_ADD") == true) {
            shared.setODPendingListUIS("1");
          } else {
            shared.setODPendingListUIS("0");
          }
          // 🟢 Check if the selected profile has the OD Activate permission
          /*String odActivateUISPermission = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("MOBILE_OD_ACTIVATE_ADD") == true) {
            shared.setODActivateUIS("1");
          } else {
            shared.setODActivateUIS("0");
          }
          // 🟢 Check if the selected profile has the OD Pending List permission
          /*String pendingAttendanceRequestUISL1 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_ONE_ADD") == true) {
            shared.setPendingAttendanceReqL1UIS("1");
          } else {
            shared.setPendingAttendanceReqL1UIS("0");
          }
          // 🟢 Check if the selected profile has the OD Activate permission
          /*String pendingAttendanceRequestUISL2 = (loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
          if(loginModelglobal!.data!.profileList![i].profilePermission!.contains("ATT_APP_TWO_ADD") == true) {
            shared.setPendingAttendanceReqL2UIS("1");
          } else {
            shared.setPendingAttendanceReqL2UIS("0");
          }



          // 🟢 Save the MSS MO permission to SharedPreferences
          /*shared.setPendingAttendanceReqMSSMOPermission(pendingAttReqMOPermValue);
          shared.setPendingLeaveReqMSSMOPermission(leaveReqMOPermValue);
          shared.setPendingLeaveReqL1MSSMOPermission(leaveReqL1MOPermValue);
          shared.setPendingLeaveReqL2MSSMOPermission(leaveReqL2MOPermValue);
          shared.setOthersLeaveReqMSSMOPermission(othersLeaveReqMOPermValue);
          shared.setClaimLevelOneMO(pendingClaimL1MOPermission);
          shared.setClaimLevelTwoMO(pendingClaimL2MOPermission);
          shared.setClaimLevelThreeMO(pendingClaimL3MOPermission);
          shared.setODActivateMO(odActivateMOPermission);
          shared.setODPendingListMO(pendingODListMOPermission);
          shared.setPendingAttendanceReqL1MO(pendingAttendanceRequestMOL1);
          shared.setPendingAttendanceReqL2MO(pendingAttendanceRequestMOL2);
          print("✅ Attendance Permission for profileId $profileIdNew: $pendingAttReqMOPermValue");
          print("✅ Leave Permission for profileId $profileIdNew: $leaveReqMOPermValue");
          print("✅ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1MOPermValue");
          print("✅ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2MOPermValue");
          print("✅ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqMOPermValue");
          print("✅ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1MOPermission");
          print("✅ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2MOPermission");
          print("✅ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3MOPermission");
          print("✅ OD Activate Permission for profileId $profileIdNew: $odActivateMOPermission");
          print("✅ Pending OD Permission for profileId $profileIdNew: $pendingODListMOPermission");
          print("✅ Pending Attendance L1 MO Permission for profileId $profileIdNew: $pendingAttendanceRequestMOL1");
          print("✅ Pending Attendance L2 MO Permission for profileId $profileIdNew: $pendingAttendanceRequestMOL2");

          // 🟢 Save the MSS permission to SharedPreferences
          shared.setPendingAttendanceReqMSSPermission(pendingAttReqMSSPermValue);
          shared.setPendingLeaveReqMSSPermission(leaveReqMSSPermValue);
          shared.setPendingLeaveReqL1MSSPermission(leaveReqL1MSSPermValue);
          shared.setPendingLeaveReqL2MSSPermission(leaveReqL2MSSPermValue);
          shared.setOthersLeaveReqMSSPermission(othersLeaveReqMSSPermValue);
          shared.setClaimLevelOne(pendingClaimL1Permission);
          shared.setClaimLevelTwo(pendingClaimL2Permission);
          shared.setClaimLevelThree(pendingClaimL3Permission);
          shared.setODActivate(odActivatePermission);
          shared.setODPendingList(pendingODListPermission);
          shared.setPendingAttendanceReqL1MSS(pendingAttendanceRequestMSSL1);
          shared.setPendingAttendanceReqL2MSS(pendingAttendanceRequestMSSL2);
          print("✅ Attendance Permission for profileId $profileIdNew: $pendingAttReqMSSPermValue");
          print("✅ Leave Permission for profileId $profileIdNew: $leaveReqMSSPermValue");
          print("✅ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1MSSPermValue");
          print("✅ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2MSSPermValue");
          print("✅ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqMSSPermValue");
          print("✅ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1Permission");
          print("✅ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2Permission");
          print("✅ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3Permission");
          print("✅ OD Activate Permission for profileId $profileIdNew: $odActivatePermission");
          print("✅ Pending OD List Permission for profileId $profileIdNew: $pendingODListPermission");
          print("✅ Pending Attendance L1 MSS Permission for profileId $profileIdNew: $pendingAttendanceRequestMSSL1");
          print("✅ Pending Attendance L2 MSS Permission for profileId $profileIdNew: $pendingAttendanceRequestMSSL2");

          // 🟢 Save the UIS permission to SharedPreferences
          shared.setPendingAttendanceReqUISPermission(pendingAttReqUISPermValue);
          shared.setPendingLeaveReqUISPermission(leaveReqUISPermValue);
          shared.setPendingLeaveReqL1UISPermission(leaveReqL1UISPermValue);
          shared.setPendingLeaveReqL2UISPermission(leaveReqL2UISPermValue);
          shared.setOthersLeaveReqUISPermission(othersLeaveReqUISPermValue);
          shared.setClaimLevelOneUIS(pendingClaimL1UISPermission);
          shared.setClaimLevelTwoUIS(pendingClaimL2UISPermission);
          shared.setClaimLevelThreeUIS(pendingClaimL3UISPermission);
          shared.setODActivateUIS(odActivateUISPermission);
          shared.setODPendingListUIS(pendingODListUISPermission);
          shared.setPendingAttendanceReqL1UIS(pendingAttendanceRequestUISL1);
          shared.setPendingAttendanceReqL2UIS(pendingAttendanceRequestUISL2);
          print("✅ Attendance Permission for profileId $profileIdNew: $pendingAttReqUISPermValue");
          print("✅ Leave Permission for profileId $profileIdNew: $leaveReqUISPermValue");
          print("✅ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1UISPermValue");
          print("✅ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2UISPermValue");
          print("✅ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqUISPermValue");
          print("✅ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1UISPermission");
          print("✅ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2UISPermission");
          print("✅ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3UISPermission");
          print("✅ OD Activate Permission for profileId $profileIdNew: $odActivateUISPermission");
          print("✅ Pending OD List Permission for profileId $profileIdNew: $pendingODListUISPermission");
          print("✅ Pending Attendance L1 UIS Permission for profileId $profileIdNew: $pendingAttendanceRequestUISL1");
          print("✅ Pending Attendance L2 UIS Permission for profileId $profileIdNew: $pendingAttendanceRequestUISL2");*/
        }

        print('Profile Name $profileName');
        print('Profile Id $profileId');
        print('Default Profile $defaultProfile');
      }
    } setState(() {

    });
    empLength;
    roLength;
    adminlength;
    /*levelOne = "false";
    levelTwo = "false";
    pendingLeaveRequisitions = "false";
    shared.setLevelOne(levelOne);
    shared.setLevelTwo(levelTwo);
    shared.setPendingLeaveReq(pendingLeaveRequisitions);*/
    print("User Role Length - ${loginModelglobal!.data!.profileList!.length}");

    setState(() {

    });


    getSharedPrfanceList();
  }

  /*void setAdminSharedPrefValue(LoginModel? adminLoginModalGlobal) {
    setState(() {
      shared.setSessionId(adminLoginModalGlobal!.data!.sessionId!);
      shared.setName(adminLoginModalGlobal!.data!.userLoginned!.name);
      shared.setProfileImage(adminLoginModalGlobal!.data!.userImage);
      shared.setOrgId(adminLoginModalGlobal!.data!.orgId);
      shared.setEmailid(adminLoginModalGlobal!.data!.userLoginned!.userId);
      shared.setEmailid(adminLoginModalGlobal!.data!.roRole!.length);
      shared.setEmailid(adminLoginModalGlobal!.data!.adminrole!.length);
      shared.setEmpCode(loginModelglobal!.data!.empCode);
      shared.setEmpId(loginModelglobal!.data!.empId);
      shared.setDob(loginModelglobal!.data!.dob);
      shared.setUserType(loginModelglobal!.data!.userLoginned!.userType);
    });

    empRole = adminLoginModalGlobal!.data!.empRole!.length;
    empLength;
    roLength;
    adminlength;
    levelOne = "false";
    levelTwo = "false";
    pendingLeaveRequisitions = "false";
    shared.setLevelOne(levelOne);
    shared.setLevelTwo(levelTwo);
    shared.setPendingLeaveReq(pendingLeaveRequisitions);
    getSharedPrfanceList();
  }*/

  void saveLoginCredentials() {
    passwordChange.put("email", _username.text.trim());
    passwordChange.put("pass", _password.text.trim());
  }

/* void checkLoginOrNot() {
    if (sessionId != null || sessionId != "") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
    }
  }*/
}

