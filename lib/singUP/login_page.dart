import 'dart:async';
import 'dart:convert' show json, utf8;

import 'package:er_flutter_project/commanScreen/accountSuspend.dart';
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
import 'package:velocity_x/velocity_x.dart';

import '../adminPage/adminPanelScreen.dart';
import '../commanScreen/allAPIList.dart';
import '../commanScreen/commanNotificationPage.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../commanScreen/routes.dart';
import '../main.dart';
import '../sharedPrefancePage/ShardPre.dart';
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
String? pendingLeaveRequisitions;
bool accountExpired = false;

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
  Future<LoginModel> monthAttendance(String emailId, String password) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.login;
    changeButton = true;
    LoginModel loginModel;
    LoginFaild loginFaild;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "userName=$emailId&password=$password");
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
          //print('response Login ${loginModel.data!.sessionId}');
          //print('response {$loginValidation.toString()}');
          accountExpired = mapResponse['data']['expired'];
          print("Account Expired - $accountExpired");
          if(accountExpired == true) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AccountSuspendPage()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
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
    sessionId = await shared!.getSessionId();
    levelOne =await shared!.getLevelOne();
    levelTwo =await shared!.getLevelTwo();
    empLength=await shared!.getEmpRoll();
    roLength=await shared!.getRoRole();
    adminlength=await shared!.getAdminRole();

    claimLevelOne = await shared!.getClaimLevelOne();
    claimLevelTwo = await shared!.getClaimLevelTwo();
    claimLevelThree = await shared!.getClaimLevelThree();


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

        if(empLength == 1 || roLength == 1) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
        }
        else if(adminlength == 1){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminPanelScreen()));
        }


        /*else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
        }*/

      });
    }
    //print('Response snapshot login: ${sessionId}');
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
                                  suffixIcon: IconButton(
                                    icon: Icon(_showPassword
                                        ? CupertinoIcons.eye_fill
                                        : CupertinoIcons.eye_slash_fill),
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
                                            shared.setAdminRole(value!.data!.adminrole!.length);
                                            shared.setMobAction(value!.data!.mobAction!.length);
                                            shared.setEmpRoll(value!.data!.empRole!.length);
                                            shared.setRoRoll(value!.data!.roRole!.length);
                                            shared.setShowPayroll(loginModelglobal!.data!.userLoginned!.showPayroll);
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
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, MyRoutings.forgetPasswordEmailRoute);
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Forget Password / Reset Password ? ",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ).py4(),
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
    });

    shared.setEmpRoll(loginModelglobal!.data!.empRole!.length);
    shared.setMobAction(loginModelglobal!.data!.mobAction!.length);
    shared.setDoj(loginModelglobal!.data!.doj);
    shared.setShowPayroll(loginModelglobal!.data!.userLoginned!.showPayroll);
    shared.setEmpCode(loginModelglobal!.data!.empCode);

    var mobAction = loginModelglobal!.data!.mobAction!.length;
    shared.setUserRoles(loginModelglobal!.data!.userRoles![0]);
    print(loginModelglobal!.data!.userRoles![0]);



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
      attAction = shared.setAttAction(loginModelglobal!.data!.mobAction![i].attAction);
      mobileActions = shared.setMobAttAction(loginModelglobal!.data!.mobAction![i].mobAction);
      mobileTrackTime = shared.setMobTrackTime(loginModelglobal!.data!.mobAction![i].time);
      print('attActionSet $attAction');
      print('MobActionSet $mobileActions');
      print('MobTrackTime $mobileTrackTime');
    }
    empLength;
    roLength;
    adminlength;
    levelOne = "false";
    levelTwo = "false";
    pendingLeaveRequisitions = "false";
    shared.setLevelOne(levelOne);
    shared.setLevelTwo(levelTwo);
    shared.setPendingLeaveReq(pendingLeaveRequisitions);
  /*  print("User Role Length - ${loginModelglobal!.data!.userRoles!.length}");
    // Get the user roles list from API response
    shared.setUserRoles(loginModelglobal!.data!.userRoles![0]);
    print(" User Roles ${loginModelglobal!.data!.userRoles![0]}");*/

    setState(() {
      List<String>? userRoles = loginModelglobal?.data?.userRoles;

      // Check if the list contains "CLAIM_APPROVAL_LEVEL_THREE_VIEW"


      if(userRoles != null && userRoles.contains("LEVEL_ONE_LEAVE_APPROVE_ADD")) {
        print("resopnse LEVEL_ONE_LEAVE_APPROVE_ADD");
        levelOne = "true";
        shared.setLevelOne(levelOne);

      }
      if(userRoles != null && userRoles.contains("LEVEL_TWO_LEAVE_APPROVE_ADD")) {
        print("resopnse LEVEL_TWO_LEAVE_APPROVE_ADD");
        levelTwo = "true";
        shared.setLevelTwo(levelTwo);
      }
      if(userRoles != null && userRoles.contains("LEAVE_REQ_APPROVAL_ADD")) {
        print("resopnse LEAVE_REQ_APPROVAL_ADD");
        pendingLeaveRequisitions = "true";
        shared.setPendingLeaveReq(pendingLeaveRequisitions);
      }

      if(userRoles != null && userRoles.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW")) {
        print("resopnse CLAIM_APPROVAL_LEVEL_ONE_VIEW");
        claimLevelOne = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
        shared.setClaimLevelOne(claimLevelOne);

      } else {
        print("claimLevelOne else");
        claimLevelOne = "";
        shared.setClaimLevelOne(claimLevelOne);
      }
      if(userRoles != null && userRoles.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW")) {
        print("resopnse CLAIM_APPROVAL_LEVEL_TWO_VIEW");
        claimLevelTwo = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
        shared.setClaimLevelTwo(claimLevelTwo);

      } else {
        print("claimLevelTwo else");
        claimLevelTwo = "";
        shared.setClaimLevelTwo(claimLevelTwo);
      }
      if (userRoles != null && userRoles.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW")) {
        print("Response: CLAIM_APPROVAL_LEVEL_THREE_VIEW");
        claimLevelThree = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
        shared.setClaimLevelThree(claimLevelThree);
      } else {
        print("claimLevelThree else");
        claimLevelThree = "";
        shared.setClaimLevelThree(claimLevelThree);
      }
      if (userRoles != null && userRoles.contains("PRE_INDUCTION_ONBOARDING_ADD")) {
        print("Response: PRE_INDUCTION_ONBOARDING_ADD");
        preOnboardShow = "true";
        shared.setPreOnboardShow(preOnboardShow);
      } else {
        print("preOnboardShow else");
        preOnboardShow = "false";
        shared.setPreOnboardShow(preOnboardShow);
      }
      if (userRoles != null && userRoles.contains("EXIT_EMP_LIST_ADD")) {
        print("Response: EXIT_EMP_LIST_ADD");
        exitShow = "true";
        shared.setExitShow(exitShow);
      } else {
        print("exitShow else");
        exitShow = "false";
        shared.setExitShow(exitShow);
      }
      /*for(int i=0; i<loginModelglobal!.data!.userRoles!.length;i++){
        print(loginModelglobal!.data!.userRoles![i]);
      }*/
    });


    getSharedPrfanceList();
  }

  void setAdminSharedPrefValue(LoginModel? adminLoginModalGlobal) {
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
   /* for(int i=0; i<loginModelglobal!.data!.userRoles!.length;i++){
      print(loginModelglobal!.data!.userRoles![i]);

      if(loginModelglobal!.data!.userRoles![i].contains("LEVEL_ONE_LEAVE_APPROVE_ADD")) {
        print("resopnse LEVEL_ONE_LEAVE_APPROVE_ADD");
        levelOne = "true";
        shared.setLevelOne(levelOne);
      }

      if(loginModelglobal!.data!.userRoles![i].contains("LEVEL_TWO_LEAVE_APPROVE_ADD")) {
        print("resopnse LEVEL_TWO_LEAVE_APPROVE_ADD");
        levelTwo = "true";
        shared.setLevelTwo(levelTwo);
      }
      if(loginModelglobal!.data!.userRoles![i].contains("LEAVE_REQ_APPROVAL_ADD")) {
        print("resopnse LEAVE_REQ_APPROVAL_ADD");
        pendingLeaveRequisitions = "true";
        shared.setPendingLeaveReq(pendingLeaveRequisitions);
      }

      if(loginModelglobal!.data!.userRoles![i].contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW")) {
        print("resopnse CLAIM_APPROVAL_LEVEL_ONE_VIEW");
        claimLevelOne = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
        shared.setClaimLevelOne(claimLevelOne);

      }
      if(loginModelglobal!.data!.userRoles![i].contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW")) {
        print("resopnse CLAIM_APPROVAL_LEVEL_TWO_VIEW");
        claimLevelTwo = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
        shared.setClaimLevelTwo(claimLevelTwo);

      }
      if(loginModelglobal!.data!.userRoles![i].contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW")) {
        print("resopnse CLAIM_APPROVAL_LEVEL_THREE_VIEW");
        claimLevelThree = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
        shared.setClaimLevelThree(claimLevelThree);
      }
    }*/
    setState(() {
      List<String>? userRoles = loginModelglobal?.data?.userRoles;

      // Check if the list contains "CLAIM_APPROVAL_LEVEL_THREE_VIEW"


      if(userRoles != null && userRoles.contains("LEVEL_ONE_LEAVE_APPROVE_ADD")) {
        print("resopnse LEVEL_ONE_LEAVE_APPROVE_ADD");
        levelOne = "true";
        shared.setLevelOne(levelOne);

      }
      if(userRoles != null && userRoles.contains("LEVEL_TWO_LEAVE_APPROVE_ADD")) {
        print("resopnse LEVEL_TWO_LEAVE_APPROVE_ADD");
        levelTwo = "true";
        shared.setLevelTwo(levelTwo);
      }
      if(userRoles != null && userRoles.contains("LEAVE_REQ_APPROVAL_ADD")) {
        print("resopnse LEAVE_REQ_APPROVAL_ADD");
        pendingLeaveRequisitions = "true";
        shared.setPendingLeaveReq(pendingLeaveRequisitions);
      }

      if(userRoles != null && userRoles.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW")) {
        print("resopnse CLAIM_APPROVAL_LEVEL_ONE_VIEW");
        claimLevelOne = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
        shared.setClaimLevelOne(claimLevelOne);

      } else {
        print("claimLevelOne else");
        claimLevelOne = "";
        shared.setClaimLevelOne(claimLevelOne);
      }
      if(userRoles != null && userRoles.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW")) {
        print("resopnse CLAIM_APPROVAL_LEVEL_TWO_VIEW");
        claimLevelTwo = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
        shared.setClaimLevelTwo(claimLevelTwo);

      } else {
        print("claimLevelTwo else");
        claimLevelTwo = "";
        shared.setClaimLevelTwo(claimLevelTwo);
      }
      if (userRoles != null && userRoles.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW")) {
        print("Response: CLAIM_APPROVAL_LEVEL_THREE_VIEW");
        claimLevelThree = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
        shared.setClaimLevelThree(claimLevelThree);
      } else {
        print("claimLevelThree else");
        claimLevelThree = "";
        shared.setClaimLevelThree(claimLevelThree);
      }
      /*for(int i=0; i<loginModelglobal!.data!.userRoles!.length;i++){
        print(loginModelglobal!.data!.userRoles![i]);
      }*/
    });
    getSharedPrfanceList();
  }

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

