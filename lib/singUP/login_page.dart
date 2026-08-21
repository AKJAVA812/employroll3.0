import 'dart:async';
import 'dart:convert' show json;
import 'dart:io';

import 'package:er_flutter_project/commanScreen/accountSuspend.dart';
import 'package:er_flutter_project/singUP/resetPassword/forgetPasswordEmail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../adminPage/adminPanelScreen.dart';
import '../commanScreen/allAPIList.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../sharedPrefancePage/ShardPre.dart';
import '../services/mobile_auth_service.dart';
import '../services/mobile_http_client.dart';
import '../services/login_organisation_service.dart';
import '../services/mobile_panel_service.dart';
import '../sharedPrefancePage/sharedPreferenceCalendarMyRequest.dart';
import '../sharedPrefancePage/shared_preference_helper.dart';
import '../themes/empThemes.dart';
import 'model/adminLoginModal.dart';
import 'model/login_organisation.dart';
import 'model/loginModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
  bool _isPasswordStep = false;
  bool _lookupLoading = false;
  bool _logoLoadFailed = false;
  String _lookupError = '';
  String _resolvedLoginId = '';
  LoginOrganisation? _organisation;
  LoginModel? loginModelglobal;
  AdminLoginModal? adminLoginModalGlobal;
  late BuildContext buildContext;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  late Box passwordChange;
  SessionManager shared = SessionManager();
  Map<String, dynamic> mapResponse = {};
  var loginValidation = "";
  String? sessionId = "";

  final _formkey = GlobalKey<FormState>();

  Future<void> _findWorkspace() async {
    FocusScope.of(context).unfocus();
    if (!(_formkey.currentState?.validate() ?? false)) return;

    final internetAvailable =
        await InternetConnectionChecker().hasConnection;
    if (!internetAvailable) {
      showDialgErro(context, 'Please check your internet connection.');
      return;
    }

    setState(() {
      _lookupLoading = true;
      _lookupError = '';
    });

    try {
      final organisation = await LoginOrganisationService.instance.lookup(
        _username.text,
      );
      if (!mounted) return;
      setState(() {
        _organisation = organisation;
        _resolvedLoginId = organisation.loginId.isNotEmpty
            ? organisation.loginId
            : _username.text.trim();
        _isPasswordStep = true;
        _lookupLoading = false;
        _logoLoadFailed = false;
        _lookupError = '';
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _passwordFocusNode.requestFocus();
      });
    } on LoginOrganisationException catch (error) {
      if (!mounted) return;
      setState(() {
        _lookupLoading = false;
        _lookupError = '';
      });
      showDialgErro(context, error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _lookupLoading = false;
        _lookupError = '';
      });
      showDialgErro(
        context,
        'Unable to check your workspace. Please try again.',
      );
    }
  }

  void _changeIdentifier() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isPasswordStep = false;
      _organisation = null;
      _resolvedLoginId = '';
      _password.clear();
      _lookupError = '';
      changeButton = false;
      _logoLoadFailed = false;
    });
  }

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

    shared.setAppVersion(version);
  }

  final loading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CircularProgressIndicator(),
      Text(" Login ... Please wait"),
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
    /*var urlapi = Uri.parse("$conn$apiUrl?"
        "userName=$emailId&password=$password");*/
    var urlapi = Uri.parse(
      "$conn$apiUrl?username=${Uri.encodeComponent(emailId)}&password=${Uri.encodeComponent(password)}",
    );
    /*var urlapi = Uri.parse(
        "http://www.employroll.com/restful/service/login?userName=$emailId&password=$password");*/
    /*  final response= await MobileHttpClient.instance.get(urlapi,headers: {
      "email": emailId,
      "password": password
    });*/
    /* empRole= await shared.getEmpRoll();
    roRole= await shared.getRoRole();
    adminRole= await shared.getAdminRole();
    print('EmpRoleChecks $empRole');
    print('roRole $roRole');
    print('adminRole $adminRole');*/
    final response = await MobileHttpClient.instance.post(urlapi);
    //print('Response body: ${response.body}');
    mapResponse = json.decode(response.body);
    loginModel = LoginModel.fromJson(Map<String, dynamic>.from(mapResponse));
    final loginData = loginModel.data!;

    if (!loginModel.isSuccess) {
      final dataResponse = mapResponse['data'];
      final errorMessage =
          dataResponse is Map<String, dynamic>
              ? (dataResponse['reason'] ??
                  mapResponse['message'] ??
                  'Login failed')
              : (mapResponse['message'] ?? 'Login failed');
      showDialgErro(buildContext, errorMessage.toString());
      setState(() {
        changeButton = false;
      });
      return loginModel;
    }

    final getEmpData = loginData.empRole ?? <String>[];
    final getRoData = loginData.roRole ?? <String>[];
    final getAdminData = loginData.adminrole ?? <String>[];

    setState(() {
      empLength = getEmpData.length;
      roLength = getRoData.length;
      adminlength = getAdminData.length;
    });

    try {
      if (response.statusCode == 200) {
        setState(() {
          accountExpired = loginData.expired ?? false;

          SharedPrefHelper.clearApiCacheOnLogin();
          SharedPrefHelperMyRequest.clearApiCacheOnLogin();
        });
      } else {
        showDialgErro(
          buildContext,
          loginModel.message ?? 'Please check your internet connection.',
        );
      }
    } catch (e) {
    }

    // shared?.setSessionId(loginModel!.data!.sessionId);
    // getSharedPrfanceList();
    return loginModel;
  }

  Future<AdminLoginModal> adminPanel(String emailId, String password) async {
    AdminLoginModal adminLoginModal;
    var urlapi = Uri.parse(
      "http://www.employroll.com/restful/service/login?userName=$emailId&password=$password",
    );

    final response = await MobileHttpClient.instance.get(urlapi);
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminPanelScreen()),
          );
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
    setState(() {});
    levelOne = await shared.getLevelOne();
    levelTwo = await shared.getLevelTwo();
    empLength = await shared.getEmpRoll();
    roLength = await shared.getRoRole();
    adminlength = await shared.getAdminRole();

    claimLevelOne = await shared.getClaimLevelOne();
    claimLevelTwo = await shared.getClaimLevelTwo();
    claimLevelThree = await shared.getClaimLevelThree();

    if (sessionId != null && sessionId != "") {
      setState(() {
        //print('response Login ${loginModel.data!.sessionId}');
        //print('response {$loginValidation.toString()}');

        /*  accountExpired = mapResponse['data']['expired'] ?? false;
        //accountExpired = mapResponse['data']['expired'];
        print("Account Expired - $accountExpired");
        if(accountExpired == true) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AccountSuspendPage()));
        } else {

        }*/
        if (mapResponse['data'] != null) {
          accountExpired = mapResponse['data']['expired'] ?? false;
          if (accountExpired == true) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountSuspendPage()),
            );
          }
        } else {
          if (empLength == 1 || roLength == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PunchInOUtActivity(selectedIndex: 0),
              ),
            );
          } else if (adminlength == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminPanelScreen()),
            );
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
    final storeUrl =
        isAndroid
            ? 'https://play.google.com/store/apps/details?id=com.employroll.employroll' // Ã¢Å“â€¦ Replace with your Play Store URL
            : 'https://apps.apple.com/in/app/employroll-2-0/id1664350846'; // Ã¢Å“â€¦ Replace with your App Store ID

    final message =
        isAndroid
            ? 'A new version of the app is available on the Play Store. Please update your app to continue.'
            : 'A new version of the app is available on the App Store. Please update your app to continue.';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Update Available'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(storeUrl))) {
                    launchUrl(
                      Uri.parse(storeUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open store.')),
                    );
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
    setState(() {});

    createIdpass();
    //checkLoginOrNot();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
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
        "firebaseId=$fcmToken",
      );


      // Send POST request
      final response = await MobileHttpClient.instance.post(urlapi);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
      } else {

        // Retry logic (similar to your Android code)
        //await sendGeoFenceId(sessionId, geofenceTokenId);
      }
    } catch (e) {

      // Retry on error
      //await sendGeoFenceId(sessionId, geofenceTokenId);
    }
  }

  Widget _buildDefaultLoginHeader() {
    if (!_isPasswordStep) {
      return Image.asset(
        'assets/images/employroll_logo_flutter_login_page.png',
        height: 150,
        width: 190,
      );
    }

    return Container(
      height: 230,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF18245C), Color(0xFF4F63D9)],
        ),
      ),
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/employroll_logo_flutter_login_page.png',
        height: 120,
        width: 160,
      ),
    );
  }

  Widget _buildOrganisationIdentity() {
    final organisation = _organisation!;
    final hasLogo = organisation.logoUrl.isNotEmpty && !_logoLoadFailed;

    Widget fallbackLogo() => CircleAvatar(
      radius: 48,
      backgroundColor: Mythemes.lightBluishColor,
      child: Text(
        organisation.initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return Column(
      children: [
        if (hasLogo)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              organisation.logoUrl,
              height: 96,
              width: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => fallbackLogo(),
            ),
          )
        else
          fallbackLogo(),
        const SizedBox(height: 12),
        Text(
          'Sign in to',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Text(
          organisation.orgName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: _changeIdentifier,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_outline, size: 18),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    _username.text.trim(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 7),
                const Icon(Icons.edit_outlined, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitPasswordLogin() async {
    FocusScope.of(context).unfocus();
    if (!(_formkey.currentState?.validate() ?? false)) return;

    final internetAvailable =
        await InternetConnectionChecker().hasConnection;
    if (!internetAvailable) {
      showDialgErro(context, 'Please check your internet connection.');
      return;
    }

    setState(() {
      changeButton = true;
      _lookupError = '';
    });

    try {
      saveLoginCredentials();
      final value = await monthAttendance(
        _resolvedLoginId.isNotEmpty
            ? _resolvedLoginId
            : _username.text.trim(),
        _password.text,
      );
      if (!value.isSuccess) return;

      loginModelglobal = value;
      if (value.data?.expired == true) {
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountSuspendPage()),
        );
        if (mounted) setState(() => changeButton = false);
        return;
      }

      if (!_hasAnyMobilePermission(value)) {
        if (!mounted) return;
        setState(() => changeButton = false);
        showDialgErro(
          context,
          'No mobile permissions are assigned to your account. Please contact your administrator.',
        );
        return;
      }

      shared.setAdminRole(value.data!.adminrole!.length);
      shared.setMobAction(value.data!.mobAction!.length);
      shared.setEmpRoll(value.data!.empRole!.length);
      shared.setRoRoll(value.data!.roRole!.length);
      shared.setShowPayroll(value.data!.userLoginned!.showPayroll);

      if (value.data!.adminrole!.isNotEmpty &&
          value.data!.empRole!.isEmpty &&
          value.data!.roRole!.isEmpty) {
        await setAdminSharedPrefValue(value);
      } else {
        await setSharedPrefanceValue(value);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => changeButton = false);
      showDialgErro(
        context,
        'Unable to sign in. Please check your details and try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    final loginImageUrl = _organisation?.loginImageUrl.trim() ?? '';
    final hasLoginBackground = _isPasswordStep && loginImageUrl.isNotEmpty;

    return MaterialApp(
      color: Colors.white,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (hasLoginBackground)
              Image.network(
                loginImageUrl,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.18),
                colorBlendMode: BlendMode.darken,
                errorBuilder: (context, error, stackTrace) =>
                    const ColoredBox(color: Colors.white),
              )
            else
              const ColoredBox(color: Colors.white),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 40,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 32,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(
                                hasLoginBackground ? 0.94 : 1,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: hasLoginBackground
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x33000000),
                                        blurRadius: 28,
                                        offset: Offset(0, 12),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Form(
                              key: _formkey,
                              child: AutofillGroup(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!_isPasswordStep) ...[
                                      _buildDefaultLoginHeader(),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Welcome back',
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Find your EmployRoll workspace',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 28),
                                    ],
                                    if (_isPasswordStep) ...[
                                      _buildOrganisationIdentity(),
                                      const SizedBox(height: 28),
                                    ],
                                    if (!_isPasswordStep)
                                      TextFormField(
                                        enableSuggestions: true,
                                        keyboardType: TextInputType.text,
                                        autofillHints: const [
                                          AutofillHints.username,
                                        ],
                                        controller: _username,
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (_) async {
                                          if (!_lookupLoading) {
                                            await _findWorkspace();
                                          }
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            CupertinoIcons.profile_circled,
                                            size: 20,
                                            color: Mythemes.black,
                                          ),
                                          hintText:
                                              'Enter email, mobile or user ID',
                                          labelText:
                                              'Email, mobile number or user ID',
                                        ),
                                        onChanged: (value) {
                                          name = value;
                                          setState(() {});
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Email, mobile number, or user ID is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    if (_isPasswordStep)
                                      TextFormField(
                                        autofillHints: const [
                                          AutofillHints.password,
                                        ],
                                        keyboardType: TextInputType.text,
                                        controller: _password,
                                        focusNode: _passwordFocusNode,
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (_) async {
                                          if (!changeButton) {
                                            await _submitPasswordLogin();
                                          }
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.security,
                                            size: 20,
                                            color: Mythemes.black,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _showPassword
                                                  ? CupertinoIcons.eye_fill
                                                  : CupertinoIcons
                                                      .eye_slash_fill,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _showPassword = !_showPassword;
                                              });
                                            },
                                          ),
                                          hintText: 'Enter password',
                                          labelText: 'Password',
                                        ),
                                        obscureText: _showPassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Password is required';
                                          } else if (value.length < 6) {
                                            return 'Password must be at least 6 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                    if (_isPasswordStep)
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPasswordEmailPage(),
                                            ),
                                          );
                                        },
                                        child: const Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'Forgot Password?',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ).py4(),
                                      ),
                                    SizedBox(
                                      height: _isPasswordStep ? 28 : 48,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: (changeButton || _lookupLoading)
                                          ? 50
                                          : 180,
                                      child: Material(
                                        elevation: 5,
                                        color: Mythemes.lightBluishColor,
                                        borderRadius: BorderRadius.circular(
                                          (changeButton || _lookupLoading)
                                              ? 150
                                              : 20,
                                        ),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            (changeButton || _lookupLoading)
                                                ? 150
                                                : 20,
                                          ),
                                          onTap: () async {
                                            if (_lookupLoading || changeButton) {
                                              return;
                                            }
                                            if (!_isPasswordStep) {
                                              await _findWorkspace();
                                              return;
                                            }
                                            await _submitPasswordLogin();
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            alignment: Alignment.center,
                                            child:
                                                (changeButton || _lookupLoading)
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                          10,
                                                        ),
                                                        child:
                                                            CircularProgressIndicator(
                                                          color:
                                                              Mythemes.whitish,
                                                          strokeWidth: 3,
                                                        ),
                                                      )
                                                    : Text(
                                                        _isPasswordStep
                                                            ? 'Sign In'
                                                            : 'Continue',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDialgErro(BuildContext buildContext, Object? result) {
    if (!mounted) return;

    // Stop loaders only. Keep the entered identifier and password available so
    // the user can correct/retry the login without typing everything again.
    setState(() {
      changeButton = false;
      _lookupLoading = false;
      _lookupError = '';
    });

    showDialog<void>(
      context: buildContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded),
              SizedBox(width: 10),
              Expanded(child: Text('Unable to continue')),
            ],
          ),
          content: Text(
            result?.toString() ?? 'Something went wrong. Please try again.',
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          buttonPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
          elevation: 24.0,
        );
      },
    );
  }

  bool _hasAnyMobilePermission(LoginModel loginModel) {
    final data = loginModel.data;
    final profiles = <ProfileList>[
      ...loginModel.profiles,
      ...?data?.profileList,
    ];
    final hasProfilePermission = profiles.any(
      (profile) => profile.profilePermission.isNotEmpty,
    );
    final hasEssPermission =
        loginModel.essPermissions?.securityGroupIds.isNotEmpty == true;
    final hasLegacyAccess =
        data?.empRole?.isNotEmpty == true ||
        data?.roRole?.isNotEmpty == true ||
        data?.adminrole?.isNotEmpty == true;

    return loginModel.permissions.isNotEmpty ||
        hasEssPermission ||
        hasProfilePermission ||
        hasLegacyAccess;
  }

  Future<void> saveMobileAuth(LoginModel? loginModelglobal) async {
    if (loginModelglobal == null) return;
    await shared.clearMobileAuth();
    final mobileSessionId =
        loginModelglobal.data?.sessionId ?? loginModelglobal.session?.sessionId;
    await shared.setAccessToken(
      loginModelglobal.accessToken ?? loginModelglobal.data?.accessToken,
    );
    await shared.setTokenType(
      loginModelglobal.tokenType ??
          loginModelglobal.data?.tokenType ??
          'Bearer',
    );
    await shared.setPermissionsVersion(
      loginModelglobal.permissionsVersion ??
          loginModelglobal.data?.permissionsVersion,
    );
    await shared.setProfileVersion(
      loginModelglobal.profileVersion ?? loginModelglobal.data?.profileVersion,
    );
    await shared.setSessionId(mobileSessionId ?? '');
    await shared.setMobileSessionId(mobileSessionId ?? '');
    await shared.setLoginResponseJson(json.encode(loginModelglobal.toJson()));
    MobileHttpClient.instance.markAuthenticated();
    MobileAuthService.instance.syncAfterLogin(
      accessToken:
          loginModelglobal.accessToken ?? loginModelglobal.data?.accessToken,
      sessionId: mobileSessionId,
      tokenType:
          loginModelglobal.tokenType ??
          loginModelglobal.data?.tokenType ??
          'Bearer',
    );
  }

  Future<void> setSharedPrefanceValue(LoginModel loginModelglobal) async {
    await saveMobileAuth(loginModelglobal);
    await MobilePanelService.bootstrapFromLogin(loginModelglobal);
    final mobileSessionId =
        loginModelglobal.data?.sessionId ?? loginModelglobal.session?.sessionId;
    setState(() {
      shared.setSessionId(mobileSessionId ?? "");
      shared.setDept(loginModelglobal.data!.department);
      shared.setName(loginModelglobal.data!.userLoginned!.name);
      shared.setProfileImage(loginModelglobal.data!.userImage);
      shared.setOrgId(loginModelglobal.data!.orgId);
      shared.setOrgName(loginModelglobal.data!.orgName ?? '');
      shared.setEmailid(loginModelglobal.data!.userLoginned!.userId);
      shared.setDob(loginModelglobal.data!.dob);
      shared.setMobileNo(loginModelglobal.data!.contact);
      shared.setDesignation(loginModelglobal.data!.designation);
      shared.setBranch(loginModelglobal.data!.branch);
      shared.setAadhar(loginModelglobal.data!.aadharNo);
      shared.setPfNo(loginModelglobal.data!.pfNo);
      shared.setEsicNo(loginModelglobal.data!.esicNo);
      shared.setBankName(loginModelglobal.data!.bankName);
      shared.setBankAccount(loginModelglobal.data!.bankAccNo);
      shared.setAccountHolderName(loginModelglobal.data!.accountHolderName);
      shared.setBankIfsc(loginModelglobal.data!.ifscCode);
      shared.setEmpId(loginModelglobal.data!.empId);
      shared.setEmployeeDetailsId(
        loginModelglobal.data!.employeeDetailsId ?? loginModelglobal.data!.empId,
      );
      shared.setEmployeeId(loginModelglobal.data!.employeeId);
      shared.setRaiseRequisition(loginModelglobal.data!.raisedDate);
      shared.setApprovalRequisition(loginModelglobal.data!.approvedDate);
      shared.setUserType(loginModelglobal.data!.userLoginned!.userType);

      shared.setUserPanel(loginModelglobal.data!.userPanel);
      userPanel = loginModelglobal.data!.userPanel;
      shared.setEnrollId(loginModelglobal.data!.enrollId);

      if (loginModelglobal.data!.startDate == null) {
        startPayCycle = "0";
        shared.setPayCycleStart(startPayCycle);
        //print("If Null Show 0 - $startPayCycle");
      } else {
        startPayCycle = loginModelglobal.data!.startDate;
        shared.setPayCycleStart(startPayCycle);
        //print("Else Show value - $startPayCycle");
      }
      if (loginModelglobal.data!.endDate == null) {
        endPayCycle = "0";
        shared.setPayCycleEnd(endPayCycle);
      } else {
        endPayCycle = loginModelglobal.data!.endDate;
        shared.setPayCycleEnd(endPayCycle);
      }
    });

    setState(() {});

    shared.setEmpRoll(loginModelglobal.data!.empRole!.length);
    shared.setMobAction(loginModelglobal.data!.mobAction!.length);
    shared.setDoj(loginModelglobal.data!.doj);
    shared.setShowPayroll(loginModelglobal.data!.userLoginned!.showPayroll);
    shared.setEmpCode(loginModelglobal.data!.empCode);
    shared.setEmployeeDetailsId(
      loginModelglobal.data!.employeeDetailsId ?? loginModelglobal.data!.empId,
    );
    shared.setEmployeeId(loginModelglobal.data!.employeeId);
    shared.setRoRoll(loginModelglobal.data!.roRole!.length);
    roRole = loginModelglobal.data!.roRole!.length;
    shared.setAdminRole(loginModelglobal.data!.adminrole!.length);

    adminRoleChcker = loginModelglobal.data!.adminrole!.length;
    for (int i = 0; i < loginModelglobal.data!.mobAction!.length; i++) {
      geofenceActive = shared.setGeofenceActive(
        loginModelglobal.data!.mobAction![i].geofenceActive,
      );
      attAction = shared.setAttAction(
        loginModelglobal.data!.mobAction![i].attAction,
      );
      mobileActions = shared.setMobAttAction(
        loginModelglobal.data!.mobAction![i].mobAction,
      );
      mobileTrackTime = shared.setMobTrackTime(
        loginModelglobal.data!.mobAction![i].time,
      );
    }

    if (userPanel == "COMPANY_EMPLOYEE") {
      // Clear profile ID and name in SharedPreferences
      shared.setDefaultProfileName('');
      shared.setDefaultProfileId(0); // or '' if you're treating it as a String
    } else {
      // Loop through profiles and save default one
      for (int i = 0; i < loginModelglobal.data!.profileList!.length; i++) {
        profileName = loginModelglobal.data!.profileList![i].profileName;
        profileId = loginModelglobal.data!.profileList![i].profileId;
        defaultProfile = loginModelglobal.data!.profileList![i].defaultProfile;

        if (defaultProfile == true ||
            loginModelglobal.data!.profileList![i].isDefaultProfile == true) {
          String profileNameNew =
              loginModelglobal.data!.profileList![i].profileName ?? '';
          dynamic profileIdNew =
              loginModelglobal.data!.profileList![i].profileId;
          shared.setDefaultProfileName(profileNameNew);
          shared.setDefaultProfileId(profileIdNew);

          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_ONE_LEAVE_APPROVE_ADD",
              ) ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD",
              )) {
            //levelOne = "true";
            shared.setLevelOne("true");
          } else {
            //levelOne = "false";
            shared.setLevelOne("false");
          }

          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_TWO_LEAVE_APPROVE_ADD",
              ) ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD",
              ) ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                "FINAL_LEVEL_LEAVE_APPROVE_MYTEAM_ADD",
              )) {
            //levelTwo = "true";
            shared.setLevelTwo("true");
          } else {
            //levelTwo = "false";
            shared.setLevelTwo("false");
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "LEAVE_REQ_APPROVAL_ADD",
          )) {
            //pendingLeaveRequisitions = "true";
            shared.setPendingLeaveReq("true");
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
          )) {
            //claimLevelOne = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
            shared.setClaimLevelOne("CLAIM_APPROVAL_LEVEL_ONE_VIEW");
          } else {
            //claimLevelOne = "";
            shared.setClaimLevelOne("");
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
          )) {
            //claimLevelTwo = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
            shared.setClaimLevelTwo("CLAIM_APPROVAL_LEVEL_TWO_VIEW");
          } else {
            //claimLevelTwo = "";
            shared.setClaimLevelTwo("");
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
          )) {
            //claimLevelThree = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
            shared.setClaimLevelThree("CLAIM_APPROVAL_LEVEL_THREE_VIEW");
          } else {
            //claimLevelThree = "";
            shared.setClaimLevelThree("");
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "PRE_INDUCTION_ONBOARDING_ADD",
          )) {
            //preOnboardShow = "true";
            shared.setPreOnboardShow("true");
          } else {
            //preOnboardShow = "false";
            shared.setPreOnboardShow("false");
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "EXIT_EMP_LIST_ADD",
          )) {
            //exitShow = "true";
            shared.setExitShow("true");
          } else {
            //exitShow = "false";
            shared.setExitShow("false");
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "HRIS_EMP_LIST_VIEW",
          )) {
            //myTeamShow = "true";
            shared.setMyTeamShow("true");
            shared.setMyTeamPageShow("1");
          } else {
            //myTeamShow = "false";
            shared.setMyTeamShow("false");
            shared.setMyTeamPageShow("0");
          }

          //Exit Permission setter
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "EXIT_RESIGN_REQUEST_LIST_VIEW",
          )) {
            //exitResignationListShow = "true";
            //exitResignationListView = "1";
            shared.setExitResignationListShow("true");
            shared.setExitResignationListView("1");
          } else {
            //exitResignationListShow = "false";
            //exitResignationListView = "0";
            shared.setExitResignationListShow("false");
            shared.setExitResignationListView("0");
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD",
          )) {
            //exitResignationApproveL1Show = "true";
            shared.setExitResignationApproveL1Show("true");
          } else {
            //exitResignationApproveL1Show = "false";
            shared.setExitResignationApproveL1Show("false");
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD",
          )) {
            //exitResignationApproveL2Show = "true";
            shared.setExitResignationApproveL2Show("true");
          } else {
            //exitResignationApproveL2Show = "false";
            shared.setExitResignationApproveL2Show("false");
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE",
          )) {
            //exitResignationDisApproveL1Show = "true";
            shared.setExitResignationDisApproveL1Show("true");
          } else {
            //exitResignationDisApproveL1Show = "false";
            shared.setExitResignationDisApproveL1Show("false");
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE",
          )) {
            //exitResignationDisApproveL2Show = "true";
            shared.setExitResignationDisApproveL2Show("true");
          } else {
            //exitResignationDisApproveL2Show = "false";
            shared.setExitResignationDisApproveL2Show("false");
          }

          //MSS MO
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Pending Attendance Request permission
          /*String pendingAttReqMOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqMSSMOPermission("1");
          } else {
            shared.setPendingAttendanceReqMSSMOPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request permission
          /*String leaveReqMOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEAVE_REQ_APPROVAL_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEAVE_REQ_APPROVAL_MO_ADD",
                  ) ==
                  true ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEAVE_REQ_MYTEAM_ADD",
                  ) ==
                  true) {
            shared.setPendingLeaveReqMSSMOPermission("1");
          } else {
            shared.setPendingLeaveReqMSSMOPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L1 permission
          /*String leaveReqL1MOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_ONE_LEAVE_APPROVE_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEVEL_ONE_LEAVE_APPROVE_MO_ADD",
                  ) ==
                  true ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD",
                  ) ==
                  true) {
            shared.setPendingLeaveReqL1MSSMOPermission("1");
          } else {
            shared.setPendingLeaveReqL1MSSMOPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
          /*String leaveReqL2MOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_TWO_LEAVE_APPROVE_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEVEL_TWO_LEAVE_APPROVE_MO_ADD",
                  ) ==
                  true ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD",
                  ) ==
                  true ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "FINAL_LEVEL_LEAVE_APPROVE_MO_ADD",
                  ) ==
                  true) {
            shared.setPendingLeaveReqL2MSSMOPermission("1");
          } else {
            shared.setPendingLeaveReqL2MSSMOPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
          /*String othersLeaveReqMOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("OTHERS_LEAVE_REQUEST_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "OTHERS_LEAVE_REQUEST_MO_ADD",
              ) ==
              true) {
            shared.setOthersLeaveReqMSSMOPermission("1");
          } else {
            shared.setOthersLeaveReqMSSMOPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L1 permission
          /*String pendingClaimL1MOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
              ) ==
              true) {
            shared.setClaimLevelOneMO("1");
          } else {
            shared.setClaimLevelOneMO("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L2 permission
          /*String pendingClaimL2MOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
              ) ==
              true) {
            shared.setClaimLevelTwoMO("1");
          } else {
            shared.setClaimLevelTwoMO("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L3 permission
          /*String pendingClaimL3MOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
              ) ==
              true) {
            shared.setClaimLevelThreeMO("1");
          } else {
            shared.setClaimLevelThreeMO("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
          /* String pendingODListMOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "MOBILE_OD_PENDING_REQ_ADD",
              ) ==
              true) {
            shared.setODPendingListMO("1");
          } else {
            shared.setODPendingListMO("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
          /*String odActivateMOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "MOBILE_OD_ACTIVATE_ADD",
              ) ==
              true) {
            shared.setODActivateMO("1");
          } else {
            shared.setODActivateMO("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
          /*String pendingAttendanceRequestMOL1 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATT_APP_ONE_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqL1MO("1");
          } else {
            shared.setPendingAttendanceReqL1MO("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
          /* String pendingAttendanceRequestMOL2 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATT_APP_TWO_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqL2MO("1");
          } else {
            shared.setPendingAttendanceReqL2MO("0");
          }

          //MSS
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Pending Attendance Request permission
          /*String pendingAttReqMSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATTENDANCE_REQ_APPROVAL_DETAILS_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqMSSPermission("1");
          } else {
            shared.setPendingAttendanceReqMSSPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request permission
          /*String leaveReqMSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEAVE_REQ_APPROVAL_ADD") || loginModelglobal.data!.profileList![i].profilePermission.contains("LEAVE_APP_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEAVE_REQ_APPROVAL_ADD",
                  ) ==
                  true ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEAVE_APP_MYTEAM_ADD",
                  ) ==
                  true) {
            shared.setPendingLeaveReqMSSPermission("1");
          } else {
            shared.setPendingLeaveReqMSSPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L1 permission
          /*String leaveReqL1MSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") || loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEVEL_ONE_LEAVE_APPROVE_ADD",
                  ) ==
                  true ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD",
                  ) ==
                  true) {
            shared.setPendingLeaveReqL1MSSPermission("1");
          } else {
            shared.setPendingLeaveReqL1MSSPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
          /*String leaveReqL2MSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") || loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEVEL_TWO_LEAVE_APPROVE_ADD",
                  ) ==
                  true ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD",
                  ) ==
                  true) {
            shared.setPendingLeaveReqL2MSSPermission("1");
          } else {
            shared.setPendingLeaveReqL2MSSPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
          /* String othersLeaveReqMSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "OTHERS_LEAVE_REQUEST_ADD",
              ) ==
              true) {
            shared.setOthersLeaveReqMSSPermission("1");
          } else {
            shared.setOthersLeaveReqMSSPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L1 permission
          /* String pendingClaimL1Permission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
              ) ==
              true) {
            shared.setClaimLevelOne("1");
          } else {
            shared.setClaimLevelOne("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L2 permission
          /*String pendingClaimL2Permission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
              ) ==
              true) {
            shared.setClaimLevelTwo("1");
          } else {
            shared.setClaimLevelTwo("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L3 permission
          /*String pendingClaimL3Permission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
              ) ==
              true) {
            shared.setClaimLevelThree("1");
          } else {
            shared.setClaimLevelThree("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
          /*String pendingODListPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "MOBILE_OD_PENDING_REQ_ADD",
              ) ==
              true) {
            shared.setODPendingList("1");
          } else {
            shared.setODPendingList("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
          /*String odActivatePermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "MOBILE_OD_ACTIVATE_ADD",
              ) ==
              true) {
            shared.setODActivate("1");
          } else {
            shared.setODActivate("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
          /*String pendingAttendanceRequestMSSL1 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATT_APP_ONE_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqL1MSS("1");
          } else {
            shared.setPendingAttendanceReqL1MSS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
          /*String pendingAttendanceRequestMSSL2 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATT_APP_TWO_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqL2MSS("1");
          } else {
            shared.setPendingAttendanceReqL2MSS("0");
          }

          //USER
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Pending Attendance Request permission
          /*String pendingAttReqUISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATTENDANCE_REQ_APPROVAL_DETAILS_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqUISPermission("1");
          } else {
            shared.setPendingAttendanceReqUISPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request permission
          /*String leaveReqUISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEAVE_REQ_APPROVAL_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEAVE_REQ_APPROVAL_ADD",
              ) ==
              true) {
            shared.setPendingLeaveReqUISPermission("1");
          } else {
            shared.setPendingLeaveReqUISPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L1 permission
          /*String leaveReqL1UISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_ONE_LEAVE_APPROVE_ADD",
              ) ==
              true) {
            shared.setPendingLeaveReqL1UISPermission("1");
          } else {
            shared.setPendingLeaveReqL1UISPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
          /*String leaveReqL2UISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_TWO_LEAVE_APPROVE_ADD",
              ) ==
              true) {
            shared.setPendingLeaveReqL2UISPermission("1");
          } else {
            shared.setPendingLeaveReqL2UISPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
          /*String othersLeaveReqUISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "OTHERS_LEAVE_REQUEST_ADD",
              ) ==
              true) {
            shared.setOthersLeaveReqUISPermission("1");
          } else {
            shared.setOthersLeaveReqUISPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L1 permission
          /*String pendingClaimL1UISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
              ) ==
              true) {
            shared.setClaimLevelOneUIS("1");
          } else {
            shared.setClaimLevelOneUIS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L2 permission
          /*String pendingClaimL2UISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
              ) ==
              true) {
            shared.setClaimLevelTwoUIS("1");
          } else {
            shared.setClaimLevelTwoUIS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L3 permission
          /*String pendingClaimL3UISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
              ) ==
              true) {
            shared.setClaimLevelThreeUIS("1");
          } else {
            shared.setClaimLevelThreeUIS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
          /*String pendingODListUISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "MOBILE_OD_PENDING_REQ_ADD",
              ) ==
              true) {
            shared.setODPendingListUIS("1");
          } else {
            shared.setODPendingListUIS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
          /*String odActivateUISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "MOBILE_OD_ACTIVATE_ADD",
              ) ==
              true) {
            shared.setODActivateUIS("1");
          } else {
            shared.setODActivateUIS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
          /*String pendingAttendanceRequestUISL1 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATT_APP_ONE_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqL1UIS("1");
          } else {
            shared.setPendingAttendanceReqL1UIS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
          /*String pendingAttendanceRequestUISL2 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATT_APP_TWO_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqL2UIS("1");
          } else {
            shared.setPendingAttendanceReqL2UIS("0");
          }
        }

      }
    }
    setState(() {});
    empLength;
    roLength;
    adminlength;
    /*levelOne = "false";
    levelTwo = "false";
    pendingLeaveRequisitions = "false";
    shared.setLevelOne(levelOne);
    shared.setLevelTwo(levelTwo);
    shared.setPendingLeaveReq(pendingLeaveRequisitions);*/

    setState(() {});

    getSharedPrfanceList();
  }

  Future<void> setAdminSharedPrefValue(LoginModel loginModelglobal) async {
    await saveMobileAuth(loginModelglobal);
    await MobilePanelService.bootstrapFromLogin(loginModelglobal);
    final mobileSessionId =
        loginModelglobal.data?.sessionId ?? loginModelglobal.session?.sessionId;
    setState(() {
      shared.setSessionId(mobileSessionId ?? "");
      shared.setDept(loginModelglobal.data!.department);
      shared.setName(loginModelglobal.data!.userLoginned!.name);
      shared.setProfileImage(loginModelglobal.data!.userImage);
      shared.setOrgId(loginModelglobal.data!.orgId);
      shared.setOrgName(loginModelglobal.data!.orgName ?? '');
      shared.setEmailid(loginModelglobal.data!.userLoginned!.userId);
      shared.setDob(loginModelglobal.data!.dob);
      shared.setMobileNo(loginModelglobal.data!.contact);
      shared.setDesignation(loginModelglobal.data!.designation);
      shared.setBranch(loginModelglobal.data!.branch);
      shared.setAadhar(loginModelglobal.data!.aadharNo);
      shared.setPfNo(loginModelglobal.data!.pfNo);
      shared.setEsicNo(loginModelglobal.data!.esicNo);
      shared.setBankName(loginModelglobal.data!.bankName);
      shared.setBankAccount(loginModelglobal.data!.bankAccNo);
      shared.setAccountHolderName(loginModelglobal.data!.accountHolderName);
      shared.setBankIfsc(loginModelglobal.data!.ifscCode);
      shared.setEmpId(loginModelglobal.data!.empId);
      shared.setEmployeeDetailsId(
        loginModelglobal.data!.employeeDetailsId ?? loginModelglobal.data!.empId,
      );
      shared.setEmployeeId(loginModelglobal.data!.employeeId);
      shared.setUserType(loginModelglobal.data!.userLoginned!.userType);
      shared.setRaiseRequisition(loginModelglobal.data!.raisedDate);
      shared.setApprovalRequisition(loginModelglobal.data!.approvedDate);
      shared.setUserPanel(loginModelglobal.data!.userPanel);
      userPanel = loginModelglobal.data!.userPanel;
      shared.setEnrollId(loginModelglobal.data!.enrollId);

      if (loginModelglobal.data!.startDate == null) {
        startPayCycle = "0";
        shared.setPayCycleStart(startPayCycle);
      } else {
        startPayCycle = loginModelglobal.data!.startDate;
        shared.setPayCycleStart(startPayCycle);
      }

      if (loginModelglobal.data!.endDate == null) {
        endPayCycle = "0";
        shared.setPayCycleEnd(endPayCycle);
      } else {
        endPayCycle = loginModelglobal.data!.endDate;
        shared.setPayCycleEnd(endPayCycle);
      }
    });
    shared.setEmpRoll(loginModelglobal.data!.empRole!.length);
    shared.setMobAction(loginModelglobal.data!.mobAction!.length);
    shared.setDoj(loginModelglobal.data!.doj);
    shared.setShowPayroll(loginModelglobal.data!.userLoginned!.showPayroll);
    shared.setEmpCode(loginModelglobal.data!.empCode);
    shared.setEmpCode(loginModelglobal.data!.empCode);
    shared.setEmployeeDetailsId(
      loginModelglobal.data!.employeeDetailsId ?? loginModelglobal.data!.empId,
    );
    shared.setEmployeeId(loginModelglobal.data!.employeeId);
    /*shared.setUserRoles(loginModelglobal.data!.userRoles![0]);
    print(loginModelglobal.data!.userRoles![0]);*/

    shared.setRoRoll(loginModelglobal.data!.roRole!.length);
    shared.setAdminRole(loginModelglobal.data!.adminrole!.length);

    adminRoleChcker = loginModelglobal.data!.adminrole!.length;
    for (int i = 0; i < loginModelglobal.data!.profileList!.length; i++) {
      profileName = loginModelglobal.data!.profileList![i].profileName;
      profileId = loginModelglobal.data!.profileList![i].profileId;
      defaultProfile = loginModelglobal.data!.profileList![i].defaultProfile;

      if (defaultProfile == true ||
          loginModelglobal.data!.profileList![i].isDefaultProfile == true) {
        String profileNameNew =
            loginModelglobal.data!.profileList![i].profileName ?? '';
        dynamic profileIdNew = loginModelglobal.data!.profileList![i].profileId;
        shared.setDefaultProfileName(profileNameNew);
        shared.setDefaultProfileId(profileIdNew);

        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "LEVEL_ONE_LEAVE_APPROVE_ADD",
            ) ||
            loginModelglobal.data!.profileList![i].profilePermission.contains(
              "LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD",
            )) {
          //levelOne = "true";
          shared.setLevelOne("true");
        } else {
          //levelOne = "false";
          shared.setLevelOne("false");
        }

        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "LEVEL_TWO_LEAVE_APPROVE_ADD",
            ) ||
            loginModelglobal.data!.profileList![i].profilePermission.contains(
              "LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD",
            ) ||
            loginModelglobal.data!.profileList![i].profilePermission.contains(
              "FINAL_LEVEL_LEAVE_APPROVE_MYTEAM_ADD",
            )) {
          //levelTwo = "true";
          shared.setLevelTwo("true");
        } else {
          //levelTwo = "false";
          shared.setLevelTwo("false");
        }
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
          "LEAVE_REQ_APPROVAL_ADD",
        )) {
          //pendingLeaveRequisitions = "true";
          shared.setPendingLeaveReq("true");
        }
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
          "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
        )) {
          //claimLevelOne = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
          shared.setClaimLevelOne("CLAIM_APPROVAL_LEVEL_ONE_VIEW");
        } else {
          //claimLevelOne = "";
          shared.setClaimLevelOne("");
        }
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
          "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
        )) {
          //claimLevelTwo = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
          shared.setClaimLevelTwo("CLAIM_APPROVAL_LEVEL_TWO_VIEW");
        } else {
          //claimLevelTwo = "";
          shared.setClaimLevelTwo("");
        }
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
          "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
        )) {
          //claimLevelThree = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
          shared.setClaimLevelThree("CLAIM_APPROVAL_LEVEL_THREE_VIEW");
        } else {
          //claimLevelThree = "";
          shared.setClaimLevelThree("");
        }
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
          "PRE_INDUCTION_ONBOARDING_ADD",
        )) {
          //preOnboardShow = "true";
          shared.setPreOnboardShow("true");
        } else {
          //preOnboardShow = "false";
          shared.setPreOnboardShow("false");
        }
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
          "EXIT_EMP_LIST_ADD",
        )) {
          //exitShow = "true";
          shared.setExitShow("true");
        } else {
          //exitShow = "false";
          shared.setExitShow("false");
        }
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
          "HRIS_EMP_LIST_VIEW",
        )) {
          //myTeamShow = "true";
          shared.setMyTeamShow("true");
          shared.setMyTeamPageShow("1");
        } else {
          //myTeamShow = "false";
          shared.setMyTeamShow("false");
          shared.setMyTeamPageShow("0");
        }

        //Exit Permission setter
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
          "EXIT_RESIGN_REQUEST_LIST_VIEW",
        )) {
          //exitResignationListShow = "true";
          //exitResignationListView = "1";
          shared.setExitResignationListShow("true");
          shared.setExitResignationListView("1");
        } else {
          //exitResignationListShow = "false";
          //exitResignationListView = "0";
          shared.setExitResignationListShow("false");
          shared.setExitResignationListView("0");
        }
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
          "EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD",
        )) {
          //exitResignationApproveL1Show = "true";
          shared.setExitResignationApproveL1Show("true");
        } else {
          //exitResignationApproveL1Show = "false";
          shared.setExitResignationApproveL1Show("false");
        }
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
          "EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD",
        )) {
          //exitResignationApproveL2Show = "true";
          shared.setExitResignationApproveL2Show("true");
        } else {
          //exitResignationApproveL2Show = "false";
          shared.setExitResignationApproveL2Show("false");
        }
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
          "EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE",
        )) {
          //exitResignationDisApproveL1Show = "true";
          shared.setExitResignationDisApproveL1Show("true");
        } else {
          //exitResignationDisApproveL1Show = "false";
          shared.setExitResignationDisApproveL1Show("false");
        }
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
          "EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE",
        )) {
          //exitResignationDisApproveL2Show = "true";
          shared.setExitResignationDisApproveL2Show("true");
        } else {
          //exitResignationDisApproveL2Show = "false";
          shared.setExitResignationDisApproveL2Show("false");
        }

        //MSS MO
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Pending Attendance Request permission
        /*String pendingAttReqMOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD",
            ) ==
            true) {
          shared.setPendingAttendanceReqMSSMOPermission("1");
        } else {
          shared.setPendingAttendanceReqMSSMOPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request permission
        /*String leaveReqMOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEAVE_REQ_APPROVAL_MO_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "LEAVE_REQ_APPROVAL_MO_ADD",
                ) ==
                true ||
            loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "LEAVE_REQ_MYTEAM_ADD",
                ) ==
                true) {
          shared.setPendingLeaveReqMSSMOPermission("1");
        } else {
          shared.setPendingLeaveReqMSSMOPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L1 permission
        /*String leaveReqL1MOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_ONE_LEAVE_APPROVE_MO_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "LEVEL_ONE_LEAVE_APPROVE_MO_ADD",
                ) ==
                true ||
            loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD",
                ) ==
                true) {
          shared.setPendingLeaveReqL1MSSMOPermission("1");
        } else {
          shared.setPendingLeaveReqL1MSSMOPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
        /*String leaveReqL2MOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_TWO_LEAVE_APPROVE_MO_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "LEVEL_TWO_LEAVE_APPROVE_MO_ADD",
                ) ==
                true ||
            loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD",
                ) ==
                true ||
            loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "FINAL_LEVEL_LEAVE_APPROVE_MO_ADD",
                ) ==
                true) {
          shared.setPendingLeaveReqL2MSSMOPermission("1");
        } else {
          shared.setPendingLeaveReqL2MSSMOPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
        /*String othersLeaveReqMOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("OTHERS_LEAVE_REQUEST_MO_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "OTHERS_LEAVE_REQUEST_MO_ADD",
            ) ==
            true) {
          shared.setOthersLeaveReqMSSMOPermission("1");
        } else {
          shared.setOthersLeaveReqMSSMOPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L1 permission
        /*String pendingClaimL1MOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
            ) ==
            true) {
          shared.setClaimLevelOneMO("1");
        } else {
          shared.setClaimLevelOneMO("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L2 permission
        /*String pendingClaimL2MOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
            ) ==
            true) {
          shared.setClaimLevelTwoMO("1");
        } else {
          shared.setClaimLevelTwoMO("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L3 permission
        /*String pendingClaimL3MOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
            ) ==
            true) {
          shared.setClaimLevelThreeMO("1");
        } else {
          shared.setClaimLevelThreeMO("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
        /* String pendingODListMOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "MOBILE_OD_PENDING_REQ_ADD",
            ) ==
            true) {
          shared.setODPendingListMO("1");
        } else {
          shared.setODPendingListMO("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
        /*String odActivateMOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "MOBILE_OD_ACTIVATE_ADD",
            ) ==
            true) {
          shared.setODActivateMO("1");
        } else {
          shared.setODActivateMO("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
        /*String pendingAttendanceRequestMOL1 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "ATT_APP_ONE_ADD",
            ) ==
            true) {
          shared.setPendingAttendanceReqL1MO("1");
        } else {
          shared.setPendingAttendanceReqL1MO("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
        /* String pendingAttendanceRequestMOL2 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "ATT_APP_TWO_ADD",
            ) ==
            true) {
          shared.setPendingAttendanceReqL2MO("1");
        } else {
          shared.setPendingAttendanceReqL2MO("0");
        }

        //MSS
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Pending Attendance Request permission
        /*String pendingAttReqMSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "ATTENDANCE_REQ_APPROVAL_DETAILS_ADD",
            ) ==
            true) {
          shared.setPendingAttendanceReqMSSPermission("1");
        } else {
          shared.setPendingAttendanceReqMSSPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request permission
        /*String leaveReqMSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEAVE_REQ_APPROVAL_ADD") || loginModelglobal.data!.profileList![i].profilePermission.contains("LEAVE_APP_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "LEAVE_REQ_APPROVAL_ADD",
                ) ==
                true ||
            loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "LEAVE_APP_MYTEAM_ADD",
                ) ==
                true) {
          shared.setPendingLeaveReqMSSPermission("1");
        } else {
          shared.setPendingLeaveReqMSSPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L1 permission
        /*String leaveReqL1MSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") || loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "LEVEL_ONE_LEAVE_APPROVE_ADD",
                ) ==
                true ||
            loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD",
                ) ==
                true) {
          shared.setPendingLeaveReqL1MSSPermission("1");
        } else {
          shared.setPendingLeaveReqL1MSSPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
        /*String leaveReqL2MSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") || loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "LEVEL_TWO_LEAVE_APPROVE_ADD",
                ) ==
                true ||
            loginModelglobal.data!.profileList![i].profilePermission.contains(
                  "LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD",
                ) ==
                true) {
          shared.setPendingLeaveReqL2MSSPermission("1");
        } else {
          shared.setPendingLeaveReqL2MSSPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
        /* String othersLeaveReqMSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "OTHERS_LEAVE_REQUEST_ADD",
            ) ==
            true) {
          shared.setOthersLeaveReqMSSPermission("1");
        } else {
          shared.setOthersLeaveReqMSSPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L1 permission
        /* String pendingClaimL1Permission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
            ) ==
            true) {
          shared.setClaimLevelOne("1");
        } else {
          shared.setClaimLevelOne("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L2 permission
        /*String pendingClaimL2Permission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
            ) ==
            true) {
          shared.setClaimLevelTwo("1");
        } else {
          shared.setClaimLevelTwo("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L3 permission
        /*String pendingClaimL3Permission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
            ) ==
            true) {
          shared.setClaimLevelThree("1");
        } else {
          shared.setClaimLevelThree("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
        /*String pendingODListPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "MOBILE_OD_PENDING_REQ_ADD",
            ) ==
            true) {
          shared.setODPendingList("1");
        } else {
          shared.setODPendingList("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
        /*String odActivatePermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "MOBILE_OD_ACTIVATE_ADD",
            ) ==
            true) {
          shared.setODActivate("1");
        } else {
          shared.setODActivate("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
        /*String pendingAttendanceRequestMSSL1 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "ATT_APP_ONE_ADD",
            ) ==
            true) {
          shared.setPendingAttendanceReqL1MSS("1");
        } else {
          shared.setPendingAttendanceReqL1MSS("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
        /*String pendingAttendanceRequestMSSL2 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "ATT_APP_TWO_ADD",
            ) ==
            true) {
          shared.setPendingAttendanceReqL2MSS("1");
        } else {
          shared.setPendingAttendanceReqL2MSS("0");
        }

        //USER
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Pending Attendance Request permission
        /*String pendingAttReqUISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "ATTENDANCE_REQ_APPROVAL_DETAILS_ADD",
            ) ==
            true) {
          shared.setPendingAttendanceReqUISPermission("1");
        } else {
          shared.setPendingAttendanceReqUISPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request permission
        /*String leaveReqUISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEAVE_REQ_APPROVAL_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "LEAVE_REQ_APPROVAL_ADD",
            ) ==
            true) {
          shared.setPendingLeaveReqUISPermission("1");
        } else {
          shared.setPendingLeaveReqUISPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L1 permission
        /*String leaveReqL1UISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "LEVEL_ONE_LEAVE_APPROVE_ADD",
            ) ==
            true) {
          shared.setPendingLeaveReqL1UISPermission("1");
        } else {
          shared.setPendingLeaveReqL1UISPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
        /*String leaveReqL2UISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "LEVEL_TWO_LEAVE_APPROVE_ADD",
            ) ==
            true) {
          shared.setPendingLeaveReqL2UISPermission("1");
        } else {
          shared.setPendingLeaveReqL2UISPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
        /*String othersLeaveReqUISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "OTHERS_LEAVE_REQUEST_ADD",
            ) ==
            true) {
          shared.setOthersLeaveReqUISPermission("1");
        } else {
          shared.setOthersLeaveReqUISPermission("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L1 permission
        /*String pendingClaimL1UISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
            ) ==
            true) {
          shared.setClaimLevelOneUIS("1");
        } else {
          shared.setClaimLevelOneUIS("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L2 permission
        /*String pendingClaimL2UISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
            ) ==
            true) {
          shared.setClaimLevelTwoUIS("1");
        } else {
          shared.setClaimLevelTwoUIS("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L3 permission
        /*String pendingClaimL3UISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
            ) ==
            true) {
          shared.setClaimLevelThreeUIS("1");
        } else {
          shared.setClaimLevelThreeUIS("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
        /*String pendingODListUISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "MOBILE_OD_PENDING_REQ_ADD",
            ) ==
            true) {
          shared.setODPendingListUIS("1");
        } else {
          shared.setODPendingListUIS("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
        /*String odActivateUISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "MOBILE_OD_ACTIVATE_ADD",
            ) ==
            true) {
          shared.setODActivateUIS("1");
        } else {
          shared.setODActivateUIS("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
        /*String pendingAttendanceRequestUISL1 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "ATT_APP_ONE_ADD",
            ) ==
            true) {
          shared.setPendingAttendanceReqL1UIS("1");
        } else {
          shared.setPendingAttendanceReqL1UIS("0");
        }
        // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
        /*String pendingAttendanceRequestUISL2 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
        if (loginModelglobal.data!.profileList![i].profilePermission.contains(
              "ATT_APP_TWO_ADD",
            ) ==
            true) {
          shared.setPendingAttendanceReqL2UIS("1");
        } else {
          shared.setPendingAttendanceReqL2UIS("0");
        }

        // Ã°Å¸Å¸Â¢ Save the MSS MO permission to SharedPreferences
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
          print("Ã¢Å“â€¦ Attendance Permission for profileId $profileIdNew: $pendingAttReqMOPermValue");
          print("Ã¢Å“â€¦ Leave Permission for profileId $profileIdNew: $leaveReqMOPermValue");
          print("Ã¢Å“â€¦ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1MOPermValue");
          print("Ã¢Å“â€¦ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2MOPermValue");
          print("Ã¢Å“â€¦ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqMOPermValue");
          print("Ã¢Å“â€¦ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1MOPermission");
          print("Ã¢Å“â€¦ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2MOPermission");
          print("Ã¢Å“â€¦ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3MOPermission");
          print("Ã¢Å“â€¦ OD Activate Permission for profileId $profileIdNew: $odActivateMOPermission");
          print("Ã¢Å“â€¦ Pending OD Permission for profileId $profileIdNew: $pendingODListMOPermission");
          print("Ã¢Å“â€¦ Pending Attendance L1 MO Permission for profileId $profileIdNew: $pendingAttendanceRequestMOL1");
          print("Ã¢Å“â€¦ Pending Attendance L2 MO Permission for profileId $profileIdNew: $pendingAttendanceRequestMOL2");

          // Ã°Å¸Å¸Â¢ Save the MSS permission to SharedPreferences
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
          print("Ã¢Å“â€¦ Attendance Permission for profileId $profileIdNew: $pendingAttReqMSSPermValue");
          print("Ã¢Å“â€¦ Leave Permission for profileId $profileIdNew: $leaveReqMSSPermValue");
          print("Ã¢Å“â€¦ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1MSSPermValue");
          print("Ã¢Å“â€¦ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2MSSPermValue");
          print("Ã¢Å“â€¦ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqMSSPermValue");
          print("Ã¢Å“â€¦ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1Permission");
          print("Ã¢Å“â€¦ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2Permission");
          print("Ã¢Å“â€¦ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3Permission");
          print("Ã¢Å“â€¦ OD Activate Permission for profileId $profileIdNew: $odActivatePermission");
          print("Ã¢Å“â€¦ Pending OD List Permission for profileId $profileIdNew: $pendingODListPermission");
          print("Ã¢Å“â€¦ Pending Attendance L1 MSS Permission for profileId $profileIdNew: $pendingAttendanceRequestMSSL1");
          print("Ã¢Å“â€¦ Pending Attendance L2 MSS Permission for profileId $profileIdNew: $pendingAttendanceRequestMSSL2");

          // Ã°Å¸Å¸Â¢ Save the UIS permission to SharedPreferences
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
          print("Ã¢Å“â€¦ Attendance Permission for profileId $profileIdNew: $pendingAttReqUISPermValue");
          print("Ã¢Å“â€¦ Leave Permission for profileId $profileIdNew: $leaveReqUISPermValue");
          print("Ã¢Å“â€¦ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1UISPermValue");
          print("Ã¢Å“â€¦ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2UISPermValue");
          print("Ã¢Å“â€¦ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqUISPermValue");
          print("Ã¢Å“â€¦ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1UISPermission");
          print("Ã¢Å“â€¦ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2UISPermission");
          print("Ã¢Å“â€¦ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3UISPermission");
          print("Ã¢Å“â€¦ OD Activate Permission for profileId $profileIdNew: $odActivateUISPermission");
          print("Ã¢Å“â€¦ Pending OD List Permission for profileId $profileIdNew: $pendingODListUISPermission");
          print("Ã¢Å“â€¦ Pending Attendance L1 UIS Permission for profileId $profileIdNew: $pendingAttendanceRequestUISL1");
          print("Ã¢Å“â€¦ Pending Attendance L2 UIS Permission for profileId $profileIdNew: $pendingAttendanceRequestUISL2");*/
      }

    }

    /*for(int i=0; i<loginModelglobal.data!.profileList!.length;i++){
      profileName = loginModelglobal.data!.profileList![i].profileName;
      profileId = loginModelglobal.data!.profileList![i].profileId;
      defaultProfile = loginModelglobal.data!.profileList![i].defaultProfile;

      if (defaultProfile == true || loginModelglobal.data!.profileList![i].isDefaultProfile == true) {
        String profileNameNew = '${loginModelglobal.data!.profileList![i].profileName}';
        dynamic profileIdNew = loginModelglobal.data!.profileList![i].profileId;
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
      for (int i = 0; i < loginModelglobal.data!.profileList!.length; i++) {
        profileName = loginModelglobal.data!.profileList![i].profileName;
        profileId = loginModelglobal.data!.profileList![i].profileId;
        defaultProfile = loginModelglobal.data!.profileList![i].defaultProfile;

        if (defaultProfile == true ||
            loginModelglobal.data!.profileList![i].isDefaultProfile == true) {
          String profileNameNew =
              loginModelglobal.data!.profileList![i].profileName ?? '';
          dynamic profileIdNew =
              loginModelglobal.data!.profileList![i].profileId;
          shared.setDefaultProfileName(profileNameNew);
          shared.setDefaultProfileId(profileIdNew);

          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_ONE_LEAVE_APPROVE_ADD",
              ) ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD",
              )) {
            levelOne = "true";
            shared.setLevelOne(levelOne);
          } else {
            levelOne = "false";
            shared.setLevelOne(levelOne);
          }

          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_TWO_LEAVE_APPROVE_ADD",
              ) ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD",
              ) ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                "FINAL_LEVEL_LEAVE_APPROVE_MYTEAM_ADD",
              )) {
            levelTwo = "true";
            shared.setLevelTwo(levelTwo);
          } else {
            levelTwo = "false";
            shared.setLevelTwo(levelTwo);
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "LEAVE_REQ_APPROVAL_ADD",
          )) {
            pendingLeaveRequisitions = "true";
            shared.setPendingLeaveReq(pendingLeaveRequisitions);
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
          )) {
            claimLevelOne = "CLAIM_APPROVAL_LEVEL_ONE_VIEW";
            shared.setClaimLevelOne(claimLevelOne);
          } else {
            claimLevelOne = "";
            shared.setClaimLevelOne(claimLevelOne);
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
          )) {
            claimLevelTwo = "CLAIM_APPROVAL_LEVEL_TWO_VIEW";
            shared.setClaimLevelTwo(claimLevelTwo);
          } else {
            claimLevelTwo = "";
            shared.setClaimLevelTwo(claimLevelTwo);
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
          )) {
            claimLevelThree = "CLAIM_APPROVAL_LEVEL_THREE_VIEW";
            shared.setClaimLevelThree(claimLevelThree);
          } else {
            claimLevelThree = "";
            shared.setClaimLevelThree(claimLevelThree);
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "PRE_INDUCTION_ONBOARDING_ADD",
          )) {
            preOnboardShow = "true";
            shared.setPreOnboardShow(preOnboardShow);
          } else {
            preOnboardShow = "false";
            shared.setPreOnboardShow(preOnboardShow);
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "EXIT_EMP_LIST_ADD",
          )) {
            exitShow = "true";
            shared.setExitShow(exitShow);
          } else {
            exitShow = "false";
            shared.setExitShow(exitShow);
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "HRIS_EMP_LIST_VIEW",
          )) {
            //myTeamShow = "true";
            shared.setMyTeamShow("true");
            shared.setMyTeamPageShow("1");
          } else {
            //myTeamShow = "false";
            shared.setMyTeamShow("false");
            shared.setMyTeamPageShow("0");
          }

          //Exit Permission setter
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "EXIT_RESIGN_REQUEST_LIST_VIEW",
          )) {
            //exitResignationListShow = "true";
            //exitResignationListView = "1";
            shared.setExitResignationListShow("true");
            shared.setExitResignationListView("1");
          } else {
            //exitResignationListShow = "false";
            //exitResignationListView = "0";
            shared.setExitResignationListShow("false");
            shared.setExitResignationListView("0");
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "EXIT_RESGINATION_APPROVAL_LEVEL_ONE_ADD",
          )) {
            exitResignationApproveL1Show = "true";
            shared.setExitResignationApproveL1Show(
              exitResignationApproveL1Show,
            );
          } else {
            exitResignationApproveL1Show = "false";
            shared.setExitResignationApproveL1Show(
              exitResignationApproveL1Show,
            );
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "EXIT_RESGINATION_APPROVAL_LEVEL_TWO_ADD",
          )) {
            exitResignationApproveL2Show = "true";
            shared.setExitResignationApproveL2Show(
              exitResignationApproveL2Show,
            );
          } else {
            exitResignationApproveL2Show = "false";
            shared.setExitResignationApproveL2Show(
              exitResignationApproveL2Show,
            );
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "EXIT_RESGINATION_APPROVAL_LEVEL_ONE_DELETE",
          )) {
            exitResignationDisApproveL1Show = "true";
            shared.setExitResignationDisApproveL1Show(
              exitResignationDisApproveL1Show,
            );
          } else {
            exitResignationDisApproveL1Show = "false";
            shared.setExitResignationDisApproveL1Show(
              exitResignationDisApproveL1Show,
            );
          }
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
            "EXIT_RESGINATION_APPROVAL_LEVEL_TWO_DELETE",
          )) {
            exitResignationDisApproveL2Show = "true";
            shared.setExitResignationDisApproveL2Show(
              exitResignationDisApproveL2Show,
            );
          } else {
            exitResignationDisApproveL2Show = "false";
            shared.setExitResignationDisApproveL2Show(
              exitResignationDisApproveL2Show,
            );
          }

          //MSS MO
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Pending Attendance Request permission
          /*String pendingAttReqMOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATTENDANCE_REQ_APPROVAL_DETAILS_MO_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqMSSMOPermission("1");
          } else {
            shared.setPendingAttendanceReqMSSMOPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request permission
          /*String leaveReqMOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEAVE_REQ_APPROVAL_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEAVE_REQ_APPROVAL_MO_ADD",
              ) ==
              true) {
            shared.setPendingLeaveReqMSSMOPermission("1");
          } else {
            shared.setPendingLeaveReqMSSMOPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L1 permission
          /*String leaveReqL1MOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_ONE_LEAVE_APPROVE_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_ONE_LEAVE_APPROVE_MO_ADD",
              ) ==
              true) {
            shared.setPendingLeaveReqL1MSSMOPermission("1");
          } else {
            shared.setPendingLeaveReqL1MSSMOPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
          /*String leaveReqL2MOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_TWO_LEAVE_APPROVE_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "LEVEL_TWO_LEAVE_APPROVE_MO_ADD",
                  ) ==
                  true ||
              loginModelglobal.data!.profileList![i].profilePermission.contains(
                    "FINAL_LEVEL_LEAVE_APPROVE_MO_ADD",
                  ) ==
                  true) {
            shared.setPendingLeaveReqL2MSSMOPermission("1");
          } else {
            shared.setPendingLeaveReqL2MSSMOPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
          /*String othersLeaveReqMOPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("OTHERS_LEAVE_REQUEST_MO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "OTHERS_LEAVE_REQUEST_MO_ADD",
              ) ==
              true) {
            shared.setOthersLeaveReqMSSMOPermission("1");
          } else {
            shared.setOthersLeaveReqMSSMOPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L1 permission
          /*String pendingClaimL1MOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
              ) ==
              true) {
            shared.setClaimLevelOneMO("1");
          } else {
            shared.setClaimLevelOneMO("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L2 permission
          /*String pendingClaimL2MOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
              ) ==
              true) {
            shared.setClaimLevelTwoMO("1");
          } else {
            shared.setClaimLevelTwoMO("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L3 permission
          /*String pendingClaimL3MOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
              ) ==
              true) {
            shared.setClaimLevelThreeMO("1");
          } else {
            shared.setClaimLevelThreeMO("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
          /* String pendingODListMOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "MOBILE_OD_PENDING_REQ_ADD",
              ) ==
              true) {
            shared.setODPendingListMO("1");
          } else {
            shared.setODPendingListMO("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
          /*String odActivateMOPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "MOBILE_OD_ACTIVATE_ADD",
              ) ==
              true) {
            shared.setODActivateMO("1");
          } else {
            shared.setODActivateMO("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
          /*String pendingAttendanceRequestMOL1 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATT_APP_ONE_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqL1MO("1");
          } else {
            shared.setPendingAttendanceReqL1MO("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
          /* String pendingAttendanceRequestMOL2 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATT_APP_TWO_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqL2MO("1");
          } else {
            shared.setPendingAttendanceReqL2MO("0");
          }

          //MSS
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Pending Attendance Request permission
          /*String pendingAttReqMSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATTENDANCE_REQ_APPROVAL_DETAILS_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqMSSPermission("1");
          } else {
            shared.setPendingAttendanceReqMSSPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request permission
          /*String leaveReqMSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEAVE_REQ_APPROVAL_ADD") || loginModelglobal.data!.profileList![i].profilePermission.contains("LEAVE_APP_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEAVE_REQ_APPROVAL_ADD",
              ) ==
              true) {
            shared.setPendingLeaveReqMSSPermission("1");
          } else {
            shared.setPendingLeaveReqMSSPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L1 permission
          /*String leaveReqL1MSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") || loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_ONE_LEAVE_APPROVE_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_ONE_LEAVE_APPROVE_ADD",
              ) ==
              true) {
            shared.setPendingLeaveReqL1MSSPermission("1");
          } else {
            shared.setPendingLeaveReqL1MSSPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
          /*String leaveReqL2MSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") || loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_TWO_LEAVE_APPROVE_MYTEAM_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_TWO_LEAVE_APPROVE_ADD",
              ) ==
              true) {
            shared.setPendingLeaveReqL2MSSPermission("1");
          } else {
            shared.setPendingLeaveReqL2MSSPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
          /* String othersLeaveReqMSSPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "OTHERS_LEAVE_REQUEST_ADD",
              ) ==
              true) {
            shared.setOthersLeaveReqMSSPermission("1");
          } else {
            shared.setOthersLeaveReqMSSPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L1 permission
          /* String pendingClaimL1Permission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
              ) ==
              true) {
            shared.setClaimLevelOne("1");
          } else {
            shared.setClaimLevelOne("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L2 permission
          /*String pendingClaimL2Permission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
              ) ==
              true) {
            shared.setClaimLevelTwo("1");
          } else {
            shared.setClaimLevelTwo("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L3 permission
          /*String pendingClaimL3Permission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
              ) ==
              true) {
            shared.setClaimLevelThree("1");
          } else {
            shared.setClaimLevelThree("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
          /*String pendingODListPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "MOBILE_OD_PENDING_REQ_ADD",
              ) ==
              true) {
            shared.setODPendingList("1");
          } else {
            shared.setODPendingList("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
          /*String odActivatePermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "MOBILE_OD_ACTIVATE_ADD",
              ) ==
              true) {
            shared.setODActivate("1");
          } else {
            shared.setODActivate("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
          /*String pendingAttendanceRequestMSSL1 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATT_APP_ONE_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqL1MSS("1");
          } else {
            shared.setPendingAttendanceReqL1MSS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
          /*String pendingAttendanceRequestMSSL2 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATT_APP_TWO_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqL2MSS("1");
          } else {
            shared.setPendingAttendanceReqL2MSS("0");
          }

          //USER
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Pending Attendance Request permission
          /*String pendingAttReqUISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATTENDANCE_REQ_APPROVAL_DETAILS_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATTENDANCE_REQ_APPROVAL_DETAILS_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqUISPermission("1");
          } else {
            shared.setPendingAttendanceReqUISPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request permission
          /*String leaveReqUISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEAVE_REQ_APPROVAL_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEAVE_REQ_APPROVAL_ADD",
              ) ==
              true) {
            shared.setPendingLeaveReqUISPermission("1");
          } else {
            shared.setPendingLeaveReqUISPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L1 permission
          /*String leaveReqL1UISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_ONE_LEAVE_APPROVE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_ONE_LEAVE_APPROVE_ADD",
              ) ==
              true) {
            shared.setPendingLeaveReqL1UISPermission("1");
          } else {
            shared.setPendingLeaveReqL1UISPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
          /*String leaveReqL2UISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("LEVEL_TWO_LEAVE_APPROVE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "LEVEL_TWO_LEAVE_APPROVE_ADD",
              ) ==
              true) {
            shared.setPendingLeaveReqL2UISPermission("1");
          } else {
            shared.setPendingLeaveReqL2UISPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Leave Request L2 permission
          /*String othersLeaveReqUISPermValue = (loginModelglobal.data!.profileList![i].profilePermission.contains("OTHERS_LEAVE_REQUEST_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "OTHERS_LEAVE_REQUEST_ADD",
              ) ==
              true) {
            shared.setOthersLeaveReqUISPermission("1");
          } else {
            shared.setOthersLeaveReqUISPermission("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L1 permission
          /*String pendingClaimL1UISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_ONE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_ONE_VIEW",
              ) ==
              true) {
            shared.setClaimLevelOneUIS("1");
          } else {
            shared.setClaimLevelOneUIS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L2 permission
          /*String pendingClaimL2UISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_TWO_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_TWO_VIEW",
              ) ==
              true) {
            shared.setClaimLevelTwoUIS("1");
          } else {
            shared.setClaimLevelTwoUIS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the Claim L3 permission
          /*String pendingClaimL3UISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("CLAIM_APPROVAL_LEVEL_THREE_VIEW") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "CLAIM_APPROVAL_LEVEL_THREE_VIEW",
              ) ==
              true) {
            shared.setClaimLevelThreeUIS("1");
          } else {
            shared.setClaimLevelThreeUIS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
          /*String pendingODListUISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_PENDING_REQ_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "MOBILE_OD_PENDING_REQ_ADD",
              ) ==
              true) {
            shared.setODPendingListUIS("1");
          } else {
            shared.setODPendingListUIS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
          /*String odActivateUISPermission = (loginModelglobal.data!.profileList![i].profilePermission.contains("MOBILE_OD_ACTIVATE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "MOBILE_OD_ACTIVATE_ADD",
              ) ==
              true) {
            shared.setODActivateUIS("1");
          } else {
            shared.setODActivateUIS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Pending List permission
          /*String pendingAttendanceRequestUISL1 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_ONE_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATT_APP_ONE_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqL1UIS("1");
          } else {
            shared.setPendingAttendanceReqL1UIS("0");
          }
          // Ã°Å¸Å¸Â¢ Check if the selected profile has the OD Activate permission
          /*String pendingAttendanceRequestUISL2 = (loginModelglobal.data!.profileList![i].profilePermission.contains("ATT_APP_TWO_ADD") ?? false)
              ? "1"
              : "0";*/
          if (loginModelglobal.data!.profileList![i].profilePermission.contains(
                "ATT_APP_TWO_ADD",
              ) ==
              true) {
            shared.setPendingAttendanceReqL2UIS("1");
          } else {
            shared.setPendingAttendanceReqL2UIS("0");
          }

          // Ã°Å¸Å¸Â¢ Save the MSS MO permission to SharedPreferences
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
          print("Ã¢Å“â€¦ Attendance Permission for profileId $profileIdNew: $pendingAttReqMOPermValue");
          print("Ã¢Å“â€¦ Leave Permission for profileId $profileIdNew: $leaveReqMOPermValue");
          print("Ã¢Å“â€¦ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1MOPermValue");
          print("Ã¢Å“â€¦ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2MOPermValue");
          print("Ã¢Å“â€¦ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqMOPermValue");
          print("Ã¢Å“â€¦ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1MOPermission");
          print("Ã¢Å“â€¦ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2MOPermission");
          print("Ã¢Å“â€¦ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3MOPermission");
          print("Ã¢Å“â€¦ OD Activate Permission for profileId $profileIdNew: $odActivateMOPermission");
          print("Ã¢Å“â€¦ Pending OD Permission for profileId $profileIdNew: $pendingODListMOPermission");
          print("Ã¢Å“â€¦ Pending Attendance L1 MO Permission for profileId $profileIdNew: $pendingAttendanceRequestMOL1");
          print("Ã¢Å“â€¦ Pending Attendance L2 MO Permission for profileId $profileIdNew: $pendingAttendanceRequestMOL2");

          // Ã°Å¸Å¸Â¢ Save the MSS permission to SharedPreferences
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
          print("Ã¢Å“â€¦ Attendance Permission for profileId $profileIdNew: $pendingAttReqMSSPermValue");
          print("Ã¢Å“â€¦ Leave Permission for profileId $profileIdNew: $leaveReqMSSPermValue");
          print("Ã¢Å“â€¦ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1MSSPermValue");
          print("Ã¢Å“â€¦ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2MSSPermValue");
          print("Ã¢Å“â€¦ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqMSSPermValue");
          print("Ã¢Å“â€¦ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1Permission");
          print("Ã¢Å“â€¦ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2Permission");
          print("Ã¢Å“â€¦ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3Permission");
          print("Ã¢Å“â€¦ OD Activate Permission for profileId $profileIdNew: $odActivatePermission");
          print("Ã¢Å“â€¦ Pending OD List Permission for profileId $profileIdNew: $pendingODListPermission");
          print("Ã¢Å“â€¦ Pending Attendance L1 MSS Permission for profileId $profileIdNew: $pendingAttendanceRequestMSSL1");
          print("Ã¢Å“â€¦ Pending Attendance L2 MSS Permission for profileId $profileIdNew: $pendingAttendanceRequestMSSL2");

          // Ã°Å¸Å¸Â¢ Save the UIS permission to SharedPreferences
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
          print("Ã¢Å“â€¦ Attendance Permission for profileId $profileIdNew: $pendingAttReqUISPermValue");
          print("Ã¢Å“â€¦ Leave Permission for profileId $profileIdNew: $leaveReqUISPermValue");
          print("Ã¢Å“â€¦ Leave L1 Permission for profileId $profileIdNew: $leaveReqL1UISPermValue");
          print("Ã¢Å“â€¦ Leave L2 Permission for profileId $profileIdNew: $leaveReqL2UISPermValue");
          print("Ã¢Å“â€¦ Others Leave Permission for profileId $profileIdNew: $othersLeaveReqUISPermValue");
          print("Ã¢Å“â€¦ Claim L1 Permission for profileId $profileIdNew: $pendingClaimL1UISPermission");
          print("Ã¢Å“â€¦ Claim L2 Permission for profileId $profileIdNew: $pendingClaimL2UISPermission");
          print("Ã¢Å“â€¦ Claim L3 Permission for profileId $profileIdNew: $pendingClaimL3UISPermission");
          print("Ã¢Å“â€¦ OD Activate Permission for profileId $profileIdNew: $odActivateUISPermission");
          print("Ã¢Å“â€¦ Pending OD List Permission for profileId $profileIdNew: $pendingODListUISPermission");
          print("Ã¢Å“â€¦ Pending Attendance L1 UIS Permission for profileId $profileIdNew: $pendingAttendanceRequestUISL1");
          print("Ã¢Å“â€¦ Pending Attendance L2 UIS Permission for profileId $profileIdNew: $pendingAttendanceRequestUISL2");*/
        }

      }
    }
    setState(() {});
    empLength;
    roLength;
    adminlength;
    /*levelOne = "false";
    levelTwo = "false";
    pendingLeaveRequisitions = "false";
    shared.setLevelOne(levelOne);
    shared.setLevelTwo(levelTwo);
    shared.setPendingLeaveReq(pendingLeaveRequisitions);*/

    setState(() {});

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
      shared.setEmpCode(loginModelglobal.data!.empCode);
      shared.setEmpId(loginModelglobal.data!.empId);
      shared.setDob(loginModelglobal.data!.dob);
      shared.setUserType(loginModelglobal.data!.userLoginned!.userType);
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
